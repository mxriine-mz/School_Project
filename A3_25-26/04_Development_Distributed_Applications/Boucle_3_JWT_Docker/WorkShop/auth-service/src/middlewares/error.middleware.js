/**
 * Gestion centralisée des erreurs.
 *
 * - notFound : déclenché quand aucune route ne correspond (404).
 * - errorHandler : middleware Express à 4 arguments, capte toute erreur
 *   passée à next(err) ou levée dans une route async correctement relayée.
 *   Il garantit une réponse JSON cohérente plutôt qu'une page HTML par défaut.
 */

function notFound(req, res, next) {
  res.status(404).json({ message: `Route not found: ${req.method} ${req.originalUrl}` });
}

// La signature à 4 paramètres (err, req, res, next) est ce qui identifie
// ce middleware comme gestionnaire d'erreurs auprès d'Express.
function errorHandler(err, req, res, next) {
  const status = err.status || 500;

  // On logge la stack côté serveur, mais on ne l'expose jamais au client.
  console.error(`[ERROR] ${req.method} ${req.originalUrl} -> ${err.message}`);

  res.status(status).json({
    message: status === 500 ? "Internal server error" : err.message,
  });
}

module.exports = { notFound, errorHandler };
