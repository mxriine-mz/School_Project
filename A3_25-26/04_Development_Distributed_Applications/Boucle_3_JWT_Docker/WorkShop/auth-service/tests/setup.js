// Exécuté avant chaque suite de tests.
// Garantit un environnement de test cohérent et indépendant du .env.
process.env.NODE_ENV = "test";
process.env.JWT_SECRET = process.env.JWT_SECRET || "test-secret";
process.env.JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "1h";
process.env.SALT_ROUNDS = process.env.SALT_ROUNDS || "4"; // plus rapide en test
