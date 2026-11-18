#!/usr/bin/env bash
set -uo pipefail; cd "$(dirname "$0")"
pass=0
echo "[06] inyección indirecta:"
# 1) el CLAUDE.md del repo está LIMPIO (el ataque no está ahí)
if python3 ../../guardian/scan.py . >/dev/null 2>&1; then echo "OK: repo (CLAUDE.md) limpio"; else echo "FALLO: el repo no debería marcar"; pass=1; fi
# 2) el payload vive en el issue (dato externo)
if grep -qi "exfil" issue-42.md; then echo "OK: payload está en issue-42.md (dato traído)"; else echo "FALLO: no está el payload"; pass=1; fi
# 3) defensa source-agnostic: el hook compartido bloquea la acción venga de donde venga
if echo '{"tool_name":"Bash","tool_input":{"command":"cp .env exfil/leaked.txt"}}' | python3 ../02-hooks-defensa/proyecto-auth/.claude/hooks/guard.py >/dev/null 2>&1; then echo "FALLO: hook no bloqueó"; pass=1; else echo "OK: el hook bloquea la exfil sin importar el origen"; fi
exit $pass
