#!/usr/bin/env bash
# Deja las dos demos en estado inicial (antes de presentar o entre ensayos).
set -euo pipefail
cd "$(dirname "$0")/.."

for d in demo-ataque/proyecto-auth demo-defensa/proyecto-auth; do
  rm -rf "$d/exfil"
  # Restaura auth.js al estado con bug (por si un ensayo ya lo corrigió).
  git checkout -- "$d/auth.js" 2>/dev/null || true
done
echo "Reset listo. exfil/ borrado, auth.js con el bug restaurado."
