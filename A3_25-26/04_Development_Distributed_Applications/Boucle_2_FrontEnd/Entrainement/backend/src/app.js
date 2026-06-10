import express from "express";
import cors from "cors";
import fruitRoutes from "./routes/fruit.routes.js";
import { notFound, errorHandler } from "./middlewares/errorHandler.js";

// Construction de l'application Express (separee de server.js lors du
// refactor de la video 2 : ici on assemble middlewares + routes, server.js
// se contente de demarrer le serveur).
const app = express();

// --- Middlewares globaux ---
// CORS : en developpement on autorise toutes les origines (localhost,
// 127.0.0.1, IP de l'hote Windows sous WSL...). Pas de cookies/credentials
// ici, donc "*" est sans risque et evite les blocages selon l'URL d'acces.
app.use(cors());
app.use(express.json()); // parse le corps JSON des requetes

// --- Route de sante (pratique pour verifier que l'API tourne) ---
app.get("/", (req, res) => {
  res.json({ message: "API CRUD Fruits — OK", endpoints: "/api/fruits" });
});

// --- Routes metier ---
app.use("/api/fruits", fruitRoutes);

// --- Gestion des erreurs (toujours en dernier) ---
app.use(notFound);
app.use(errorHandler);

export default app;
