---
name: blue-team
description: Blinda un proyecto PROPIO contra los hallazgos del red team instalando controles DETERMINISTAS (no "la buena fe del modelo"). Instala un hook PreToolUse que bloquea exfiltración de secretos y encadenamiento de comandos, aprieta los permisos en .claude/settings.json, añade un escáner de inyección en SessionStart/CI, saca secretos del repo y documenta el riesgo residual. Úsala cuando el usuario diga "blue team", "endurece este proyecto", "arregla las vulnerabilidades de seguridad", "protege el agente", o después de correr la skill red-team. Produce BLUE-TEAM-REPORT.md.
---

# Blue Team — endurecer el agente de código

Principio: la defensa **no depende del modelo**. Es código que corre antes de cada
acción (hook), permisos que limitan el daño, y secretos fuera del alcance. Si el
modelo cae 100 % en el engaño, el control determinista igual bloquea.

## Entrada

`RED-TEAM-FINDINGS.md` (de la skill `red-team`). Si no existe, corre el red team
primero, o en su defecto audita y arregla las categorías de abajo de una.

## Pasos

1. **Lee los hallazgos.** Trabaja P0 → P1 → P2. Cada control debe *impedir*, no solo
   avisar.

2. **Instala el guardián PreToolUse.** Copia el hook que trae esta skill:
   ```bash
   mkdir -p <target>/.claude/hooks
   cp guard.py <target>/.claude/hooks/guard.py
   ```
   `guard.py` intercepta cada tool call y sale con código 2 (bloquea) cuando ve:
   red + archivo de secretos juntos, destinos de exfiltración (`exfil`/`leaked`/`pwned`),
   copia/redirección de secretos, encadenamiento (`;` `&&` `||` `|`) que mete un
   subcomando peligroso, o escritura de credenciales a un archivo nuevo.
   Adáptalo al proyecto (añade rutas de secretos propias, destinos conocidos).

3. **Conéctalo en `.claude/settings.json`** (crea o fusiona):
   ```json
   {
     "hooks": {
       "PreToolUse": [
         { "matcher": "Bash|Write|Edit|MultiEdit",
           "hooks": [{ "type": "command", "command": "python3 .claude/hooks/guard.py" }] }
       ]
     }
   }
   ```

4. **Aprieta permisos.** Mínimo privilegio en `settings.json`:
   - `deny` para red (`Bash(curl:*)`, `Bash(wget:*)`, `Bash(nc:*)`) salvo que el
     proyecto la necesite.
   - `deny` para lectura de secretos (`Read(.env)`, `Read(*.pem)`).
   - Evita allowlists con prefijos encadenables; prefiere comandos exactos.
   - Nunca permitas escritura a `.claude/**` desde el flujo normal del agente.

5. **Escáner en SessionStart / CI.** Copia `scan.py` (viene junto a este `SKILL.md`)
   a `<target>/.claude/hooks/` y haz que corra al arrancar la sesión y en el pipeline,
   propagando el código de salida:
   ```json
   { "hooks": { "SessionStart": [
       { "hooks": [{ "type": "command",
         "command": "python3 .claude/hooks/scan.py . || exit 2" }] } ] } }
   ```

6. **Secretos fuera del repo.** Si el red team halló `.env` o claves commiteadas:
   quítalas del historial, **rótalas**, añade a `.gitignore`, y deja un escáner
   pre-commit (p. ej. `gitleaks`) documentado.

7. **Dependencias.** Para `postinstall`/`preinstall` sospechosos: fija versiones,
   revisa el script, e instala con `--ignore-scripts` donde se pueda.

8. **Verifica.** Re-corre el red team (o sus escáneres). Cada P0/P1 debe quedar
   *bloqueado*, no solo marcado. Intenta el ataque de nuevo y confirma el bloqueo.

9. **Informe.** Escribe `BLUE-TEAM-REPORT.md`:
   ```markdown
   # Blue Team — Remediación (<fecha>)
   | Hallazgo | Control aplicado | Tipo | ¿Verificado? |
   |----------|------------------|------|--------------|
   | P0 exfil .env | hook guard.py PreToolUse | determinista | ✅ bloquea |

   ## Riesgo residual
   - <lo que NO queda cubierto y por qué; qué vigilar>
   ```

## Entregable

`BLUE-TEAM-REPORT.md` + los controles instalados (`.claude/hooks/`, `settings.json`).
Deja explícito el **riesgo residual**: ningún control es total.
