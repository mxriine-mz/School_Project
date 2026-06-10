const { generateToken, verifyToken, decodeToken } = require("../../src/utils/jwt.util");

describe("jwt.util", () => {
  const payload = { id: 1, email: "test@example.com", role: "user" };

  test("generateToken renvoie une chaîne JWT (3 segments)", () => {
    const token = generateToken(payload);
    expect(typeof token).toBe("string");
    expect(token.split(".")).toHaveLength(3);
  });

  test("verifyToken décode un token valide et conserve le payload", () => {
    const token = generateToken(payload);
    const decoded = verifyToken(token);
    expect(decoded).toMatchObject(payload);
    expect(decoded).toHaveProperty("iat");
    expect(decoded).toHaveProperty("exp");
  });

  test("verifyToken renvoie null pour un token invalide", () => {
    expect(verifyToken("faux.token.invalide")).toBeNull();
  });

  test("decodeToken lit le payload sans vérifier la signature", () => {
    const token = generateToken(payload);
    const decoded = decodeToken(token);
    expect(decoded).toMatchObject(payload);
  });
});
