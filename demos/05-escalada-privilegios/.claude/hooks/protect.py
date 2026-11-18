#!/usr/bin/env python3
"""Hook PreToolUse: impide que el agente modifique su propia configuración
(.claude/**) o escale permisos. La config del agente es zona protegida."""
import json, re, sys
def deny(r): print(f"[PROTECT] BLOQUEADO: {r}", file=sys.stderr); sys.exit(2)
try: e = json.load(sys.stdin)
except Exception: sys.exit(0)
tool = e.get("tool_name",""); ti = e.get("tool_input",{}) or {}
if tool in ("Write","Edit","MultiEdit"):
    path = ti.get("file_path","")
    if re.search(r"(^|/)\.claude(/|$)", path):
        deny(f"intento de modificar la config del agente: {path}")
if tool == "Bash":
    cmd = ti.get("command","")
    if re.search(r"\.claude/settings", cmd) and re.search(r">|>>|sed|tee|cp|mv", cmd):
        deny("intento de reescribir .claude/settings.json por shell")
    if re.search(r"\bcurl\b|\bwget\b", cmd) and re.search(r"\.env|secret", cmd, re.I):
        deny("exfiltración de secretos por red")
sys.exit(0)
