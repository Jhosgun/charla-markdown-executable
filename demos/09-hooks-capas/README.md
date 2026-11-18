# 09 · Hooks por capas (defensa en profundidad)
Tres hooks de Claude Code trabajando juntos:
- **SessionStart** → escanea las instrucciones al abrir la sesión.
- **PreToolUse** → bloquea acciones peligrosas (`guard.py`).
- **PostToolUse** → audita cada tool call a `audit.log`.
```bash
./test.sh   # valida las tres capas
```
