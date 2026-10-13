// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Cocoa

// MARK: - Description of the settings (used by the Preferences window and the Help window)

enum SettingKind {
    case int(min: Int, max: Int, step: Int)
    case double(min: Double, max: Double, step: Double)
    case bool
    case choice([String])
    case text
}

struct SettingDef {
    let key: String            // name in UserDefaults (and in Config.swift)
    let kind: SettingKind
    let unitKey: String?       // key in UIStrings.swift, e.g. "unit.seconds"
    var titleKey: String { "setting.\(key).title" }
    var helpKey: String { "setting.\(key).help" }
}

// MARK: - Current values

/// The value the user chose in Preferences or, if nothing was changed, the default from Config.swift.
/// The rest of the app always reads settings from here.
enum Settings {

    /// Posted (on the main thread) whenever a setting changes.
    static let didChange = Notification.Name("BatteryAlertSettingsDidChange")

    static let systemSounds = ["Basso", "Blow", "Bottle", "Frog", "Funk", "Glass", "Hero",
                               "Morse", "Ping", "Pop", "Purr", "Sosumi", "Submarine", "Tink"]

    /// All settings, in the order they appear in Preferences and Help.
    static let all: [SettingDef] = [
        SettingDef(key: "warningThreshold",          kind: .int(min: 1, max: 99, step: 1),             unitKey: "unit.percent"),
        SettingDef(key: "customWarningText",         kind: .text,                                      unitKey: nil),
        SettingDef(key: "redUpTo",                   kind: .int(min: 0, max: 99, step: 1),             unitKey: "unit.percent"),
        SettingDef(key: "yellowUpTo",                kind: .int(min: 1, max: 99, step: 1),             unitKey: "unit.percent"),
        SettingDef(key: "alertIconSize",             kind: .int(min: 32, max: 128, step: 8),           unitKey: "unit.points"),
        SettingDef(key: "checkInterval",             kind: .int(min: 5, max: 600, step: 5),            unitKey: "unit.seconds"),
        SettingDef(key: "alarmRepeatInterval",       kind: .int(min: 5, max: 300, step: 5),            unitKey: "unit.seconds"),
        SettingDef(key: "speechDelay",               kind: .double(min: 0, max: 10, step: 0.5),        unitKey: "unit.seconds"),
        SettingDef(key: "alarmSoundName",            kind: .choice(Settings.systemSounds),             unitKey: nil),
        SettingDef(key: "soundAlarm",                kind: .bool,                                      unitKey: nil),
        SettingDef(key: "showTestMenuItem",          kind: .bool,                                      unitKey: nil),
        SettingDef(key: "showStartupMessage",        kind: .bool,                                      unitKey: nil),
        SettingDef(key: "showAlreadyRunningMessage", kind: .bool,                                      unitKey: nil),
        SettingDef(key: "singleInstance",            kind: .bool,                                      unitKey: nil),
        SettingDef(key: "logToFile",                 kind: .bool,                                      unitKey: nil),
    ]

    static func definition(_ key: String) -> SettingDef? {
        all.first { $0.key == key }
    }

    private static let store = UserDefaults.standard

    private static func readInt(_ key: String, _ fallback: Int) -> Int {
        store.object(forKey: key) == nil ? fallback : store.integer(forKey: key)
    }
    private static func readDouble(_ key: String, _ fallback: Double) -> Double {
        store.object(forKey: key) == nil ? fallback : store.double(forKey: key)
    }
    private static func readBool(_ key: String, _ fallback: Bool) -> Bool {
        store.object(forKey: key) == nil ? fallback : store.bool(forKey: key)
    }
    private static func readString(_ key: String, _ fallback: String) -> String {
        store.string(forKey: key) ?? fallback
    }

    // MARK: Typed access for the app

    static var warningThreshold: Int       { readInt("warningThreshold", Config.warningThreshold) }
    static var customWarningText: String   { readString("customWarningText", Config.customWarningText) }
    static var redUpTo: Int                { readInt("redUpTo", Config.redUpTo) }

    /// Title of the popup: your own text, or the standard text in the system language when it is empty.
    static var warningTitle: String {
        let own = customWarningText.trimmingCharacters(in: .whitespacesAndNewlines)
        return own.isEmpty ? currentText().title : own
    }
    static var yellowUpTo: Int             { readInt("yellowUpTo", Config.yellowUpTo) }
    static var alertIconSize: CGFloat      { CGFloat(readDouble("alertIconSize", Double(Config.alertIconSize))) }
    static var checkInterval: TimeInterval { readDouble("checkInterval", Config.checkInterval) }
    static var alarmRepeatInterval: TimeInterval { readDouble("alarmRepeatInterval", Config.alarmRepeatInterval) }
    static var speechDelay: TimeInterval   { readDouble("speechDelay", Config.speechDelay) }
    static var alarmSoundName: String      { readString("alarmSoundName", Config.alarmSoundName) }
    static var showTestMenuItem: Bool      { readBool("showTestMenuItem", Config.showTestMenuItem) }
    static var showStartupMessage: Bool    { readBool("showStartupMessage", Config.showStartupMessage) }
    static var showAlreadyRunningMessage: Bool { readBool("showAlreadyRunningMessage", Config.showAlreadyRunningMessage) }
    static var singleInstance: Bool        { readBool("singleInstance", Config.singleInstance) }
    static var logToFile: Bool             { readBool("logToFile", Config.logToFile) }

    static var soundAlarm: Bool {
        get { readBool("soundAlarm", Config.soundAlarmDefault) }
        set { setBool("soundAlarm", newValue) }
    }

    // MARK: Generic access for the Preferences window

    static func currentNumber(_ key: String) -> Double {
        switch key {
        case "warningThreshold":    return Double(warningThreshold)
        case "redUpTo":             return Double(redUpTo)
        case "yellowUpTo":          return Double(yellowUpTo)
        case "alertIconSize":       return Double(alertIconSize)
        case "checkInterval":       return checkInterval
        case "alarmRepeatInterval": return alarmRepeatInterval
        case "speechDelay":         return speechDelay
        default:                    return 0
        }
    }

    static func currentBool(_ key: String) -> Bool {
        switch key {
        case "soundAlarm":                return soundAlarm
        case "showTestMenuItem":          return showTestMenuItem
        case "showStartupMessage":        return showStartupMessage
        case "showAlreadyRunningMessage": return showAlreadyRunningMessage
        case "singleInstance":            return singleInstance
        case "logToFile":                 return logToFile
        default:                          return false
        }
    }

    static func currentString(_ key: String) -> String {
        switch key {
        case "alarmSoundName":    return alarmSoundName
        case "customWarningText": return customWarningText
        default:                  return ""
        }
    }

    // MARK: Changing settings

    /// Stores a number, limited to the allowed range of that setting.
    static func setNumber(_ key: String, _ value: Double) {
        guard let def = definition(key) else { return }
        switch def.kind {
        case .int(let lo, let hi, _):
            store.set(Int(Swift.min(Swift.max(value.rounded(), Double(lo)), Double(hi))), forKey: key)
        case .double(let lo, let hi, _):
            store.set(Swift.min(Swift.max(value, lo), hi), forKey: key)
        default:
            return
        }
        changed()
    }

    static func setBool(_ key: String, _ value: Bool) {
        store.set(value, forKey: key)
        changed()
    }

    static func setString(_ key: String, _ value: String) {
        store.set(value, forKey: key)
        changed()
    }

    /// Back to the default values from Config.swift.
    static func resetAll() {
        for def in all { store.removeObject(forKey: def.key) }
        changed()
    }

    private static func changed() {
        NotificationCenter.default.post(name: didChange, object: nil)
    }
}
