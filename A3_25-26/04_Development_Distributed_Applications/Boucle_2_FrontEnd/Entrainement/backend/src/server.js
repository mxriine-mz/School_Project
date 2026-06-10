import "dotenv/config";
import app from "./app.js";
import { connectDB } from "./config/db.js";

// Point d'entree : on se connecte a la base puis on demarre le serveur HTTP.
const PORT = process.env.PORT || 5000;

const start = async () => {
  await connectDB();
  app.listen(PORT, () => {
    console.log(`🚀 Serveur demarre sur http://localhost:${PORT}`);
  });
};

start();
