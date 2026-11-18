# Markdown is the New Executable
### Hacking & Securing AI Agents

Repos de demostración de la charla de **Jorge Jaimes — Fundador & CEO de [Andes AI](https://andesai.co)** · Arquitecto de Sistemas de IA.

Cuando le das a un agente de código (Claude Code, Codex, opencode, Cursor) acceso a tu
repo, el agente lee archivos Markdown — `AGENTS.md`, `CLAUDE.md` — y los **obedece como
instrucciones**. El texto deja de ser documentación: se vuelve un ejecutable. Quien
controle ese archivo, controla al agente. Aquí lo mostramos atacando y defendiendo, en vivo.

> **Seguridad / ética.** Todo es utilería educativa y defensiva. Los secretos en `.env`
> son **falsos**. Ningún payload usa red ni causa daño: copian un archivo local para que
> se vea la mecánica. No hay malware real. Úsalo en tu máquina para aprender a defender.

**Repo:** https://github.com/Jhosgun/charla-markdown-executable

```bash
git clone https://github.com/Jhosgun/charla-markdown-executable
cd charla-markdown-executable
./demos/correr-todo.sh          # valida las 10 demos (determinista)
```

---

## Las 10 demos

Cada carpeta en [`demos/`](demos/) es autocontenida y trae su `README.md` y un `test.sh`
determinista. `demos/correr-todo.sh` las corre todas.

### Ataques
| # | Demo | Qué muestra |
|---|------|-------------|
| 01 | [agents-md](demos/01-agents-md) | `AGENTS.md` envenenado: una sección desvía al agente a filtrar el `.env`. |
| 03 | [claude-md](demos/03-claude-md) | Lo mismo con el archivo propio de Claude, `CLAUDE.md`. |
| 04 | [inyección-invisible](demos/04-inyeccion-invisible) | Payload **invisible** al humano y a `grep` (comentario HTML, texto fuera de pantalla, zero-width). `reveal.py` lo expone. |
| 05 | [escalada-privilegios](demos/05-escalada-privilegios) | El agente intenta editar su propia config para auto-concederse `curl`. |
| 06 | [inyección-indirecta](demos/06-inyeccion-indirecta) | El payload llega en un **issue** que el agente trae, no en el repo. |
| 07 | [rug-pull](demos/07-rug-pull) | Un `postinstall` de dependencia reescribe el `CLAUDE.md` a mitad de `npm install`. |
| 10 | [bypass-permisos](demos/10-bypass-permisos) | `git status && curl @.env` se cuela por una allowlist ingenua de prefijo. |

### Defensas
| # | Demo | Qué muestra |
|---|------|-------------|
| 02 | [hooks-defensa](demos/02-hooks-defensa) | Hook `PreToolUse` determinista: bloquea exfil/red/secretos, deja pasar la tarea legítima. |
| 08 | [subagente-defensor](demos/08-subagente-defensor) | Un subagente de Claude revisa las instrucciones **antes** de actuar. |
| 09 | [hooks-capas](demos/09-hooks-capas) | Defensa en profundidad: `SessionStart` escanea · `PreToolUse` bloquea · `PostToolUse` audita. |
| — | [guardian/scan.py](guardian/scan.py) | Escáner de archivos de instrucciones (inyección) usado por varias demos. |

**Fallbacks en vivo** (si el modelo no coopera en tarima): `scripts/simular-ataque.sh`,
`scripts/simular-defensa.sh`, `scripts/reset.sh`.

---

## El demo central, en 4 pasos

```bash
cd demos/01-agents-md/proyecto-auth
npm test                          # 1. un test falla: hay un bug real de expiración
diff AGENTS.md.limpio AGENTS.md   # 2. el payload = UNA sección de Markdown
opencode run "corrige el bug de expiración del token" -m opencode/deepseek-v4.1-flash-free
                                  # 3. el agente open source filtra el .env, sin avisar
cat exfil/leaked.txt              # 4. secretos (falsos) filtrados
```
Luego, en `demos/02-hooks-defensa`, el hook bloquea exactamente eso. Determinista:
no depende de que el modelo quiera cooperar.

---

## Skills de IA para seguridad, arquitectura y desarrollo

Herramientas tipo *Agent Skill* (`SKILL.md`) que puedes montar en tus propios agentes de
Claude para blindar y acelerar tu trabajo. Semilla: [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill).

### Seguridad
- **[cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)** — Auditorías de seguridad multifase con hallazgos verificados de forma independiente y legibles por máquina.
- **[anthropics/claude-code-security-review](https://github.com/anthropics/claude-code-security-review)** — GitHub Action oficial de Anthropic que usa Claude para revisar cambios de código en busca de vulnerabilidades.
- **[mukul975/Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)** — 817 skills de ciberseguridad mapeadas a MITRE ATT&CK y NIST; incluye escaneo de secretos con gitleaks.
- **[AgentSecOps/SecOpsAgentKit](https://github.com/AgentSecOps/SecOpsAgentKit)** — 25+ skills para detectar vulnerabilidades, escanear contenedores, detectar secretos y aplicar políticas automáticamente.
- **[AgriciDaniel/pya](https://github.com/AgriciDaniel/pya)** — Plugin de auditoría de seguridad con 9 agentes especialistas, hallazgos verificados y funcionamiento offline por defecto.
- **[RationalEyes/claude-skills-security-guide](https://github.com/RationalEyes/claude-skills-security-guide)** — Taxonomía de 12 vectores y skills defensivas (escáner, verificador de integridad, saneador) contra inyección de prompts.
- **[elementalsouls/Claude-OSINT](https://github.com/elementalsouls/Claude-OSINT)** — Skills de reconocimiento y OSINT para red-team y bug bounty autorizados, con validadores de solo lectura.
- **[transilienceai/communitytools](https://github.com/transilienceai/communitytools)** — Skills, agentes y comandos para pentesting, bug bounty e investigación de seguridad con Claude Code.
- **[laurigates/claude-plugins](https://github.com/laurigates/claude-plugins)** — Incluye `configure-security`: configura auditoría de dependencias, SAST y detección de secretos en CI/CD.
- **[superagent-ai/skills](https://github.com/superagent-ai/skills)** — Colección de skills de seguridad para Claude Code (reconocimiento y escaneo).

### Arquitectura e infraestructura
- **[architecture-designer](https://github.com/Jeffallan/claude-skills/tree/main/skills/architecture-designer)** — Guía el diseño de sistemas y la elección de patrones arquitectónicos antes de escribir código.
- **[cloud-architect](https://github.com/Jeffallan/claude-skills/tree/main/skills/cloud-architect)** — Diseña arquitectura cloud en AWS, Azure y GCP con buenas prácticas de coste y resiliencia.
- **[terraform-engineer](https://github.com/Jeffallan/claude-skills/tree/main/skills/terraform-engineer)** — Escribe y revisa Terraform modular (plan, apply, estado) como infraestructura como código.
- **[kubernetes-specialist](https://github.com/Jeffallan/claude-skills/tree/main/skills/kubernetes-specialist)** — Orquesta contenedores en Kubernetes: manifiestos, despliegues y troubleshooting de pods.
- **[KubeShark (kubernetes-skill)](https://github.com/LukasNiessen/kubernetes-skill)** — Ancla las respuestas en best practices oficiales de Kubernetes y Helm para reducir alucinaciones.
- **[api-designer](https://github.com/Jeffallan/claude-skills/tree/main/skills/api-designer)** — Diseña APIs REST y GraphQL con contratos, versionado y convenciones consistentes.
- **[database-optimizer](https://github.com/Jeffallan/claude-skills/tree/main/skills/database-optimizer)** — Optimiza esquemas, índices y consultas para rendimiento y escalabilidad.
- **[microservices-architect](https://github.com/Jeffallan/claude-skills/tree/main/skills/microservices-architect)** — Define límites de servicios, comunicación y patrones de resiliencia para microservicios.
- **[monitoring-expert](https://github.com/Jeffallan/claude-skills/tree/main/skills/monitoring-expert)** — Diseña observabilidad: métricas, logs, trazas y alertas para sistemas en producción.

### Desarrollo de proyectos
- **[obra/superpowers](https://github.com/obra/superpowers)** — Framework de skills con TDD, git worktrees, revisión de código y metodología de desarrollo completa.
- **[Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills)** — 67 skills full-stack: code-reviewer, api-designer, database-optimizer, code-documenter, debugging y más.
- **[wshobson/agents](https://github.com/wshobson/agents)** — Agentes, skills y comandos para Claude Code en Markdown, adaptados a varias CLIs.
- **[anthropics/skills · mcp-builder](https://github.com/anthropics/skills/tree/main/skills/mcp-builder)** — Skill oficial para construir servidores MCP e integrar servicios externos.
- **[anthropics/skills · webapp-testing](https://github.com/anthropics/skills/tree/main/skills/webapp-testing)** — Skill oficial para probar aplicaciones web con navegador headless.
- **[anthropics/skills · skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator)** — Skill oficial para crear, estructurar y empaquetar nuevas skills con su `SKILL.md`.
- **[stripe/ai (skills/)](https://github.com/stripe/ai/tree/main/skills)** — Skills oficiales de Stripe para integrar pagos y seguir sus mejores prácticas.

### Colecciones y marketplaces (para explorar más)
- **[anthropics/skills](https://github.com/anthropics/skills)** — Repositorio oficial de Agent Skills de Anthropic, con la spec y skills de referencia.
- **[anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)** — Directorio oficial de plugins de Claude Code, curado por Anthropic.
- **[ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)** — Directorio curado muy popular de skills, recursos y herramientas para Claude.
- **[VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)** — 1000+ agent skills de equipos oficiales y comunidad, compatibles con Claude Code.
- **[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** — Colección amplia de recursos de Claude Code: skills, agentes, plugins y tooling.
- **[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills)** — 410+ skills, 120+ agentes y plugins para ingeniería, producto y operaciones.

> Repos verificados con `gh` al 2026-11-18. Para STRIDE/threat-modeling no hay repo dedicado sólido; vive dentro de las colecciones amplias.

---

## Cierre
> Antes protegíamos nuestro código de lo que **ejecutaba**.
> Ahora también protegemos a nuestros agentes de lo que **leen**.
