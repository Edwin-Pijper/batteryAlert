// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Foundation
import IOKit.ps

// MARK: - Battery

struct BatteryStatus {
    let percent: Int
    let isOnACPower: Bool
    var minutesToEmpty: Int? = nil   // estimated minutes left on battery; nil = still calculating / unknown
}

func readBattery() -> BatteryStatus? {
    guard let info = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
          let list = IOPSCopyPowerSourcesList(info)?.takeRetainedValue() as? [CFTypeRef]
    else { return nil }

    for source in list {
        guard let desc = IOPSGetPowerSourceDescription(info, source)?
                .takeUnretainedValue() as? [String: Any],
              desc[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
              let current = desc[kIOPSCurrentCapacityKey] as? Int,
              let max = desc[kIOPSMaxCapacityKey] as? Int, max > 0
        else { continue }

        let onAC = (desc[kIOPSPowerSourceStateKey] as? String) == kIOPSACPowerValue
        // macOS reports -1 while it is still calculating the estimate
        let minutes = desc[kIOPSTimeToEmptyKey] as? Int
        let estimate = (minutes ?? -1) >= 0 ? minutes : nil
        return BatteryStatus(percent: current * 100 / max, isOnACPower: onAC, minutesToEmpty: estimate)
    }
    return nil // Mac without a battery
}
