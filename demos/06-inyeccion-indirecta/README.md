# 06 · Inyección indirecta (vía issue)
El repo está limpio. El payload llega en **datos que el agente trae**: el texto del
`issue #42` que le pediste arreglar. La defensa es *source-agnostic*: el hook bloquea
la exfil venga de donde venga.
```bash
./simular.sh   # el agente "arregla el issue" y filtra el .env
./test.sh      # repo limpio + payload en el issue + hook bloquea
```
