// Middleware centralise de gestion des erreurs (bonne pratique du refactor,
// video 2). Toute erreur passee a next(error) arrive ici et renvoie une
// reponse JSON coherente plutot qu'une page d'erreur HTML d'Express.

// 404 : route inconnue
export const notFound = (req, res, next) => {
  res.status(404).json({ success: false, message: `Route introuvable : ${req.originalUrl}` });
};

// Gestionnaire global d'erreurs
export const errorHandler = (err, req, res, next) => {
  console.error("💥", err.message);

  // Erreur de validation Mongoose -> 400 avec le detail des champs
  if (err.name === "ValidationError") {
    const messages = Object.values(err.errors).map((e) => e.message);
    return res.status(400).json({ success: false, message: messages.join(", ") });
  }

  const status = res.statusCode && res.statusCode !== 200 ? res.statusCode : 500;
  res.status(status).json({ success: false, message: err.message || "Erreur serveur" });
};
