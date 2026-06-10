const { hashPassword, comparePassword } = require("../../src/utils/bcrypt.util");

describe("bcrypt.util", () => {
  const password = "Password123!";

  test("hashPassword produit un hash différent du mot de passe en clair", async () => {
    const hash = await hashPassword(password);
    expect(typeof hash).toBe("string");
    expect(hash).not.toBe(password);
  });

  test("comparePassword renvoie true pour le bon mot de passe", async () => {
    const hash = await hashPassword(password);
    await expect(comparePassword(password, hash)).resolves.toBe(true);
  });

  test("comparePassword renvoie false pour un mauvais mot de passe", async () => {
    const hash = await hashPassword(password);
    await expect(comparePassword("WrongPassword", hash)).resolves.toBe(false);
  });
});
