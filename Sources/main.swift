// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Cocoa
import IOKit.ps
import AVFoundation

// MARK: - App

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?

    private var lastPercent: Int?          // percentage at the previous check
    private var acknowledged = false       // true after Close was pressed, until the battery is above the threshold again
    private var isShowingAlert = false
    private var currentAlert: NSAlert?    // the popup while it is on screen

    // Sound alarm + read aloud
    private let synthesizer = AVSpeechSynthesizer()
    private var alarmSound: NSSound?
    private var alarmTimer: Timer?
    private var soundMenuItem: NSMenuItem?     // "Sound alarm" item in the menu bar menu
    private var currentCheckbox: NSButton?     // "Sound alarm" checkbox in the popup (while it is open)
    private var lockFD: Int32 = -1             // single-instance lock
    private var activeInterval: TimeInterval = 0   // check interval the timer currently uses
    private var settingsObserver: NSObjectProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let info = Bundle.main.infoDictionary
        appLog("Starting \(info?["CFBundleName"] as? String ?? "app") "
             + "\(info?["CFBundleShortVersionString"] as? String ?? "dev") (pid \(getpid()))")

        // BATTERYALERT_SMOKE_TEST is set by package.sh for its launch test: skip the lock then.
        let skipLock = ProcessInfo.processInfo.environment["BATTERYALERT_SMOKE_TEST"] != nil
        if Settings.singleInstance && !skipLock && !acquireSingleInstanceLock() {
            appLog("Another copy is already running - this copy quits")
            if Settings.showAlreadyRunningMessage {
                showInfoAlert(String(format: currentText().alreadyRunning, appName))
            }
            exit(0)
        }
        setUpMenu()
        settingsObserver = NotificationCenter.default.addObserver(
            forName: Settings.didChange, object: nil, queue: .main) { [weak self] _ in
            self?.settingsChanged()
        }
        startMonitoring()
        appLog("Started: menu bar item and monitoring are active")
        check()                                   // shows the battery in the menu bar (and the popup if it is low)
        if Settings.showStartupMessage {
            showInfoAlert(String(format: currentText().started, appName))
        }
    }

    private var appName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "BatteryAlert"
    }

    /// Small informational message with a Close button.
    private func showInfoAlert(_ message: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = appName
        alert.informativeText = message
        alert.addButton(withTitle: currentText().close)
        alert.window.level = .floating
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }

    // Menu bar item
    private func setUpMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        rebuildMenu()
    }

    /// (Re)builds the menu bar menu: at start-up and whenever a preference changes.
    private func rebuildMenu() {
        let menu = NSMenu()

        // Name + version, taken from Info.plist (set in config.env)
        let info = Bundle.main.infoDictionary
        let name = info?["CFBundleName"] as? String ?? "BatteryAlert"
        let version = info?["CFBundleShortVersionString"] as? String ?? "dev"
        let versionItem = NSMenuItem(title: "\(name) \(version)", action: nil, keyEquivalent: "")
        versionItem.isEnabled = false
        menu.addItem(versionItem)
        menu.addItem(.separator())

        // Sound alarm on/off: can be changed at any time
        let soundItem = NSMenuItem(title: currentText().soundAlarm,
                                   action: #selector(toggleSoundAlarm(_:)), keyEquivalent: "")
        soundItem.target = self
        soundItem.state = Settings.soundAlarm ? .on : .off
        menu.addItem(soundItem)
        soundMenuItem = soundItem
        menu.addItem(.separator())

        if Settings.showTestMenuItem {
            let testItem = NSMenuItem(title: ui("menu.testWarning"), action: #selector(testWarning), keyEquivalent: "t")
            testItem.target = self
            menu.addItem(testItem)
        }

        let prefsItem = NSMenuItem(title: ui("menu.preferences"), action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)

        let helpItem = NSMenuItem(title: ui("menu.help"), action: #selector(openHelp), keyEquivalent: "")
        helpItem.target = self
        menu.addItem(helpItem)

        menu.addItem(.separator())
        menu.addItem(withTitle: ui("menu.quit"), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.menu = menu
    }

    // MARK: Preferences and Help

    @objc private func openPreferences() { PreferencesWindow.shared.show() }
    @objc private func openHelp() { HelpWindow.shared.show() }

    /// Applies a changed preference right away.
    private func settingsChanged() {
        rebuildMenu()                                               // menu items + check mark of the sound alarm
        currentCheckbox?.state = Settings.soundAlarm ? .on : .off   // checkbox in an open popup
        if currentAlert != nil {                                    // popup is open: start or stop the alarm
            if Settings.soundAlarm && alarmTimer == nil { startAlarm() }
            if !Settings.soundAlarm && alarmTimer != nil { stopAlarm() }
        }
        if Settings.checkInterval != activeInterval { restartTimer() }
        if let battery = readBattery() {                            // new colours / limits
            updateStatusItem(percent: battery.percent, onAC: battery.isOnACPower)
        }
    }

    // Event-driven updates + a timer as a safety net
    private func startMonitoring() {
        let context = Unmanaged.passUnretained(self).toOpaque()
        if let source = IOPSNotificationCreateRunLoopSource({ ctx in
            guard let ctx = ctx else { return }
            Unmanaged<AppDelegate>.fromOpaque(ctx).takeUnretainedValue().check()
        }, context)?.takeRetainedValue() {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        }

        restartTimer()
    }

    private func restartTimer() {
        timer?.invalidate()
        activeInterval = Settings.checkInterval
        let t = Timer(timeInterval: activeInterval, repeats: true) { [weak self] _ in self?.check() }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    // Menu bar icon: green above 20%, yellow 11-20%, red 0-10%
    private func iconColor(for percent: Int) -> NSColor {
        switch percent {
        case ...Settings.redUpTo: return .systemRed
        case ...Settings.yellowUpTo: return .systemYellow
        default:    return .systemGreen
        }
    }

    private func symbolName(for percent: Int) -> String {
        switch percent {
        case 88...: return "battery.100"
        case 63...: return "battery.75"
        case 38...: return "battery.50"
        case 13...: return "battery.25"
        default:    return "battery.0"
        }
    }

    // Coloured battery symbol; while charging a lightning bolt is drawn inside it.
    // pointSize: nil = default menu bar size; pass e.g. 64 for the large popup picture.
    private func makeBatteryImage(percent: Int, onAC: Bool, pointSize: CGFloat? = nil) -> NSImage? {
        let color = iconColor(for: percent)
        var config = NSImage.SymbolConfiguration(hierarchicalColor: color)
        if let pointSize = pointSize {
            config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .regular).applying(config)
        }
        guard let battery = NSImage(systemSymbolName: symbolName(for: percent),
                                    accessibilityDescription: "Battery")?
            .withSymbolConfiguration(config)
        else { return nil }

        guard onAC else {
            battery.isTemplate = false
            return battery
        }

        let boltBase = NSImage(systemSymbolName: "bolt.fill", accessibilityDescription: "Charging")
        let weight = NSImage.SymbolConfiguration(pointSize: 9, weight: .heavy)
        guard
            let white = boltBase?.withSymbolConfiguration(
                weight.applying(NSImage.SymbolConfiguration(hierarchicalColor: .white))),
            let dark = boltBase?.withSymbolConfiguration(
                weight.applying(NSImage.SymbolConfiguration(hierarchicalColor: NSColor.black.withAlphaComponent(0.75))))
        else {
            battery.isTemplate = false
            return battery
        }

        let size = battery.size
        let result = NSImage(size: size, flipped: false) { rect in
            battery.draw(in: rect)

            // The battery body is the left part of the symbol (the right part is the terminal cap).
            let body = NSRect(x: rect.minX, y: rect.minY, width: rect.width * 0.88, height: rect.height)
            let height = rect.height * 0.62
            let width = height * white.size.width / max(white.size.height, 1)

            func draw(_ image: NSImage, scale: CGFloat) {
                let w = width * scale, h = height * scale
                image.draw(in: NSRect(x: body.midX - w / 2, y: body.midY - h / 2, width: w, height: h))
            }
            draw(dark, scale: 1.3)    // dark halo so the bolt is visible on any fill
            draw(white, scale: 1.0)
            return true
        }
        result.isTemplate = false
        return result
    }

    private func updateStatusItem(percent: Int, onAC: Bool) {
        guard let button = statusItem.button else { return }
        if let image = makeBatteryImage(percent: percent, onAC: onAC) {
            button.image = image
            button.imagePosition = .imageLeading
            button.title = " \(percent)%"
        } else {
            button.image = nil
            button.title = "🔋 \(percent)%" + (onAC ? " ⚡︎" : "")
        }
    }

    func check() {
        guard let battery = readBattery() else {
            statusItem.button?.image = nil
            statusItem.button?.title = "No battery"
            return
        }
        let percent = battery.percent
        updateStatusItem(percent: percent, onAC: battery.isOnACPower)
        refreshAlert(battery: battery)   // popup follows the menu bar icon

        let previous = lastPercent
        lastPercent = percent

        // Above the threshold: warnings are armed again.
        if percent > Settings.warningThreshold {
            acknowledged = false
            return
        }

        // At or below the threshold: no popup if
        //  - Close was already pressed (stays quiet until the battery is above 20% again),
        //  - a popup is already open (it stays until Close is pressed),
        //  - the percentage went up since the previous check.
        // (Being plugged in does not matter: a drop to 20% or lower always warns.)
        if acknowledged || isShowingAlert { return }
        if let previous = previous, percent > previous { return }

        showWarning(battery: battery)   // blocks until Close is pressed
        acknowledged = true
    }

    @objc private func testWarning() {
        // test only: shows the real battery state and doesn't change the warning state
        let battery = readBattery() ?? BatteryStatus(percent: Settings.warningThreshold, isOnACPower: false)
        showWarning(battery: battery)
    }

    // Keeps an open popup in sync with the menu bar icon (colour, fill level, charging sign, text, time estimate).
    private func refreshAlert(battery: BatteryStatus) {
        guard let alert = currentAlert else { return }
        if let picture = makeBatteryImage(percent: battery.percent, onAC: battery.isOnACPower,
                                          pointSize: Settings.alertIconSize) {
            alert.icon = picture
        }
        alert.informativeText = warningBody(for: battery)
    }

    // MARK: Sound alarm

    /// Saving the setting posts a notification; settingsChanged() then keeps the menu item,
    /// the popup checkbox, the Preferences window and the alarm in sync.
    private func setSoundAlarm(_ on: Bool) {
        Settings.soundAlarm = on
    }

    @objc private func toggleSoundAlarm(_ sender: NSMenuItem) {
        setSoundAlarm(!Settings.soundAlarm)
    }

    @objc private func soundCheckboxChanged(_ sender: NSButton) {
        setSoundAlarm(sender.state == .on)
    }

    // MARK: Single instance

    /// Takes an exclusive lock on a file; a second copy of the app can't get it and quits.
    /// The lock is released automatically when the app exits (also after a crash).
    private func acquireSingleInstanceLock() -> Bool {
        let id = Bundle.main.bundleIdentifier ?? "BatteryAlert"
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(id).lock")
        lockFD = open(path, O_CREAT | O_RDWR, 0o600)
        guard lockFD >= 0 else { return true }   // can't create the lock file: don't block the app
        return flock(lockFD, LOCK_EX | LOCK_NB) == 0
    }

    private func startAlarm() {
        stopAlarm()
        playAlarmOnce()
        let t = Timer(timeInterval: Settings.alarmRepeatInterval, repeats: true) { [weak self] _ in self?.playAlarmOnce() }
        RunLoop.main.add(t, forMode: .common)
        alarmTimer = t
    }

    // Stops the repeat timer, the alarm sound and the speech (also utterances that are still queued).
    private func stopAlarm() {
        alarmTimer?.invalidate()
        alarmTimer = nil
        alarmSound?.stop()
        alarmSound = nil
        synthesizer.stopSpeaking(at: .immediate)
        if synthesizer.isSpeaking || synthesizer.isPaused {
            synthesizer.stopSpeaking(at: .word)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        stopAlarm()
    }

    private func playAlarmOnce() {
        guard let alert = currentAlert else { return }

        alarmSound?.stop()
        alarmSound = NSSound(named: Settings.alarmSoundName)
        alarmSound?.play()

        // Read the text of the popup aloud, in the system language, after the alarm sound.
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "\(alert.messageText). \(alert.informativeText)")
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first ?? "en-US")
        utterance.preUtteranceDelay = Settings.speechDelay
        synthesizer.speak(utterance)
    }

    private func showWarning(battery: BatteryStatus) {
        guard !isShowingAlert else { return }
        isShowingAlert = true

        let text = currentText()
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = Settings.warningTitle   // own text or the standard title
        alert.informativeText = warningBody(for: battery)   // percentage + estimated time
        if let picture = makeBatteryImage(percent: battery.percent, onAC: battery.isOnACPower,
                                          pointSize: Settings.alertIconSize) {
            alert.icon = picture          // same colour and charging sign as the menu bar icon
        }
        alert.addButton(withTitle: text.close)

        // Checkbox: same setting as the "Sound alarm" menu item (alarm sound + read the popup text aloud)
        let checkbox = NSButton(checkboxWithTitle: text.soundAlarm,
                                target: self, action: #selector(soundCheckboxChanged(_:)))
        checkbox.state = Settings.soundAlarm ? .on : .off
        checkbox.sizeToFit()
        alert.accessoryView = checkbox
        alert.window.level = .floating

        NSApp.activate(ignoringOtherApps: true)
        currentAlert = alert
        currentCheckbox = checkbox
        if Settings.soundAlarm { startAlarm() }
        alert.runModal()          // stays on screen until the button is pressed
        currentAlert = nil        // set first: a late timer tick can no longer start new speech
        currentCheckbox = nil
        stopAlarm()               // popup closed -> alarm sound and speech stop immediately
        isShowingAlert = false
    }
}

appLog("Process launched (this line is written before the app window system starts)")
let app = NSApplication.shared
app.setActivationPolicy(.accessory)   // menu bar only, no Dock icon
let delegate = AppDelegate()
app.delegate = delegate
app.run()
