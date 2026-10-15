# Windows 11 – Sauberes Herunterfahren

[![Prüfung](https://github.com/AOWDGENESIS/-Windows-11-shut-down/actions/workflows/validate.yml/badge.svg)](https://github.com/AOWDGENESIS/-Windows-11-shut-down/actions/workflows/validate.yml)
[![Release](https://img.shields.io/github/v/release/AOWDGENESIS/-Windows-11-shut-down)](https://github.com/AOWDGENESIS/-Windows-11-shut-down/releases)
[![Lizenz: MIT](https://img.shields.io/badge/Lizenz-MIT-green.svg)](LICENSE)

Ein Klick auf ein Desktop-Icon: **alle Temp- und Cache-Ordner werden aufgeräumt** – inklusive
`C:\Windows\Temp` und den Temp-Ordnern **aller** Benutzerkonten – und danach **fährt Windows
sauber herunter**. Ausgeführt mit Administratorrechten über eine geplante Windows-Aufgabe,
also **ohne UAC-Abfrage** beim Benutzen.

> **English summary:** A one-click Windows 11 shutdown shortcut. It cleans all temp/cache
> folders (system-wide, via a scheduled task with admin rights) and then shuts the PC down
> cleanly – without ever forcing apps to close (`/f`). German UI, MIT licensed.

![Icon-Vorschau](docs/icon-vorschau.png)

---

## Inhalt

- [Schnellstart](#schnellstart)
- [Was beim Klick passiert](#was-beim-klick-passiert)
- [Sicherheit & Verhalten](#sicherheit--verhalten)
- [Dateien im Paket](#dateien-im-paket)
- [Deinstallation & kompletter Rückbau](#deinstallation--kompletter-rückbau)
- [Hilfs-Werkzeuge](#hilfs-werkzeuge)
- [Problembehandlung](#problembehandlung)
- [Repository, Build & Release](#repository-build--release)
- [Lizenz](#lizenz)

---

## Schnellstart

1. Unter **[Releases](../../releases)** die Datei `Windows11-Herunterfahren-v1.0.0.zip`
   herunterladen und entpacken (Rechtsklick → „Alle extrahieren …“).
2. **`Installieren.cmd`** doppelklicken.
   Es erscheint **einmalig** der Windows-UAC-Dialog → **Ja**. Damit wird das Aufräumen mit
   Administratorrechten eingerichtet.
3. Fertig. Auf dem Desktop liegt jetzt **„Herunterfahren“** mit dem Power-Icon.
   **Doppelklick** darauf → Aufräumen + Herunterfahren.

Kein Setup-Programm, keine Installation im klassischen Sinn, **nichts wird in der Registry
verändert** (außer optional auf deinen Wunsch das Ausblenden von Desktop-Systemsymbolen).
Alles liegt in `%LOCALAPPDATA%\Herunterfahren` und ist mit einem Doppelklick wieder entfernbar.

> **Falls Windows die Datei blockiert** („Diese Datei stammt von einem anderen Computer“):
> Rechtsklick → **Eigenschaften** → unten **Zulassen** anklicken → OK.
> Oder im Ordner in PowerShell: `Get-ChildItem | Unblock-File`

---

## Was beim Klick passiert

**1. Aufräumen** – mit Administratorrechten, automatisch, ohne Nachfrage:

| Ordner / Bereich | Umfang |
|---|---|
| `%TEMP%` | angemeldeter Benutzer |
| `C:\Users\<jeder>\AppData\Local\Temp` | **alle** Benutzerprofile |
| `C:\Windows\Temp` | System-Temp |
| `…\AppData\Local\Microsoft\Windows\INetCache` | Internet-/Browsercache, alle Profile |
| `…\AppData\Local\Microsoft\Windows\WER` | Fehlerberichte, alle Profile |
| `…\AppData\Local\CrashDumps` | Absturz-Abbilder, alle Profile |
| `C:\ProgramData\Microsoft\Windows\WER` | Fehlerberichte, systemweit |
| `C:\Windows\SoftwareDistribution\Download` | Windows-Update-Downloads |
| Papierkorb | optional (Schalter `PAPIERKORB=1` in `Aufraeumen.cmd`) |

Dateien, die gerade **in Benutzung** sind, werden automatisch übersprungen.

**2. Herunterfahren:** `shutdown /s /t 0` – sauber und sofort, **ohne `/f`**.
Windows beendet also keine Programme zwangsweise; ungespeicherte Arbeit wird geschützt.

Bewusst **nicht** geleert: `C:\Windows\Prefetch` (beschleunigt den Systemstart), der
Downloadordner und alle persönlichen Dateien.

### Wie das ohne UAC funktioniert

`Installieren.cmd` legt einmalig die geplante Aufgabe **`Windows11-Herunterfahren`** an
(höchste Rechte, Ausführung nur bei angemeldetem Benutzer). Die Desktop-Verknüpfung startet
diese Aufgabe – Windows gewährt dabei die Rechte automatisch. Ansehen und jederzeit löschen
kannst du sie unter: Windowstaste → **Aufgabenplanung** → Aufgabenplanungsbibliothek.

Fehlt die Aufgabe (z. B. nach abgebrochenem UAC-Dialog), arbeitet `Herunterfahren.cmd`
ersatzweise ohne Adminrechte und weist im Fenster darauf hin. Nachholen:
`Aufgabe-anlegen.cmd` per Rechtsklick → **Als Administrator ausführen**.

---

## Sicherheit & Verhalten

- **Kein Zwangs-Beenden:** es wird nie `/f` verwendet. Blockiert ein Programm das Herunterfahren,
  bleibt Windows offen – du kannst reagieren.
- **Best effort beim Löschen:** gesperrte Dateien werden übersprungen, nie erzwungen.
- **Gelöscht ist gelöscht:** Temp-Dateien wandern nicht in den Papierkorb (der Papierkorb
  selbst ist standardmäßig ausgenommen).
- **Vorsicht bei laufenden Installationen:** Während ein Installer oder Windows-Update läuft,
  bitte nicht aufräumen lassen – manche Installer nutzen den Temp aktiv.
- **Schnellstart:** Bei aktivem Windows-Schnellstart wird der Kernel-Zustand gespeichert
  (schnellerer nächster Start). Für einen kompletten Frischstart einmal `shutdown /r /t 0`.
- **Nur Skripte:** alles ist reines Batch/PowerShell ohne Binärdateien – der Quelltext ist
  vollständig lesbar. Der Installer kann vor dem Ausführen mit dem Editor geöffnet werden.

---

## Dateien im Paket

| Datei | Zweck |
|---|---|
| `Installieren.cmd` | Ein-Klick-Installation: Skripte kopieren, Icon entpacken, Verknüpfung + geplante Aufgabe anlegen |
| `Herunterfahren.cmd` | Ziel der Desktop-Verknüpfung: startet die Admin-Aufgabe (Fallback: Benutzer-Temp) |
| `Aufraeumen.cmd` | läuft mit Adminrechten: alle Temp-Ordner + Herunterfahren |
| `Aufgabe-anlegen.cmd` | richtet die geplante Aufgabe ein bzw. repariert sie |
| `Herunterfahren-30-Sekunden.cmd` | 30 s Vorlaufzeit (abbrechbar), dann derselbe Ablauf |
| `Abbrechen.cmd` | bricht ein zeitgesteuertes Herunterfahren ab (`shutdown /a`) |
| `Deinstallieren.cmd` | kompletter Rückbau in 6 Schritten (Aufgabe, Verknüpfungen, Ordner, Caches, Explorer) |
| `Desktop-aufraeumen.cmd` | entfernt alle Desktop-Verknüpfungen außer „Herunterfahren“ – mit Sicherung |
| `Desktop-Wiederherstellen.cmd` | holt weggelegte Verknüpfungen zurück |
| `Desktop-Verknuepfung-anlegen.cmd` | legt die Desktop-Verknüpfung neu an (Reparatur) |
| `Icon-aktualisieren.cmd` | setzt die Icon-Zuweisung neu, leert den Icon-Cache |
| `herunterfahren.ico` | Icon in allen Windows-Größen (16–256 px) |
| `Icon-Vorschau.png` | Vorschau des Icons |
| `ANLEITUNG.md` / `LIESMICH-ZUERST.txt` | ausführliche bzw. kurze Anleitung |

---

## Deinstallation & kompletter Rückbau

`Deinstallieren.cmd` doppelklicken und mit **J** bestätigen. Es läuft in 6 Schritten:

| Schritt | Aktion |
|---|---|
| 1/6 | löscht die geplante Aufgabe `Windows11-Herunterfahren` (kurze UAC-Abfrage, falls nötig) |
| 2/6 | löscht **alle** Verknüpfungen (Desktop inkl. OneDrive-/Public-Desktop, angeheftete Taskleiste, Startmenü, Downloadordner) |
| 3/6 | löscht den Programmordner `%LOCALAPPDATA%\Herunterfahren` |
| 4/6 | löscht Temp-Reste des Pakets |
| 5/6 | löscht Windows-Icon- und Thumbnail-Cache |
| 6/6 | startet den Explorer neu → Anzeige frisch |

**Kompletter Neuaufbau in 2 Schritten:** `Deinstallieren.cmd` (J) → `Installieren.cmd`.

---

## Hilfs-Werkzeuge

- **`Desktop-aufraeumen.cmd`** – listet alle Desktop-Verknüpfungen, behält „Herunterfahren“ und
  bietet an, den Rest **in eine Sicherung zu verschieben** (`%USERPROFILE%\Desktop-Sicherung\DATUM`),
  endgültig zu löschen oder nichts zu tun. Optional lassen sich danach die Windows-Systemsymbole
  (Papierkorb, Dieser PC, Netzwerk, Benutzerdateien, Systemsteuerung) ausblenden.
  Es werden ausschließlich `*.lnk` / `*.url` angefasst – keine Dokumente, Ordner oder Dateien.
- **`Icon-aktualisieren.cmd`** – Windows merkt sich Symbole im Icon-Cache. Zeigt der Explorer
  nach einem Icon-Wechsel noch das alte Bild, hilft dieses Skript: es setzt die Icon-Zuweisung
  neu, leert den Cache und startet den Explorer neu.
- **`Desktop-Verknuepfung-anlegen.cmd`** – legt die Desktop-Verknüpfung neu an und meldet dabei,
  welche Desktop-Ordner Windows kennt (hilft u. a. bei OneDrive-umgeleiteten Desktops).

---

## Problembehandlung

<details>
<summary><strong>Die Verknüpfung erscheint nicht auf dem Desktop</strong></summary>

`Desktop-Verknuepfung-anlegen.cmd` ausführen – es prüft alle Desktop-Ordner, die Windows
kennt (Shell, .NET, `%USERPROFILE%\Desktop`, `C:\Users\Public\Desktop`, OneDrive) und meldet
den Fundort. Danach auf dem Desktop **F5** drücken und prüfen:
Rechtsklick → Ansicht → **„Desktopsymbole anzeigen“** muss aktiv sein.
</details>

<details>
<summary><strong>Es wird noch das alte Icon angezeigt</strong></summary>

`Icon-aktualisieren.cmd` starten und mit **J** den Explorer-Neustart samt Cache-Löschung
bestätigen. Alternative: Verknüpfung umbenennen (z. B. „Herunterfahren 2“) – das erzwingt
einen neuen Cache-Eintrag.
</details>

<details>
<summary><strong>Es öffnet sich kein Fenster / es räumt nur teilweise auf</strong></summary>

Dann fehlt die geplante Aufgabe. `Aufgabe-anlegen.cmd` per Rechtsklick → **Als Administrator
ausführen**. Prüfen mit: `schtasks /query /tn Windows11-Herunterfahren`
</details>

<details>
<summary><strong>Windows meldet „Diese Datei stammt von einem anderen Computer“</strong></summary>

Rechtsklick auf die Datei → **Eigenschaften** → **Zulassen** aktivieren → OK.
Oder im Ordner: `Get-ChildItem | Unblock-File`
</details>

---

## Repository, Build & Release

```
-Windows-11-shut-down/
├── Windows11-Herunterfahren/      ← Inhalt dieses Ordners wandert ins Release-ZIP
├── docs/                          ← Icon-Designs, Varianten, Release-Text, Setup-Anleitung
├── tools/validate.py              ← prüft Skripte + Icon (läuft auch in der CI)
└── .github/workflows/             ← Release-Automatik & Prüfung
```

**ZIP lokal bauen:** `tools/validate.py` ausführen, dann den Ordner
`Windows11-Herunterfahren` zippen (oder `bash tools/build-release.sh`).

**Release veröffentlichen:** einen Tag pushen, z. B. `git tag v1.0.0 && git push origin v1.0.0` –
die GitHub-Action `.github/workflows/release.yml` baut das ZIP und hängt es samt
Release-Notizen automatisch an den Release an.

Details zum Veröffentlichen: **`docs/GITHUB-SETUP.md`**
Fertiger Text für die Release-Seite: **`docs/RELEASE-TEXT-v1.0.0.md`**

---

## Lizenz

MIT – siehe [LICENSE](LICENSE).
