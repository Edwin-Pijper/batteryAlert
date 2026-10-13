// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Cocoa

/// A view whose origin is at the top (so scroll content starts at the top).
private final class FlippedView: NSView {
    override var isFlipped: Bool { true }
}

// MARK: - Preferences window

/// Window with all settings from Settings.all. Every change is saved and applied immediately.
final class PreferencesWindow: NSObject, NSWindowDelegate {
    static let shared = PreferencesWindow()

    private let contentWidth: CGFloat = 552      // width of the help texts
    private var window: NSWindow?
    private var fields: [String: NSTextField] = [:]
    private var steppers: [String: NSStepper] = [:]
    private var checkboxes: [String: NSButton] = [:]
    private var popups: [String: NSPopUpButton] = [:]
    private var textFields: [String: NSTextField] = [:]
    private var previewSound: NSSound?

    func show() {
        if window == nil { buildWindow() }
        refreshControls()
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }

    // MARK: Building the window

    private func buildWindow() {
        let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 600, height: 640),
                           styleMask: [.titled, .closable, .resizable],
                           backing: .buffered, defer: false)
        win.title = ui("menu.preferences").replacingOccurrences(of: "…", with: "")
        win.isReleasedWhenClosed = false
        win.minSize = NSSize(width: 600, height: 360)
        win.maxSize = NSSize(width: 600, height: 4000)      // fixed width, height can change
        win.center()
        win.delegate = self

        // All settings below each other
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        for def in Settings.all {
            stack.addArrangedSubview(makeRow(for: def))
        }

        let doc = FlippedView()
        doc.translatesAutoresizingMaskIntoConstraints = false
        doc.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: doc.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: doc.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: doc.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: doc.bottomAnchor, constant: -20),
        ])

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.drawsBackground = false
        scroll.borderType = .noBorder
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = doc
        NSLayoutConstraint.activate([
            doc.topAnchor.constraint(equalTo: scroll.contentView.topAnchor),
            doc.leadingAnchor.constraint(equalTo: scroll.contentView.leadingAnchor),
            doc.trailingAnchor.constraint(equalTo: scroll.contentView.trailingAnchor),
        ])

        // Bottom bar: note + "Reset to defaults"
        let note = NSTextField(labelWithString: ui("prefs.note"))
        note.font = .systemFont(ofSize: 11)
        note.textColor = .secondaryLabelColor
        note.translatesAutoresizingMaskIntoConstraints = false

        let reset = NSButton(title: ui("prefs.reset"), target: self, action: #selector(resetTapped))
        reset.translatesAutoresizingMaskIntoConstraints = false

        guard let content = win.contentView else { return }
        content.addSubview(scroll)
        content.addSubview(note)
        content.addSubview(reset)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: content.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: reset.topAnchor, constant: -12),

            reset.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
            reset.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -16),

            note.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
            note.centerYAnchor.constraint(equalTo: reset.centerYAnchor),
        ])

        // Keep the controls up to date when a setting changes elsewhere (e.g. the menu)
        NotificationCenter.default.addObserver(forName: Settings.didChange, object: nil, queue: .main) { [weak self] _ in
            self?.refreshControls()
        }

        window = win
    }

    /// One setting: the control (with its title) and the help text below it.
    private func makeRow(for def: SettingDef) -> NSView {
        let title = ui(def.titleKey)

        let help = NSTextField(wrappingLabelWithString: ui(def.helpKey))
        help.font = .systemFont(ofSize: 11)
        help.textColor = .secondaryLabelColor
        help.preferredMaxLayoutWidth = contentWidth
        help.translatesAutoresizingMaskIntoConstraints = false
        help.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true

        let top = NSStackView()
        top.orientation = .horizontal
        top.alignment = .centerY
        top.spacing = 8

        switch def.kind {
        case .bool:
            let box = NSButton(checkboxWithTitle: title, target: self, action: #selector(boolChanged(_:)))
            box.identifier = NSUserInterfaceItemIdentifier(def.key)
            checkboxes[def.key] = box
            top.addArrangedSubview(box)

        case .int(let lo, let hi, let step):
            addNumberControls(def, to: top, title: title, min: Double(lo), max: Double(hi),
                              step: Double(step), decimals: 0)

        case .double(let lo, let hi, let step):
            addNumberControls(def, to: top, title: title, min: lo, max: hi, step: step, decimals: 1)

        case .text:
            let label = NSTextField(labelWithString: title)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: 230).isActive = true
            let field = NSTextField()
            field.placeholderString = currentText().title      // shows the standard text while the field is empty
            field.identifier = NSUserInterfaceItemIdentifier(def.key)
            field.target = self
            field.action = #selector(textChanged(_:))
            field.translatesAutoresizingMaskIntoConstraints = false
            field.widthAnchor.constraint(equalToConstant: 290).isActive = true
            textFields[def.key] = field
            top.addArrangedSubview(label)
            top.addArrangedSubview(field)

        case .choice(let options):
            let label = NSTextField(labelWithString: title)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: 230).isActive = true
            let popup = NSPopUpButton(frame: .zero, pullsDown: false)
            popup.addItems(withTitles: options)
            popup.identifier = NSUserInterfaceItemIdentifier(def.key)
            popup.target = self
            popup.action = #selector(choiceChanged(_:))
            popups[def.key] = popup
            top.addArrangedSubview(label)
            top.addArrangedSubview(popup)
        }

        let row = NSStackView(views: [top, help])
        row.orientation = .vertical
        row.alignment = .leading
        row.spacing = 4
        return row
    }

    private func addNumberControls(_ def: SettingDef, to top: NSStackView, title: String,
                                   min: Double, max: Double, step: Double, decimals: Int) {
        let label = NSTextField(labelWithString: title)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 230).isActive = true

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = NSNumber(value: min)
        formatter.maximum = NSNumber(value: max)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimals

        let field = NSTextField()
        field.formatter = formatter
        field.alignment = .right
        field.identifier = NSUserInterfaceItemIdentifier(def.key)
        field.target = self
        field.action = #selector(numberChanged(_:))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 64).isActive = true

        let stepper = NSStepper()
        stepper.minValue = min
        stepper.maxValue = max
        stepper.increment = step
        stepper.valueWraps = false
        stepper.identifier = NSUserInterfaceItemIdentifier(def.key)
        stepper.target = self
        stepper.action = #selector(numberChanged(_:))

        fields[def.key] = field
        steppers[def.key] = stepper

        top.addArrangedSubview(label)
        top.addArrangedSubview(field)
        top.addArrangedSubview(stepper)
        if let unitKey = def.unitKey {
            top.addArrangedSubview(NSTextField(labelWithString: ui(unitKey)))
        }
    }

    // MARK: Showing the current values

    private func refreshControls() {
        for def in Settings.all {
            switch def.kind {
            case .bool:
                checkboxes[def.key]?.state = Settings.currentBool(def.key) ? .on : .off
            case .int, .double:
                let value = Settings.currentNumber(def.key)
                fields[def.key]?.doubleValue = value
                steppers[def.key]?.doubleValue = value
            case .choice:
                popups[def.key]?.selectItem(withTitle: Settings.currentString(def.key))
            case .text:
                textFields[def.key]?.stringValue = Settings.currentString(def.key)
            }
        }
    }

    // MARK: Actions

    @objc private func numberChanged(_ sender: NSControl) {
        guard let key = sender.identifier?.rawValue else { return }
        Settings.setNumber(key, sender.doubleValue)

        // Keep the colour limits in the right order: red limit <= yellow limit
        if key == "redUpTo" && Settings.redUpTo > Settings.yellowUpTo {
            Settings.setNumber("yellowUpTo", Double(Settings.redUpTo))
        }
        if key == "yellowUpTo" && Settings.yellowUpTo < Settings.redUpTo {
            Settings.setNumber("redUpTo", Double(Settings.yellowUpTo))
        }
        refreshControls()     // shows the value as it was stored (limited to the allowed range)
    }

    @objc private func textChanged(_ sender: NSTextField) {
        guard let key = sender.identifier?.rawValue else { return }
        Settings.setString(key, sender.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    /// Makes sure text that is still being typed is saved when the window is closed.
    func windowWillClose(_ notification: Notification) {
        window?.makeFirstResponder(nil)
    }

    @objc private func boolChanged(_ sender: NSButton) {
        guard let key = sender.identifier?.rawValue else { return }
        Settings.setBool(key, sender.state == .on)
    }

    @objc private func choiceChanged(_ sender: NSPopUpButton) {
        guard let key = sender.identifier?.rawValue, let name = sender.titleOfSelectedItem else { return }
        Settings.setString(key, name)
        previewSound?.stop()
        previewSound = NSSound(named: name)       // preview of the chosen sound
        previewSound?.play()
    }

    @objc private func resetTapped() {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = ui("prefs.resetQuestion")
        alert.informativeText = ui("prefs.resetInfo")
        alert.addButton(withTitle: ui("prefs.reset"))
        alert.addButton(withTitle: ui("prefs.cancel"))
        if alert.runModal() == .alertFirstButtonReturn {
            Settings.resetAll()
        }
    }
}

// MARK: - Help window

/// Window that explains how the app works and what every setting does.
final class HelpWindow: NSObject {
    static let shared = HelpWindow()
    private var window: NSWindow?

    func show() {
        if window == nil { buildWindow() }
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }

    private func buildWindow() {
        let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 640, height: 620),
                           styleMask: [.titled, .closable, .resizable],
                           backing: .buffered, defer: false)
        win.title = ui("menu.help")
        win.isReleasedWhenClosed = false
        win.center()

        let scroll = NSTextView.scrollableTextView()
        guard let textView = scroll.documentView as? NSTextView else { return }
        textView.isEditable = false
        textView.textContainerInset = NSSize(width: 18, height: 18)
        textView.textStorage?.setAttributedString(makeText())
        win.contentView = scroll

        window = win
    }

    /// How the app works (ui("help.body")) followed by the help of every setting.
    private func makeText() -> NSAttributedString {
        let out = NSMutableAttributedString()

        let bodyFont = NSFont.systemFont(ofSize: 13)
        let boldFont = NSFont.boldSystemFont(ofSize: 13)
        let headFont = NSFont.boldSystemFont(ofSize: 16)

        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacing = 6
        let headStyle = NSMutableParagraphStyle()
        headStyle.paragraphSpacingBefore = 14
        headStyle.paragraphSpacing = 6

        func add(_ text: String, font: NSFont, style: NSParagraphStyle) {
            out.append(NSAttributedString(string: text + "\n", attributes: [
                .font: font,
                .foregroundColor: NSColor.labelColor,
                .paragraphStyle: style,
            ]))
        }

        for line in ui("help.body").components(separatedBy: "\n") {
            if line.hasPrefix("## ") {
                add(String(line.dropFirst(3)), font: headFont, style: headStyle)
            } else if !line.isEmpty {
                add(line, font: bodyFont, style: bodyStyle)
            }
        }

        add(ui("help.settingsHeading"), font: headFont, style: headStyle)
        for def in Settings.all {
            add(ui(def.titleKey), font: boldFont, style: bodyStyle)
            add(ui(def.helpKey), font: bodyFont, style: bodyStyle)
        }
        return out
    }
}
