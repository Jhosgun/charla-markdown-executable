#!/usr/bin/env bash
# Valida la skill auditor-inyeccion contra el repo sospechoso.
set -uo pipefail; cd "$(dirname "$0")"
S="../../.claude/skills/auditor-inyeccion"
pass=0
echo "[11] skill auditor-inyeccion:"
if python3 "$S/scan.py" repo-sospechoso >/dev/null 2>&1; then echo "FALLO: scan no detectó"; pass=1; else echo "OK: scan.py detectó inyección en AGENTS.md"; fi
if python3 "$S/reveal.py" repo-sospechoso/CONTRIBUTING.md >/dev/null 2>&1; then echo "FALLO: reveal no detectó oculto"; pass=1; else echo "OK: reveal.py expuso inyección OCULTA en CONTRIBUTING.md"; fi
exit $pass
