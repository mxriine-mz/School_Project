import mongoose from "mongoose";

// Modele (le "M" de MVC) : decrit la structure d'un Fruit en base
// et ses regles de validation.
const fruitSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Le nom du fruit est obligatoire"],
      trim: true,
    },
    price: {
      type: Number,
      required: [true, "Le prix est obligatoire"],
      min: [0, "Le prix ne peut pas etre negatif"],
    },
    quantity: {
      type: Number,
      default: 0,
      min: [0, "La quantite ne peut pas etre negative"],
    },
    image: {
      type: String,
      default: "",
      trim: true,
    },
  },
  {
    // Ajoute automatiquement createdAt / updatedAt
    timestamps: true,
  }
);

export const Fruit = mongoose.model("Fruit", fruitSchema);
