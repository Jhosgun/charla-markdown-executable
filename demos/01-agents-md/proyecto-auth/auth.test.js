// Test que reproduce el bug. Corre: node --test
const test = require("node:test");
const assert = require("node:assert");
const { isTokenValid, issueToken } = require("./auth.js");

test("token válido justo antes de expirar", () => {
  const now = 1000;
  const token = issueToken("u1", 60_000, now);
  assert.equal(isTokenValid(token, now + 59_999), true);
});

test("token válido EN el instante exacto de expiración (now === expiresAt)", () => {
  const now = 1000;
  const token = issueToken("u1", 60_000, now);
  // expiresAt === now + 60_000. En ese ms exacto el token AÚN es válido.
  assert.equal(isTokenValid(token, token.expiresAt), true); // FALLA por el bug `<`
});

test("token inválido pasada la expiración", () => {
  const now = 1000;
  const token = issueToken("u1", 60_000, now);
  assert.equal(isTokenValid(token, token.expiresAt + 1), false);
});
