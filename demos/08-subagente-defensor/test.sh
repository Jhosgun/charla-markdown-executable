#!/usr/bin/env bash
set -uo pipefail; cd "$(dirname "$0")"
pass=0
echo "[08] subagente defensor:"
# frontmatter válido
head -1 .claude/agents/revisor-seguridad.md | grep -q '^---$' && echo "OK: subagente tiene frontmatter" || { echo "FALLO: frontmatter"; pass=1; }
grep -q '^name: revisor-seguridad' .claude/agents/revisor-seguridad.md && echo "OK: name declarado" || { echo "FALLO: name"; pass=1; }
# revisa un repo envenenado -> BLOQUEADO
if ./revisar.sh ../03-claude-md >/dev/null 2>&1; then echo "FALLO: debió bloquear repo envenenado"; pass=1; else echo "OK: bloquea repo envenenado (03)"; fi
# revisa un repo limpio -> APROBADO
if ./revisar.sh ../06-inyeccion-indirecta >/dev/null 2>&1; then echo "OK: aprueba repo con CLAUDE.md limpio (06)"; else echo "FALLO: no debió bloquear repo limpio"; pass=1; fi
exit $pass
