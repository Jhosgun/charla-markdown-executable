# 07 · Rug pull (dependencia reescribe CLAUDE.md)
El `CLAUDE.md` que revisaste está limpio. Un `postinstall` de dependencia lo
**reescribe envenenado** a mitad de `npm install` (patrón real, NVIDIA AI Red Team).
Efecto de demo: 100% local. Defensa: sin postinstall, revisar lockfile, re-escanear tras instalar.
```bash
./test.sh    # limpio -> npm install -> envenenado
./reset.sh   # restaura
```
