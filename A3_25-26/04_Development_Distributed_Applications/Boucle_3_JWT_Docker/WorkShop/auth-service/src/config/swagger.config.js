const swaggerJSDoc = require("swagger-jsdoc");

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Auth Service API",
      version: "1.0.0",
      description:
        "Service d'authentification du workshop JWT : inscription, connexion et validation de token.",
    },
    servers: [
      { url: "/api", description: "Accès direct au service" },
      { url: "/", description: "Accès via la gateway NGINX (port 8080)" },
    ],
    components: {
      // Définition du schéma de sécurité : un Bearer token (JWT)
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
      schemas: {
        Credentials: {
          type: "object",
          required: ["email", "password"],
          properties: {
            email: { type: "string", format: "email", example: "bob@example.com" },
            password: { type: "string", example: "Password123!" },
          },
        },
        PublicUser: {
          type: "object",
          properties: {
            email: { type: "string", example: "bob@example.com" },
            role: { type: "string", example: "user" },
          },
        },
        Token: {
          type: "object",
          properties: {
            token: { type: "string", example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." },
          },
        },
        Message: {
          type: "object",
          properties: {
            message: { type: "string", example: "Token is valid" },
          },
        },
      },
    },
  },
  // Fichiers scannés pour récupérer les annotations @swagger (JSDoc)
  apis: ["./src/routes/*.js"],
};

module.exports = swaggerJSDoc(options);
