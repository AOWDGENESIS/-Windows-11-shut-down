#!/usr/bin/env python3
"""Prüft das Windows-Paket auf formale Fehler.

Prüft:
  1. Alle .cmd-Dateien: reines ASCII, CRLF-Zeilenenden, Klammerbilanz im Code
  2. Icon: gültige .ico mit den erwarteten Größen; im Installer eingebettetes Icon
     muss byte-identisch zur Datei herunterfahren.ico sein
  3. Base64-Blöcke (eingebettetes Icon, PowerShell-Befehle) dekodierbar
  4. Pflichtdateien vorhanden

Aufruf:  python3 tools/validate.py
Exit-Code 0 = alles in Ordnung, 1 = Fehler gefunden.
"""
from __future__ import annotations

import base64
import hashlib
import io
import re
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:  # Pillow ist optional - Icon-Tiefenprüfung entfällt dann
    Image = None

ROOT = Path(__file__).resolve().parent.parent
PKG = ROOT / "Windows11-Herunterfahren"

PFLICHTDATEIEN = [
    "Installieren.cmd",
    "Herunterfahren.cmd",
    "Aufraeumen.cmd",
    "Aufgabe-anlegen.cmd",
    "Herunterfahren-30-Sekunden.cmd",
    "Abbrechen.cmd",
    "Deinstallieren.cmd",
    "Desktop-aufraeumen.cmd",
    "Desktop-Wiederherstellen.cmd",
    "Desktop-Verknuepfung-anlegen.cmd",
    "Icon-aktualisieren.cmd",
    "herunterfahren.ico",
    "ANLEITUNG.md",
    "LIESMICH-ZUERST.txt",
]

ERWARTETE_ICON_GROESSEN = {(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)}

fehler: list[str] = []
hinweise: list[str] = []


def pruefe_ascii_crlf(pfad: Path) -> None:
    roh = pfad.read_bytes()
    nicht_ascii = [(i, b) for i, b in enumerate(roh) if b > 127]
    if nicht_ascii:
        fehler.append(f"{pfad.name}: {len(nicht_ascii)} Nicht-ASCII-Bytes (z. B. Offset {nicht_ascii[0][0]})")
    if roh.count(b"\n") != roh.count(b"\r\n"):
        fehler.append(f"{pfad.name}: gemischte Zeilenenden (LF ohne CR gefunden)")
    if not roh.startswith(b"@echo off"):
        hinweise.append(f"{pfad.name}: beginnt nicht mit '@echo off'")


def pruefe_klammern(pfad: Path) -> None:
    """Klammerbilanz außerhalb von Kommentaren/Anzeigen (grobe Strukturprüfung)."""
    text = pfad.read_text(encoding="ascii", newline="")
    tiefe = 0
    for nr, zeile in enumerate(text.split("\r\n"), 1):
        s = zeile.strip()
        if not s or s.startswith(":") or s.lower().startswith(("rem", "::", "echo", "title")):
            continue
        tiefe += zeile.count("(") - zeile.count(")")
        if tiefe < 0:
            fehler.append(f"{pfad.name}: Klammer schließt in Zeile {nr} ohne Öffnung")
            tiefe = 0
    if tiefe != 0:
        fehler.append(f"{pfad.name}: unbalancierte Klammern ({tiefe:+d})")


def pruefe_base64_bloecke(pfad: Path) -> None:
    """Dekodiert den eingebetteten PowerShell-Block (UTF-16LE-Base64) oder das Icon."""
    text = pfad.read_text(encoding="ascii", newline="")
    for nr, block in enumerate(re.findall(r"-EncodedCommand ([A-Za-z0-9+/=]+)", text), 1):
        try:
            inhalt = base64.b64decode(block).decode("utf-16-le")
        except Exception as exc:  # noqa: BLE001
            fehler.append(f"{pfad.name}: PowerShell-Block {nr} nicht dekodierbar ({exc})")
            continue
        if not inhalt.startswith("$"):
            fehler.append(f"{pfad.name}: PowerShell-Block {nr} sieht nicht wie PowerShell aus")
        if len(block) > 7000:
            fehler.append(f"{pfad.name}: PowerShell-Block {nr} zu lang für eine Kommandozeile (>{len(block)})")


def pruefe_icon() -> None:
    ico = PKG / "herunterfahren.ico"
    roh = ico.read_bytes()
    if not roh.startswith(b"\x00\x00\x01\x00"):
        fehler.append("herunterfahren.ico: keine gültige ICO-Datei")
    if Image is not None:
        bild = Image.open(io.BytesIO(roh))
        groessen = set(bild.info.get("sizes", set()))
        if not ERWARTETE_ICON_GROESSEN.issubset(groessen):
            fehler.append(f"herunterfahren.ico: Größen {sorted(groessen)} – erwartet mind. {sorted(ERWARTETE_ICON_GROESSEN)}")
    else:
        hinweise.append("Pillow nicht installiert – Icon-Größen werden nicht geprüft")

    # im Installer eingebettetes Icon vergleichen
    text = (PKG / "Installieren.cmd").read_text(encoding="ascii", newline="")
    treffer = re.search(r'> "%B64FILE%" \(\r?\n(.*?)\r?\n\)', text, re.S)
    if not treffer:
        fehler.append("Installieren.cmd: eingebetteter Icon-Block nicht gefunden")
        return
    b64 = "".join(zeile[5:] for zeile in treffer.group(1).split("\r\n"))
    eingebettet = base64.b64decode(b64)
    if eingebettet != roh:
        fehler.append(
            "Installieren.cmd: eingebettetes Icon weicht von herunterfahren.ico ab "
            f"(SHA-256 eingebettet {hashlib.sha256(eingebettet).hexdigest()[:12]}, "
            f"Datei {hashlib.sha256(roh).hexdigest()[:12]})"
        )


def pruefe_abhaengigkeiten() -> None:
    """Verknüpfungen zwischen den Skripten: kopiert Installieren.cmd alles Benötigte?"""
    text = (PKG / "Installieren.cmd").read_text(encoding="ascii", newline="")
    kopiert = set(re.findall(r'copy /y "%QUELLE%([^"]+)"', text))
    erwartet = {f.name for f in PKG.glob("*.cmd")} - {"Installieren.cmd"}
    fehlend = erwartet - kopiert
    if fehlend:
        fehler.append(f"Installieren.cmd: kopiert nicht alle Skripte: {sorted(fehlend)}")
    if "Aufraeumen.cmd" not in kopiert:
        fehler.append("Installieren.cmd: Aufraeumen.cmd fehlt (geplante Aufgabe braucht sie)")
    if "schtasks /query /tn Windows11-Herunterfahren" not in text:
        fehler.append("Installieren.cmd: prüft die geplante Aufgabe nicht")


def main() -> int:
    if not PKG.is_dir():
        print(f"FEHLER: Paketordner nicht gefunden: {PKG}")
        return 1

    for name in PFLICHTDATEIEN:
        if not (PKG / name).exists():
            fehler.append(f"Pflichtdatei fehlt: {name}")

    for datei in sorted(PKG.glob("*.cmd")):
        pruefe_ascii_crlf(datei)
        pruefe_klammern(datei)
        pruefe_base64_bloecke(datei)

    if (PKG / "herunterfahren.ico").exists():
        pruefe_icon()
    if (PKG / "Installieren.cmd").exists():
        pruefe_abhaengigkeiten()

    print("=" * 62)
    print(" Prüfung des Windows-11-Pakets")
    print("=" * 62)
    print(f" Paketordner : {PKG}")
    print(f" .cmd-Dateien: {len(list(PKG.glob('*.cmd')))}")
    print("-" * 62)

    for h in hinweise:
        print(f" HINWEIS  {h}")
    for f in fehler:
        print(f" FEHLER   {f}")

    print("-" * 62)
    if fehler:
        print(f" ERGEBNIS: {len(fehler)} Fehler gefunden.")
        return 1
    print(f" ERGEBNIS: OK – keine Fehler ({len(hinweise)} Hinweise).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
