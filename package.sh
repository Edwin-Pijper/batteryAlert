#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.
# Builds BatteryAlert.app and packages it (dmg / zip / pkg).
# Settings: config.env      Usage: ./package.sh [--app-only] [--clean] [--help]
set -euo pipefail
cd "$(dirname "$0")"

APP_ONLY=0
for arg in "$@"; do
    case "$arg" in
        --app-only) APP_ONLY=1 ;;
        --clean)    source ./config.env; rm -rf "$BUILD_DIR" "$DIST_DIR"; echo "Removed $BUILD_DIR and $DIST_DIR"; exit 0 ;;
        -h|--help)
            cat << 'HELP'
Usage: ./package.sh [options]

  (no option)   build the app and create the packages listed in PACKAGE_FORMATS
  --app-only    only build the .app (no dmg/zip/pkg)
  --clean       remove the build and dist folders
  --help        show this help

Settings are in config.env. Example for one run:
  VERSION=1.2.0 BUILD_NUMBER=7 ./package.sh
HELP
            exit 0 ;;
        *) echo "Unknown option: $arg (try --help)" >&2; exit 1 ;;
    esac
done

source ./config.env

# ── Checks ───────────────────────────────────────────────────
command -v swiftc >/dev/null || { echo "swiftc not found. Install the Xcode command line tools: xcode-select --install" >&2; exit 1; }
[ -d "$SOURCE_DIR" ] || { echo "Source folder '$SOURCE_DIR' not found" >&2; exit 1; }

APP_PATH="$BUILD_DIR/$APP_NAME.app"
echo "▶ Building $APP_NAME $VERSION (build $BUILD_NUMBER) for: $ARCHS"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/obj" "$APP_PATH/Contents/MacOS" "$APP_PATH/Contents/Resources"

# ── Which files are compiled? ────────────────────────────────
echo "  • compiling these files from $SOURCE_DIR/:"
for f in "$SOURCE_DIR"/*.swift; do
    printf "      %-34s %4s lines\n" "$f" "$(wc -l < "$f" | tr -d ' ')"
done
STRAY="$(ls ./*.swift 2>/dev/null || true)"
if [ -n "$STRAY" ]; then
    echo "  ⚠ Swift files in the project folder itself are NOT compiled (only $SOURCE_DIR/ is used):" >&2
    echo "$STRAY" | sed 's/^/      /' >&2
    echo "    If these are newer versions, move them into $SOURCE_DIR/ (replacing the old ones)." >&2
fi

# ── Compile (one binary per architecture, then merge) ───────
for arch in $ARCHS; do
    echo "  • compiling $arch"
    swiftc -O -target "$arch-apple-macos$MIN_MACOS" "$SOURCE_DIR"/*.swift -o "$BUILD_DIR/obj/$EXECUTABLE_NAME-$arch"
done
lipo -create -output "$APP_PATH/Contents/MacOS/$EXECUTABLE_NAME" "$BUILD_DIR"/obj/"$EXECUTABLE_NAME"-*

# ── Icon (optional) ──────────────────────────────────────────
ICON_PLIST=""
if [ -n "$ICON_FILE" ]; then
    [ -f "$ICON_FILE" ] || { echo "ICON_FILE '$ICON_FILE' not found" >&2; exit 1; }
    cp "$ICON_FILE" "$APP_PATH/Contents/Resources/"
    ICON_PLIST="<key>CFBundleIconFile</key><string>$(basename "$ICON_FILE")</string>"
fi

# ── License (GPLv3): the license text travels with the app ──
if [ -f LICENSE ]; then
    cp LICENSE "$APP_PATH/Contents/Resources/LICENSE"
    if [ "$(wc -l < LICENSE | tr -d ' ')" -lt 500 ]; then
        echo "  ⚠ LICENSE does not contain the full GPLv3 text yet. Download it with:" >&2
        echo "      curl -o LICENSE https://www.gnu.org/licenses/gpl-3.0.txt" >&2
    fi
else
    echo "  ⚠ No LICENSE file found in the project folder" >&2
fi

# ── Info.plist (generated from config.env) ───────────────────
cat > "$APP_PATH/Contents/Info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>$EXECUTABLE_NAME</string>
    <key>CFBundleIdentifier</key><string>$BUNDLE_ID</string>
    <key>CFBundleName</key><string>$APP_NAME</string>
    <key>CFBundleDisplayName</key><string>$APP_NAME</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>$VERSION</string>
    <key>CFBundleVersion</key><string>$BUILD_NUMBER</string>
    <key>LSMinimumSystemVersion</key><string>$MIN_MACOS</string>
    <key>NSHumanReadableCopyright</key><string>$COPYRIGHT</string>
    <key>LSUIElement</key><true/>
    $ICON_PLIST
</dict>
</plist>
PLIST
plutil -lint "$APP_PATH/Contents/Info.plist" >/dev/null

# ── Sign ─────────────────────────────────────────────────────
xattr -cr "$APP_PATH"          # remove extended attributes: they can invalidate the signature
echo "  • signing ($SIGN_IDENTITY)"
if [ "$SIGN_IDENTITY" = "-" ]; then
    codesign --force --deep --sign - "$APP_PATH"
else
    codesign --force --deep --options runtime --timestamp --sign "$SIGN_IDENTITY" "$APP_PATH"
fi

codesign --verify --deep --strict "$APP_PATH" && echo "  • signature is valid"

# ── Launch test: does the app start and keep running? ────────
if [ "${SMOKE_TEST:-1}" = "1" ]; then
    echo "  • launch test (3 seconds)"
    BATTERYALERT_SMOKE_TEST=1 "$APP_PATH/Contents/MacOS/$EXECUTABLE_NAME" > "$BUILD_DIR/launch-test.log" 2>&1 &
    TEST_PID=$!
    sleep 3
    if kill -0 "$TEST_PID" 2>/dev/null; then
        kill "$TEST_PID" 2>/dev/null || true
        wait "$TEST_PID" 2>/dev/null || true
        echo "    the app starts and keeps running"
    else
        TEST_CODE=0; wait "$TEST_PID" || TEST_CODE=$?
        echo "✘ The app quit within 3 seconds (exit code $TEST_CODE; 137 = killed by macOS, 133 = crash). Its output:" >&2
        cat "$BUILD_DIR/launch-test.log" >&2
        echo "  Run ./diagnose.sh for more information." >&2
        exit 1
    fi
fi

echo "✔ Built $APP_PATH"
[ "$APP_ONLY" -eq 1 ] && exit 0

# ── Packages ─────────────────────────────────────────────────
mkdir -p "$DIST_DIR"
ARTIFACTS=()

notarize() {   # $1 = file; staple = 1 to attach the ticket (not possible for zip)
    [ -n "$NOTARY_PROFILE" ] || return 0
    echo "  • notarizing $(basename "$1") (this can take a few minutes)"
    xcrun notarytool submit "$1" --keychain-profile "$NOTARY_PROFILE" --wait
    [ "${2:-0}" -eq 1 ] && xcrun stapler staple "$1"
    return 0
}

for format in $PACKAGE_FORMATS; do
    case "$format" in
        zip)
            OUT="$DIST_DIR/$PACKAGE_NAME.zip"
            echo "▶ Creating $OUT"
            rm -f "$OUT"
            ditto -c -k --keepParent "$APP_PATH" "$OUT"
            notarize "$OUT" 0
            ARTIFACTS+=("$OUT") ;;
        dmg)
            OUT="$DIST_DIR/$PACKAGE_NAME.dmg"
            echo "▶ Creating $OUT"
            rm -f "$OUT"
            STAGE="$BUILD_DIR/dmg"
            rm -rf "$STAGE"; mkdir -p "$STAGE"
            ditto "$APP_PATH" "$STAGE/$APP_NAME.app"      # ditto keeps the code signature intact
            ln -s /Applications "$STAGE/Applications"
            if [ -f LICENSE ]; then cp LICENSE "$STAGE/LICENSE.txt"; fi
            # Newer macOS versions print a harmless "hdiutil ... is deprecated" warning; hide only that line.
            HDI_LOG="$(mktemp)"
            if ! hdiutil create -volname "$DMG_VOLUME_NAME" -srcfolder "$STAGE" -ov -format UDZO "$OUT" >/dev/null 2>"$HDI_LOG"; then
                cat "$HDI_LOG" >&2; rm -f "$HDI_LOG"; exit 1
            fi
            grep -v "is deprecated" "$HDI_LOG" >&2 || true
            rm -f "$HDI_LOG"
            [ "$SIGN_IDENTITY" != "-" ] && codesign --force --sign "$SIGN_IDENTITY" "$OUT"
            notarize "$OUT" 1
            ARTIFACTS+=("$OUT") ;;
        pkg)
            OUT="$DIST_DIR/$PACKAGE_NAME.pkg"
            echo "▶ Creating $OUT"
            rm -f "$OUT"
            PKG_ARGS=(--component "$APP_PATH" --install-location /Applications
                      --identifier "$BUNDLE_ID" --version "$VERSION")
            [ -n "$PKG_SIGN_IDENTITY" ] && PKG_ARGS+=(--sign "$PKG_SIGN_IDENTITY")
            pkgbuild "${PKG_ARGS[@]}" "$OUT" >/dev/null
            notarize "$OUT" 1
            ARTIFACTS+=("$OUT") ;;
        *) echo "Unknown format '$format' in PACKAGE_FORMATS (use dmg, zip, pkg)" >&2; exit 1 ;;
    esac
done

echo
echo "✔ Done. Packages in $DIST_DIR/:"
for f in "${ARTIFACTS[@]}"; do
    printf "  %s  (%s)\n" "$f" "$(du -h "$f" | cut -f1)"
    printf "    sha256: %s\n" "$(shasum -a 256 "$f" | cut -d' ' -f1)"
done
