# Windows 11 – sauberes Herunterfahren mit Desktop-Icon

Ein Klick auf das Desktop-Icon → **Temp- und Cache-Ordner werden aufgeräumt** → **Windows fährt
sauber herunter**. Keine Ja/Nein-Abfrage, kein Zwangs-Beenden von Programmen.

---

## Schnellstart

1. Ordner **`Windows11-Herunterfahren`** entpacken und ablegen.
2. **`Installieren.cmd`** doppelklicken → dort erscheint **einmalig der Windows-UAC-Dialog**
   („Möchten Sie zulassen, dass …“) → **Ja**. Damit wird das automatische Aufräumen mit
   Administratorrechten eingerichtet.
3. Auf dem Desktop liegt jetzt **„Herunterfahren“** mit dem Power-Icon.
   Doppelklick darauf → Aufräumen (mit Adminrechten, **ohne** weitere Nachfrage) +
   Herunterfahren.

Was `Installieren.cmd` macht:

| Schritt | Aktion |
|---|---|
| 1/4 | kopiert die Skripte nach `%LOCALAPPDATA%\Herunterfahren` |
| 2/4 | **entpackt das Icon – es ist direkt in der Datei eingebettet** (Base64) |
| 3/4 | legt die Desktop-Verknüpfung an (prüft alle Desktop-Ordner, die Windows kennt) und weist das Icon zu |
| 4/4 | richtet die **geplante Aufgabe „Windows11-Herunterfahren“** ein (höchste Rechte, interaktiv) – dafür die einmalige UAC-Bestätigung |

Nichts wird „installiert“ im klassischen Sinn und nichts an der Registry geändert. Die geplante
Aufgabe lässt sich jederzeit ansehen unter: Windowstaste → **Aufgabenplanung** →
Aufgabenplanungsbibliothek. Wird die UAC-Abfrage in Schritt 4 abgebrochen, funktioniert
„Herunterfahren“ trotzdem – dann aber ohne die Admin-Ordner. Nachholen:
Rechtsklick auf `%LOCALAPPDATA%\Herunterfahren\Aufgabe-anlegen.cmd` → **Als Administrator ausführen**.

---

## Was beim Klick passiert – automatisch, mit Adminrechten

Der Klick auf die Desktop-Verknüpfung startet die geplante Aufgabe
`Windows11-Herunterfahren`. Sie läuft mit **höchsten Rechten** – also ohne UAC-Abfrage und ohne
Rechtsklick „Als Administrator ausführen“. Aufgeräumt wird dann:

| Ordner / Bereich | Umfang | Rechte |
|---|---|---|
| `%TEMP%` | angemeldeter Benutzer | automatisch |
| `C:\Users\<jeder>\AppData\Local\Temp` | **alle** Benutzerprofile | automatisch |
| `C:\Windows\Temp` | System-Temp | automatisch |
| `…\AppData\Local\Microsoft\Windows\INetCache` | Internet-/Browsercache, alle Profile | automatisch |
| `…\AppData\Local\Microsoft\Windows\WER` | Fehlerberichte, alle Profile | automatisch |
| `…\AppData\Local\CrashDumps` | Absturz-Abbilder, alle Profile | automatisch |
| `C:\ProgramData\Microsoft\Windows\WER` | Fehlerberichte, systemweit | automatisch |
| `C:\Windows\SoftwareDistribution\Download` | Windows-Update-Downloads | automatisch |
| Papierkorb | optional, Schalter `PAPIERKORB=1` in `Aufraeumen.cmd` | automatisch |

**2. Herunterfahren:** `shutdown /s /t 0` → sofort und sauber, **ohne `/f`**.
Bewusst **nicht** geleert: `C:\Windows\Prefetch` (beschleunigt den Systemstart) und der
Papierkorb (Standard aus – er ist kein Temp-Ordner).

Wichtig zu wissen:

- **Dateien in Benutzung werden übersprungen** – Programme werden dadurch nicht beschädigt.
- **Gelöscht ist gelöscht** – Temp-Dateien wandern nicht in den Papierkorb.
- **Ungespeicherte Arbeit ist geschützt:** ohne `/f` melden sich Programme selbst bzw. Windows
  fragt nach.
- Während ein **Installer/Windows-Update läuft**, besser nicht aufräumen lassen.
- Bei aktivem Windows-**Schnellstart** wird der Kernel-Zustand gespeichert (schnellerer
  nächster Start). Für einen kompletten Frischstart einmal `shutdown /r /t 0`.

### Wenn die geplante Aufgabe fehlt

Dann (z. B. nach einem abgebrochenen UAC-Dialog) arbeitet `Herunterfahren.cmd` ersatzweise ohne
Adminrechte: es leert nur `%TEMP%`, INetCache, WER und CrashDumps des angemeldeten Benutzers
und fährt dann herunter. Es weist im Fenster darauf hin.

**Nachholen/reparieren:** Rechtsklick auf `%LOCALAPPDATA%\Herunterfahren\Aufgabe-anlegen.cmd`
→ **Als Administrator ausführen**. Oder den aktualisierten `Installieren.cmd` erneut starten.

---

## Einstellungen

Diese Schalter stehen oben in **`Aufraeumen.cmd`** (dem Skript, das die Aufgabe mit
Adminrechten startet):

```bat
set "UPDATE_CACHE=1"     :: Windows-Update-Downloads leeren
set "PAPIERKORB=0"       :: Papierkorb leeren (kein Temp-Ordner - Standard aus)
```

`Herunterfahren.cmd` (die Desktop-Verknüpfung) hat nur den Fallback-Ablauf, falls die
geplante Aufgabe fehlt – dort ist nichts einzustellen.

Zusätzliche Ordner lassen sich in `Aufraeumen.cmd` mit einer Zeile ergänzen, z. B.:
```bat
call :leer "%SystemRoot%\Logs\CBS"
```

---

## Dateien im Paket

| Datei | Zweck |
|---|---|
| `Herunterfahren.cmd` | Ziel der Desktop-Verknüpfung: startet die Admin-Aufgabe (Fallback: Benutzer-Temp) |
| `Aufraeumen.cmd` | **läuft automatisch mit Adminrechten:** alle Temp-Ordner + Herunterfahren |
| `Aufgabe-anlegen.cmd` | richtet die geplante Aufgabe ein bzw. repariert sie |
| `Herunterfahren-30-Sekunden.cmd` | 30 s Vorlauf (abbrechbar), dann derselbe Ablauf |
| `Abbrechen.cmd` | bricht ein laufendes, zeitgesteuertes Herunterfahren ab (`shutdown /a`) |
| `Installieren.cmd` | Ein-Klick-Installation inkl. eingebettetem Icon |
| `Deinstallieren.cmd` | kompletter Rückbau (siehe unten) |
| `Desktop-Verknüpfung-anlegen.cmd` | legt die Desktop-Verknüpfung neu an (Reparatur-Helfer) |
| `Icon-aktualisieren.cmd` | setzt die Icon-Zuweisung neu und baut den Icon-Cache auf |
| `Desktop-aufraeumen.cmd` | entfernt alle Desktop-Verknüpfungen außer „Herunterfahren“ – mit Sicherung |
| `Desktop-Wiederherstellen.cmd` | holt die weggelegten Verknüpfungen zurück |
| `herunterfahren.ico` | Icon in allen Windows-Größen (16–256 px) |
| `Icon-Vorschau.png` | Vorschau des Icons |
| `LIESMICH-ZUERST.txt` | Kurz-Anleitung für den ersten Start |
| *(Design-Übersicht, Varianten und Quelldatei)* | im Projektordner unter `docs/` |

---

## Deinstallieren im Detail (kompletter Rückbau)

`Deinstallieren.cmd` zeigt die Fundstellen und fragt einmal nach (J/N, 30 s → Nein).
Danach läuft der Rückbau in fünf Schritten:

| Schritt | Aktion |
|---|---|
| 1/6 | löscht die geplante Aufgabe `Windows11-Herunterfahren` (kurze UAC-Abfrage, falls nötig) |
| 2/6 | löscht **alle** Verknüpfungen: Desktop (inkl. OneDrive- und Public-Desktop), angeheftete Taskleiste, Startmenü, Download-Ordner, Profilordner |
| 3/6 | löscht den Programmordner `%LOCALAPPDATA%\Herunterfahren` |
| 4/6 | löscht Temp-Reste des Pakets (`hf_*`) |
| 5/6 | löscht Windows-Icon- und Thumbnail-Cache (`IconCache.db`, `iconcache*.db`, `thumbcache*.db`) |
| 6/6 | startet den Explorer neu → Anzeige wird frisch aufgebaut |

**Kompletter Neuaufbau in 2 Schritten:** `Deinstallieren.cmd` (J drücken) → `Installieren.cmd`.
Danach sind Skripte, Icon-Datei, Verknüpfung und Icon-Cache komplett frisch.

Tipp: Rechtsklick auf die Verknüpfung → **An Taskleiste anheften** bzw.
**An „Start“ anheften** – beim Deinstallieren entfernt das Skript diese Anheftungen
automatisch mit (als Dateien).

---

## Desktop aufräumen (nur „Herunterfahren“ behalten)

`Desktop-aufraeumen.cmd` listet zuerst alle Verknüpfungen des Desktops auf und lässt dir
die Wahl:

| Taste | Wirkung |
|---|---|
| **V** | alles außer „Herunterfahren“ in den Sicherungsordner verschieben (empfohlen) |
| **L** | endgültig löschen (mit zusätzlicher Sicherheitsabfrage) |
| **N** | nichts tun (Standard nach 30 s) |

**Sicherung:** `%USERPROFILE%\Desktop-Sicherung\JJJJ-MM-TT_HH-MM` –
mit `Desktop-Wiederherstellen.cmd` holst du alles zurück (nimmt automatisch den neuesten Stand).

Wichtig:

- Es werden **ausschließlich Verknüpfungen** (`*.lnk`, `*.url`) angefasst – Dokumente,
  Ordner und eigene Dateien bleiben unberührt.
- Behalten wird jede Verknüpfung, deren Name mit **„Herunterfahren“** beginnt – also auch
  eine eventuelle „Herunterfahren 2.lnk“.
- Geprüft werden alle Desktop-Ordner, die Windows kennt (auch OneDrive- und
  `C:\Users\Public\Desktop`). Verknüpfungen im öffentlichen Desktop brauchen Adminrechte –
  scheitert das Verschieben, bleibt die Verknüpfung stehen und wird gemeldet.
- Am Ende fragt das Skript optional, ob auch die **Windows-Systemsymbole** (Papierkorb,
  Dieser PC, Netzwerk, Benutzerdateien, Systemsteuerung) ausgeblendet werden sollen.
  Rückgängig: Einstellungen → Personalisierung → Designs → **Desktopsymboleinstellungen**.
- Danach wird der Explorer kurz neu gestartet, damit die Anzeige sofort passt.

---

## Wenn Windows noch das alte Icon zeichnet

Windows speichert Symbole im Icon-Cache. Wird eine Icon-Datei inhaltlich ausgetauscht, zeigt
der Explorer manchmal weiter das alte Symbol – das ist reine Anzeige, die Datei selbst ist
korrekt.

**Schnellster Weg:** `Icon-aktualisieren.cmd` doppelklicken. Das Skript zeigt den Ist-Zustand,
setzt die Icon-Zuweisung neu und fragt, ob Explorer-Neustart + Cache-Löschung erfolgen soll.

**Alternative ohne Skript:** Verknüpfung umbenennen (z. B. „Herunterfahren 2“) – das erzwingt
einen neuen Cache-Eintrag.

---

## Wenn die Verknüpfung nicht auf dem Desktop erscheint

Der Installer gibt aus, **welche Desktop-Ordner Windows meldet** und wo er die Verknüpfung
angelegt hat – er prüft dabei alle Quellen:

| Quelle | Beispiel |
|---|---|
| Shell-Abfrage (`SpecialFolders`) | `C:\Users\Name\OneDrive\Desktop` |
| .NET `GetFolderPath('Desktop')` / `('DesktopDirectory')` | `C:\Users\Name\Desktop` |
| Profilordner | `%USERPROFILE%\Desktop` |
| Öffentlicher Desktop | `C:\Users\Public\Desktop` |
| OneDrive-Variablen | `%OneDrive%\Desktop` usw. |

**Reparatur in einem Schritt:** `Desktop-Verknüpfung-anlegen.cmd` doppelklicken.
Danach ggf. auf dem Desktop **F5** drücken und prüfen, dass Rechtsklick → Ansicht →
**„Desktopsymbole anzeigen“** aktiv ist.

---

## Manuell einrichten (Alternative ohne Installer)

1. Rechtsklick Desktop → **Neu → Verknüpfung**.
2. Als Speicherort: `%LOCALAPPDATA%\Herunterfahren\Herunterfahren.cmd` → Weiter →
   Name: `Herunterfahren` → Fertig.
3. **Icon:** Rechtsklick → Eigenschaften → Anderes Symbol → `herunterfahren.ico` auswählen.
4. Optional: **Erweitert …** → „Als Administrator ausführen“ (für die Admin-Ordner).

---

## Nützliche Befehle zum Testen

| Aktion | Befehl |
|---|---|
| Herunterfahren sofort | `shutdown /s /t 0` |
| Herunterfahren in 1 Stunde | `shutdown /s /t 3600` |
| Neu starten | `shutdown /r /t 0` |
| Ruhezustand | `shutdown /h` |
| Abbrechen (nur bei Wartezeit > 0) | `shutdown /a` |

---

## Repository & Updates

Dieses Paket wird im GitHub-Repository **`AOWDGENESIS/-Windows-11-shut-down`** gepflegt.
Neue Versionen erscheinen dort unter **Releases**; im Repository selbst liegen zusätzlich
unter `docs/` die Design-Vorlagen des Icons und die Prüfwerkzeuge unter `tools/`.

---

## Falls Windows die Datei blockiert

Rechtsklick auf die Datei → **Eigenschaften** → unten **Zulassen** aktivieren → OK.
(Oder in PowerShell im Ordner: `Get-ChildItem | Unblock-File`.)
