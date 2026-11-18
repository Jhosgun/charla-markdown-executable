#!/usr/bin/env bash
# Valida: (1) grep ingenuo NO encuentra el payload (evasión funciona),
#         (2) reveal.py SÍ expone el contenido oculto.
set -uo pipefail
cd "$(dirname "$0")"
echo "[04] grep ingenuo 'exfil':"
if grep -qi "exfil" CLAUDE.md; then echo "FALLO: grep lo encontró (no hubo evasión)"; exit 1; else echo "OK: invisible para grep"; fi
echo "[04] reveal.py:"
if python3 reveal.py CLAUDE.md; then echo "FALLO: reveal no detectó"; exit 1; else echo "OK: reveal expuso lo oculto"; fi
