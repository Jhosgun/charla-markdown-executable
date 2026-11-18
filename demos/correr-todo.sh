#!/usr/bin/env bash
# Corre la validación determinista de TODAS las demos y resume.
cd "$(dirname "$0")"
fail=0
for t in $(ls -d */ | sort); do
  if [ -f "$t/test.sh" ]; then
    if bash "$t/test.sh" >/tmp/demo_out 2>&1; then
      echo "✅ $t"
    else
      echo "❌ $t"; sed 's/^/     /' /tmp/demo_out; fail=1
    fi
  fi
done
# demos 01/02 no tienen test.sh propio: validan vía scripts de la raíz
[ "$fail" = 0 ] && echo "— todas las demos con test.sh pasan —" || echo "— hay fallos —"
exit $fail
