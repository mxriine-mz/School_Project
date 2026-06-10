const { verifyToken } = require("../utils/jwt.util");

function authenticate(req, res, next) {
  // Récupérer le header "Authorization"
  const authHeader = req.headers["authorization"];

  // Aucun header fourni → on refuse l'accès
  if (!authHeader) {
    return res.status(401).json({ message: "No token provided" });
  }

  // Extraire uniquement le token du header (format attendu: "Bearer <token>")
  const token = authHeader.split(" ")[1];

  try {
    // Vérifier le token grâce à la fonction verifyToken
    const decoded = verifyToken(token);

    // verifyToken renvoie null si le token est invalide ou expiré
    if (!decoded) {
      return res.status(401).json({ message: "Invalid token" });
    }

    // Stocker les informations décodées dans req.user pour les rendre accessibles ensuite
    req.user = decoded;

    // Passer la main au prochain middleware / controller
    next();
  } catch (err) {
    // Token invalide ou expiré
    return res.status(401).json({ message: "Invalid token" });
  }
}

module.exports = { authenticate };
