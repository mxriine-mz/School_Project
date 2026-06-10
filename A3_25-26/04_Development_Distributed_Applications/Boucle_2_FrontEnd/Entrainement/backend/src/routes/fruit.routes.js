import { Router } from "express";
import {
  getFruits,
  getFruit,
  createFruit,
  updateFruit,
  deleteFruit,
} from "../controllers/fruit.controller.js";

// Routes : associent une URL + un verbe HTTP a une fonction du controleur.
const router = Router();

router.route("/").get(getFruits).post(createFruit);
router.route("/:id").get(getFruit).put(updateFruit).delete(deleteFruit);

export default router;
