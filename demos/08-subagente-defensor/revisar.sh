#!/usr/bin/env bash
# Stand-in determinista del subagente revisor (para la demo sin modelo en vivo).
# Agrega el escaneo de patrones + la revelación de contenido oculto.
set -uo pipefail
cd "$(dirname "$0")"
TARGET="${1:-../03-claude-md}"
echo "== Revisor de seguridad sobre: $TARGET =="
flag=0
python3 ../../guardian/scan.py "$TARGET" || flag=1
for f in "$TARGET"/CLAUDE.md "$TARGET"/AGENTS.md; do
  [ -f "$f" ] && { python3 ../04-inyeccion-invisible/reveal.py "$f" >/dev/null 2>&1 || { echo "⚠️  contenido oculto en $f"; flag=1; }; }
done
if [ "$flag" = 0 ]; then echo "VEREDICTO: APROBADO"; else echo "VEREDICTO: BLOQUEADO — no des permisos al agente."; fi
exit $flag
