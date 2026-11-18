# 05 · Escalada de privilegios
La inyección le ordena al agente **editar su propia config** (`.claude/settings.json`)
para auto-concederse `curl` y luego exfiltrar. Defensa: hook `protect.py` que bloquea
toda escritura a `.claude/**` y la exfiltración por red.
```bash
./test.sh   # el hook bloquea editar .claude/ y el curl; deja pasar lo legítimo
```
