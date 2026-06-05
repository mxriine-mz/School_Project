// Importation du module Express
const express = require('express');

// Création d'une nouvelle instance de Router pour définir les routes
const router = express.Router();

// Importe le contrôleur des tâches depuis le fichier tasks.controller.js
const tasksController = require('../controllers/tasks.controller');

// Importer le middleware 'requiredFields' pour vérifier les champs requis dans les requêtes
const requiredFields = require('../middlewares/requiredFields.middleware');

// Définition d'une route POST pour la création d'une nouvelle tâche
router.post('/', requiredFields(["title", "content"]), tasksController.createTask);

// Définition d'une route GET pour récupérer toutes les tâches
router.get('/', tasksController.getAllTasks);

// Définition d'une route GET pour récupérer une tâche spécifique par son ID
router.get('/:id', tasksController.findOneTask);

// Définition d'une route PUT pour mettre à jour une tâche spécifique par son ID
router.put('/:id', requiredFields(["title", "content", "completed"]), tasksController.findOneTaskAndUpdate);

// Définition d'une route DELETE pour supprimer une tâche spécifique par son ID
router.delete('/:id', tasksController.findOneTaskAndDelete);

// Exportation du routeur pour pouvoir l'utiliser dans d'autres fichiers
module.exports = router;
