import mongoose from "mongoose";
import { Fruit } from "../models/fruit.model.js";

// Controleur (le "C" de MVC) : logique metier de chaque operation CRUD.

// GET /api/fruits  -> liste tous les fruits
export const getFruits = async (req, res, next) => {
  try {
    const fruits = await Fruit.find().sort({ createdAt: -1 });
    res.status(200).json({ success: true, count: fruits.length, data: fruits });
  } catch (error) {
    next(error);
  }
};

// GET /api/fruits/:id  -> un fruit par son id
export const getFruit = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Identifiant invalide" });
    }
    const fruit = await Fruit.findById(id);
    if (!fruit) {
      return res.status(404).json({ success: false, message: "Fruit introuvable" });
    }
    res.status(200).json({ success: true, data: fruit });
  } catch (error) {
    next(error);
  }
};

// POST /api/fruits  -> cree un fruit
export const createFruit = async (req, res, next) => {
  try {
    const fruit = await Fruit.create(req.body);
    res.status(201).json({ success: true, data: fruit });
  } catch (error) {
    next(error);
  }
};

// PUT /api/fruits/:id  -> met a jour un fruit
export const updateFruit = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Identifiant invalide" });
    }
    const fruit = await Fruit.findByIdAndUpdate(id, req.body, {
      new: true, // renvoie le document mis a jour
      runValidators: true, // applique les regles du schema
    });
    if (!fruit) {
      return res.status(404).json({ success: false, message: "Fruit introuvable" });
    }
    res.status(200).json({ success: true, data: fruit });
  } catch (error) {
    next(error);
  }
};

// DELETE /api/fruits/:id  -> supprime un fruit
export const deleteFruit = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Identifiant invalide" });
    }
    const fruit = await Fruit.findByIdAndDelete(id);
    if (!fruit) {
      return res.status(404).json({ success: false, message: "Fruit introuvable" });
    }
    res.status(200).json({ success: true, message: "Fruit supprime", data: fruit });
  } catch (error) {
    next(error);
  }
};
