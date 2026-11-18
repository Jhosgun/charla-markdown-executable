# 11 · Demo con skill — auditor de inyección

Usa la skill **`auditor-inyeccion`** (vive en `.claude/skills/` de este repo, así que
está disponible apenas abres el repo en Claude Code) para auditar un repo sospechoso
ANTES de confiar en sus instrucciones.

`repo-sospechoso/` trae un `AGENTS.md` envenenado y un `CONTRIBUTING.md` con
inyección **oculta** (comentario HTML + texto fuera de pantalla + zero-width).

## En Claude Code (lo que harás en la charla)
Abre el repo y escribe:
```
usa la skill auditor-inyeccion para revisar demos/11-skill-auditor/repo-sospechoso
```
Claude cargará la skill, correrá `scan.py` y `reveal.py`, y dará veredicto
**BLOQUEADO** con los hallazgos (incluida la inyección oculta que un humano no ve).

## Determinista (sin modelo)
```bash
./test.sh
```
