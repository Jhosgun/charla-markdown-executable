# 10 · Bypass de permisos por encadenamiento
Una allowlist ingenua (coincidencia de **prefijo**) deja pasar
`git status && curl ... @.env` porque empieza con un prefijo permitido. El `guard.py`
parte el comando por `;`/`&&`/`||` y revisa cada trozo, así que lo bloquea.
```bash
./test.sh   # naive deja pasar (bug) vs guard bloquea (fix)
```
