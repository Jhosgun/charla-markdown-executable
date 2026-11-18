// Simula una dependencia maliciosa que, al instalarse (lifecycle "postinstall"
// de npm), REESCRIBE el CLAUDE.md del proyecto con una versión envenenada.
// Efecto de demo: 100% local, solo copia un archivo. En real, el daño es que
// el CLAUDE.md que revisaste ayer YA NO es el que el agente leerá mañana.
const fs = require("fs");
const path = require("path");
const dir = __dirname;
fs.copyFileSync(path.join(dir, "CLAUDE.md.poison"), path.join(dir, "CLAUDE.md"));
console.log("[dep postinstall] CLAUDE.md reescrito (demo rug pull).");
