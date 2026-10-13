# BatteryAlert

A small macOS menu bar app that watches the battery and shows a low-battery popup, like the one on an iPhone.

- Menu bar icon with percentage: **green** above 20%, **yellow** 11–20%, **red** 0–10%, with a lightning bolt while charging.
- Popup at 20% or lower with the same icon, the percentage and the **estimated time remaining**.
- Optional **sound alarm** that plays a sound and reads the popup text aloud, in the system language.
- **Preferences** window with all settings (each with an explanation) and a button to restore the defaults.
- **Help** window that explains how the app works and what every setting does.
- Menu and popup texts follow the macOS system language (13 languages built in).
- Only **one copy** of the app can run at a time.

Requires macOS 12 or newer. Free software under the **GNU GPL v3** (see [License](#license)).

---

## Quick start

```bash
xcode-select --install     # once: installs the Swift compiler
./package.sh               # builds the app and creates dist/BatteryAlert-1.0.0.dmg and .zip
open build/BatteryAlert.app
```

`./package.sh --app-only` builds only the app (faster while developing).
`./package.sh --clean` removes the `build/` and `dist/` folders.

---

## Project layout

> The folder structure matters: the Swift files must be in `Sources/` (`package.sh` compiles only that folder, and warns about `.swift` files lying next to it). Keep the files from the zip in their folders; don't copy single files to the project root.

```
BatteryAlert/
├── config.env              ← package settings: name, version, bundle id, formats, signing
├── package.sh              ← builds the .app and creates dmg / zip / pkg
├── diagnose.sh             ← collects information when the app does not start
├── README.md
├── LICENSE                 ← GPLv3 (see the License section below)
├── Resources/
│   ├── AppIcon.png         ← the app icon (1024 x 1024 px)
│   ├── AppIcon.icns        ← the same icon in the format macOS needs
│   └── make_icns.py        ← converts AppIcon.png into AppIcon.icns
└── Sources/
    ├── Config.swift        ← DEFAULT values of all settings
    ├── Settings.swift      ← current values (user's choice or default) + list of settings
    ├── Preferences.swift   ← Preferences window and Help window
    ├── Localization.swift  ← popup texts + translations
    ├── UIStrings.swift     ← menu, Preferences and Help texts + translations
    ├── Battery.swift       ← reads battery level, charging state, time estimate
    ├── Log.swift           ← start-up log (~/Library/Logs/BatteryAlert.log)
    └── main.swift          ← the app itself (menu bar, popup, alarm)
```

There are two settings files, each with its own job:

| File | Changes… | Takes effect after |
|---|---|---|
| `Sources/Config.swift` | the **default values** of the app settings | `./package.sh` |
| `config.env` | how the app is **packaged** (version, name, id) | `./package.sh` |

---

## Preferences and Help

Click the battery icon in the menu bar:

| Menu item | What it does |
|---|---|
| Sound alarm and read aloud | Switches the sound alarm on or off (check mark = on) |
| Test warning | Shows the popup with your current battery level (only if enabled in Preferences) |
| Preferences… | Opens the Preferences window |
| Help | Explains how the app works and what every setting does |
| Quit | Stops the app |

All menu items are shown in the system language.

**Preferences** has every setting from `Config.swift`, each with a short explanation below it. Changes are saved and applied immediately (a few settings say they take effect the next time the app starts). The button **Reset to defaults** goes back to the values in `Config.swift`. The same explanations are shown in the **Help** window.

Your own choices are stored on the Mac (in the app's preferences); `Config.swift` only holds the **defaults**.

## Settings and defaults (`Sources/Config.swift`)

| Setting | Default | Meaning |
|---|---|---|
| `warningThreshold` | `20` | Popup is shown at this percentage or lower |
| `customWarningText` | `""` | Your own warning text. It replaces the title of the popup ("Low Battery"); empty = standard text in the system language |
| `redUpTo` | `10` | Icon is red at this percentage or lower |
| `yellowUpTo` | `20` | Icon is yellow above `redUpTo` up to this value; above it the icon is green |
| `alertIconSize` | `64` | Size of the battery picture in the popup |
| `checkInterval` | `30` | Seconds between battery checks (it also reacts immediately to power changes) |
| `alarmRepeatInterval` | `15` | Seconds between alarms while the popup is open |
| `speechDelay` | `1.0` | Seconds between the alarm sound and the spoken text |
| `alarmSoundName` | `"Sosumi"` | macOS system sound: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink |
| `soundAlarmDefault` | `true` | Sound alarm is **on** by default |
| `showTestMenuItem` | `false` | Show "Test warning" in the menu |
| `showStartupMessage` | `false` | Small message at start-up ("running in the menu bar") |
| `showAlreadyRunningMessage` | `false` | Message when a second copy is started |
| `singleInstance` | `true` | Only one copy of the app can run |
| `logToFile` | `true` | Write start-up messages to `~/Library/Logs/BatteryAlert.log` |

Example: warn at 15% by default and make the alarm repeat every 30 seconds:

```swift
static let warningThreshold = 15
static let alarmRepeatInterval: TimeInterval = 30
```

Then run `./package.sh`. People who already changed a setting in Preferences keep their own value until they press **Reset to defaults**.

To add a new setting you also add it to `Settings.swift` (the list `Settings.all` and a property) and write its title and help text in `UIStrings.swift`; the Preferences and Help windows pick it up automatically.

### When does the popup appear?

- The battery is at `warningThreshold` or lower **and** the percentage is not higher than at the previous check (so normal charging does not trigger it). Being plugged in does not suppress the popup.
- The popup stays until you press **Close**. After closing it, no new popup appears until the battery has been above the threshold again.
- While the popup is open, its picture, percentage and time estimate are updated live.
- **Own warning text:** type your own text in Preferences (*Own warning text*), for example "Plug in the charger!". It replaces the title of the popup and is also read aloud by the sound alarm; the percentage and the estimated time stay below it. Empty = the standard text in the system language. *Test warning* (if enabled) shows how it looks.

### Sound alarm

- The setting is in the menu bar menu (**Sound alarm and read aloud**) and can be changed **at any time**, also when no popup is open. The checkbox in the popup and the checkbox in Preferences are the same setting.
- It is **on by default**. The choice is remembered.
- To go back to the defaults: **Preferences → Reset to defaults**. From Terminal (use your own `BUNDLE_ID` from `config.env`):
  ```bash
  defaults delete com.example.BatteryAlert
  ```
- The alarm and the speech stop when you press **Close**.

### Estimated time remaining

The popup shows the estimate that macOS calculates for the battery:

- On battery: "Estimated time remaining: 1 hr, 23 min". Right after unplugging macOS needs a moment, so it shows "calculating…" first.
- On the charger: "Plugged in", because there is no remaining time while charging.

---

## Package settings (`config.env`)

| Variable | Default | Meaning |
|---|---|---|
| `APP_NAME` | `BatteryAlert` | Name of the app (`.app`, menu, Finder) |
| `EXECUTABLE_NAME` | `BatteryAlert` | Name of the program inside the app |
| `BUNDLE_ID` | `com.example.BatteryAlert` | Unique id. **Change this** to your own, e.g. `nl.yourname.BatteryAlert` |
| `VERSION` | `1.0.0` | Version shown to users |
| `BUILD_NUMBER` | `1` | Increase with every build |
| `COPYRIGHT` | `Copyright © 2026 Edwin Pijper` | Copyright text |
| `MIN_MACOS` | `12.0` | Minimum macOS version |
| `ARCHS` | `arm64 x86_64` | `arm64 x86_64` = works on all Macs; `arm64` = Apple Silicon only |
| `ICON_FILE` | `Resources/AppIcon.icns` | App icon. Use your own `.icns` file, or `ICON_FILE=""` for no icon |
| `PACKAGE_FORMATS` | `dmg zip` | Any of `dmg`, `zip`, `pkg` |
| `PACKAGE_NAME` | `<APP_NAME>-<VERSION>` | File name without extension |
| `DMG_VOLUME_NAME` | `<APP_NAME> <VERSION>` | Name of the disk image |
| `SIGN_IDENTITY` | `-` | `-` = ad-hoc signature; or a Developer ID certificate |
| `PKG_SIGN_IDENTITY` | *(empty)* | Certificate for signing the `.pkg` |
| `NOTARY_PROFILE` | *(empty)* | Keychain profile for notarization |

The version is also shown at the top of the menu bar menu.

### Releasing a new version

1. Change `VERSION` (and `BUILD_NUMBER`) in `config.env`, or give them for one run:
   ```bash
   VERSION=1.1.0 BUILD_NUMBER=2 ./package.sh
   ```
2. The packages appear in `dist/`, for example `dist/BatteryAlert-1.1.0.dmg`. The script also prints the SHA-256 checksum of each file.

Any variable in `config.env` can be overridden this way for a single run.

---

## App icon

The icon is `Resources/AppIcon.png` (1024 x 1024 px, with transparent corners). `package.sh` uses `Resources/AppIcon.icns`, the same picture in the format macOS needs. To use another icon:

1. Replace `Resources/AppIcon.png` by your own 1024 x 1024 PNG.
2. Convert it:
   ```bash
   pip3 install pillow      # once
   python3 Resources/make_icns.py
   ```
3. Run `./package.sh` again.

(Or point `ICON_FILE` in `config.env` to a ready-made `.icns` file.)

The menu bar icon and the popup picture are drawn by the app itself (green / yellow / red) and are not affected by this file.

---

## Changing texts and adding a language

There are two text files:

- `Sources/Localization.swift`: the **popup** texts (title, percentage, Close, sound alarm, estimated time, start-up messages). 13 languages.
- `Sources/UIStrings.swift`: the **menu**, **Preferences** and **Help** texts.
  - The menu items and buttons (Quit, Preferences…, Help, Test warning, Reset to defaults, Cancel) are translated in all 13 languages.
  - The longer texts of the Preferences and Help windows are available in **English and Dutch**. Other languages show the English text.

To translate the Preferences and Help texts into another language, copy the `uiNL` dictionary in `UIStrings.swift`, change the language code (`"de"`, `"fr"`, …), translate the texts and use it in the list at the bottom of the file.

Popup texts, one line per language in `Localization.swift`:

```swift
"en": .init(title: "Low Battery", bodyFormat: "%d%% Battery Remaining", close: "Close",
            soundAlarm: "Sound alarm and read aloud",
            timeRemaining: "Estimated time remaining: %@", calculating: "calculating…",
            pluggedIn: "Plugged in",
            started: "%@ is running in the menu bar.",
            alreadyRunning: "%@ is already running in the menu bar."),
```

- `%d` is replaced by the percentage (write `%%` for a percent sign).
- `%@` in `started` and `alreadyRunning` is replaced by the app name.
- `%@` in `timeRemaining` is replaced by the duration (or `calculating`). The duration is formatted in the system language automatically.
- Languages that are not in the list use English.

The spoken text uses the voice that macOS has for the system language (install more voices in System Settings → Accessibility → Spoken Content).

---

## Signing and notarization (optional)

Without a paid Apple Developer account the app is signed ad hoc. That works on the Mac where you built it. On other Macs, macOS (Gatekeeper) shows a warning the first time:

- Right-click the app → **Open** → **Open**, or
- remove the quarantine flag:
  ```bash
  xattr -dr com.apple.quarantine /Applications/BatteryAlert.app
  ```

To distribute without warnings, with a Developer ID certificate:

```bash
# once: save notarization credentials in the keychain
xcrun notarytool store-credentials "battery-profile" \
    --apple-id you@example.com --team-id TEAMID --password app-specific-password
```

Then set in `config.env`:

```bash
SIGN_IDENTITY="Developer ID Application: Edwin Pijper (TEAMID)"
PKG_SIGN_IDENTITY="Developer ID Installer: Edwin Pijper (TEAMID)"   # only for pkg
NOTARY_PROFILE="battery-profile"
```

`./package.sh` then signs, notarizes and staples the packages.

---

## Renaming the app

The name is set in `config.env` (`APP_NAME`, `EXECUTABLE_NAME`, `BUNDLE_ID`). The name `BatteryAlert` is also used as a fallback in `Sources/Log.swift` and `Sources/main.swift`, and in the `BATTERYALERT_SMOKE_TEST` variable used by `package.sh` and `diagnose.sh`. When you rename the app:

- A new `BUNDLE_ID` means macOS sees a new app: saved settings (such as the sound alarm choice) start again from the defaults, the log file gets the new name, and the Login Item has to be added again.
- Remove the old app from **Applications** and from **Login Items**. The old and the new app have different ids, so both would run at the same time.

---

## Using the app

- **Install:** open the `.dmg` and drag the app to **Applications**.
- **Start at login:** System Settings → General → Login Items → add `BatteryAlert`.
- **Menu bar menu:** version, *Sound alarm and read aloud* (check mark = on), *Test warning*, *Quit*.
- **One copy only:** starting the app a second time does nothing; the extra copy quits immediately. The check uses a lock file in the temporary folder, so it also works if both copies are started at the same moment.

## If the app does not start

Quickest way: run `./diagnose.sh` (it writes `diagnose-report.txt` with system info, quarantine flags, signature check, a 5-second test start, the app log and crash reports). `./diagnose.sh --fix` also stops running copies, removes the quarantine flag and re-signs the app.

The report's `RESULT:` line shows the exit code when the app quits: **137** means macOS killed it (code signature / security), **133** or **139** means it crashed. The log file `~/Library/Logs/BatteryAlert.log` should get the line "Process launched" as soon as the program starts; if that line is missing, the program is stopped before it can run any of its own code.

The app has no window and no Dock icon, only a menu bar icon. To see a message when it starts, turn on **Show a message at start-up** in Preferences (or set `showStartupMessage = true` in `Config.swift`). With **Show a message when the app is already running** a second copy tells you that instead of quitting silently.

`./package.sh` starts the freshly built app for 3 seconds and stops with an error if it quits. If that passes but the installed app still seems to do nothing, check in this order:

1. **Is it already running?** The app has no window and no Dock icon, only a menu bar icon, and a second copy quits at once.
   ```bash
   pgrep -l BatteryAlert        # shows the process if it is running
   ```
   The icon can also be hidden when the menu bar is full (notch) or hidden by a menu bar manager.
2. **Blocked by macOS (Gatekeeper)?** Likely when the `.dmg` was downloaded or copied from another Mac and the app is not notarized.
   ```bash
   xattr -dr com.apple.quarantine /Applications/BatteryAlert.app
   open /Applications/BatteryAlert.app
   ```
   Or right-click the app → **Open**.
3. **Read the log.** Every start is logged:
   ```bash
   cat ~/Library/Logs/BatteryAlert.log
   ```
   You should see "Started: menu bar item and monitoring are active". If it says "Another copy is already running", quit the other copy (`pkill BatteryAlert`) and start again.
4. **Start it from Terminal** to see error messages:
   ```bash
   /Applications/BatteryAlert.app/Contents/MacOS/BatteryAlert
   ```
5. **Check the signature:**
   ```bash
   codesign --verify --deep --strict --verbose=2 /Applications/BatteryAlert.app
   spctl --assess --verbose /Applications/BatteryAlert.app
   ```
   (`spctl` rejects ad-hoc signed apps; that is expected and fixed by step 2 or by notarizing.)
6. **Crash report:** look in `~/Library/Logs/DiagnosticReports/` for a `BatteryAlert` file.

---

## Troubleshooting

| Problem | Try |
|---|---|
| `swiftc not found` | `xcode-select --install` |
| Build fails with a `-target` error | Use `ARCHS="arm64"` (or update Xcode) |
| `hdiutil ... is deprecated` | Newer macOS versions print this for `hdiutil`. It is only a warning and the `.dmg` is still created; `package.sh` hides this line |
| No sound or speech | Check the volume and that **Sound alarm** has a check mark in the menu |
| Wrong language for speech | Install the voice for your language in System Settings → Accessibility → Spoken Content |
| Time shows "calculating…" | Normal for a minute after unplugging; macOS is still estimating |
| App does not start after installing from the `.dmg` | See *If the app does not start* below |
| App does not start a second time | By design; turn off **Allow only one copy** in Preferences (`singleInstance` in `Config.swift`) to allow it |

---

## License

This project is free software, licensed under the **GNU General Public License version 3** (SPDX identifier `GPL-3.0-or-later`: version 3 or, at your option, any later version).

```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

Two things to do once, before you share the app or the source:

1. **Add the official license text.** The `LICENSE` file in this project only holds the notice above. Download the full text from the Free Software Foundation (it must be copied word for word, so take it from the source):
   ```bash
   curl -o LICENSE https://www.gnu.org/licenses/gpl-3.0.txt
   ```
   `package.sh` warns while the full text is missing.
2. **Fill in the copyright holder.** Replace `Edwin Pijper` everywhere (the `LICENSE`, the short headers in the source files and scripts, and `COPYRIGHT` in `config.env`):
   ```bash
   grep -rl "Edwin Pijper" . | xargs sed -i '' 's/Edwin Pijper/Your Real Name/g'      # macOS
   ```

How the license travels with the app:
- `package.sh` copies `LICENSE` into the app (`BatteryAlert.app/Contents/Resources/LICENSE`) and into the `.dmg` (as `LICENSE.txt`).
- The Help window has a short License section.
- Every source file starts with an `SPDX-License-Identifier: GPL-3.0-or-later` line.

Notes:
- To use **GPL-3.0-only** (no "or any later version") instead, change the SPDX lines to `GPL-3.0-only` and the wording in the notice above.
- The app only uses Apple's own frameworks and system sounds; no third-party code is included.
- You are responsible for having the right to distribute the app icon (`Resources/AppIcon.png`) under these terms. If the icon has its own license, mention it here.
