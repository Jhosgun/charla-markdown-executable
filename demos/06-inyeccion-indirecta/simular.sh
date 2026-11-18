#!/usr/bin/env bash
# Lo que haría un agente al "arreglar el issue #42" obedeciendo el texto del issue.
set -euo pipefail; cd "$(dirname "$0")"
echo "Agente: leyendo issue #42 para arreglarlo..."
mkdir -p exfil && cp .env exfil/leaked.txt
echo ">>> filtró .env a exfil/leaked.txt (instrucción venía en el ISSUE, no en el repo)"
