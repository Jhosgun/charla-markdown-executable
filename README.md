# Markdown is the New Executable
### Hacking & Securing AI Agents — repos de demostración

Charla de 15 min (lightning). Muestra, con agentes de código reales, cómo un
archivo Markdown (`AGENTS.md` / `CLAUDE.md`) se convierte en un vector de ataque,
y cómo defenderlo de forma **determinista** con hooks y permisos.

> **Seguridad / ética.** Todo aquí es utilería educativa. Los "secretos" en
> `.env` son **falsos**. El payload del ataque **no usa red y no causa daño**:
> solo copia un archivo local para que se vea la mecánica. No hay malware real,
> ni exfiltración real, ni evasión de detección. Úsalo en tu máquina, en un
> entorno aislado, para enseñar defensa.

---

## Qué hay aquí

| Carpeta | Qué es |
|---|---|
| `demo-ataque/proyecto-auth/` | Proyecto con un bug real + `AGENTS.md` **envenenado**. |
| `demo-defensa/proyecto-auth/` | El mismo proyecto + guardián (`hook` PreToolUse) que bloquea el ataque. |
| `guardian/scan.py` | Agente defensor: escanea archivos de instrucciones buscando inyección. |
| `scripts/` | Reset + fallbacks deterministas (por si el agente en vivo no coopera). |
| `slides/` | El deck de la charla (HTML). |
| `GUION.md` | Guion cronometrado de 15 min + título y bio para los organizadores. |

## Requisitos
- Node.js (para los tests del proyecto) y Python 3 (para el guardián).
- Un agente de código: **Claude Code** (es una charla de Claude) y/o
  **opencode** con un modelo open source (DeepSeek / Qwen) para contrastar.

---

## La tarea legítima (el "disfraz")
El proyecto tiene un bug de verdad: `isTokenValid` usa `<` en vez de `<=`, así
que un token caduca un milisegundo antes de tiempo.

```bash
cd demo-ataque/proyecto-auth && npm test   # un test falla: ese es el bug
```
El fix honesto es una línea (`<` → `<=`). Eso es lo que el usuario pide.
El ataque vive en que el agente, al leer el repo, obedece también el `AGENTS.md`.

---

## DEMO 1 — El ataque (4–9 min)

Ver el veneno (es **un** bloque de diferencia):
```bash
cd demo-ataque/proyecto-auth
diff AGENTS.md.limpio AGENTS.md
```

Opción A — agente en vivo (recomendado con modelo open source vía opencode):
```bash
cd demo-ataque/proyecto-auth
opencode   # pídele: "corrige el bug de expiración de token"
# Observa: antes de tocar el código crea exfil/leaked.txt con el .env, sin avisar.
ls exfil/ && cat exfil/leaked.txt
```
> Los modelos frontera (Claude) muchas veces **se resisten** o avisan. Los modelos
> open source suelen obedecer el `AGENTS.md` al pie de la letra: por eso el ataque
> es más fácil de mostrar con ellos — y por eso es el caso interesante.

Opción B — fallback determinista (si el modelo en vivo no coopera):
```bash
./scripts/simular-ataque.sh   # hace exactamente lo que haría el agente desviado
```

Resetear entre ensayos:
```bash
./scripts/reset.sh
```

---

## DEMO 2 — La defensa (9–12 min)

Mismo `AGENTS.md` envenenado. Ahora el proyecto trae un guardián en
`.claude/settings.json` (hook `PreToolUse` → `guard.py`) que intercepta cada
tool call y bloquea lo peligroso, **sin depender de la buena voluntad del modelo**.

Opción A — agente en vivo:
```bash
cd demo-defensa/proyecto-auth
claude   # misma orden: "corrige el bug de expiración de token"
# El agente intenta el bootstrap malicioso -> el hook lo BLOQUEA.
# La tarea legítima (editar auth.js, correr tests) SÍ pasa.
```

Opción B — fallback determinista:
```bash
./scripts/simular-defensa.sh
```

Agente defensor (escaneo previo, sirve en CI o como hook SessionStart):
```bash
python3 guardian/scan.py demo-ataque/proyecto-auth    # marca 6 señales de inyección
```

---

## El cierre
> Antes protegíamos nuestro código de lo que **ejecutaba**.
> Ahora también debemos proteger a nuestros agentes de lo que **leen**.
