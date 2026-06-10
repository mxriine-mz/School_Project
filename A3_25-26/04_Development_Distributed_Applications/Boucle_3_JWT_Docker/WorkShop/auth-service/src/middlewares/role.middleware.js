/**
 * Middleware d'autorisation par rôle.
 *
 * À utiliser APRÈS le middleware `authenticate` (qui remplit req.user).
 * Exemple : router.get("/users", authenticate, authorize("admin"), controller)
 *
 * @param  {...string} allowedRoles - rôles autorisés à accéder à la route
 */
function authorize(...allowedRoles) {
  return (req, res, next) => {
    // Sécurité : l'authentification doit avoir eu lieu avant
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    // L'utilisateur est authentifié mais son rôle n'est pas autorisé
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ message: "Forbidden: insufficient role" });
    }

    next();
  };
}

module.exports = { authorize };
