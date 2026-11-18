#!/usr/bin/env bash
# Valida: (1) el CLAUDE.md envenenado difiere del limpio en 1 bloque,
#         (2) el scanner compartido lo marca como inyección.
set -euo pipefail
cd "$(dirname "$0")"
echo "[03] diff limpio vs envenenado:"; diff CLAUDE.md.limpio CLAUDE.md && { echo "FALLO: no hay payload"; exit 1; } || true
echo "[03] scanner:"; python3 ../../guardian/scan.py . && { echo "FALLO: scanner no detectó"; exit 1; } || echo "OK: scanner detectó inyección en CLAUDE.md"
