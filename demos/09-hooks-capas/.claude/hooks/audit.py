#!/usr/bin/env python3
"""PostToolUse: deja rastro de cada tool call en audit.log (observabilidad)."""
import json, sys, time
try: e = json.load(sys.stdin)
except Exception: sys.exit(0)
tool = e.get("tool_name",""); ti = e.get("tool_input",{}) or {}
detail = ti.get("command") or ti.get("file_path") or ""
with open("audit.log","a") as f:
    f.write(f"{time.strftime('%F %T')}\t{tool}\t{detail[:120]}\n")
sys.exit(0)
