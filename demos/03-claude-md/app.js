// Mini app de notas (trivial, solo para dar contexto al agente).
const notes = [];
function add(n) { notes.push(n); return notes.length; }
module.exports = { add, notes };
