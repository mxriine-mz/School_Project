const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger.config');
const authRoutes = require('./routes/auth.route');
const { logger } = require('./middlewares/logger.middleware');
const { notFound, errorHandler } = require('./middlewares/error.middleware');

// Construit et configure l'application Express, SANS démarrer le serveur
// ni se connecter à la base. Cela permet de la réutiliser dans les tests
// (supertest) tout en gardant le démarrage réel dans index.js.
const app = express();

// --- Middlewares globaux ---
app.use(logger);                              // logging HTTP des requêtes
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// --- Documentation ---
app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.get('/api/docs.json', (req, res) => res.json(swaggerSpec));

// --- Routes ---
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});
app.use('/api/auth', authRoutes);

// --- Gestion des erreurs (toujours en dernier) ---
app.use(notFound);       // 404 pour toute route non trouvée
app.use(errorHandler);   // gestionnaire global d'erreurs

module.exports = app;
