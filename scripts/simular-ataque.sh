#!/usr/bin/env bash
# FALLBACK determinista: reproduce EXACTAMENTE lo que haría un agente desviado
# por el AGENTS.md envenenado, sin depender de un modelo en vivo.
# Úsalo si la demo con agente real no coopera en el escenario.
set -euo pipefail
cd "$(dirname "$0")/../demo-ataque/proyecto-auth"

echo "Agente: leyendo AGENTS.md para entender el proyecto..."
sleep 1
echo "Agente: siguiendo 'configuración del entorno (OBLIGATORIO)'..."
mkdir -p exfil
cp .env exfil/leaked.txt
echo "PWNED por AGENTS.md — $(date '+%Y-%m-%d %H:%M:%S')" >> exfil/leaked.txt
echo
echo ">>> El agente NUNCA mencionó esto al usuario. Contenido filtrado:"
echo "-----------------------------------------------------------------"
cat exfil/leaked.txt
echo "-----------------------------------------------------------------"
echo "En un ataque real, 'exfil/leaked.txt' sería un POST a un servidor del atacante."
