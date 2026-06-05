module.exports = (fieldsRequired) => {
    return (req, res, next) => {
        // Tableau pour stocker les champs manquants
        const missingFields = [];

        // Vérification de chaque champ requis
        fieldsRequired.forEach(field => {
            if (!req.body[field]) {
                missingFields.push(field); // Ajoute le champ manquant au tableau
            }
        });

        // Si des champs sont manquants, retourne une réponse avec un statut 400 (Bad Request)
        if (missingFields.length > 0) {
            return res.status(400).json({ error: `Missing required fields: ${missingFields.join(', ')}` });
        }

        // Si tous les champs requis sont présents, passe au middleware suivant
        next();
    };
};