// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Foundation

/// Writes a line to the system log (Console.app) and, if Settings.logToFile is on,
/// to ~/Library/Logs/<AppName>.log — handy to see why the app does not start.
func appLog(_ message: String) {
    NSLog("BatteryAlert: %@", message)
    fputs("BatteryAlert: \(message)\n", stderr)   // also visible in Terminal / the launch test output
    guard Settings.logToFile else { return }

    let name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "BatteryAlert"
    let url = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Logs/\(name).log")
    let line = "\(ISO8601DateFormatter().string(from: Date())) \(message)\n"
    guard let data = line.data(using: .utf8) else { return }

    if let handle = try? FileHandle(forWritingTo: url) {      // file exists: append
        handle.seekToEndOfFile()
        handle.write(data)
        try? handle.close()
    } else {                                                  // first line: create the file
        try? data.write(to: url)
    }
}
