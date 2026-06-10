require("dotenv").config();
const sequelize = require("../config/database.config");
const User = require("../models/user.model");
const { hashPassword } = require("../utils/bcrypt.util");

// Jeu de données initial inséré dans la base
const usersToSeed = [
  { email: "admin@example.com", password: "admin123", role: "admin" },
  { email: "user@example.com", password: "user123", role: "user" },
];

async function seedUsers() {
  // Sécurité : on interdit l'exécution de la seed hors environnement autorisé
  if (process.env.SEED_ENABLED !== "true") {
    console.error(
      "Seed désactivée. Définir SEED_ENABLED=true pour l'exécuter (jamais en production)."
    );
    process.exit(1);
  }

  try {
    // Vérifie la connexion et synchronise le modèle avec la table
    await sequelize.authenticate();
    await sequelize.sync();

    for (const data of usersToSeed) {
      const passwordHash = await hashPassword(data.password);

      // findOrCreate évite de dupliquer un utilisateur déjà présent
      const [user, created] = await User.findOrCreate({
        where: { email: data.email },
        defaults: { passwordHash, role: data.role },
      });

      console.log(
        created
          ? `Utilisateur créé : ${user.email} (${user.role})`
          : `Utilisateur déjà existant : ${user.email}`
      );
    }

    console.log("Seed terminée avec succès.");
    process.exit(0);
  } catch (error) {
    console.error("Erreur lors de la seed :", error.message);
    process.exit(1);
  }
}

seedUsers();
