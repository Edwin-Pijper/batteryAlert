// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Edwin Pijper. Part of this project; see the LICENSE file.

import Foundation

// MARK: - Localization (follows the macOS system language)

struct LocalizedText {
    let title: String
    let bodyFormat: String   // contains one %d for the percentage
    let close: String
    let soundAlarm: String   // checkbox / menu label
    let timeRemaining: String   // contains one %@ for the duration
    let calculating: String     // replaces the duration while macOS is still calculating
    let pluggedIn: String       // shown instead of the estimate while on the charger
    let started: String         // contains one %@ for the app name
    let alreadyRunning: String  // contains one %@ for the app name
}

let translations: [String: LocalizedText] = [
    "en": .init(title: "Low Battery",              bodyFormat: "%d%% Battery Remaining",        close: "Close", soundAlarm: "Sound alarm and read aloud", timeRemaining: "Estimated time remaining: %@", calculating: "calculating…", pluggedIn: "Plugged in", started: "%@ is running in the menu bar.", alreadyRunning: "%@ is already running in the menu bar."),
    "nl": .init(title: "Batterij bijna leeg",      bodyFormat: "Nog %d%% batterij over",        close: "Sluit", soundAlarm: "Geluidsalarm en voorlezen", timeRemaining: "Geschatte resterende tijd: %@", calculating: "wordt berekend…", pluggedIn: "Aangesloten op netstroom", started: "%@ draait nu in de menubalk.", alreadyRunning: "%@ draait al in de menubalk."),
    "de": .init(title: "Niedriger Batteriestand",  bodyFormat: "Noch %d %% Batterie übrig",     close: "Schließen", soundAlarm: "Alarmton und Text vorlesen", timeRemaining: "Geschätzte Restlaufzeit: %@", calculating: "wird berechnet …", pluggedIn: "Netzteil angeschlossen", started: "%@ läuft jetzt in der Menüleiste.", alreadyRunning: "%@ läuft bereits in der Menüleiste."),
    "fr": .init(title: "Batterie faible",          bodyFormat: "Il reste %d %% de batterie",    close: "Fermer", soundAlarm: "Alarme sonore et lecture à voix haute", timeRemaining: "Autonomie estimée : %@", calculating: "calcul en cours…", pluggedIn: "Branché sur secteur", started: "%@ est maintenant ouvert dans la barre des menus.", alreadyRunning: "%@ est déjà ouvert dans la barre des menus."),
    "es": .init(title: "Batería baja",             bodyFormat: "Queda un %d %% de batería",     close: "Cerrar", soundAlarm: "Alarma sonora y lectura en voz alta", timeRemaining: "Tiempo restante estimado: %@", calculating: "calculando…", pluggedIn: "Conectado a la corriente", started: "%@ se está ejecutando en la barra de menús.", alreadyRunning: "%@ ya se está ejecutando en la barra de menús."),
    "it": .init(title: "Batteria in esaurimento",  bodyFormat: "Carica residua: %d%%",          close: "Chiudi", soundAlarm: "Allarme sonoro e lettura a voce alta", timeRemaining: "Tempo rimanente stimato: %@", calculating: "calcolo in corso…", pluggedIn: "Collegato all'alimentazione", started: "%@ è in esecuzione nella barra dei menu.", alreadyRunning: "%@ è già in esecuzione nella barra dei menu."),
    "pt": .init(title: "Bateria fraca",            bodyFormat: "Restam %d%% de bateria",        close: "Fechar", soundAlarm: "Alarme sonoro e leitura em voz alta", timeRemaining: "Tempo restante estimado: %@", calculating: "calculando…", pluggedIn: "Ligado à corrente", started: "%@ está a ser executado na barra de menus.", alreadyRunning: "%@ já está a ser executado na barra de menus."),
    "ru": .init(title: "Низкий заряд батареи",     bodyFormat: "Осталось %d%% заряда",          close: "Закрыть", soundAlarm: "Звуковой сигнал и озвучивание текста", timeRemaining: "Оценка оставшегося времени: %@", calculating: "вычисляется…", pluggedIn: "Подключено к сети", started: "%@ работает в строке меню.", alreadyRunning: "%@ уже запущено в строке меню."),
    "ja": .init(title: "バッテリー残量が少なくなっています", bodyFormat: "バッテリー残量: %d%%",       close: "閉じる", soundAlarm: "アラーム音と音声読み上げ", timeRemaining: "残り時間の目安: %@", calculating: "計算中…", pluggedIn: "電源に接続中", started: "%@ はメニューバーで実行中です。", alreadyRunning: "%@ はすでにメニューバーで実行中です。"),
    "zh": .init(title: "电池电量不足",               bodyFormat: "剩余电量：%d%%",                 close: "关闭", soundAlarm: "声音警报并朗读文字", timeRemaining: "预计剩余使用时间：%@", calculating: "正在计算…", pluggedIn: "已连接电源", started: "%@ 正在菜单栏中运行。", alreadyRunning: "%@ 已在菜单栏中运行。"),
    "ko": .init(title: "배터리 부족",                bodyFormat: "배터리 %d%% 남음",               close: "닫기", soundAlarm: "경고음 및 음성 읽기", timeRemaining: "예상 남은 시간: %@", calculating: "계산 중…", pluggedIn: "전원 연결됨", started: "%@이(가) 메뉴 막대에서 실행 중입니다.", alreadyRunning: "%@이(가) 이미 메뉴 막대에서 실행 중입니다."),
    "pl": .init(title: "Niski poziom baterii",     bodyFormat: "Pozostało %d%% baterii",        close: "Zamknij", soundAlarm: "Alarm dźwiękowy i odczyt na głos", timeRemaining: "Szacowany pozostały czas: %@", calculating: "obliczanie…", pluggedIn: "Podłączono do zasilania", started: "%@ działa na pasku menu.", alreadyRunning: "%@ jest już uruchomiony na pasku menu."),
    "tr": .init(title: "Düşük Pil",                bodyFormat: "Pil %%%d kaldı",                close: "Kapat", soundAlarm: "Sesli alarm ve sesli okuma", timeRemaining: "Tahmini kalan süre: %@", calculating: "hesaplanıyor…", pluggedIn: "Güce bağlı", started: "%@ menü çubuğunda çalışıyor.", alreadyRunning: "%@ zaten menü çubuğunda çalışıyor."),
]

func currentText() -> LocalizedText {
    let code = Locale.preferredLanguages.first?
        .split(separator: "-").first.map(String.init) ?? "en"
    return translations[code] ?? translations["en"]!
}

/// Locale of the system language (used for the time format).
func appLocale() -> Locale {
    Locale(identifier: Locale.preferredLanguages.first ?? "en")
}

/// Text of the popup: the percentage + the estimated work time on a second line.
func warningBody(for battery: BatteryStatus) -> String {
    let t = currentText()
    let line1 = String(format: t.bodyFormat, battery.percent)
    let line2: String
    if battery.isOnACPower {
        line2 = t.pluggedIn
    } else if let minutes = battery.minutesToEmpty {
        line2 = String(format: t.timeRemaining, formatDuration(minutes: minutes))
    } else {
        line2 = String(format: t.timeRemaining, t.calculating)
    }
    return line1 + "\n" + line2
}

private func formatDuration(minutes: Int) -> String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = appLocale()
    let formatter = DateComponentsFormatter()
    formatter.calendar = calendar
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .short            // e.g. "1 hr, 23 min" (localized)
    formatter.zeroFormattingBehavior = .dropAll
    return formatter.string(from: TimeInterval(max(minutes, 1) * 60)) ?? "\(minutes) min"
}
