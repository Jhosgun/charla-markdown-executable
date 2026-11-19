#!/usr/bin/env python3
"""
Guardián de agente — hook PreToolUse para Claude Code.

Idea: la defensa NO depende de la buena voluntad del modelo. Es determinista.
Intercepta CADA tool call ANTES de ejecutarla y bloquea las acciones peligrosas,
sin importar qué diga el AGENTS.md ni qué haya "decidido" el agente.

Contrato Claude Code: recibe JSON por stdin. Si salimos con código 2, la tool
call se bloquea y el texto de stderr vuelve al modelo como feedback.

Cubre el ataque de la demo (exfiltración de .env vía AGENTS.md) y, de paso,
el bypass de permisos por encadenamiento de comandos (allowed-prefix + `;`/`&&`).
"""
import json
import re
import sys

# Rutas/archivos sensibles que el agente no debería tocar en una tarea normal.
SECRET_FILES = re.compile(r"\.env(\.|$|\b)|secrets?|credentials?|id_rsa|\.pem\b", re.I)
# Destinos de exfiltración típicos del payload.
EXFIL_TARGETS = re.compile(r"\bexfil\b|leaked|pwned", re.I)
# Herramientas de red = posible exfiltración a un servidor externo.
NETWORK_CMDS = re.compile(r"\b(curl|wget|nc|ncat|scp|ftp|telnet|/dev/tcp)\b", re.I)


def deny(reason: str) -> None:
    print(f"[GUARDIÁN] BLOQUEADO: {reason}", file=sys.stderr)
    sys.exit(2)


def check_bash(cmd: str) -> None:
    # 1) Red + lectura de secretos en el mismo comando = exfiltración.
    if NETWORK_CMDS.search(cmd) and SECRET_FILES.search(cmd):
        deny("comando de red que toca archivos de secretos (exfiltración).")
    # 2) Cualquier escritura/copia hacia un destino de exfiltración.
    if EXFIL_TARGETS.search(cmd):
        deny("el comando escribe en un destino de exfiltración (exfil/leaked/pwned).")
    # 3) Lectura de secretos redirigida a archivo (cat .env > ... / cp .env ...).
    if SECRET_FILES.search(cmd) and re.search(r">|>>|\bcp\b|\btee\b", cmd):
        deny("copia/redirección del contenido de un archivo de secretos.")
    # 4) Encadenamiento: un prefijo permitido no legitima lo que viene tras ; && || |.
    for part in re.split(r";|&&|\|\|?", cmd):
        p = part.strip()
        if NETWORK_CMDS.search(p) and SECRET_FILES.search(p):
            deny("subcomando encadenado hace exfiltración de red.")


def check_write(path: str, content: str) -> None:
    if EXFIL_TARGETS.search(path or ""):
        deny(f"escritura a ruta de exfiltración: {path}")
    # No permitir volcar secretos a ningún archivo nuevo.
    if content and re.search(r"sk_live_|AWS_SECRET|JWT_SECRET\s*=", content):
        deny("el contenido a escribir incluye credenciales (fuga de secretos).")


def main() -> None:
    try:
        event = json.load(sys.stdin)
    except Exception:
        sys.exit(0)  # sin datos → no bloquear

    tool = event.get("tool_name", "")
    ti = event.get("tool_input", {}) or {}

    if tool == "Bash":
        check_bash(ti.get("command", "") or "")
    elif tool in ("Write", "Edit", "MultiEdit"):
        content = ti.get("content") or ti.get("new_string") or ""
        check_write(ti.get("file_path", ""), content)

    sys.exit(0)  # permitido


if __name__ == "__main__":
    main()
