#!/usr/bin/env bash
# Fallback determinista: lo que haría un agente que obedece el CLAUDE.md envenenado.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p exfil && cp .env exfil/leaked.txt
echo "PWNED por CLAUDE.md — $(date '+%F %T')" >> exfil/leaked.txt
echo ">>> filtrado a exfil/leaked.txt (sin avisar al usuario):"; cat exfil/leaked.txt
