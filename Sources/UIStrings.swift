// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Your Name. Part of this project; see the LICENSE file.

import Foundation

// Texts of the menu bar menu, the Preferences window and the Help window,
// in all 13 languages (en, nl, de, fr, es, it, pt, ru, ja, zh, ko, pl, tr).
// If a text is missing for a language, the English text is shown.
//
// To add a language: copy a dictionary (e.g. `uiNL`), translate the texts, and add it to
// `uiStrings` at the bottom of this file. (The popup texts are in Localization.swift.)

/// Language code of the system language, e.g. "nl".
private func systemLanguageCode() -> String {
    Locale.preferredLanguages.first?.split(separator: "-").first.map(String.init) ?? "en"
}

/// Text for `key` in the system language; falls back to English.
func ui(_ key: String) -> String {
    uiStrings[systemLanguageCode()]?[key] ?? uiStrings["en"]?[key] ?? key
}

// MARK: - English

private let uiEN: [String: String] = [
    "menu.quit": "Quit",
    "menu.preferences": "Preferences…",
    "menu.help": "Help",
    "menu.testWarning": "Test warning",
    "prefs.reset": "Reset to defaults",
    "prefs.cancel": "Cancel",
    "unit.seconds": "sec",
    "unit.percent": "%",
    "unit.points": "pt",

    "prefs.note": "Changes are saved and applied immediately.",
    "prefs.resetQuestion": "Reset all preferences to the default values?",
    "prefs.resetInfo": "Your own changes will be lost.",
    "help.settingsHeading": "Settings",

    "help.body": """
## Menu bar icon
Shows the battery level in the menu bar. The icon is green when the battery is fine, yellow when it is getting low and red when it is almost empty (you can set the limits in Preferences). A lightning bolt in the icon means the Mac is charging.

## Low-battery popup
When the battery reaches the warning level, a popup appears with the same picture, the percentage and the estimated time remaining. The popup stays on screen until you press Close. After that, no new popup appears until the battery has been above the warning level again.
If the percentage is higher than at the previous check (for example while charging), no popup is shown. Being plugged in does not stop the popup: if the battery still drops to the warning level, you are warned.
You can replace the title of the popup with your own warning text in Preferences.

## Sound alarm
When ‘Sound alarm and read aloud’ is on, an alarm sound plays and the text of the popup is read aloud in the system language. It repeats while the popup is open and stops as soon as you press Close. You can switch it on or off at any time in the menu bar menu, in the popup and in Preferences.

## Estimated time remaining
The popup shows how long macOS expects the battery to last. Right after unplugging it can show ‘calculating…’. While the Mac is plugged in, it shows ‘Plugged in’.

## Menu bar menu
Click the battery icon in the menu bar. Sound alarm switches the alarm on or off, Preferences opens the settings, Help shows this text and Quit stops the app.

## Preferences
Every setting can be changed in the Preferences window. Changes are saved and applied immediately, except for settings that say they take effect the next time the app starts. ‘Reset to defaults’ brings back the original values.

## Only one copy
Only one copy of the app can run at a time (you can change this in Preferences).

## License
This app is free software: you can redistribute it and modify it under the terms of the GNU General Public License, version 3 or (at your option) any later version. It comes with no warranty. The license text is included in the app and can be read at https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.warningThreshold.title": "Warning level",
    "setting.warningThreshold.help": "The low-battery popup appears when the battery is at or below this percentage (and has not gone up since the previous check).",
    "setting.customWarningText.title": "Own warning text",
    "setting.customWarningText.help": "Replaces the title of the popup (‘Low Battery’) with your own text. It is also read aloud by the sound alarm. The percentage and the estimated time stay below it. Leave empty to use the standard text.",
    "setting.redUpTo.title": "Red icon up to",
    "setting.redUpTo.help": "The icon is red at this percentage or lower.",
    "setting.yellowUpTo.title": "Yellow icon up to",
    "setting.yellowUpTo.help": "The icon is yellow above the red limit, up to this percentage. Above it the icon is green.",
    "setting.alertIconSize.title": "Popup picture size",
    "setting.alertIconSize.help": "Size of the battery picture in the popup, in points.",
    "setting.checkInterval.title": "Check every",
    "setting.checkInterval.help": "How often the battery is checked. The app also checks immediately when the power state changes (plugging in, unplugging).",
    "setting.alarmRepeatInterval.title": "Repeat alarm every",
    "setting.alarmRepeatInterval.help": "While the popup is open and the sound alarm is on: the pause between two alarms.",
    "setting.speechDelay.title": "Pause before speech",
    "setting.speechDelay.help": "Pause between the alarm sound and the spoken text.",
    "setting.alarmSoundName.title": "Alarm sound",
    "setting.alarmSoundName.help": "The macOS system sound that is played as alarm. When you choose a sound, you hear a preview.",
    "setting.soundAlarm.title": "Sound alarm and read aloud",
    "setting.soundAlarm.help": "Plays the alarm sound and reads the text of the popup aloud, in the system language, while the popup is open. The same setting is in the menu and in the popup.",
    "setting.showTestMenuItem.title": "Show “Test warning” in the menu",
    "setting.showTestMenuItem.help": "Adds a menu item that shows the popup with your current battery level, so you can see how it looks.",
    "setting.showStartupMessage.title": "Show a message at start-up",
    "setting.showStartupMessage.help": "Shows a small message that the app is running in the menu bar. Takes effect the next time the app starts.",
    "setting.showAlreadyRunningMessage.title": "Show a message when the app is already running",
    "setting.showAlreadyRunningMessage.help": "When you start a second copy, a message is shown instead of quitting silently. Takes effect the next time the app starts.",
    "setting.singleInstance.title": "Allow only one copy",
    "setting.singleInstance.help": "Only one copy of the app can run at a time; a second copy quits. Takes effect the next time the app starts.",
    "setting.logToFile.title": "Write a log file",
    "setting.logToFile.help": "Writes start-up messages to a log file in ~/Library/Logs. Useful when something does not work.",
]

// MARK: - Nederlands

private let uiNL: [String: String] = [
    "menu.quit": "Stop",
    "menu.preferences": "Voorkeuren…",
    "menu.help": "Help",
    "menu.testWarning": "Waarschuwing testen",
    "prefs.reset": "Standaardwaarden herstellen",
    "prefs.cancel": "Annuleer",
    "unit.seconds": "sec",

    "prefs.note": "Wijzigingen worden direct bewaard en toegepast.",
    "prefs.resetQuestion": "Alle voorkeuren terugzetten naar de standaardwaarden?",
    "prefs.resetInfo": "Je eigen wijzigingen gaan verloren.",
    "help.settingsHeading": "Instellingen",

    "help.body": """
## Menubalkicoon
Toont het batterijniveau in de menubalk. Het icoon is groen als de batterij ruim voldoende is, geel als hij laag begint te worden en rood als hij bijna leeg is (de grenzen stel je in bij Voorkeuren). Een bliksemschicht in het icoon betekent dat de Mac oplaadt.

## Melding bij lage batterij
Als de batterij het waarschuwingsniveau bereikt, verschijnt een melding met dezelfde afbeelding, het percentage en de geschatte resterende tijd. De melding blijft op het scherm staan tot je op Sluit drukt. Daarna komt er pas weer een melding als de batterij eerst weer boven het waarschuwingsniveau is geweest.
Als het percentage hoger is dan bij de vorige controle (bijvoorbeeld tijdens het opladen), verschijnt er geen melding. Aangesloten zijn op de lader voorkomt de melding niet: zakt de batterij toch tot het waarschuwingsniveau, dan word je gewaarschuwd.
Je kunt de titel van de melding vervangen door je eigen waarschuwingstekst bij Voorkeuren.

## Geluidsalarm
Als ‘Geluidsalarm en voorlezen’ aan staat, klinkt een alarmgeluid en wordt de tekst van de melding voorgelezen in de systeemtaal. Dit herhaalt zich zolang de melding open staat en stopt zodra je op Sluit drukt. Je kunt het op elk moment aan of uit zetten in het menu van de menubalk, in de melding en bij Voorkeuren.

## Geschatte resterende tijd
De melding toont hoe lang macOS verwacht dat de batterij het nog volhoudt. Vlak na het loskoppelen kan er ‘wordt berekend…’ staan. Zolang de Mac op de lader zit, staat er ‘Aangesloten op netstroom’.

## Menu in de menubalk
Klik op het batterij-icoon in de menubalk. Met Geluidsalarm zet je het alarm aan of uit, Voorkeuren opent de instellingen, Help toont deze tekst en Stop sluit de app af.

## Voorkeuren
Elke instelling kun je wijzigen in het venster Voorkeuren. Wijzigingen worden direct bewaard en toegepast, behalve instellingen waarbij staat dat ze pas werken bij de volgende keer opstarten. Met ‘Standaardwaarden herstellen’ zet je alles terug naar de oorspronkelijke waarden.

## Maar één exemplaar
Er kan maar één exemplaar van de app tegelijk draaien (dit kun je wijzigen bij Voorkeuren).

## Licentie
Deze app is vrije software: je mag hem verspreiden en aanpassen onder de voorwaarden van de GNU General Public License, versie 3 of (naar keuze) een latere versie. Er is geen enkele garantie. De licentietekst zit in de app en staat op https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.warningThreshold.title": "Waarschuwingsniveau",
    "setting.warningThreshold.help": "De melding bij lage batterij verschijnt als de batterij op of onder dit percentage zit (en niet hoger is dan bij de vorige controle).",
    "setting.customWarningText.title": "Eigen waarschuwingstekst",
    "setting.customWarningText.help": "Vervangt de titel van de melding (de standaardtitel) door je eigen tekst. Het geluidsalarm leest die tekst ook voor. Het percentage en de geschatte tijd blijven eronder staan. Laat leeg voor de standaardtekst.",
    "setting.redUpTo.title": "Rood icoon tot",
    "setting.redUpTo.help": "Het icoon is rood bij dit percentage of lager.",
    "setting.yellowUpTo.title": "Geel icoon tot",
    "setting.yellowUpTo.help": "Het icoon is geel boven de roodgrens, tot dit percentage. Daarboven is het icoon groen.",
    "setting.alertIconSize.title": "Grootte afbeelding in melding",
    "setting.alertIconSize.help": "Grootte van de batterijafbeelding in de melding, in punten.",
    "setting.checkInterval.title": "Controleer elke",
    "setting.checkInterval.help": "Hoe vaak de batterij wordt gecontroleerd. De app controleert ook direct bij een wijziging in de stroomvoorziening (aansluiten, loskoppelen).",
    "setting.alarmRepeatInterval.title": "Herhaal alarm elke",
    "setting.alarmRepeatInterval.help": "Zolang de melding open staat en het geluidsalarm aan staat: de pauze tussen twee alarmen.",
    "setting.speechDelay.title": "Pauze voor het voorlezen",
    "setting.speechDelay.help": "Pauze tussen het alarmgeluid en de voorgelezen tekst.",
    "setting.alarmSoundName.title": "Alarmgeluid",
    "setting.alarmSoundName.help": "Het macOS-systeemgeluid dat als alarm wordt afgespeeld. Als je een geluid kiest, hoor je een voorbeeld.",
    "setting.soundAlarm.title": "Geluidsalarm en voorlezen",
    "setting.soundAlarm.help": "Speelt het alarmgeluid af en leest de tekst van de melding voor, in de systeemtaal, zolang de melding open staat. Dezelfde instelling staat in het menu en in de melding.",
    "setting.showTestMenuItem.title": "“Waarschuwing testen” tonen in het menu",
    "setting.showTestMenuItem.help": "Voegt een menu-item toe dat de melding toont met je huidige batterijniveau, zodat je kunt zien hoe die eruitziet.",
    "setting.showStartupMessage.title": "Melding tonen bij het opstarten",
    "setting.showStartupMessage.help": "Toont een klein bericht dat de app in de menubalk draait. Werkt vanaf de volgende keer opstarten.",
    "setting.showAlreadyRunningMessage.title": "Melding tonen als de app al draait",
    "setting.showAlreadyRunningMessage.help": "Als je een tweede exemplaar start, wordt een bericht getoond in plaats van stil af te sluiten. Werkt vanaf de volgende keer opstarten.",
    "setting.singleInstance.title": "Slechts één exemplaar toestaan",
    "setting.singleInstance.help": "Er kan maar één exemplaar van de app tegelijk draaien; een tweede exemplaar sluit af. Werkt vanaf de volgende keer opstarten.",
    "setting.logToFile.title": "Logbestand schrijven",
    "setting.logToFile.help": "Schrijft opstartmeldingen naar een logbestand in ~/Library/Logs. Handig als er iets niet werkt.",
]

// MARK: - Other languages

private let uiDE: [String: String] = [
    "menu.quit": "Beenden", "menu.preferences": "Einstellungen…", "menu.help": "Hilfe",
    "menu.testWarning": "Warnung testen", "prefs.reset": "Auf Standard zurücksetzen",
    "prefs.cancel": "Abbrechen", "unit.seconds": "Sek.",

    "prefs.note": "Änderungen werden sofort gespeichert und angewendet.",
    "prefs.resetQuestion": "Alle Einstellungen auf die Standardwerte zurücksetzen?",
    "prefs.resetInfo": "Ihre eigenen Änderungen gehen verloren.",
    "help.settingsHeading": "Einstellungen",

    "help.body": """
## Symbol in der Menüleiste
Zeigt den Batteriestand in der Menüleiste. Das Symbol ist grün, wenn die Batterie ausreichend geladen ist, gelb, wenn sie niedrig wird, und rot, wenn sie fast leer ist (die Grenzen legen Sie in den Einstellungen fest). Ein Blitz im Symbol bedeutet, dass der Mac lädt.

## Warnung bei niedrigem Batteriestand
Erreicht die Batterie den Warnwert, erscheint ein Hinweisfenster mit demselben Bild, dem Prozentwert und der geschätzten Restlaufzeit. Es bleibt auf dem Bildschirm, bis Sie auf „Schließen“ klicken. Danach erscheint erst wieder eine Warnung, wenn die Batterie zuvor wieder über dem Warnwert lag.
Ist der Prozentwert höher als bei der vorherigen Prüfung (z. B. beim Laden), erscheint keine Warnung. Ein angeschlossenes Netzteil verhindert die Warnung nicht: Sinkt die Batterie trotzdem auf den Warnwert, werden Sie gewarnt.
Sie können den Titel des Hinweisfensters in den Einstellungen durch einen eigenen Warntext ersetzen.

## Alarmton
Ist „Alarmton und Text vorlesen“ aktiviert, ertönt ein Alarm und der Text des Hinweisfensters wird in der Systemsprache vorgelesen. Das wiederholt sich, bis Sie auf „Schließen“ klicken. Sie können es jederzeit im Menü der Menüleiste, im Hinweisfenster und in den Einstellungen ein- oder ausschalten.

## Geschätzte Restlaufzeit
Das Hinweisfenster zeigt, wie lange die Batterie laut macOS noch hält. Direkt nach dem Trennen vom Netzteil kann „wird berechnet …“ erscheinen. Solange der Mac am Netzteil hängt, steht dort „Netzteil angeschlossen“.

## Menü in der Menüleiste
Klicken Sie auf das Batteriesymbol in der Menüleiste. „Alarmton und Text vorlesen“ schaltet den Alarm ein oder aus, „Einstellungen…“ öffnet die Einstellungen, „Hilfe“ zeigt diesen Text und „Beenden“ beendet die App.

## Einstellungen
Jede Einstellung können Sie im Einstellungsfenster ändern. Änderungen werden sofort gespeichert und angewendet, außer bei Einstellungen, die erst beim nächsten Start wirksam werden. „Auf Standard zurücksetzen“ stellt die ursprünglichen Werte wieder her.

## Nur eine Kopie
Es kann immer nur eine Kopie der App laufen (das lässt sich in den Einstellungen ändern).

## Lizenz
Diese App ist freie Software: Sie dürfen sie unter den Bedingungen der GNU General Public License, Version 3 oder (nach Ihrer Wahl) einer späteren Version, weitergeben und ändern. Es gibt keine Garantie. Der Lizenztext ist in der App enthalten und unter https://www.gnu.org/licenses/gpl-3.0.html zu lesen.
""",

    "setting.soundAlarm.title": "Alarmton und Text vorlesen",
    "setting.warningThreshold.title": "Warnschwelle",
    "setting.warningThreshold.help": "Das Hinweisfenster erscheint bei diesem Prozentwert oder darunter (sofern er seit der letzten Prüfung nicht gestiegen ist).",
    "setting.customWarningText.title": "Eigener Warntext",
    "setting.customWarningText.help": "Ersetzt den Titel des Hinweisfensters durch Ihren Text (wird auch vorgelesen). Prozentwert und Restzeit bleiben darunter. Leer = Standardtext.",
    "setting.redUpTo.title": "Rotes Symbol bis",
    "setting.redUpTo.help": "Das Symbol ist bei diesem Prozentwert oder darunter rot.",
    "setting.yellowUpTo.title": "Gelbes Symbol bis",
    "setting.yellowUpTo.help": "Gelb oberhalb der roten Grenze bis zu diesem Prozentwert; darüber ist das Symbol grün.",
    "setting.alertIconSize.title": "Bildgröße im Hinweisfenster",
    "setting.alertIconSize.help": "Größe des Batteriebilds im Hinweisfenster in Punkt.",
    "setting.checkInterval.title": "Prüfen alle",
    "setting.checkInterval.help": "Wie oft der Batteriestand geprüft wird. Beim Anschließen oder Trennen des Netzteils wird sofort geprüft.",
    "setting.alarmRepeatInterval.title": "Alarm wiederholen alle",
    "setting.alarmRepeatInterval.help": "Solange das Hinweisfenster offen und der Alarmton aktiv ist: Pause zwischen zwei Alarmen.",
    "setting.speechDelay.title": "Pause vor dem Vorlesen",
    "setting.speechDelay.help": "Pause zwischen dem Alarmton und dem vorgelesenen Text.",
    "setting.alarmSoundName.title": "Alarmton",
    "setting.alarmSoundName.help": "Der macOS-Systemton, der als Alarm abgespielt wird. Bei der Auswahl hören Sie eine Vorschau.",
    "setting.soundAlarm.help": "Spielt den Alarmton ab und liest den Text des Hinweisfensters in der Systemsprache vor, solange es offen ist. Dieselbe Einstellung wie im Menü und im Hinweisfenster.",
    "setting.showTestMenuItem.title": "„Warnung testen“ im Menü anzeigen",
    "setting.showTestMenuItem.help": "Fügt einen Menüeintrag hinzu, der das Hinweisfenster mit Ihrem aktuellen Batteriestand zeigt.",
    "setting.showStartupMessage.title": "Beim Start eine Meldung anzeigen",
    "setting.showStartupMessage.help": "Zeigt eine kurze Meldung, dass die App in der Menüleiste läuft. Gilt ab dem nächsten Start.",
    "setting.showAlreadyRunningMessage.title": "Meldung anzeigen, wenn die App schon läuft",
    "setting.showAlreadyRunningMessage.help": "Eine zweite Kopie zeigt eine Meldung, statt sich stillschweigend zu beenden. Gilt ab dem nächsten Start.",
    "setting.singleInstance.title": "Nur eine Kopie zulassen",
    "setting.singleInstance.help": "Es kann nur eine Kopie laufen; eine zweite beendet sich. Gilt ab dem nächsten Start.",
    "setting.logToFile.title": "Protokolldatei schreiben",
    "setting.logToFile.help": "Schreibt Startmeldungen in eine Protokolldatei in ~/Library/Logs. Nützlich, wenn etwas nicht funktioniert.",
]

private let uiFR: [String: String] = [
    "menu.quit": "Quitter", "menu.preferences": "Préférences…", "menu.help": "Aide",
    "menu.testWarning": "Tester l’avertissement", "prefs.reset": "Rétablir les valeurs par défaut",
    "prefs.cancel": "Annuler", "unit.seconds": "s",

    "prefs.note": "Les modifications sont enregistrées et appliquées immédiatement.",
    "prefs.resetQuestion": "Rétablir toutes les préférences aux valeurs par défaut ?",
    "prefs.resetInfo": "Vos modifications seront perdues.",
    "help.settingsHeading": "Réglages",

    "help.body": """
## Icône de la barre des menus
Affiche le niveau de la batterie. L’icône est verte quand la batterie est correcte, jaune quand elle devient faible et rouge quand elle est presque vide (les seuils se règlent dans les Préférences). Un éclair signifie que le Mac est en charge.

## Avertissement de batterie faible
Au niveau d’alerte, une fenêtre affiche la même image, le pourcentage et l’autonomie estimée. Elle reste affichée jusqu’à ce que vous cliquiez sur « Fermer » ; ensuite, aucune nouvelle fenêtre n’apparaît tant que la batterie n’est pas repassée au-dessus du niveau d’alerte.
Si le pourcentage est plus élevé qu’à la vérification précédente (par exemple en charge), rien n’est affiché. Être branché sur secteur n’empêche pas l’avertissement : si la batterie descend quand même au niveau d’alerte, vous êtes prévenu.
Vous pouvez remplacer le titre de la fenêtre par votre propre texte dans les Préférences.

## Alarme sonore
Si « Alarme sonore et lecture à voix haute » est activée, une alarme retentit et le texte de la fenêtre est lu à voix haute dans la langue du système, en boucle jusqu’à ce que vous cliquiez sur « Fermer ». Vous pouvez l’activer ou la désactiver à tout moment dans le menu, dans la fenêtre et dans les Préférences.

## Autonomie estimée
Indique combien de temps macOS pense que la batterie va tenir (« calcul en cours… » juste après le débranchement ; « Branché sur secteur » pendant la charge).

## Menu de la barre des menus
Cliquez sur l’icône de batterie. « Alarme sonore et lecture à voix haute » active ou désactive l’alarme, « Préférences… » ouvre les réglages, « Aide » affiche ce texte et « Quitter » ferme l’app.

## Préférences
Chaque réglage peut y être modifié ; les changements sont appliqués immédiatement (sauf mention « au prochain démarrage »). « Rétablir les valeurs par défaut » restaure les valeurs d’origine.

## Une seule copie
Une seule copie de l’app peut tourner à la fois (modifiable dans les Préférences).

## Licence
Cette app est un logiciel libre : vous pouvez la redistribuer et la modifier selon les termes de la GNU General Public License, version 3 ou (à votre choix) toute version ultérieure. Elle est fournie sans aucune garantie. Le texte de la licence est inclus dans l’app et consultable sur https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Alarme sonore et lecture à voix haute",
    "setting.warningThreshold.title": "Niveau d’alerte",
    "setting.warningThreshold.help": "La fenêtre apparaît à ce pourcentage ou en dessous (s’il n’a pas augmenté depuis la vérification précédente).",
    "setting.customWarningText.title": "Texte d’alerte personnel",
    "setting.customWarningText.help": "Remplace le titre de la fenêtre par votre texte (lu aussi à voix haute). Le pourcentage et le temps restent dessous. Vide = texte standard.",
    "setting.redUpTo.title": "Icône rouge jusqu’à",
    "setting.redUpTo.help": "L’icône est rouge à ce pourcentage ou en dessous.",
    "setting.yellowUpTo.title": "Icône jaune jusqu’à",
    "setting.yellowUpTo.help": "Jaune au-dessus du seuil rouge jusqu’à ce pourcentage ; au-dessus, l’icône est verte.",
    "setting.alertIconSize.title": "Taille de l’image dans la fenêtre",
    "setting.alertIconSize.help": "Taille de l’image de la batterie dans la fenêtre, en points.",
    "setting.checkInterval.title": "Vérifier toutes les",
    "setting.checkInterval.help": "Fréquence de vérification de la batterie. Elle est aussi vérifiée immédiatement au branchement ou au débranchement.",
    "setting.alarmRepeatInterval.title": "Répéter l’alarme toutes les",
    "setting.alarmRepeatInterval.help": "Tant que la fenêtre est ouverte et l’alarme sonore activée : pause entre deux alarmes.",
    "setting.speechDelay.title": "Pause avant la lecture",
    "setting.speechDelay.help": "Pause entre le son d’alarme et le texte lu.",
    "setting.alarmSoundName.title": "Son d’alarme",
    "setting.alarmSoundName.help": "Le son système macOS utilisé comme alarme. Lorsque vous en choisissez un, vous entendez un aperçu.",
    "setting.soundAlarm.help": "Joue le son d’alarme et lit à voix haute le texte de la fenêtre, dans la langue du système, tant qu’elle est ouverte. Même réglage que dans le menu et dans la fenêtre.",
    "setting.showTestMenuItem.title": "Afficher « Tester l’avertissement » dans le menu",
    "setting.showTestMenuItem.help": "Ajoute une commande de menu qui affiche la fenêtre avec le niveau actuel de la batterie.",
    "setting.showStartupMessage.title": "Afficher un message au démarrage",
    "setting.showStartupMessage.help": "Affiche un court message indiquant que l’app tourne dans la barre des menus. Pris en compte au prochain démarrage.",
    "setting.showAlreadyRunningMessage.title": "Afficher un message si l’app tourne déjà",
    "setting.showAlreadyRunningMessage.help": "Une seconde copie affiche un message au lieu de se fermer en silence. Pris en compte au prochain démarrage.",
    "setting.singleInstance.title": "N’autoriser qu’une seule copie",
    "setting.singleInstance.help": "Une seule copie peut tourner ; la seconde se ferme. Pris en compte au prochain démarrage.",
    "setting.logToFile.title": "Écrire un fichier journal",
    "setting.logToFile.help": "Écrit les messages de démarrage dans un fichier journal dans ~/Library/Logs. Utile quand quelque chose ne marche pas.",
]

private let uiES: [String: String] = [
    "menu.quit": "Salir", "menu.preferences": "Preferencias…", "menu.help": "Ayuda",
    "menu.testWarning": "Probar aviso", "prefs.reset": "Restablecer valores",
    "prefs.cancel": "Cancelar", "unit.seconds": "s",

    "prefs.note": "Los cambios se guardan y se aplican al instante.",
    "prefs.resetQuestion": "¿Restablecer todas las preferencias a los valores predeterminados?",
    "prefs.resetInfo": "Se perderán tus cambios.",
    "help.settingsHeading": "Ajustes",

    "help.body": """
## Icono de la barra de menús
Muestra el nivel de la batería. El icono es verde cuando la batería está bien, amarillo cuando empieza a bajar y rojo cuando está casi vacía (los límites se ajustan en Preferencias). Un rayo significa que el Mac se está cargando.

## Aviso de batería baja
Al llegar al nivel de aviso aparece una ventana con la misma imagen, el porcentaje y el tiempo restante estimado. Permanece hasta que pulses «Cerrar»; después no aparece otra hasta que la batería haya vuelto a superar el nivel de aviso.
Si el porcentaje es mayor que en la comprobación anterior (por ejemplo, al cargar), no se muestra nada. Estar conectado a la corriente no evita el aviso: si la batería baja igualmente hasta el nivel de aviso, se te avisa.
En Preferencias puedes sustituir el título de la ventana por tu propio texto.

## Alarma sonora
Con «Alarma sonora y lectura en voz alta» activada, suena una alarma y el texto de la ventana se lee en voz alta en el idioma del sistema, repitiéndose hasta que pulses «Cerrar». Puedes activarla o desactivarla en cualquier momento en el menú, en la ventana y en Preferencias.

## Tiempo restante estimado
Indica cuánto cree macOS que durará la batería («calculando…» justo después de desconectar; «Conectado a la corriente» mientras se carga).

## Menú de la barra de menús
Haz clic en el icono de batería. «Alarma sonora y lectura en voz alta» activa o desactiva la alarma, «Preferencias…» abre los ajustes, «Ayuda» muestra este texto y «Salir» cierra la app.

## Preferencias
Cada ajuste se puede cambiar allí; los cambios se aplican al instante (salvo los que indican «en el próximo inicio»). «Restablecer valores» recupera los valores originales.

## Una sola copia
Solo puede ejecutarse una copia de la app a la vez (se puede cambiar en Preferencias).

## Licencia
Esta app es software libre: puedes redistribuirla y modificarla según los términos de la GNU General Public License, versión 3 o (a tu elección) cualquier versión posterior. No ofrece ninguna garantía. El texto de la licencia está incluido en la app y puede leerse en https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Alarma sonora y lectura en voz alta",
    "setting.warningThreshold.title": "Nivel de aviso",
    "setting.warningThreshold.help": "La ventana aparece con este porcentaje o menos (si no ha subido desde la comprobación anterior).",
    "setting.customWarningText.title": "Texto de aviso propio",
    "setting.customWarningText.help": "Sustituye el título de la ventana por tu texto (también se lee en voz alta). El porcentaje y el tiempo siguen debajo. Vacío = texto estándar.",
    "setting.redUpTo.title": "Icono rojo hasta",
    "setting.redUpTo.help": "El icono es rojo con este porcentaje o menos.",
    "setting.yellowUpTo.title": "Icono amarillo hasta",
    "setting.yellowUpTo.help": "Amarillo por encima del límite rojo hasta este porcentaje; por encima el icono es verde.",
    "setting.alertIconSize.title": "Tamaño de la imagen en la ventana",
    "setting.alertIconSize.help": "Tamaño de la imagen de la batería en la ventana, en puntos.",
    "setting.checkInterval.title": "Comprobar cada",
    "setting.checkInterval.help": "Con qué frecuencia se comprueba la batería. También se comprueba al instante al conectar o desconectar el cargador.",
    "setting.alarmRepeatInterval.title": "Repetir alarma cada",
    "setting.alarmRepeatInterval.help": "Mientras la ventana está abierta y la alarma sonora activada: pausa entre dos alarmas.",
    "setting.speechDelay.title": "Pausa antes de la lectura",
    "setting.speechDelay.help": "Pausa entre el sonido de alarma y el texto leído.",
    "setting.alarmSoundName.title": "Sonido de alarma",
    "setting.alarmSoundName.help": "El sonido del sistema macOS que se usa como alarma. Al elegir uno se oye una vista previa.",
    "setting.soundAlarm.help": "Reproduce el sonido de alarma y lee en voz alta el texto de la ventana, en el idioma del sistema, mientras está abierta. Es el mismo ajuste que en el menú y en la ventana.",
    "setting.showTestMenuItem.title": "Mostrar «Probar aviso» en el menú",
    "setting.showTestMenuItem.help": "Añade una opción de menú que muestra la ventana con el nivel de batería actual.",
    "setting.showStartupMessage.title": "Mostrar un mensaje al iniciar",
    "setting.showStartupMessage.help": "Muestra un breve mensaje de que la app se está ejecutando en la barra de menús. Se aplica en el próximo inicio.",
    "setting.showAlreadyRunningMessage.title": "Mostrar un mensaje si la app ya se está ejecutando",
    "setting.showAlreadyRunningMessage.help": "Una segunda copia muestra un mensaje en lugar de cerrarse en silencio. Se aplica en el próximo inicio.",
    "setting.singleInstance.title": "Permitir una sola copia",
    "setting.singleInstance.help": "Solo puede ejecutarse una copia; la segunda se cierra. Se aplica en el próximo inicio.",
    "setting.logToFile.title": "Escribir un archivo de registro",
    "setting.logToFile.help": "Escribe mensajes de inicio en un archivo de registro en ~/Library/Logs. Útil cuando algo no funciona.",
]

private let uiIT: [String: String] = [
    "menu.quit": "Esci", "menu.preferences": "Preferenze…", "menu.help": "Aiuto",
    "menu.testWarning": "Prova avviso", "prefs.reset": "Ripristina predefiniti",
    "prefs.cancel": "Annulla", "unit.seconds": "s",

    "prefs.note": "Le modifiche vengono salvate e applicate subito.",
    "prefs.resetQuestion": "Ripristinare tutte le preferenze ai valori predefiniti?",
    "prefs.resetInfo": "Le tue modifiche andranno perse.",
    "help.settingsHeading": "Impostazioni",

    "help.body": """
## Icona nella barra dei menu
Mostra il livello della batteria. L’icona è verde quando la batteria è a posto, gialla quando sta scendendo e rossa quando è quasi scarica (i limiti si impostano nelle Preferenze). Un fulmine indica che il Mac è in carica.

## Avviso di batteria scarica
Al livello di avviso compare una finestra con la stessa immagine, la percentuale e il tempo rimanente stimato. Resta visibile finché non premi «Chiudi»; poi non ne compare un’altra finché la batteria non è tornata sopra il livello di avviso.
Se la percentuale è più alta rispetto al controllo precedente (ad esempio in carica), non viene mostrato nulla. Essere collegati all’alimentazione non impedisce l’avviso: se la batteria scende comunque al livello di avviso, vieni avvisato.
Nelle Preferenze puoi sostituire il titolo della finestra con un testo tuo.

## Allarme sonoro
Con «Allarme sonoro e lettura a voce alta» attivo, suona un allarme e il testo della finestra viene letto ad alta voce nella lingua del sistema, ripetendosi finché non premi «Chiudi». Puoi attivarlo o disattivarlo in qualsiasi momento dal menu, dalla finestra e dalle Preferenze.

## Tempo rimanente stimato
Indica per quanto tempo macOS prevede che durerà la batteria («calcolo in corso…» subito dopo lo scollegamento; «Collegato all'alimentazione» durante la carica).

## Menu nella barra dei menu
Fai clic sull’icona della batteria. «Allarme sonoro e lettura a voce alta» attiva o disattiva l’allarme, «Preferenze…» apre le impostazioni, «Aiuto» mostra questo testo ed «Esci» chiude l’app.

## Preferenze
Ogni impostazione si può modificare lì; le modifiche sono applicate subito (salvo quelle che indicano «al prossimo avvio»). «Ripristina predefiniti» riporta i valori originali.

## Una sola copia
Può essere in esecuzione una sola copia dell’app alla volta (modificabile nelle Preferenze).

## Licenza
Questa app è software libero: puoi ridistribuirla e modificarla secondo i termini della GNU General Public License, versione 3 o (a tua scelta) una versione successiva. Non offre alcuna garanzia. Il testo della licenza è incluso nell’app e consultabile su https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Allarme sonoro e lettura a voce alta",
    "setting.warningThreshold.title": "Livello di avviso",
    "setting.warningThreshold.help": "La finestra compare a questa percentuale o meno (se non è salita dal controllo precedente).",
    "setting.customWarningText.title": "Testo di avviso personale",
    "setting.customWarningText.help": "Sostituisce il titolo della finestra con il tuo testo (letto anche ad alta voce). Percentuale e tempo restano sotto. Vuoto = testo standard.",
    "setting.redUpTo.title": "Icona rossa fino a",
    "setting.redUpTo.help": "L’icona è rossa a questa percentuale o meno.",
    "setting.yellowUpTo.title": "Icona gialla fino a",
    "setting.yellowUpTo.help": "Gialla sopra il limite rosso fino a questa percentuale; sopra l’icona è verde.",
    "setting.alertIconSize.title": "Dimensione immagine nella finestra",
    "setting.alertIconSize.help": "Dimensione dell’immagine della batteria nella finestra, in punti.",
    "setting.checkInterval.title": "Controlla ogni",
    "setting.checkInterval.help": "Ogni quanto viene controllata la batteria. Il controllo avviene subito anche quando colleghi o scolleghi l’alimentatore.",
    "setting.alarmRepeatInterval.title": "Ripeti allarme ogni",
    "setting.alarmRepeatInterval.help": "Finché la finestra è aperta e l’allarme sonoro è attivo: pausa tra due allarmi.",
    "setting.speechDelay.title": "Pausa prima della lettura",
    "setting.speechDelay.help": "Pausa tra il suono dell’allarme e il testo letto.",
    "setting.alarmSoundName.title": "Suono dell’allarme",
    "setting.alarmSoundName.help": "Il suono di sistema macOS usato come allarme. Scegliendolo senti un’anteprima.",
    "setting.soundAlarm.help": "Riproduce il suono dell’allarme e legge ad alta voce il testo della finestra, nella lingua del sistema, finché è aperta. È la stessa impostazione del menu e della finestra.",
    "setting.showTestMenuItem.title": "Mostra «Prova avviso» nel menu",
    "setting.showTestMenuItem.help": "Aggiunge una voce di menu che mostra la finestra con il livello attuale della batteria.",
    "setting.showStartupMessage.title": "Mostra un messaggio all’avvio",
    "setting.showStartupMessage.help": "Mostra un breve messaggio che l’app è in esecuzione nella barra dei menu. Vale dal prossimo avvio.",
    "setting.showAlreadyRunningMessage.title": "Mostra un messaggio se l’app è già in esecuzione",
    "setting.showAlreadyRunningMessage.help": "Una seconda copia mostra un messaggio invece di chiudersi in silenzio. Vale dal prossimo avvio.",
    "setting.singleInstance.title": "Consenti una sola copia",
    "setting.singleInstance.help": "Può essere in esecuzione una sola copia; la seconda si chiude. Vale dal prossimo avvio.",
    "setting.logToFile.title": "Scrivi un file di log",
    "setting.logToFile.help": "Scrive i messaggi di avvio in un file di log in ~/Library/Logs. Utile quando qualcosa non funziona.",
]

private let uiPT: [String: String] = [
    "menu.quit": "Sair", "menu.preferences": "Preferências…", "menu.help": "Ajuda",
    "menu.testWarning": "Testar aviso", "prefs.reset": "Repor predefinições",
    "prefs.cancel": "Cancelar", "unit.seconds": "s",

    "prefs.note": "As alterações são guardadas e aplicadas de imediato.",
    "prefs.resetQuestion": "Repor todas as preferências para os valores predefinidos?",
    "prefs.resetInfo": "As suas alterações serão perdidas.",
    "help.settingsHeading": "Definições",

    "help.body": """
## Ícone na barra de menus
Mostra o nível da bateria. O ícone é verde quando a bateria está bem, amarelo quando começa a ficar baixa e vermelho quando está quase vazia (os limites definem-se nas Preferências). Um raio significa que o Mac está a carregar.

## Aviso de bateria fraca
Ao atingir o nível de aviso, aparece uma janela com a mesma imagem, a percentagem e o tempo restante estimado. Fica visível até clicar em «Fechar»; depois não volta a aparecer até a bateria ter estado novamente acima do nível de aviso.
Se a percentagem for superior à da verificação anterior (por exemplo, a carregar), não aparece nada. Estar ligado à corrente não impede o aviso: se a bateria descer mesmo assim até ao nível de aviso, é avisado.
Nas Preferências pode substituir o título da janela por um texto seu.

## Alarme sonoro
Com «Alarme sonoro e leitura em voz alta» ativo, toca um alarme e o texto da janela é lido em voz alta no idioma do sistema, repetindo-se até clicar em «Fechar». Pode ativá-lo ou desativá-lo a qualquer momento no menu, na janela e nas Preferências.

## Tempo restante estimado
Mostra quanto tempo o macOS prevê que a bateria dure («calculando…» logo após desligar; «Ligado à corrente» durante o carregamento).

## Menu na barra de menus
Clique no ícone da bateria. «Alarme sonoro e leitura em voz alta» ativa ou desativa o alarme, «Preferências…» abre as definições, «Ajuda» mostra este texto e «Sair» fecha a app.

## Preferências
Todas as definições podem ser alteradas aí; as alterações são aplicadas de imediato (exceto as que indicam «no próximo arranque»). «Repor predefinições» restaura os valores originais.

## Apenas uma cópia
Só pode estar a correr uma cópia da app de cada vez (pode alterar nas Preferências).

## Licença
Esta app é software livre: pode redistribuí-la e modificá-la nos termos da GNU General Public License, versão 3 ou (à sua escolha) qualquer versão posterior. Não tem qualquer garantia. O texto da licença está incluído na app e pode ser lido em https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Alarme sonoro e leitura em voz alta",
    "setting.warningThreshold.title": "Nível de aviso",
    "setting.warningThreshold.help": "A janela aparece com esta percentagem ou menos (se não tiver subido desde a verificação anterior).",
    "setting.customWarningText.title": "Texto de aviso próprio",
    "setting.customWarningText.help": "Substitui o título da janela pelo seu texto (também é lido em voz alta). A percentagem e o tempo ficam por baixo. Vazio = texto padrão.",
    "setting.redUpTo.title": "Ícone vermelho até",
    "setting.redUpTo.help": "O ícone é vermelho com esta percentagem ou menos.",
    "setting.yellowUpTo.title": "Ícone amarelo até",
    "setting.yellowUpTo.help": "Amarelo acima do limite vermelho até esta percentagem; acima disso o ícone é verde.",
    "setting.alertIconSize.title": "Tamanho da imagem na janela",
    "setting.alertIconSize.help": "Tamanho da imagem da bateria na janela, em pontos.",
    "setting.checkInterval.title": "Verificar a cada",
    "setting.checkInterval.help": "Com que frequência a bateria é verificada. Também é verificada de imediato ao ligar ou desligar o carregador.",
    "setting.alarmRepeatInterval.title": "Repetir alarme a cada",
    "setting.alarmRepeatInterval.help": "Enquanto a janela está aberta e o alarme sonoro ativo: pausa entre dois alarmes.",
    "setting.speechDelay.title": "Pausa antes da leitura",
    "setting.speechDelay.help": "Pausa entre o som do alarme e o texto lido.",
    "setting.alarmSoundName.title": "Som do alarme",
    "setting.alarmSoundName.help": "O som do sistema macOS usado como alarme. Ao escolher um, ouve uma pré-visualização.",
    "setting.soundAlarm.help": "Toca o som do alarme e lê em voz alta o texto da janela, no idioma do sistema, enquanto estiver aberta. É a mesma definição do menu e da janela.",
    "setting.showTestMenuItem.title": "Mostrar «Testar aviso» no menu",
    "setting.showTestMenuItem.help": "Adiciona um item de menu que mostra a janela com o nível atual da bateria.",
    "setting.showStartupMessage.title": "Mostrar uma mensagem ao iniciar",
    "setting.showStartupMessage.help": "Mostra uma breve mensagem de que a app está a correr na barra de menus. Aplica-se no próximo arranque.",
    "setting.showAlreadyRunningMessage.title": "Mostrar uma mensagem se a app já estiver a correr",
    "setting.showAlreadyRunningMessage.help": "Uma segunda cópia mostra uma mensagem em vez de fechar em silêncio. Aplica-se no próximo arranque.",
    "setting.singleInstance.title": "Permitir apenas uma cópia",
    "setting.singleInstance.help": "Só pode correr uma cópia; a segunda fecha. Aplica-se no próximo arranque.",
    "setting.logToFile.title": "Escrever um ficheiro de registo",
    "setting.logToFile.help": "Escreve mensagens de arranque num ficheiro de registo em ~/Library/Logs. Útil quando algo não funciona.",
]

private let uiRU: [String: String] = [
    "menu.quit": "Выйти", "menu.preferences": "Настройки…", "menu.help": "Справка",
    "menu.testWarning": "Проверить предупреждение", "prefs.reset": "Сбросить настройки",
    "prefs.cancel": "Отмена", "unit.seconds": "с",

    "prefs.note": "Изменения сохраняются и применяются сразу.",
    "prefs.resetQuestion": "Сбросить все настройки к значениям по умолчанию?",
    "prefs.resetInfo": "Ваши изменения будут потеряны.",
    "help.settingsHeading": "Параметры",

    "help.body": """
## Значок в строке меню
Показывает уровень заряда. Значок зелёный, когда заряда достаточно, жёлтый, когда он становится низким, и красный, когда батарея почти разряжена (границы задаются в настройках). Молния означает, что Mac заряжается.

## Предупреждение о низком заряде
При достижении уровня предупреждения появляется окно с тем же изображением, процентом и оценкой оставшегося времени. Оно остаётся на экране, пока вы не нажмёте «Закрыть»; затем новое окно не появится, пока заряд снова не поднимется выше уровня предупреждения.
Если процент выше, чем при предыдущей проверке (например, при зарядке), окно не показывается. Подключение к сети не отменяет предупреждение: если заряд всё равно падает до уровня предупреждения, вы будете предупреждены.
В настройках можно заменить заголовок окна собственным текстом.

## Звуковой сигнал
Если включён пункт «Звуковой сигнал и озвучивание текста», звучит сигнал, а текст окна читается вслух на языке системы; это повторяется, пока вы не нажмёте «Закрыть». Включить или выключить можно в любой момент в меню, в окне и в настройках.

## Оценка оставшегося времени
Показывает, на сколько, по оценке macOS, хватит заряда («вычисляется…» сразу после отключения; «Подключено к сети» во время зарядки).

## Меню в строке меню
Нажмите на значок батареи. «Звуковой сигнал и озвучивание текста» включает или выключает сигнал, «Настройки…» открывают параметры, «Справка» показывает этот текст, «Выйти» завершает приложение.

## Настройки
Каждый параметр можно изменить в окне настроек; изменения применяются сразу (кроме тех, что действуют «при следующем запуске»). «Сбросить настройки» возвращает исходные значения.

## Только одна копия
Одновременно может работать только одна копия приложения (это можно изменить в настройках).

## Лицензия
Это свободное программное обеспечение: вы можете распространять и изменять его на условиях GNU General Public License версии 3 или (по вашему выбору) более поздней версии. Гарантий нет. Текст лицензии входит в приложение и доступен по адресу https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Звуковой сигнал и озвучивание текста",
    "setting.warningThreshold.title": "Уровень предупреждения",
    "setting.warningThreshold.help": "Окно появляется при этом проценте или ниже (если он не вырос с прошлой проверки).",
    "setting.customWarningText.title": "Свой текст предупреждения",
    "setting.customWarningText.help": "Заменяет заголовок окна вашим текстом (он тоже читается вслух). Процент и время остаются ниже. Пусто = стандартный текст.",
    "setting.redUpTo.title": "Красный значок до",
    "setting.redUpTo.help": "Значок красный при этом проценте или ниже.",
    "setting.yellowUpTo.title": "Жёлтый значок до",
    "setting.yellowUpTo.help": "Жёлтый выше красной границы до этого процента; выше значок зелёный.",
    "setting.alertIconSize.title": "Размер картинки в окне",
    "setting.alertIconSize.help": "Размер изображения батареи в окне, в пунктах.",
    "setting.checkInterval.title": "Проверять каждые",
    "setting.checkInterval.help": "Как часто проверяется заряд. При подключении и отключении зарядки проверка выполняется сразу.",
    "setting.alarmRepeatInterval.title": "Повторять сигнал каждые",
    "setting.alarmRepeatInterval.help": "Пока окно открыто и звуковой сигнал включён: пауза между двумя сигналами.",
    "setting.speechDelay.title": "Пауза перед озвучиванием",
    "setting.speechDelay.help": "Пауза между звуком сигнала и озвученным текстом.",
    "setting.alarmSoundName.title": "Звук сигнала",
    "setting.alarmSoundName.help": "Системный звук macOS, используемый как сигнал. При выборе звучит образец.",
    "setting.soundAlarm.help": "Воспроизводит звук сигнала и читает текст окна вслух на языке системы, пока окно открыто. Это тот же параметр, что в меню и в окне.",
    "setting.showTestMenuItem.title": "Показывать «Проверить предупреждение» в меню",
    "setting.showTestMenuItem.help": "Добавляет пункт меню, который показывает окно с текущим уровнем заряда.",
    "setting.showStartupMessage.title": "Показывать сообщение при запуске",
    "setting.showStartupMessage.help": "Показывает короткое сообщение, что приложение работает в строке меню. Действует со следующего запуска.",
    "setting.showAlreadyRunningMessage.title": "Сообщать, если приложение уже запущено",
    "setting.showAlreadyRunningMessage.help": "Вторая копия показывает сообщение вместо тихого завершения. Действует со следующего запуска.",
    "setting.singleInstance.title": "Разрешить только одну копию",
    "setting.singleInstance.help": "Может работать только одна копия; вторая завершается. Действует со следующего запуска.",
    "setting.logToFile.title": "Вести файл журнала",
    "setting.logToFile.help": "Записывает сообщения о запуске в файл журнала в ~/Library/Logs. Полезно, если что-то не работает.",
]

private let uiJA: [String: String] = [
    "menu.quit": "終了", "menu.preferences": "環境設定…", "menu.help": "ヘルプ",
    "menu.testWarning": "警告をテスト", "prefs.reset": "初期設定に戻す",
    "prefs.cancel": "キャンセル", "unit.seconds": "秒",

    "prefs.note": "変更はすぐに保存され、反映されます。",
    "prefs.resetQuestion": "すべての設定を初期値に戻しますか？",
    "prefs.resetInfo": "加えた変更は失われます。",
    "help.settingsHeading": "設定項目",

    "help.body": """
## メニューバーのアイコン
バッテリー残量を表示します。残量が十分なときは緑、少なくなると黄、ほぼ空のときは赤になります（しきい値は環境設定で変更できます）。稲妻マークは Mac が充電中であることを示します。

## バッテリー残量低下の警告
警告レベルに達すると、同じ画像、残量のパーセント、残り時間の目安を表示するウインドウが現れます。「閉じる」を押すまで表示され続け、その後は残量が一度警告レベルを上回るまで再表示されません。
前回の確認より残量が増えている場合（充電中など）は表示されません。電源に接続していても警告は止まりません。それでも警告レベルまで減った場合は通知されます。
環境設定で、ウインドウのタイトルを独自のテキストに置き換えることもできます。

## アラーム音
「アラーム音と音声読み上げ」をオンにすると、アラーム音が鳴り、ウインドウのテキストがシステムの言語で読み上げられます。「閉じる」を押すまで繰り返されます。メニュー、ウインドウ、環境設定でいつでもオン／オフを切り替えられます。

## 残り時間の目安
macOS が見積もったバッテリーの持ち時間を表示します（電源を外した直後は「計算中…」、充電中は「電源に接続中」）。

## メニューバーのメニュー
メニューバーのバッテリーアイコンをクリックします。「アラーム音と音声読み上げ」でオン／オフ、「環境設定…」で設定、「ヘルプ」でこのテキスト、「終了」でアプリを終了します。

## 環境設定
すべての項目を環境設定で変更できます。変更はすぐに反映されます（「次回起動時」と書かれた項目を除く）。「初期設定に戻す」で元の値に戻ります。

## 同時に起動できるのは1つだけ
アプリは同時に1つだけ起動できます（環境設定で変更できます）。

## ライセンス
このアプリはフリーソフトウェアです。GNU General Public License バージョン3、または（任意で）それ以降のバージョンの条件のもとで再配布・改変できます。保証はありません。ライセンス全文はアプリに含まれており、https://www.gnu.org/licenses/gpl-3.0.html でも読めます。
""",

    "setting.soundAlarm.title": "アラーム音と音声読み上げ",
    "setting.warningThreshold.title": "警告レベル",
    "setting.warningThreshold.help": "この割合以下になるとウインドウが表示されます（前回の確認から増えていない場合）。",
    "setting.customWarningText.title": "独自の警告テキスト",
    "setting.customWarningText.help": "ウインドウのタイトルを独自のテキストに置き換えます（読み上げも対象）。割合と残り時間はその下に表示されます。空欄＝標準テキスト。",
    "setting.redUpTo.title": "アイコンが赤になる上限",
    "setting.redUpTo.help": "この割合以下でアイコンが赤になります。",
    "setting.yellowUpTo.title": "アイコンが黄になる上限",
    "setting.yellowUpTo.help": "赤の上限を超えてこの割合まで黄色になり、それより上は緑です。",
    "setting.alertIconSize.title": "ウインドウの画像サイズ",
    "setting.alertIconSize.help": "ウインドウ内のバッテリー画像の大きさ（ポイント）。",
    "setting.checkInterval.title": "確認の間隔",
    "setting.checkInterval.help": "バッテリーを確認する間隔です。電源の接続・取り外し時はすぐに確認します。",
    "setting.alarmRepeatInterval.title": "アラームの繰り返し間隔",
    "setting.alarmRepeatInterval.help": "ウインドウが開いていてアラーム音がオンのとき、アラーム同士の間隔です。",
    "setting.speechDelay.title": "読み上げ前の間隔",
    "setting.speechDelay.help": "アラーム音と読み上げの間の間隔です。",
    "setting.alarmSoundName.title": "アラーム音の種類",
    "setting.alarmSoundName.help": "アラームとして鳴らす macOS のシステムサウンド。選ぶと試聴できます。",
    "setting.soundAlarm.help": "ウインドウが開いている間、アラーム音を鳴らし、ウインドウのテキストをシステムの言語で読み上げます。メニューやウインドウと同じ設定です。",
    "setting.showTestMenuItem.title": "メニューに「警告をテスト」を表示",
    "setting.showTestMenuItem.help": "現在のバッテリー残量でウインドウを表示するメニュー項目を追加します。",
    "setting.showStartupMessage.title": "起動時にメッセージを表示",
    "setting.showStartupMessage.help": "アプリがメニューバーで動作中であることを短いメッセージで知らせます。次回の起動から有効です。",
    "setting.showAlreadyRunningMessage.title": "すでに起動中のときにメッセージを表示",
    "setting.showAlreadyRunningMessage.help": "2つ目のコピーは、何も言わずに終了する代わりにメッセージを表示します。次回の起動から有効です。",
    "setting.singleInstance.title": "1つのコピーのみ許可",
    "setting.singleInstance.help": "同時に起動できるのは1つだけで、2つ目は終了します。次回の起動から有効です。",
    "setting.logToFile.title": "ログファイルを書き込む",
    "setting.logToFile.help": "起動メッセージを ~/Library/Logs のログファイルに書き込みます。不具合の調査に役立ちます。",
]

private let uiZH: [String: String] = [
    "menu.quit": "退出", "menu.preferences": "偏好设置…", "menu.help": "帮助",
    "menu.testWarning": "测试警告", "prefs.reset": "恢复默认设置",
    "prefs.cancel": "取消", "unit.seconds": "秒",

    "prefs.note": "更改会立即保存并生效。",
    "prefs.resetQuestion": "要将所有偏好设置恢复为默认值吗？",
    "prefs.resetInfo": "您所做的更改将丢失。",
    "help.settingsHeading": "设置项",

    "help.body": """
## 菜单栏图标
显示电池电量。电量充足时图标为绿色，电量偏低时为黄色，电量几乎耗尽时为红色（阈值可在偏好设置中调整）。闪电标志表示 Mac 正在充电。

## 低电量警告
电量达到警告值时，会弹出窗口，显示相同的图片、电量百分比和预计剩余时间。窗口会一直显示，直到您点击“关闭”；之后在电量重新高于警告值之前不会再次弹出。
如果电量比上次检查时更高（例如正在充电），则不会弹出。接通电源并不会阻止警告：如果电量仍然降到警告值，您会收到提醒。
您可以在偏好设置中用自己的文字替换窗口标题。

## 声音警报
开启“声音警报并朗读文字”后，会播放警报声，并用系统语言朗读窗口中的文字，重复直到您点击“关闭”。您可以随时在菜单、窗口和偏好设置中开启或关闭。

## 预计剩余时间
显示 macOS 预计电池还能使用多久（刚拔掉电源时显示“正在计算…”；充电时显示“已连接电源”）。

## 菜单栏菜单
点击菜单栏中的电池图标。“声音警报并朗读文字”用于开关警报，“偏好设置…”打开设置，“帮助”显示本说明，“退出”关闭应用。

## 偏好设置
每项设置都可以在偏好设置窗口中更改，更改会立即生效（注明“下次启动时生效”的除外）。“恢复默认设置”会恢复原始值。

## 仅一个副本
同一时间只能运行一个应用副本（可在偏好设置中更改）。

## 许可证
本应用是自由软件：您可以依据 GNU 通用公共许可证第 3 版或（由您选择）任何更高版本的条款重新分发和修改它。本应用不提供任何担保。许可证全文包含在应用中，也可在 https://www.gnu.org/licenses/gpl-3.0.html 阅读。
""",

    "setting.soundAlarm.title": "声音警报并朗读文字",
    "setting.warningThreshold.title": "警告值",
    "setting.warningThreshold.help": "电量等于或低于此百分比时弹出窗口（前提是自上次检查以来没有上升）。",
    "setting.customWarningText.title": "自定义警告文字",
    "setting.customWarningText.help": "用您的文字替换窗口标题（也会被朗读）。百分比和剩余时间仍显示在其下方。留空＝标准文字。",
    "setting.redUpTo.title": "红色图标上限",
    "setting.redUpTo.help": "电量等于或低于此百分比时图标为红色。",
    "setting.yellowUpTo.title": "黄色图标上限",
    "setting.yellowUpTo.help": "高于红色上限、至此百分比之间为黄色；再高则为绿色。",
    "setting.alertIconSize.title": "窗口图片大小",
    "setting.alertIconSize.help": "窗口中电池图片的大小，单位为点。",
    "setting.checkInterval.title": "检查间隔",
    "setting.checkInterval.help": "检查电池的频率。插上或拔掉电源时会立即检查。",
    "setting.alarmRepeatInterval.title": "警报重复间隔",
    "setting.alarmRepeatInterval.help": "窗口打开且声音警报开启时，两次警报之间的间隔。",
    "setting.speechDelay.title": "朗读前停顿",
    "setting.speechDelay.help": "警报声与朗读文字之间的停顿。",
    "setting.alarmSoundName.title": "警报声",
    "setting.alarmSoundName.help": "用作警报的 macOS 系统声音。选择后会播放试听。",
    "setting.soundAlarm.help": "窗口打开期间，播放警报声并用系统语言朗读窗口中的文字。与菜单和窗口中的是同一个设置。",
    "setting.showTestMenuItem.title": "在菜单中显示“测试警告”",
    "setting.showTestMenuItem.help": "添加一个菜单项，用当前电量显示警告窗口。",
    "setting.showStartupMessage.title": "启动时显示提示",
    "setting.showStartupMessage.help": "显示一条简短提示，说明应用正在菜单栏中运行。下次启动时生效。",
    "setting.showAlreadyRunningMessage.title": "应用已在运行时显示提示",
    "setting.showAlreadyRunningMessage.help": "第二个副本会显示提示，而不是悄悄退出。下次启动时生效。",
    "setting.singleInstance.title": "只允许一个副本",
    "setting.singleInstance.help": "只能运行一个副本；第二个副本会退出。下次启动时生效。",
    "setting.logToFile.title": "写入日志文件",
    "setting.logToFile.help": "将启动信息写入 ~/Library/Logs 中的日志文件。出现问题时很有用。",
]

private let uiKO: [String: String] = [
    "menu.quit": "종료", "menu.preferences": "환경설정…", "menu.help": "도움말",
    "menu.testWarning": "경고 테스트", "prefs.reset": "기본값으로 재설정",
    "prefs.cancel": "취소", "unit.seconds": "초",

    "prefs.note": "변경 사항은 즉시 저장되고 적용됩니다.",
    "prefs.resetQuestion": "모든 환경설정을 기본값으로 재설정할까요?",
    "prefs.resetInfo": "직접 변경한 내용이 사라집니다.",
    "help.settingsHeading": "설정 항목",

    "help.body": """
## 메뉴 막대 아이콘
배터리 잔량을 표시합니다. 잔량이 충분하면 녹색, 부족해지기 시작하면 노란색, 거의 소진되면 빨간색입니다(기준값은 환경설정에서 정할 수 있습니다). 번개 표시는 Mac이 충전 중임을 뜻합니다.

## 배터리 부족 경고
경고 수준에 도달하면 같은 그림, 잔량 비율, 예상 남은 시간이 표시된 창이 나타납니다. “닫기”를 누를 때까지 화면에 남으며, 이후에는 배터리가 다시 경고 수준 위로 올라갔다가 내려가야 다시 나타납니다.
이전 확인보다 잔량이 높아졌다면(예: 충전 중) 창이 나타나지 않습니다. 전원이 연결되어 있어도 경고는 멈추지 않습니다. 그래도 경고 수준까지 내려가면 알려 드립니다.
환경설정에서 창의 제목을 직접 쓴 문구로 바꿀 수 있습니다.

## 경고음
“경고음 및 음성 읽기”를 켜면 경고음이 울리고 창의 문구를 시스템 언어로 읽어 줍니다. “닫기”를 누를 때까지 반복됩니다. 메뉴, 창, 환경설정에서 언제든지 켜고 끌 수 있습니다.

## 예상 남은 시간
macOS가 예상하는 배터리 사용 가능 시간을 표시합니다(전원을 뽑은 직후에는 “계산 중…”, 충전 중에는 “전원 연결됨”).

## 메뉴 막대 메뉴
메뉴 막대의 배터리 아이콘을 클릭하세요. “경고음 및 음성 읽기”는 경고음을 켜고 끄며, “환경설정…”은 설정을 열고, “도움말”은 이 문서를 보여 주며, “종료”는 앱을 끝냅니다.

## 환경설정
모든 항목을 환경설정 창에서 바꿀 수 있습니다. 변경 사항은 즉시 적용됩니다(“다음 실행 시 적용”이라고 적힌 항목 제외). “기본값으로 재설정”을 누르면 원래 값으로 돌아갑니다.

## 하나만 실행
앱은 한 번에 하나만 실행할 수 있습니다(환경설정에서 변경 가능).

## 라이선스
이 앱은 자유 소프트웨어입니다. GNU 일반 공중 사용 허가서 버전 3 또는 (선택에 따라) 그 이후 버전의 조건에 따라 재배포하거나 수정할 수 있습니다. 어떠한 보증도 없습니다. 라이선스 전문은 앱에 포함되어 있으며 https://www.gnu.org/licenses/gpl-3.0.html 에서도 볼 수 있습니다.
""",

    "setting.soundAlarm.title": "경고음 및 음성 읽기",
    "setting.warningThreshold.title": "경고 수준",
    "setting.warningThreshold.help": "이 비율 이하이면 창이 나타납니다(이전 확인 이후 올라가지 않은 경우).",
    "setting.customWarningText.title": "직접 쓴 경고 문구",
    "setting.customWarningText.help": "창의 제목을 직접 쓴 문구로 바꿉니다(음성으로도 읽습니다). 비율과 남은 시간은 그 아래에 그대로 표시됩니다. 비워 두면 기본 문구.",
    "setting.redUpTo.title": "빨간 아이콘 기준",
    "setting.redUpTo.help": "이 비율 이하이면 아이콘이 빨간색입니다.",
    "setting.yellowUpTo.title": "노란 아이콘 기준",
    "setting.yellowUpTo.help": "빨간색 기준 초과부터 이 비율까지 노란색이며, 그 위는 녹색입니다.",
    "setting.alertIconSize.title": "창 그림 크기",
    "setting.alertIconSize.help": "창 안의 배터리 그림 크기(포인트)입니다.",
    "setting.checkInterval.title": "확인 주기",
    "setting.checkInterval.help": "배터리를 확인하는 주기입니다. 전원을 연결하거나 뽑을 때는 즉시 확인합니다.",
    "setting.alarmRepeatInterval.title": "경고음 반복 주기",
    "setting.alarmRepeatInterval.help": "창이 열려 있고 경고음이 켜져 있을 때 경고음 사이의 간격입니다.",
    "setting.speechDelay.title": "읽기 전 간격",
    "setting.speechDelay.help": "경고음과 음성 읽기 사이의 간격입니다.",
    "setting.alarmSoundName.title": "경고음 소리",
    "setting.alarmSoundName.help": "경고음으로 사용할 macOS 시스템 사운드입니다. 선택하면 미리 들을 수 있습니다.",
    "setting.soundAlarm.help": "창이 열려 있는 동안 경고음을 울리고 창의 문구를 시스템 언어로 읽어 줍니다. 메뉴와 창에 있는 것과 같은 설정입니다.",
    "setting.showTestMenuItem.title": "메뉴에 “경고 테스트” 표시",
    "setting.showTestMenuItem.help": "현재 배터리 잔량으로 창을 보여 주는 메뉴 항목을 추가합니다.",
    "setting.showStartupMessage.title": "시작할 때 메시지 표시",
    "setting.showStartupMessage.help": "앱이 메뉴 막대에서 실행 중임을 알리는 짧은 메시지를 표시합니다. 다음 실행부터 적용됩니다.",
    "setting.showAlreadyRunningMessage.title": "이미 실행 중일 때 메시지 표시",
    "setting.showAlreadyRunningMessage.help": "두 번째 복사본은 조용히 종료하지 않고 메시지를 표시합니다. 다음 실행부터 적용됩니다.",
    "setting.singleInstance.title": "복사본 하나만 허용",
    "setting.singleInstance.help": "하나만 실행할 수 있으며 두 번째 복사본은 종료됩니다. 다음 실행부터 적용됩니다.",
    "setting.logToFile.title": "로그 파일 쓰기",
    "setting.logToFile.help": "시작 메시지를 ~/Library/Logs의 로그 파일에 기록합니다. 문제가 있을 때 유용합니다.",
]

private let uiPL: [String: String] = [
    "menu.quit": "Zakończ", "menu.preferences": "Preferencje…", "menu.help": "Pomoc",
    "menu.testWarning": "Testuj ostrzeżenie", "prefs.reset": "Przywróć domyślne",
    "prefs.cancel": "Anuluj", "unit.seconds": "s",

    "prefs.note": "Zmiany są zapisywane i stosowane natychmiast.",
    "prefs.resetQuestion": "Przywrócić wszystkie preferencje do wartości domyślnych?",
    "prefs.resetInfo": "Twoje zmiany zostaną utracone.",
    "help.settingsHeading": "Ustawienia",

    "help.body": """
## Ikona na pasku menu
Pokazuje poziom baterii. Ikona jest zielona, gdy bateria jest w porządku, żółta, gdy zaczyna się wyczerpywać, i czerwona, gdy jest prawie pusta (progi ustawisz w Preferencjach). Błyskawica oznacza, że Mac się ładuje.

## Ostrzeżenie o niskim poziomie baterii
Po osiągnięciu poziomu ostrzeżenia pojawia się okno z tym samym obrazkiem, procentem i szacowanym pozostałym czasem. Pozostaje na ekranie, dopóki nie naciśniesz „Zamknij”; potem nowe okno nie pojawi się, dopóki bateria nie przekroczy ponownie poziomu ostrzeżenia.
Jeśli procent jest wyższy niż przy poprzednim sprawdzeniu (np. podczas ładowania), okno się nie pojawia. Podłączenie do zasilania nie wyłącza ostrzeżenia: jeśli bateria mimo to spadnie do poziomu ostrzeżenia, zostaniesz ostrzeżony.
W Preferencjach możesz zastąpić tytuł okna własnym tekstem.

## Alarm dźwiękowy
Gdy włączona jest opcja „Alarm dźwiękowy i odczyt na głos”, rozlega się alarm, a tekst okna jest czytany na głos w języku systemu; powtarza się to, dopóki nie naciśniesz „Zamknij”. Możesz to włączyć lub wyłączyć w dowolnej chwili w menu, w oknie i w Preferencjach.

## Szacowany pozostały czas
Pokazuje, jak długo według macOS wystarczy baterii („obliczanie…” zaraz po odłączeniu; „Podłączono do zasilania” podczas ładowania).

## Menu na pasku menu
Kliknij ikonę baterii. „Alarm dźwiękowy i odczyt na głos” włącza lub wyłącza alarm, „Preferencje…” otwiera ustawienia, „Pomoc” pokazuje ten tekst, a „Zakończ” zamyka aplikację.

## Preferencje
Każde ustawienie można zmienić w oknie Preferencji; zmiany działają natychmiast (poza tymi z adnotacją „od następnego uruchomienia”). „Przywróć domyślne” przywraca wartości początkowe.

## Tylko jedna kopia
Naraz może działać tylko jedna kopia aplikacji (można to zmienić w Preferencjach).

## Licencja
Ta aplikacja jest wolnym oprogramowaniem: możesz ją rozpowszechniać i modyfikować na warunkach GNU General Public License w wersji 3 lub (według własnego wyboru) dowolnej nowszej. Nie ma żadnej gwarancji. Tekst licencji jest dołączony do aplikacji i dostępny pod adresem https://www.gnu.org/licenses/gpl-3.0.html.
""",

    "setting.soundAlarm.title": "Alarm dźwiękowy i odczyt na głos",
    "setting.warningThreshold.title": "Poziom ostrzeżenia",
    "setting.warningThreshold.help": "Okno pojawia się przy tym procencie lub niższym (jeśli nie wzrósł od poprzedniego sprawdzenia).",
    "setting.customWarningText.title": "Własny tekst ostrzeżenia",
    "setting.customWarningText.help": "Zastępuje tytuł okna Twoim tekstem (jest też czytany na głos). Procent i czas pozostają pod nim. Puste = tekst standardowy.",
    "setting.redUpTo.title": "Czerwona ikona do",
    "setting.redUpTo.help": "Ikona jest czerwona przy tym procencie lub niższym.",
    "setting.yellowUpTo.title": "Żółta ikona do",
    "setting.yellowUpTo.help": "Żółta powyżej czerwonego progu aż do tego procentu; wyżej ikona jest zielona.",
    "setting.alertIconSize.title": "Rozmiar obrazka w oknie",
    "setting.alertIconSize.help": "Rozmiar obrazka baterii w oknie, w punktach.",
    "setting.checkInterval.title": "Sprawdzaj co",
    "setting.checkInterval.help": "Jak często sprawdzany jest poziom baterii. Przy podłączeniu lub odłączeniu zasilacza sprawdzenie następuje od razu.",
    "setting.alarmRepeatInterval.title": "Powtarzaj alarm co",
    "setting.alarmRepeatInterval.help": "Gdy okno jest otwarte, a alarm dźwiękowy włączony: przerwa między dwoma alarmami.",
    "setting.speechDelay.title": "Przerwa przed odczytem",
    "setting.speechDelay.help": "Przerwa między dźwiękiem alarmu a odczytywanym tekstem.",
    "setting.alarmSoundName.title": "Dźwięk alarmu",
    "setting.alarmSoundName.help": "Dźwięk systemowy macOS używany jako alarm. Po wybraniu usłyszysz próbkę.",
    "setting.soundAlarm.help": "Odtwarza dźwięk alarmu i czyta na głos tekst okna, w języku systemu, dopóki okno jest otwarte. To samo ustawienie co w menu i w oknie.",
    "setting.showTestMenuItem.title": "Pokaż „Testuj ostrzeżenie” w menu",
    "setting.showTestMenuItem.help": "Dodaje pozycję menu, która pokazuje okno z bieżącym poziomem baterii.",
    "setting.showStartupMessage.title": "Pokaż komunikat przy uruchomieniu",
    "setting.showStartupMessage.help": "Pokazuje krótki komunikat, że aplikacja działa na pasku menu. Działa od następnego uruchomienia.",
    "setting.showAlreadyRunningMessage.title": "Pokaż komunikat, gdy aplikacja już działa",
    "setting.showAlreadyRunningMessage.help": "Druga kopia pokazuje komunikat zamiast cicho się zamknąć. Działa od następnego uruchomienia.",
    "setting.singleInstance.title": "Zezwalaj tylko na jedną kopię",
    "setting.singleInstance.help": "Może działać tylko jedna kopia; druga się zamyka. Działa od następnego uruchomienia.",
    "setting.logToFile.title": "Zapisuj plik dziennika",
    "setting.logToFile.help": "Zapisuje komunikaty startowe w pliku dziennika w ~/Library/Logs. Przydatne, gdy coś nie działa.",
]

private let uiTR: [String: String] = [
    "menu.quit": "Çık", "menu.preferences": "Tercihler…", "menu.help": "Yardım",
    "menu.testWarning": "Uyarıyı test et", "prefs.reset": "Varsayılanlara dön",
    "prefs.cancel": "İptal", "unit.seconds": "sn",

    "prefs.note": "Değişiklikler hemen kaydedilir ve uygulanır.",
    "prefs.resetQuestion": "Tüm tercihler varsayılan değerlere döndürülsün mü?",
    "prefs.resetInfo": "Yaptığınız değişiklikler kaybolacak.",
    "help.settingsHeading": "Ayarlar",

    "help.body": """
## Menü çubuğu simgesi
Pil seviyesini gösterir. Pil iyi durumdayken simge yeşil, azalmaya başlayınca sarı, neredeyse bittiğinde kırmızıdır (sınırları Tercihler’den ayarlayabilirsiniz). Şimşek işareti Mac’in şarj olduğunu gösterir.

## Düşük pil uyarısı
Pil uyarı seviyesine ulaşınca aynı resmi, yüzdeyi ve tahmini kalan süreyi gösteren bir pencere açılır. “Kapat”a basana kadar ekranda kalır; ardından pil yeniden uyarı seviyesinin üzerine çıkmadıkça yeni pencere açılmaz.
Yüzde bir önceki kontrolden yüksekse (örneğin şarj olurken) pencere gösterilmez. Güce bağlı olmak uyarıyı engellemez: pil yine de uyarı seviyesine düşerse uyarılırsınız.
Tercihler’de pencerenin başlığını kendi metninizle değiştirebilirsiniz.

## Sesli alarm
“Sesli alarm ve sesli okuma” açıkken bir alarm sesi çalar ve pencerenin metni sistem dilinde sesli okunur; siz “Kapat”a basana kadar tekrarlanır. Menüden, pencereden ve Tercihler’den istediğiniz zaman açıp kapatabilirsiniz.

## Tahmini kalan süre
macOS’in pilin ne kadar dayanacağını tahmin ettiği süreyi gösterir (fişi çektikten hemen sonra “hesaplanıyor…”; şarj olurken “Güce bağlı”).

## Menü çubuğundaki menü
Menü çubuğundaki pil simgesine tıklayın. “Sesli alarm ve sesli okuma” alarmı açar veya kapatır, “Tercihler…” ayarları açar, “Yardım” bu metni gösterir, “Çık” uygulamayı kapatır.

## Tercihler
Her ayar Tercihler penceresinde değiştirilebilir; değişiklikler hemen uygulanır (“bir sonraki açılışta” yazanlar hariç). “Varsayılanlara dön” özgün değerleri geri getirir.

## Yalnızca bir kopya
Aynı anda uygulamanın yalnızca bir kopyası çalışabilir (Tercihler’den değiştirilebilir).

## Lisans
Bu uygulama özgür yazılımdır: GNU Genel Kamu Lisansı’nın 3. sürümü veya (tercihinize göre) sonraki herhangi bir sürümünün koşulları altında yeniden dağıtabilir ve değiştirebilirsiniz. Hiçbir garanti verilmez. Lisans metni uygulamaya dahildir ve https://www.gnu.org/licenses/gpl-3.0.html adresinde okunabilir.
""",

    "setting.soundAlarm.title": "Sesli alarm ve sesli okuma",
    "setting.warningThreshold.title": "Uyarı seviyesi",
    "setting.warningThreshold.help": "Pil bu yüzdede veya altındayken pencere açılır (bir önceki kontrolden beri yükselmediyse).",
    "setting.customWarningText.title": "Kendi uyarı metniniz",
    "setting.customWarningText.help": "Pencerenin başlığını kendi metninizle değiştirir (sesli de okunur). Yüzde ve süre altında kalır. Boş = standart metin.",
    "setting.redUpTo.title": "Kırmızı simge sınırı",
    "setting.redUpTo.help": "Simge bu yüzdede veya altındayken kırmızıdır.",
    "setting.yellowUpTo.title": "Sarı simge sınırı",
    "setting.yellowUpTo.help": "Kırmızı sınırın üstünden bu yüzdeye kadar sarıdır; üstünde simge yeşildir.",
    "setting.alertIconSize.title": "Penceredeki resim boyutu",
    "setting.alertIconSize.help": "Penceredeki pil resminin boyutu, punto cinsinden.",
    "setting.checkInterval.title": "Kontrol aralığı",
    "setting.checkInterval.help": "Pilin ne sıklıkla kontrol edildiği. Şarj aleti takılıp çıkarıldığında hemen kontrol edilir.",
    "setting.alarmRepeatInterval.title": "Alarmı tekrarlama aralığı",
    "setting.alarmRepeatInterval.help": "Pencere açıkken ve sesli alarm açıkken iki alarm arasındaki bekleme.",
    "setting.speechDelay.title": "Okumadan önce bekleme",
    "setting.speechDelay.help": "Alarm sesi ile okunan metin arasındaki bekleme.",
    "setting.alarmSoundName.title": "Alarm sesi",
    "setting.alarmSoundName.help": "Alarm olarak çalınan macOS sistem sesi. Bir ses seçtiğinizde önizleme duyarsınız.",
    "setting.soundAlarm.help": "Pencere açıkken alarm sesini çalar ve pencerenin metnini sistem dilinde sesli okur. Menüdeki ve penceredeki ayarla aynıdır.",
    "setting.showTestMenuItem.title": "Menüde “Uyarıyı test et” göster",
    "setting.showTestMenuItem.help": "Güncel pil seviyenizle pencereyi gösteren bir menü öğesi ekler.",
    "setting.showStartupMessage.title": "Açılışta bir mesaj göster",
    "setting.showStartupMessage.help": "Uygulamanın menü çubuğunda çalıştığını belirten kısa bir mesaj gösterir. Bir sonraki açılıştan itibaren geçerlidir.",
    "setting.showAlreadyRunningMessage.title": "Uygulama zaten çalışıyorsa mesaj göster",
    "setting.showAlreadyRunningMessage.help": "İkinci kopya sessizce kapanmak yerine bir mesaj gösterir. Bir sonraki açılıştan itibaren geçerlidir.",
    "setting.singleInstance.title": "Yalnızca bir kopyaya izin ver",
    "setting.singleInstance.help": "Yalnızca bir kopya çalışabilir; ikincisi kapanır. Bir sonraki açılıştan itibaren geçerlidir.",
    "setting.logToFile.title": "Günlük dosyası yaz",
    "setting.logToFile.help": "Başlangıç mesajlarını ~/Library/Logs içindeki bir günlük dosyasına yazar. Bir şey çalışmadığında işe yarar.",
]

// MARK: - All languages

private let uiStrings: [String: [String: String]] = [
    "en": uiEN, "nl": uiNL, "de": uiDE, "fr": uiFR, "es": uiES, "it": uiIT, "pt": uiPT,
    "ru": uiRU, "ja": uiJA, "zh": uiZH, "ko": uiKO, "pl": uiPL, "tr": uiTR,
]
