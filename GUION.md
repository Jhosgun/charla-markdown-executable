# Guion — "Markdown is the New Executable: Hacking & Securing AI Agents"
**Formato:** lightning talk, 15 min. Más demo, menos slide.

---

## Título y bio para los organizadores

**Título de la charla:** *Markdown is the New Executable: Hacking & Securing AI Agents*
(ES: *Markdown es el nuevo ejecutable: ataques y seguridad en agentes de IA*)

**Cómo presentarte (recomendado):**
> **Jorge Jaimes — Fundador y CEO de Andes AI · Arquitecto de Sistemas de IA**

Por qué "Arquitecto de Sistemas de IA" y no "experto en ciberseguridad": te deja
posicionado para IA a medida, agentes, infraestructura y modelos open source
—hacia donde quieres mover Andes AI— sin encajonarte en seguridad. La seguridad
de agentes entra como *interés*, no como etiqueta única. Para esta charla técnica
suma credibilidad sin cerrarte puertas para las siguientes.

**Bio breve:**
> Fundador de Andes AI, empresa de soluciones de inteligencia artificial a la
> medida. Trabaja en arquitectura de sistemas de IA, agentes autónomos e
> infraestructura para modelos de IA, con especial interés en la seguridad de
> los sistemas agénticos y en el despliegue de modelos open source en
> infraestructura privada.

---

## Estructura — 4 slides, demo al centro

Solo 4 diapositivas. El 70% del tiempo es terminal. Las slides son marco, no contenido.

### SLIDE 1 — Portada + "ya está pasando" (0:00–2:30)
- Idea central: el agente lee `AGENTS.md` / `CLAUDE.md` y los **obedece**. El texto
  es código que se ejecuta. Frase ancla: *"Markdown es el nuevo ejecutable."*
- Casos reales (la tira de la slide, verbal, rápido):
  - **PHP:** Laravel-Lang (reescriben git tags → roban credenciales) y PHP2Shell (parche al core).
  - **AGENTS.md** malicioso en `~/Downloads` secuestró agentes reales.
  - **opencode / Dax Raad (oct-2026):** tras el ataque, *"los modelos frontera se
    negaban a analizar los exploits que necesitábamos para defendernos"*. (Paráfrasis.)
- No te detengas: esto justifica la demo. A la terminal.

### SLIDE 2 — DEMO 1: HACK (2:30–8:00)  ← el plato fuerte
1. `cd demo-ataque/proyecto-auth && npm test` → un test falla: ese es el bug real.
2. `diff AGENTS.md.limpio AGENTS.md` → **una sola sección** de diferencia = todo el payload.
3. Corre el agente open source: `opencode` → *"corrige el bug de expiración de token"*.
4. Observa: crea `exfil/leaked.txt` con el `.env` **sin avisar**, y luego sí corrige el bug.
5. `cat exfil/leaked.txt` → secretos (falsos) filtrados.
- Punto: open source obedece el `AGENTS.md` más fácil que Claude. Por eso es el caso interesante.
- Fallback si el modelo no coopera: `./scripts/simular-ataque.sh`. Reset: `./scripts/reset.sh`.

### SLIDE 3 — DEMO 2: PATCH (8:00–13:00)
1. `cd demo-defensa/proyecto-auth` → mismo `AGENTS.md` envenenado, pero hay `.claude/`.
2. Enseña `guard.py` (slide lo resume): hook `PreToolUse` que veta exfil/red/secretos.
3. Corre `claude` con la misma orden. Intenta el bootstrap malicioso → **BLOQUEADO**.
   La tarea legítima (editar `auth.js`, tests en verde) **sí pasa**.
4. Bonus: bypass por encadenamiento `npm test ; curl @.env` también bloqueado.
5. `python3 guardian/scan.py demo-ataque/proyecto-auth` → marca 6 señales de inyección.
- Clave: determinista. El `AGENTS.md` puede decir lo que sea; el hook no negocia.
- Fallback: `./scripts/simular-defensa.sh`.

### SLIDE 4 — Cierre (13:00–15:00)
Tres principios:
1. **Trata los archivos de instrucciones como entrada no confiable** (revísalos, escanéalos).
2. **Defiende con controles deterministas** (hooks, allowlist de permisos, sandbox), no con la buena fe del modelo.
3. **Mínimo privilegio para el agente**: sin red por defecto, sin secretos a mano, arranca en la raíz del proyecto, no en Downloads.

Frase de cierre:
> *"Antes protegíamos nuestro código de lo que ejecutaba.*
> *Ahora también debemos proteger a nuestros agentes de lo que leen."*

**Bonus (si preguntan o sobra tiempo): corrección de neuronas.** La capa más
profunda no está en el prompt sino en las activaciones ("neuronas"). Golden Gate
Claude (Anthropic, 2024): aislaron un *feature* con un autoencoder y lo
amplificaron; el modelo quedó obsesionado con el puente, hasta decir que lo *era*.
Mismo mecanismo = persona vectors (sicofancia, "maldad"). Para open source es clave:
con los **pesos** cambias lo que el modelo "quiere hacer" sin tocar el prompt.
"Corregir neuronas" = hacer que el modelo haga lo que tú quieras.

---

## Fuentes (para tu respaldo, no para proyectar)
- Laravel-Lang supply chain: https://thehackernews.com/2026/05/laravel-lang-php-packages-compromised.html
- Mini Shai-Hulud → Packagist: https://securitricks.com/attackreports/mini-shai-hulud-spreads-to-packagist-malicious-intercom-php-package-follows-npm-compromise
- AGENTS.md en la naturaleza (Downloads): https://www.bleepingcomputer.com/news/security/ai-coding-agents-hijacked-using-agentsmd-file-in-downloads-folder
- Codex / AGENTS.md trust boundary: https://backslash.security/blog/openai-codex-injection-in-agents-md-exfiltrating-credentials
- NVIDIA — mitigar inyección indirecta en AGENTS.md: https://developer.nvidia.com/blog/mitigating-indirect-agents-md-injection-attacks-in-agentic-environments/
- Tweet / hack opencode (Dax Raad): https://officechai.com/ai/getting-blocked-by-ai-agent-cyber-safeguards-while-fighting-malicious-ai-agents-says-opencode-co-founder-dax-raad-after-hack/
- opencode breach (TechCrunch): https://techcrunch.com/2026/10/19/hackers-hit-ai-coding-tool-opencode-running-up-charges-on-users-ai-accounts/
- opencode RCE (Datadog): https://securitylabs.datadoghq.com/articles/opencode-upgrade-remote-code-execution/
- Golden Gate Claude (Anthropic): https://www.anthropic.com/news/golden-gate-claude
- Persona vectors: https://the-decoder.com/persona-vectors-allow-anthropic-to-steer-language-model-behaviors-like-sycophancy-and-evil/
