import mongoose from "mongoose";

// Connexion a MongoDB via Mongoose (video 1).
// L'URI provient des variables d'environnement (.env) pour ne jamais
// coder en dur les identifiants dans le code source.
export const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI);
    console.log(`✅ MongoDB connecte : ${conn.connection.host}/${conn.connection.name}`);
  } catch (error) {
    console.error(`❌ Erreur de connexion MongoDB : ${error.message}`);
    // On arrete le process : l'API n'a aucun sens sans base de donnees.
    process.exit(1);
  }
};
