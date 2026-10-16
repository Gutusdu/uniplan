# UniPlan – iPhone-Uni-Planer (PWA)

## Funktionen
- Dashboard mit offenen Aufgaben, überfälligen Aufgaben und Fortschritt
- Wöchentlicher Stundenplan mit wiederkehrenden Veranstaltungen
- Aufgaben, Abgaben, Klausuren und Lerneinheiten mit Status, Modul, Datum, Zeit, Dauer, Priorität und Notizen
- Klausurübersicht und Erstellen einer ersten Lerneinheit
- lokale Speicherung im Browser (`localStorage`)
- JSON-Export/Import als Backup
- Offline-Grundfunktionen nach erstem Laden (Service Worker)
- optionale Browser-Benachrichtigungen, solange der Browser/App aktiv ist und die Plattform sie unterstützt

## Wichtige Einschränkungen
Dies ist ein lokaler Prototyp, kein cloud-synchronisierter Dienst. Die Daten sind an den Browser auf diesem Gerät gebunden. Exportiere regelmäßig ein Backup.
Eine Web-App kann auf iOS keine zuverlässigen nativen Wecker in Apples Uhr-App anlegen. iOS unterstützt Web-Push für zum Home-Bildschirm hinzugefügte Web-Apps ab iOS/iPadOS 16.4 mit Berechtigung; für geplante Push-Nachrichten braucht es aber einen Push-Server. Dieser Prototyp besitzt keinen solchen Server und garantiert keine Benachrichtigungen, wenn die App geschlossen ist. Erinnerungen werden vor allem geprüft, während die App geöffnet und aktiv ist.
Das Intervall für Erinnerungen ist keine präzise Alarmuhr; iOS kann Hintergrund-Timer pausieren. Die Veranstaltungserinnerung wird daher nicht zuverlässig im Hintergrund ausgelöst.
`localStorage` kann beim Löschen von Website-Daten verloren gehen. Backup-Export nutzen.

## Lokal testen
Service Worker und PWA-Installation funktionieren normalerweise nur über HTTPS oder `localhost`. Öffne `index.html` direkt zum schnellen UI-Test; Offline-Funktion und Installation funktionieren dann nicht vollständig.

Für einen lokalen Server mit Python:
```bash
python3 -m http.server 8000
```
Rufe dann auf dem Entwicklungsgerät `http://localhost:8000` auf. Für das iPhone muss die App über eine HTTPS-Adresse erreichbar sein (z. B. eigener HTTPS-Host oder HTTPS-Deployment). Verwende keine ungeschützten öffentlichen WLAN- oder fremden Hosting-Umgebungen für private Daten.

## Installation auf dem iPhone
1. Lade den kompletten Ordner auf einen Webhost mit HTTPS hoch.
2. Öffne die HTTPS-Adresse in Safari auf dem iPhone.
3. Tippe auf „Teilen“ und dann „Zum Home-Bildschirm“.
4. Aktiviere „Als Web-App öffnen“, falls iOS diese Option anbietet, und tippe auf „Hinzufügen“.
5. Starte UniPlan über das neue Home-Bildschirm-Symbol.
6. Öffne Einstellungen in UniPlan und erteile Benachrichtigungsrechte, sofern iOS die Anfrage anbietet.

## Dateien
- `index.html` – App-Struktur
- `styles.css` – dunkles, responsives Design
- `app.js` – Funktionen und lokale Datenhaltung
- `manifest.webmanifest` – PWA-Metadaten
- `sw.js` – Offline-Cache
- `icon-192.png`, `icon-512.png` – App-Symbole


## Intelligenter Lernplaner (lokaler Prototyp)
Der Tab „KI-Planer“ erstellt Vorschläge aus den direkt in UniPlan gespeicherten Veranstaltungen, offenen Aufgaben und Klausuren. Berücksichtigt werden Deadlines, Prioritäten, ein einstellbares tägliches Lernlimit, Sitzungsdauer, Pausenpuffer und ein Planungshorizont. Vorschläge werden nicht automatisch als Aufgaben angelegt: Erst mit „Übernehmen“ entsteht eine Lerneinheit im Lernplan. Abgelehnte Vorschläge werden nicht übernommen.
Die Planung ist aktuell regelbasiert und transparent, kein echtes generatives KI-Modell. Es wird kein API-Schlüssel benötigt und keine Aufgabe an einen externen KI-Anbieter gesendet. Ein echtes Sprachmodell muss über einen eigenen sicheren Server eingebunden werden; ein API-Schlüssel darf nie in `app.js` oder einer anderen öffentlich ausgelieferten Datei stehen.


## eKVV-Kalenderimport
Im Tab „Einstellungen“ kannst du deinen persönlichen iCalendar-Link aus dem eKVV versuchen direkt zu importieren oder eine `.ics`-Datei auswählen. Wöchentliche `RRULE:FREQ=WEEKLY`-Termine werden als wiederkehrende Veranstaltungen importiert; zukünftige Einzeltermine werden als Termine gespeichert. Beim erneuten Import werden nur vorher importierte eKVV-Einträge ersetzt. Der Kalenderlink wird nicht gespeichert.

**Grenzen:** Browser können den direkten Abruf eines Kalenderlinks durch CORS-Regeln blockieren. In dem Fall die Kalenderdatei als `.ics` herunterladen und in UniPlan auswählen. Die Umsetzung verarbeitet wöchentliche Wiederholungen; komplexe Wiederholungsregeln, Ausnahmen/verschobene Einzeltermine und Serientermine mit mehreren verschiedenen Wiederholungsmustern werden nicht vollständig abgebildet. Es gibt keine automatische Synchronisierung; importiere erneut, wenn sich dein Stundenplan ändert.
