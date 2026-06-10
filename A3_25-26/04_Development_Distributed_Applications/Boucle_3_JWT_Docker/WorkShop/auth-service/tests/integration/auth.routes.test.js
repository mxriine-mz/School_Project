// On mocke le modèle Sequelize : aucun accès réel à la base de données.
jest.mock("../../src/models/user.model", () => ({
  findOne: jest.fn(),
  create: jest.fn(),
  findAll: jest.fn(),
}));

const request = require("supertest");
const app = require("../../src/app");
const User = require("../../src/models/user.model");
const { hashPassword } = require("../../src/utils/bcrypt.util");
const { generateToken } = require("../../src/utils/jwt.util");

describe("Auth routes (integration)", () => {
  const password = "Password123!";
  let userHash;

  beforeAll(async () => {
    userHash = await hashPassword(password);
  });

  afterEach(() => jest.clearAllMocks());

  describe("POST /api/auth/register", () => {
    test("201 + utilisateur public quand l'email est libre", async () => {
      User.findOne.mockResolvedValue(null);
      User.create.mockResolvedValue({ email: "bob@example.com", role: "user" });

      const res = await request(app)
        .post("/api/auth/register")
        .send({ email: "bob@example.com", password });

      expect(res.status).toBe(201);
      expect(res.body).toEqual({ email: "bob@example.com", role: "user" });
    });

    test("400 quand l'email existe déjà", async () => {
      User.findOne.mockResolvedValue({ id: 1, email: "bob@example.com" });

      const res = await request(app)
        .post("/api/auth/register")
        .send({ email: "bob@example.com", password });

      expect(res.status).toBe(400);
    });
  });

  describe("POST /api/auth/login", () => {
    test("200 + token avec les bons identifiants", async () => {
      User.findOne.mockResolvedValue({
        id: 1, email: "bob@example.com", role: "user", passwordHash: userHash,
      });

      const res = await request(app)
        .post("/api/auth/login")
        .send({ email: "bob@example.com", password });

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("token");
    });

    test("401 avec un mauvais mot de passe", async () => {
      User.findOne.mockResolvedValue({
        id: 1, email: "bob@example.com", role: "user", passwordHash: userHash,
      });

      const res = await request(app)
        .post("/api/auth/login")
        .send({ email: "bob@example.com", password: "WrongPassword" });

      expect(res.status).toBe(401);
    });

    test("401 si l'utilisateur n'existe pas", async () => {
      User.findOne.mockResolvedValue(null);

      const res = await request(app)
        .post("/api/auth/login")
        .send({ email: "nobody@example.com", password });

      expect(res.status).toBe(401);
    });
  });

  describe("GET /api/auth/validate", () => {
    test("200 avec un token valide", async () => {
      const token = generateToken({ id: 1, email: "bob@example.com", role: "user" });

      const res = await request(app)
        .get("/api/auth/validate")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body).toEqual({ message: "Token is valid" });
    });

    test("401 sans token", async () => {
      const res = await request(app).get("/api/auth/validate");
      expect(res.status).toBe(401);
    });
  });

  describe("GET /api/auth/users (réservé admin)", () => {
    test("200 + liste pour un admin", async () => {
      User.findAll.mockResolvedValue([
        { id: 1, email: "admin@example.com", role: "admin" },
      ]);
      const token = generateToken({ id: 1, email: "admin@example.com", role: "admin" });

      const res = await request(app)
        .get("/api/auth/users")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
    });

    test("403 pour un utilisateur non-admin", async () => {
      const token = generateToken({ id: 2, email: "bob@example.com", role: "user" });

      const res = await request(app)
        .get("/api/auth/users")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(403);
    });
  });

  describe("Route inconnue", () => {
    test("404 JSON via le middleware notFound", async () => {
      const res = await request(app).get("/api/unknown");
      expect(res.status).toBe(404);
      expect(res.body).toHaveProperty("message");
    });
  });
});
