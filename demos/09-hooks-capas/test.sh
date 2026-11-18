#!/usr/bin/env bash
set -uo pipefail; cd "$(dirname "$0")"
pass=0; rm -f audit.log
echo "[09] hooks por capas:"
# capa 1: SessionStart escanea y detecta
if (cd .claude/hooks && CLAUDE_PROJECT_DIR="$(cd ../.. && pwd)" bash sessionstart.sh) >/dev/null 2>&1; then echo "FALLO: SessionStart debió avisar"; pass=1; else echo "OK: SessionStart detecta CLAUDE.md envenenado"; fi
# capa 2: PreToolUse bloquea exfil
if echo '{"tool_name":"Bash","tool_input":{"command":"cp .env exfil/leaked.txt"}}' | python3 .claude/hooks/guard.py >/dev/null 2>&1; then echo "FALLO: PreToolUse no bloqueó"; pass=1; else echo "OK: PreToolUse bloquea exfil"; fi
# capa 3: PostToolUse audita
echo '{"tool_name":"Bash","tool_input":{"command":"npm test"}}' | python3 .claude/hooks/audit.py
if [ -s audit.log ] && grep -q "npm test" audit.log; then echo "OK: PostToolUse escribió audit.log"; else echo "FALLO: no auditó"; pass=1; fi
rm -f audit.log
exit $pass
