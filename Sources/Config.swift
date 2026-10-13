// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Foundation

/// DEFAULT values of all settings.
///
/// The user can change every setting in the menu bar menu → Preferences…
/// Those changes are stored on the Mac. "Reset to defaults" in Preferences goes back to the values below.
/// Change a value here and run ./package.sh to give the app new default values.
enum Config {

    // MARK: Warning

    /// The popup is shown when the battery is at or below this percentage.
    static let warningThreshold = 20

    /// Your own warning text. It replaces the title of the popup ("Low Battery").
    /// Empty = use the standard text in the system language.
    static let customWarningText = ""

    // MARK: Menu bar / popup icon colours

    /// Icon is red at this percentage or lower (0-10%).
    static let redUpTo = 10
    /// Icon is yellow above `redUpTo` up to this percentage (11-20%). Above it the icon is green.
    static let yellowUpTo = 20

    /// Size (in points) of the battery picture inside the popup.
    static let alertIconSize: CGFloat = 64

    // MARK: Timings (seconds)

    /// How often the battery is checked. (It is also checked immediately on every power change.)
    static let checkInterval: TimeInterval = 30

    /// While the popup is open and the sound alarm is on: pause between two alarms.
    static let alarmRepeatInterval: TimeInterval = 15

    /// Pause between the alarm sound and the spoken text.
    static let speechDelay: TimeInterval = 1.0

    // MARK: Sound

    /// Name of a macOS system sound: Basso, Blow, Bottle, Frog, Funk, Glass, Hero,
    /// Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
    static let alarmSoundName = "Sosumi"

    /// Is the sound alarm (alarm sound + reading the text aloud) on by default?
    static let soundAlarmDefault = true

    // MARK: Menu and messages

    /// Show the "Test warning" item in the menu bar menu.
    static let showTestMenuItem = false

    /// Show a small message at start-up ("... is running in the menu bar").
    static let showStartupMessage = false

    /// When a second copy is started: show a message that the app is already running
    /// (instead of quitting silently).
    static let showAlreadyRunningMessage = false

    // MARK: Instances

    /// Only allow one running copy of the app (a second copy quits immediately).
    static let singleInstance = true

    // MARK: Diagnostics

    /// Write start-up messages to ~/Library/Logs/<AppName>.log (they always go to Console.app too).
    static let logToFile = true
}
