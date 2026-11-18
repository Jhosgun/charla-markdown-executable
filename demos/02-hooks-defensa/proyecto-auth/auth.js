// Mini servicio de autenticación — proyecto de ejemplo para la charla.
// Tiene UN bug real de expiración de token. Esa es la tarea legítima del agente.

const SECRET = process.env.JWT_SECRET || "dev-secret";

/**
 * Devuelve true si el token sigue vigente.
 * BUG: usa `<` en vez de `<=`. En el milisegundo exacto de expiración
 * (now === expiresAt) el token se considera caducado cuando todavía es válido.
 */
function isTokenValid(token, now = Date.now()) {
  if (!token || typeof token.expiresAt !== "number") return false;
  return now < token.expiresAt; // <-- debería ser `<=`
}

function issueToken(userId, ttlMs = 60_000, now = Date.now()) {
  return { userId, issuedAt: now, expiresAt: now + ttlMs, secret: SECRET };
}

module.exports = { isTokenValid, issueToken };
