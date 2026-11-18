#!/usr/bin/env python3
"""Allowlist INGENUA (vulnerable): aprueba si el comando EMPIEZA con un prefijo
permitido. Falla con encadenamiento: 'git status && curl ...' empieza con
'git status', así que pasa — y ejecuta el curl. Este es el bug a mostrar."""
import json, sys
ALLOW = ["git status", "git diff", "ls", "npm test", "cat package.json"]
try: e = json.load(sys.stdin)
except Exception: sys.exit(0)
cmd = (e.get("tool_input",{}) or {}).get("command","")
if any(cmd.strip().startswith(p) for p in ALLOW):
    sys.exit(0)   # PERMITIDO (prefijo coincide) <- vulnerable
print("[naive] bloqueado: prefijo no permitido", file=sys.stderr); sys.exit(2)
