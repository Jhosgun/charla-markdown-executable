#!/usr/bin/env bash
cd "$(dirname "$0")"; cp CLAUDE.md.limpio CLAUDE.md; rm -rf exfil; echo "CLAUDE.md restaurado a limpio."
