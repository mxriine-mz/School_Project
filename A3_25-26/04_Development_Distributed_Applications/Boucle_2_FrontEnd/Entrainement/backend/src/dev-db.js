import { MongoMemoryServer } from "mongodb-memory-server";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

// Lance un vrai MongoDB local SANS installation systeme (pratique sous WSL).
// Les donnees sont conservees dans backend/.mongo-data pour survivre aux
// redemarrages. A garder ouvert dans un terminal pendant qu'on teste l'app.
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dbPath = path.join(__dirname, "..", ".mongo-data");
fs.mkdirSync(dbPath, { recursive: true });

const mongod = await MongoMemoryServer.create({
  instance: { port: 27017, dbPath, storageEngine: "wiredTiger" },
});

console.log(`🍃 MongoDB local pret : ${mongod.getUri()}`);
console.log("   (Ctrl+C pour arreter — les donnees restent dans backend/.mongo-data)");

// Arret propre
const stop = async () => {
  await mongod.stop({ doCleanup: false });
  process.exit(0);
};
process.on("SIGINT", stop);
process.on("SIGTERM", stop);
