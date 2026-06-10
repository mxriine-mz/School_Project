const express = require("express");
const router = express.Router();
const AuthController = require("../controllers/auth.controller");
const { authenticate } = require("../middlewares/auth.middleware");
const { authorize } = require("../middlewares/role.middleware");

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Authentification (inscription, connexion, validation de token)
 */

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Inscription d'un nouvel utilisateur
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/x-www-form-urlencoded:
 *           schema:
 *             $ref: '#/components/schemas/Credentials'
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Credentials'
 *     responses:
 *       201:
 *         description: Utilisateur créé
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PublicUser'
 *       400:
 *         description: Requête invalide (email déjà utilisé, données manquantes)
 */
router.post("/register", AuthController.register);

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Connexion et génération d'un token JWT
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/x-www-form-urlencoded:
 *           schema:
 *             $ref: '#/components/schemas/Credentials'
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Credentials'
 *     responses:
 *       200:
 *         description: Connexion réussie, token renvoyé
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Token'
 *       401:
 *         description: Identifiants invalides
 */
router.post("/login", AuthController.login);

/**
 * @swagger
 * /auth/validate:
 *   get:
 *     summary: Vérifie la validité d'un token JWT
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Token valide
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Message'
 *       401:
 *         description: Token absent, invalide ou expiré
 */
router.get("/validate", authenticate, AuthController.validate);

/**
 * @swagger
 * /auth/users:
 *   get:
 *     summary: Liste tous les utilisateurs (réservé aux admins)
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Liste des utilisateurs
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/PublicUser'
 *       401:
 *         description: Token absent ou invalide
 *       403:
 *         description: Rôle insuffisant (non admin)
 */
router.get("/users", authenticate, authorize("admin"), AuthController.listUsers);

module.exports = router;
