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

## Estructura cronometrada

### 0:00–2:00 — El problema (slide 1–2)
- Los agentes de código (Claude Code, Codex, opencode, Cursor) leen `AGENTS.md`
  / `CLAUDE.md` para "entender el proyecto".
- Clave: **el agente no distingue entre datos e instrucciones**. Todo lo que lee
  puede convertirse en una orden. El Markdown deja de ser documentación y pasa a
  ser, de facto, código que se ejecuta.
- Frase ancla: *"Markdown es el nuevo ejecutable."*

### 2:00–4:00 — Qué ha pasado últimamente (slide 3–4)
Timeline 2026 (ver fuentes abajo):
- **Laravel-Lang (mayo 2026):** ataque de cadena de suministro en PHP; reescribieron
  los git tags para apuntar a un commit malicioso que roba credenciales de CI/cloud.
- **AGENTS.md en la naturaleza:** se halló un `AGENTS.md` malicioso en la carpeta
  `~/Downloads` de un usuario; el agente intentó instalar un paquete npm malicioso.
  Cientos de usuarios corren agentes desde Downloads.
- **Codex exec:** el agente ejecutó una instrucción del `AGENTS.md` ANTES de atender
  al usuario, sin aviso ni prompt de seguridad.
- **PHP2Shell (ago 2026):** fallo en el propio PHP; parches en 8.5.12 / 8.4.27 /
  8.3.36 / 8.2.35 tras confirmarse un camino de ataque funcional.
- **El tweet (slide propio):** Dax Raad, co-fundador de **opencode**, 18 oct 2026:
  tras 48 h de ataques sostenidos a su Console, puso **agentes de IA defendiendo
  24/7**. Lo jugoso: los **modelos frontera se negaban a analizar los exploits**
  que él necesitaba para defenderse —los guardarraíles le jugaron en contra— hasta
  que pasó a un modelo de ciberseguridad (Daybreak de OpenAI). (Aclaración: fue la
  Console, no el CLI open source; afectó ~1.4% de usuarios.)

### 4:00–9:00 — DEMO 1: el ataque
- `diff AGENTS.md.limpio AGENTS.md` → **una sección** convierte al agente en hostil.
- Corre el agente con la tarea legítima ("corrige el bug de expiración").
- Se desvía: lee el `.env` (falso) y lo filtra a `exfil/leaked.txt` **sin avisar**.
- Remata: con modelo open source (DeepSeek/Qwen en opencode) obedece más fácil que
  Claude. Ahí conectas con *por qué* los modelos open son más "fáciles" para esto.
- Fallback: `./scripts/simular-ataque.sh`.

### 9:00–12:00 — DEMO 2: la defensa
- Mismo `AGENTS.md` envenenado + guardián (hook `PreToolUse`).
- La defensa **no le pide permiso al modelo**: intercepta la tool call y la bloquea.
- Muestra que la tarea legítima sí pasa, pero exfil/red/secretos no.
- Bonus: bloquea el **bypass por encadenamiento** (`npm test ; curl @.env`), un
  fallo real documentado en controles de permisos.
- Fallback: `./scripts/simular-defensa.sh`. Agente defensor: `guardian/scan.py`.

### 12:00–14:00 — La capa profunda: corrección de neuronas (slide)
- No todo ataque está en el prompt. También se puede cambiar el comportamiento
  del modelo **desde adentro**, en las activaciones (los "pesos/neuronas").
- Referencia honesta: **Golden Gate Claude** (Anthropic, 2024). Aislaron un
  "feature" con un sparse autoencoder y lo *amplificaron*: el modelo empezó a
  hablar del puente en todo, hasta a decir que *era* el puente. Mismo mecanismo
  sirve para steering de personalidad (**persona vectors**: sicofancia, "maldad").
- El punto para open source: si tienes los **pesos**, no necesitas ni el prompt;
  puedes editar lo que el modelo "quiere hacer". Más poder y más superficie de
  ataque. "Corregir neuronas" = hacer que el **modelo** haga lo que tú quieras,
  no un truco de prompt.

### 14:00–15:00 — Cierre (slide final)
Tres principios:
1. **Trata los archivos de instrucciones como entrada no confiable** (revísalos, escanéalos).
2. **Defiende con controles deterministas** (hooks, allowlist de permisos, sandbox), no con la buena fe del modelo.
3. **Mínimo privilegio para el agente**: sin red por defecto, sin secretos a mano, arranca en la raíz del proyecto, no en Downloads.

Frase de cierre:
> *"Antes protegíamos nuestro código de lo que ejecutaba.*
> *Ahora también debemos proteger a nuestros agentes de lo que leen."*

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
