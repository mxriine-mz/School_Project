const morgan = require("morgan");

// Logging HTTP des requêtes entrantes.
// - format "dev" (coloré, concis) en développement
// - format "combined" (standard Apache, complet) sinon
const format = process.env.NODE_ENV === "production" ? "combined" : "dev";

// En environnement de test, on désactive le logging pour ne pas polluer
// la sortie de Jest (middleware passe-plat).
const logger =
  process.env.NODE_ENV === "test"
    ? (req, res, next) => next()
    : morgan(format);

module.exports = { logger };
