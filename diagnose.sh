#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.
# Collects information about why BatteryAlert does not start and writes diagnose-report.txt.
#
#   ./diagnose.sh                 check build/BatteryAlert.app (or /Applications/BatteryAlert.app)
#   ./diagnose.sh path/to/X.app   check a specific app
#   ./diagnose.sh --fix           also: stop running copies, remove the quarantine flag, re-sign (ad hoc)
cd "$(dirname "$0")"
source ./config.env

FIX=0; APP=""
for arg in "$@"; do
    case "$arg" in
        --fix) FIX=1 ;;
        *) APP="$arg" ;;
    esac
done
[ -n "$APP" ] || APP="$BUILD_DIR/$APP_NAME.app"
[ -d "$APP" ] || APP="/Applications/$APP_NAME.app"
[ -d "$APP" ] || { echo "App not found. Run ./package.sh --app-only first, or give the path to the .app" >&2; exit 1; }

BIN="$APP/Contents/MacOS/$EXECUTABLE_NAME"
REPORT="diagnose-report.txt"

if [ "$FIX" -eq 1 ]; then
    echo "== Fix =="
    pkill -x "$EXECUTABLE_NAME" 2>/dev/null && echo "stopped running copies" || echo "no running copies"
    xattr -cr "$APP" && echo "removed extended attributes (quarantine)"
    codesign --force --deep --sign - "$APP" && echo "re-signed (ad hoc)"
    echo
fi

{
echo "== System =="
sw_vers; echo "arch: $(uname -m)"

echo; echo "== App =="
echo "$APP"
ls -la "$APP/Contents" "$APP/Contents/MacOS" 2>&1
file "$BIN" 2>&1
echo "architectures: $(lipo -archs "$BIN" 2>&1)"
plutil -lint "$APP/Contents/Info.plist" 2>&1

echo; echo "== Quarantine / extended attributes =="
xattr -lr "$APP" 2>&1 | head -20; echo "(end)"

echo; echo "== Signature =="
codesign --verify --deep --strict --verbose=2 "$APP" 2>&1
codesign -dv "$APP" 2>&1 | head -8
spctl --assess --verbose "$APP" 2>&1 || true

echo; echo "== Running copies =="
pgrep -fl "$EXECUTABLE_NAME" || echo "none"
echo "lock files:"; ls -la "${TMPDIR:-/tmp}"/*.lock 2>&1 | head

echo; echo "== Direct start (5 seconds, lock check skipped) =="
BATTERYALERT_SMOKE_TEST=1 "$BIN" > /tmp/batterywarning-direct.log 2>&1 &
PID=$!
sleep 5
if kill -0 "$PID" 2>/dev/null; then
    echo "RESULT: the app starts and keeps running (menu bar item should have been visible)"
    kill "$PID" 2>/dev/null; wait "$PID" 2>/dev/null
else
    CODE=0; wait "$PID" || CODE=$?
    case $CODE in
        0)   WHY="(clean exit)" ;;
        132) WHY="(SIGILL: illegal instruction)" ;;
        133) WHY="(SIGTRAP: crash / Swift runtime trap)" ;;
        134) WHY="(SIGABRT: aborted)" ;;
        137) WHY="(SIGKILL: killed by macOS, usually a code signature / security problem)" ;;
        139) WHY="(SIGSEGV: crash)" ;;
        *)   WHY="" ;;
    esac
    echo "RESULT: the app QUIT within 5 seconds, exit code $CODE $WHY"
fi
echo "--- output ---"; cat /tmp/batterywarning-direct.log

echo; echo "== App log (~/Library/Logs/$APP_NAME.log) =="
tail -n 30 "$HOME/Library/Logs/$APP_NAME.log" 2>&1

echo; echo "== System log (last 3 minutes) =="
log show --last 3m --style compact \
    --predicate "process == \"$EXECUTABLE_NAME\" OR eventMessage CONTAINS \"$EXECUTABLE_NAME\"" 2>&1 | tail -n 40

echo; echo "== Crash reports (newest first; reports can take a few seconds to appear) =="
sleep 3
ls -lt "$HOME/Library/Logs/DiagnosticReports/" 2>/dev/null | head -6
ls -t "$HOME/Library/Logs/DiagnosticReports/" 2>/dev/null | grep -i "$APP_NAME\|$EXECUTABLE_NAME" | head -3 | while read -r f; do
    echo "--- $f (first lines) ---"; head -c 3000 "$HOME/Library/Logs/DiagnosticReports/$f"; echo
done
echo "(end)"
} 2>&1 | tee "$REPORT"

echo
echo "Report saved in $(pwd)/$REPORT"
