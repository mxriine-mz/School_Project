module.exports = {
  testEnvironment: "node",
  testMatch: ["**/tests/**/*.test.js"],
  // Force l'environnement de test (désactive le logging morgan, etc.)
  setupFiles: ["<rootDir>/tests/setup.js"],
  clearMocks: true,
};
