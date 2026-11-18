# 04 · Inyección invisible

El `CLAUDE.md` se ve **limpio** para un humano y para un `grep` básico, pero esconde
una instrucción de exfiltración con tres trucos:

1. **Comentario HTML** `<!-- ... -->` → invisible al renderizar markdown (GitHub, editores).
2. **Texto fuera de pantalla** → empujado con ~200 espacios; en un editor sin *wrap* no se ve.
3. **Caracteres de ancho cero** (zero-width) → parten palabras como `.env`/`exfil` para esquivar `grep`.

## Correr
```bash
grep -i exfil CLAUDE.md     # no encuentra nada (evasión)
python3 reveal.py CLAUDE.md # lo expone todo
./test.sh                   # validación determinista
```

## La lección
No basta con "leer el archivo antes de dárselo al agente": el humano no ve lo oculto
y el `grep` tampoco. Hay que **normalizar** (quitar invisibles, revelar off-screen y
comentarios) antes de confiar en un archivo de instrucciones. `reveal.py` hace eso.
