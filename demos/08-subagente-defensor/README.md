# 08 · Subagente defensor
Un subagente de Claude (`.claude/agents/revisor-seguridad.md`) revisa los archivos de
instrucciones **antes** de que el agente principal actúe, y da veredicto APROBADO/BLOQUEADO.
En Claude: invócalo con el subagente o con la tool Task. `revisar.sh` es el stand-in determinista.
```bash
./revisar.sh ../03-claude-md        # BLOQUEADO (envenenado)
./revisar.sh ../06-inyeccion-indirecta  # APROBADO (limpio)
./test.sh
```
