# Release-Text (zum Einfügen auf der GitHub-Release-Seite)

**Titel:** Windows 11 – Sauberes Herunterfahren v1.0.0
**Tag:** `v1.0.0`
**Anlage:** `Windows11-Herunterfahren-v1.0.0.zip`

---

## Text für die Release-Beschreibung

```markdown
## Ein Klick – sauberer PC

Doppelklick auf das Desktop-Icon **„Herunterfahren“** und Windows räumt automatisch auf
und fährt danach sauber herunter. **Ohne Nachfrage, ohne Zwangs-Beenden von Programmen.**

### Das steckt drin

- **Automatisches Aufräumen mit Administratorrechten** – über eine geplante Windows-Aufgabe,
  also ohne UAC-Dialog beim täglichen Benutzen:
  - `%TEMP%` des Benutzers
  - Temp-Ordner **aller** Benutzerprofile
  - `C:\Windows\Temp`
  - Internetcache (INetCache), Fehlerberichte (WER), CrashDumps – für alle Profile
  - Windows-Update-Downloads *(abschaltbar)*
  - Papierkorb *(optional, standardmäßig aus)*
- **Sauberes Herunterfahren** über `shutdown /s /t 0` – bewusst ohne `/f`, damit
  ungespeicherte Arbeit geschützt bleibt.
- **Eigenes Icon** im Windows-11-Look (dunkle Kachel, Metallring, Nachthimmel, Neon-Symbol)
  in allen Größen von 16 bis 256 px.
- **Hilfs-Werkzeuge**: 30-Sekunden-Variante mit Abbruchmöglichkeit, Abbrechen-Skript,
  Desktop-Aufräumer (behält nur „Herunterfahren“, mit Sicherung), Icon-Reparatur.
- **Kompletter Rückbau** mit einem Doppelklick – inklusive geplanter Aufgabe, Verknüpfungen,
  Icon-Cache und Explorer-Neustart.

### Installation

1. `Windows11-Herunterfahren-v1.0.0.zip` herunterladen und **entpacken**
2. **`Installieren.cmd`** doppelklicken → den einmaligen UAC-Dialog bestätigen
3. Auf dem Desktop liegt **„Herunterfahren“** – fertig

> Windows blockiert heruntergeladene Dateien manchmal: Rechtsklick auf die Datei →
> Eigenschaften → **Zulassen** → OK.

### Systemvoraussetzungen

- Windows 11 (Windows 10 funktioniert weitgehend, ist aber nicht getestet)
- keine Installation, keine Registry-Änderungen, nichts wird heruntergeladen
- alle Skripte sind reiner Quelltext (Batch/PowerShell) und vor dem Start prüfbar

### Vollständige Änderungen

Siehe [CHANGELOG.md](CHANGELOG.md).

---

**Erste Veröffentlichung.** Rückmeldungen, Ideen und Fehlerberichte sind willkommen –
am besten über die Issue-Vorlagen im Repository.
```

---

## Kurzfassung für „Was ist neu?“ (ein bis drei Zeilen)

```
Erste Version: Ein-Klick-Herunterfahren für Windows 11 mit automatischem Aufräumen
aller Temp- und Cache-Ordner (systemweit, mit Adminrechten) – ohne Zwangs-Beenden,
inklusive eigenem Icon, Hilfs-Werkzeugen und vollständigem Deinstallierer.
```

---

## Checkliste vor dem Veröffentlichen

- [ ] `tools/validate.py` läuft fehlerfrei durch
- [ ] Name in `LICENSE` passt (aktuell `AOWDGENESIS`)
- [x] Repo-Verweise zeigen auf `AOWDGENESIS/-Windows-11-shut-down`
- [ ] Testlauf auf einem echten Windows-11-System: installieren → klicken → deinstallieren
- [ ] ZIP-Datei angehängt und Dateiname enthält die Version
- [ ] Häkchen bei „Set as the latest release“
