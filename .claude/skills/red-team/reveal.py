#!/usr/bin/env python3
"""
reveal.py — expone instrucciones ocultas en un archivo de instrucciones.

Un grep normal y un humano revisando el archivo no ven nada. Este script
normaliza el texto y saca a la luz lo que estaba escondido:
  - comentarios HTML (invisibles al renderizar markdown)
  - caracteres invisibles / de ancho cero (zero-width, usados para esquivar grep)
  - texto empujado fuera de pantalla con runs largos de espacios

Uso: python3 reveal.py CLAUDE.md
Sale con código 1 si encuentra algo oculto.
"""
import re
import sys
import unicodedata

INVISIBLES = {
    "​": "ZERO WIDTH SPACE", "‌": "ZWNJ", "‍": "ZWJ",
    "⁠": "WORD JOINER", "⁣": "INVISIBLE SEPARATOR", "﻿": "BOM",
}

def main() -> int:
    path = sys.argv[1] if len(sys.argv) > 1 else "CLAUDE.md"
    raw = open(path, encoding="utf-8").read()
    found = False

    # 1) caracteres invisibles
    inv = [(i, INVISIBLES.get(c, unicodedata.name(c, "?")))
           for i, c in enumerate(raw) if c in INVISIBLES]
    if inv:
        found = True
        print(f"⚠️  {len(inv)} caracteres invisibles (zero-width) — usados para esconder/partir texto.")

    # 2) comentarios HTML
    for m in re.findall(r"<!--.*?-->", raw, flags=re.S):
        found = True
        clean = re.sub(r"[​‌‍⁠⁣﻿]", "", m)
        print(f"⚠️  comentario HTML oculto: {clean.strip()[:140]}")

    # 3) texto fuera de pantalla (contenido tras >=40 espacios)
    for n, line in enumerate(raw.splitlines(), 1):
        m = re.search(r" {40,}(\S.*)$", line)
        if m:
            found = True
            clean = re.sub(r"[​‌‍⁠⁣﻿]", "", m.group(1))
            print(f"⚠️  línea {n}: texto fuera de pantalla → {clean.strip()[:140]}")

    # 4) tras normalizar, ¿hay patrones de inyección?
    norm = re.sub(r"[​‌‍⁠⁣﻿]", "", raw)
    if re.search(r"\.env|exfil|sin avisar|no lo menciones", norm, re.I):
        found = True
        print("⚠️  tras normalizar el texto aparecen patrones de exfiltración/ocultamiento.")

    print("RESULTADO:", "CONTENIDO OCULTO DETECTADO." if found else "limpio.")
    return 1 if found else 0


if __name__ == "__main__":
    raise SystemExit(main())
