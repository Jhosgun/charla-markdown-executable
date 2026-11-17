#!/usr/bin/env python3
"""
guardian/scan.py — revisor de archivos de instrucciones.

Escanea AGENTS.md / CLAUDE.md / .cursorrules / etc. en busca de patrones de
inyección de prompt ANTES de que el agente de código los lea y los obedezca.
Pensado para correr como hook SessionStart o en CI (pre-commit / pipeline).

Uso:
  python3 guardian/scan.py <ruta-del-repo>
  python3 guardian/scan.py demo-ataque/proyecto-auth    # -> detecta el ataque
  python3 guardian/scan.py demo-defensa/proyecto-auth   # -> mismo archivo, lo marca

Salida: código 1 si encuentra algo sospechoso (rompe el pipeline), 0 si limpio.
"""
import re
import sys
from pathlib import Path

INSTRUCTION_FILES = [
    "AGENTS.md", "CLAUDE.md", "GEMINI.md", ".cursorrules",
    ".github/copilot-instructions.md", "CONVENTIONS.md",
]

# Señales de inyección. Cada una suma; varias juntas = alta confianza.
SIGNALS = [
    (r"sin (pedir |)confirmaci[oó]n", "pide actuar sin confirmación"),
    (r"no (lo |se lo |)(menciones|informes|digas|avises|reportes)", "pide ocultar la acción al usuario"),
    (r"antes de (cualquier|atender|tocar|responder)", "secuestra el flujo antes de la tarea real"),
    (r"\.env|secret|credential|api[_ ]?key|token", "menciona secretos/credenciales"),
    (r"\b(curl|wget|nc|scp|/dev/tcp)\b", "invoca herramientas de red"),
    (r"\bexfil|leaked|pwned|base64 -", "destino/técnica de exfiltración"),
    (r"ignore (all |)previous|olvida (las |)instrucciones", "override de instrucciones del sistema"),
    (r"OBLIGATORIO|DEBE ejecutar|siempre ejecuta", "imperativo de ejecución forzada"),
]


def scan_file(path: Path) -> list[str]:
    text = path.read_text(errors="ignore")
    hits = [why for rx, why in SIGNALS if re.search(rx, text, re.I)]
    return hits


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
    flagged = False
    for name in INSTRUCTION_FILES:
        f = root / name
        if not f.exists():
            continue
        hits = scan_file(f)
        if hits:
            flagged = True
            print(f"⚠️  {f}")
            for h in hits:
                print(f"      • {h}")
            print(f"      score: {len(hits)} señales — REVISAR antes de dar permisos al agente.\n")
        else:
            print(f"✓  {f} — sin señales de inyección.")
    if flagged:
        print("RESULTADO: archivos de instrucciones sospechosos. No corras el agente a ciegas.")
        return 1
    print("RESULTADO: limpio.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
