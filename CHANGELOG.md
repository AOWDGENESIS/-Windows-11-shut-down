# Changelog

Alle nennenswerten Änderungen an diesem Projekt.
Format orientiert sich an [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
Versionierung nach [Semantic Versioning](https://semver.org/lang/de/).

## [1.0.0] – 2026-10-15

Erste veröffentlichte Version.

### Hinzugefügt
- **Ein-Klick-Installation** (`Installieren.cmd`): kopiert die Skripte nach
  `%LOCALAPPDATA%\Herunterfahren`, entpackt das Icon (im Installer als Base64 eingebettet)
  und legt die Desktop-Verknüpfung in allen von Windows gemeldeten Desktop-Ordnern an.
- **Geplante Aufgabe mit Administratorrechten** (`Aufgabe-anlegen.cmd`): das Aufräumen läuft
  beim Klick automatisch mit erhöhten Rechten – ohne UAC-Abfrage im Alltag.
- **Automatisches Aufräumen vor dem Herunterfahren**: `%TEMP%`, Temp aller Benutzerprofile,
  `C:\Windows\Temp`, Internetcache (INetCache), Fehlerberichte (WER), CrashDumps,
  Windows-Update-Downloads; optional Papierkorb.
- **Sauberes Herunterfahren** über `shutdown /s /t 0` – bewusst **ohne** `/f`, damit keine
  ungespeicherte Arbeit verloren geht.
- **Eigenes Icon** im Windows-11-Look (dunkle Kachel, Metallring, Nachthimmel mit Mond,
  Neon-Power-Symbol) in allen Größen 16–256 px; kleine Größen separat optimiert.
- **Hilfs-Werkzeuge**: `Herunterfahren-30-Sekunden.cmd` (abbrechbar), `Abbrechen.cmd`,
  `Desktop-aufraeumen.cmd` (behält nur „Herunterfahren“, mit Sicherung),
  `Desktop-Wiederherstellen.cmd`, `Desktop-Verknuepfung-anlegen.cmd`, `Icon-aktualisieren.cmd`.
- **Kompletter Rückbau** (`Deinstallieren.cmd`) in 6 Schritten: geplante Aufgabe, alle
  Verknüpfungen (Desktop/Taskleiste/Startmenü), Programmordner, Temp-Reste, Icon- und
  Thumbnail-Cache, Explorer-Neustart.
- **Release-Automatik**: GitHub-Action erstellt bei einem Tag-Push automatisch das ZIP und
  hängt es an den Release; `tools/validate.py` prüft Skripte und Icon (auch in der CI).

### Behoben
- Desktop-Verknüpfung wurde nicht angelegt, wenn die .NET-Abfrage des Desktop-Pfads einen
  leeren Wert lieferte (z. B. auf deutschen Systemen). Die Ermittlung läuft jetzt zusätzlich
  über die Shell, `%USERPROFILE%\Desktop`, `C:\Users\Public\Desktop` und OneDrive-Pfade.
- Nach einem Icon-Wechsel zeigte Windows teils weiter das alte Symbol – dafür gibt es jetzt
  `Icon-aktualisieren.cmd` und den Icon-Cache-Schritt im Deinstallierer.
- Alle `.cmd`-Dateien nutzen durchgängig CRLF-Zeilenenden und reines ASCII (keine
  Zeichensatz-Probleme in der Eingabeaufforderung).

[1.0.0]: ../../releases/tag/v1.0.0
