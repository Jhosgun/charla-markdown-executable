#!/usr/bin/env bash
set -uo pipefail; cd "$(dirname "$0")/proyecto-auth"; pass=0
echo "[01] AGENTS.md envenenado:"
diff AGENTS.md.limpio AGENTS.md >/dev/null 2>&1 && { echo "FALLO: sin payload"; pass=1; } || echo "OK: payload = 1 bloque de diff"
python3 ../../../guardian/scan.py . >/dev/null 2>&1 && { echo "FALLO: scanner no detectó"; pass=1; } || echo "OK: scanner detecta inyección"
node --test >/dev/null 2>&1 && { echo "FALLO: el bug debería hacer fallar un test"; pass=1; } || echo "OK: el bug real hace fallar un test"
exit $pass
