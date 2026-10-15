#!/usr/bin/env bash
# Baut das Release-ZIP aus dem Paketordner.
#
#   bash tools/build-release.sh            -> Version aus CHANGELOG (oberste Version)
#   bash tools/build-release.sh v1.2.0     -> explizite Version
#
# Ergebnis: release/Windows11-Herunterfahren-<version>.zip
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAKET="Windows11-Herunterfahren"
VERSION="${1:-}"

if [[ -z "$VERSION" ]]; then
  VERSION="$(grep -m1 -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$REPO_DIR/CHANGELOG.md" \
             | tr -d '[] \n' | sed 's/^/v/')"
fi
[[ -n "$VERSION" ]] || { echo "Version nicht ermittelbar – bitte als Argument angeben"; exit 1; }

mkdir -p "$REPO_DIR/release"
ZIEL="$REPO_DIR/release/${PAKET}-${VERSION}.zip"
rm -f "$ZIEL"

echo "==> Prüfe Paket ..."
python3 "$REPO_DIR/tools/validate.py"

echo "==> Baue ZIP für $VERSION ..."
( cd "$REPO_DIR" && zip -r -9 "$ZIEL" "$PAKET" -x "*.DS_Store" ) >/dev/null

echo "==> Fertig: release/${PAKET}-${VERSION}.zip ($(du -h "$ZIEL" | cut -f1))"
