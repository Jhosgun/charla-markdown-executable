#!/usr/bin/env bash
# SessionStart: escanea los archivos de instrucciones al abrir la sesión.
# Imprime el resultado (Claude lo ve como contexto) y propaga el código del scan.
cd "${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
echo "SessionStart: escaneando instrucciones del repo…"
python3 ../../guardian/scan.py .
