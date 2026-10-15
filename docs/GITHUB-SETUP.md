# Veröffentlichen auf GitHub – dein Repo ist schon da

**Dein Repository:** https://github.com/AOWDGENESIS/-Windows-11-shut-down

Aktuell steht dort nur das leere Start-README. Alles Weitere (fertiges README, Lizenz,
Changelog, GitHub-Actions, Issue-Vorlagen, Prüfskript, das komplette Windows-Paket)
liegt hier vorbereitet vor und muss nur noch hochgeladen werden.

> **Kleiner Hinweis zum Repo-Namen:** Der Name beginnt mit einem Bindestrich
> (`-Windows-11-shut-down`). Das ist auf GitHub erlaubt und funktioniert, ist aber
> ungewöhnlich – falls du es magst, alles gut. Eine Umbenennung geht jederzeit unter
> *Settings → Repository name* und würde die Links hier automatisch mitziehen.

---

## Weg A – GitHub Desktop (empfohlen, geht mit allen Dateien)

So kommst du auch problemlos an den Ordner `.github` (die Actions) ins Repo.

1. **GitHub Desktop** installieren: https://desktop.github.com → mit deinem
   GitHub-Konto anmelden.
2. **Repository klonen:** File → *Clone repository…* → `AOWDGENESIS/-Windows-11-shut-down`
   → *Clone*. Merke dir den Zielordner (z. B. `Dokumente\GitHub\-Windows-11-shut-down`).
3. Das **Upload-Paket** (`AOWDGENESIS-Windows-11-shut-down-UPLOAD.zip`) entpacken und
   den Ordner **`Repository-Inhalt`** öffnen.
4. **Alle Dateien und Ordner** aus `Repository-Inhalt` in den geklonten Repo-Ordner ziehen
   (ersetzt das leere README.md).
5. In GitHub Desktop: oben „12 changes“ (o. Ä.) → rechts kurz prüfen →
   unten „Commit to **main**“ klicken.
6. Oben **Push origin** klicken → fertig. Das Repo zeigt jetzt alles.

---

## Weg B – Browser-Upload (ohne Programme)

Der Web-Upload von GitHub kann versteckte Ordner wie `.github` **nicht** per Drag & Drop
annehmen. Der Rest geht:

1. Auf https://github.com/AOWDGENESIS/-Windows-11-shut-down → **Add file → Upload files**.
2. Aus `Repository-Inhalt` alles **außer dem Ordner `.github`** hineinziehen
   (`README.md` überschreibt das leere Standard-README – gewünscht).
3. *Commit changes* → direkt im `main`-Branch.
4. **Die 4 Action-/Vorlagedateien einzeln anlegen:** *Add file → Create new file*,
   jeweils Pfad + Inhalt aus `Repository-Inhalt\.github\...` kopieren:
   - `.github/workflows/validate.yml`
   - `.github/workflows/release.yml`
   - `.github/ISSUE_TEMPLATE/bug_report.yml`
   - `.github/ISSUE_TEMPLATE/config.yml`

Ohne Schritt 4 läuft das Projekt trotzdem – nur die automatische Prüfung und das
automatische Release-Paket fehlen.

---

## Weg C – Kommandozeile (Git)

```bash
git clone https://github.com/AOWDGENESIS/-Windows-11-shut-down.git
cd -Windows-11-shut-down
# Inhalt aus "Repository-Inhalt" hier hineinkopieren, dann:
git add .
git commit -m "Windows 11 sauberes Herunterfahren v1.0.0"
git push
```

*(Hinweis: Der Repo-Name beginnt mit `-` – beim `cd` in Anführungszeichen setzen:
`cd "-Windows-11-shut-down"`.)*

---

## Danach: Release v1.0.0 veröffentlichen

Der schnellste Weg – ganz ohne Kommandozeile:

1. Lokal (oder direkt aus dem Upload-Paket) die fertige Release-Datei
   **`Windows11-Herunterfahren-v1.0.0.zip`** bereithalten
   (sie liegt auch unter `release/` im vorbereiteten Ordner).
2. Auf https://github.com/AOWDGENESIS/-Windows-11-shut-down/releases →
   **Draft a new release**.
3. **Choose a tag** → `v1.0.0` eintippen → *Create new tag: v1.0.0*.
4. Titel: `Windows 11 – Sauberes Herunterfahren v1.0.0`
5. Beschreibung: Text aus **`docs/RELEASE-TEXT-v1.0.0.md`** kopieren
   (Block „Text für die Release-Beschreibung“).
6. **Attach binaries**: `Windows11-Herunterfahren-v1.0.0.zip` hochladen.
7. **Publish release** → fertig. Der Download-Link steht jetzt im README
   (Releases-Abschnitt).

**Variante mit automatischer Action** (nach Weg A oder C, wenn `.github` im Repo ist):

```bash
git tag v1.0.0
git push origin v1.0.0
```

Die Action „Release“ baut das ZIP selbst und hängt es an – manuelles Hochladen entfällt.

---

## Optional: Repo-Auftritt polieren

| Was | Wo |
|---|---|
| Beschreibung (steht schon gut da) | Settings → General → About → z. B. `Windows 11 shut down mit Desktop Icon – räumt alle Temp-Ordner auf und fährt sauber herunter` |
| Themen setzen | About → Zahnrad: `windows-11`, `shutdown`, `batch`, `powershell`, `cleanup`, `desktop-shortcut` |
| Social Preview | Settings → Social preview → das Icon `docs/icon-vorschau.png` hochladen |
| Sichtbarkeit | bleibt am besten **Public** – dann kann jeder die Skripte vor dem Benutzen prüfen |

---

## Checkliste

- [ ] Inhalt von `Repository-Inhalt` ist im Repo (README zeigt das Projekt, nicht mehr „-Windows-11-shut-down“ allein)
- [ ] `.github/` liegt im Repo (Actions sichtbar unter „Actions“)
- [ ] Actions-Reiter zeigt „Prüfung“ als grün
- [ ] Release `v1.0.0` mit `Windows11-Herunterfahren-v1.0.0.zip` veröffentlicht
- [ ] Test: ZIP von der Release-Seite laden → `Installieren.cmd` → Desktop-Icon da

---

## Was die Actions konkret tun

| Workflow | Auslöser | Aufgabe |
|---|---|---|
| `validate.yml` | jeder Push / PR | führt `tools/validate.py` aus: ASCII, CRLF, Klammerbilanz, PowerShell-Blöcke, Icon-Kette, Installer-Vollständigkeit |
| `release.yml` | Tag `v*` | prüft, baut `release/Windows11-Herunterfahren-<tag>.zip`, veröffentlicht den Release mit Notizen |
