import "dotenv/config";
import { connectDB } from "./config/db.js";
import { Fruit } from "./models/fruit.model.js";
import mongoose from "mongoose";

// Petit script utilitaire : remplit la base avec quelques fruits de demo.
// Lancer avec : npm run seed
const demoFruits = [
  {
    name: "Banana",
    price: 12,
    quantity: 50,
    image: "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg",
  },
  {
    name: "Apple",
    price: 20,
    quantity: 30,
    image: "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
  },
  {
    name: "Orange",
    price: 8,
    quantity: 40,
    image: "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg",
  },
];

const run = async () => {
  await connectDB();
  await Fruit.deleteMany({});
  await Fruit.insertMany(demoFruits);
  console.log(`🌱 ${demoFruits.length} fruits inseres.`);
  await mongoose.connection.close();
  process.exit(0);
};

run();
