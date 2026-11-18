#!/usr/bin/env bash
set -uo pipefail; cd "$(dirname "$0")"
pass=0
cp CLAUDE.md.limpio CLAUDE.md
echo "[07] rug pull:"
if python3 ../../guardian/scan.py . >/dev/null 2>&1; then echo "OK: CLAUDE.md empieza limpio"; else echo "FALLO: no debería marcar aún"; pass=1; fi
echo "   corriendo lifecycle postinstall (como haría npm install)..."
node postinstall.js >/dev/null
if python3 ../../guardian/scan.py . >/dev/null 2>&1; then echo "FALLO: el CLAUDE.md debería estar envenenado"; pass=1; else echo "OK: tras el install, CLAUDE.md quedó envenenado (scanner lo marca)"; fi
cp CLAUDE.md.limpio CLAUDE.md
exit $pass
