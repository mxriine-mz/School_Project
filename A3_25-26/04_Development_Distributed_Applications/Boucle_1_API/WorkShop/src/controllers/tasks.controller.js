const { get } = require("mongoose");

// Initialisation d'un tableau vide pour stocker les tâches.
const Task = require('../models/task.model');

module.exports = {
    // Fonction asynchrone pour créer une nouvelle tâche.
    createTask: async (req, res) => {
        // Extraction des données de la requête : titre et contenu de la tâche.
        const { title, content } = req.body;

        // Vérification que le titre et le contenu sont présents.
        // Si l'un des deux est manquant, on retourne une réponse avec un statut 400 (Bad Request).
        if (!title || !content) return res.status(400).send("Title and content are required");

        try {
            // Création d'un nouvel objet tâche avec le titre et le contenu fournis.
            const newTask = new Task({ title, content });
            await newTask.save();

            // Envoi d'une réponse avec un statut 201 (Created) pour indiquer que la tâche a été créée avec succès.
            res.status(201).send("Task created successfully");
        } catch (err) {
            // En cas d'erreur, envoi d'une réponse avec un statut 500 (Internal Server Error)
            // et l'erreur sous forme de JSON.
            res.status(500).json(err);
        }
    },

    getAllTasks: async (req, res) => {
        try {
            // Récupérer toutes les tâches depuis la base de données
            const tasks = await Task.find();
            // Envoi d'une réponse avec un statut 200 (OK) et le tableau des tâches sous forme de JSON.
            res.status(200).json(tasks);
        } catch (err) {
            // En cas d'erreur, envoi d'une réponse avec un statut 500 (Internal Server Error)
            // et l'erreur sous forme de JSON.
            res.status(500).json(err);
        }
    },

    findOneTask: async (req, res) => {
        try {
            // Récupérer une tâche spécifique en utilisant son ID depuis les paramètres de la requête
            const task = await Task.findById(req.params.id);
            if (!task) return res.status(404).send("Task not found");
            // Envoi d'une réponse avec un statut 200 (OK) et la tâche trouvée sous forme de JSON.
            res.status(200).json(task);
        } catch (err) {
            // En cas d'erreur, envoi d'une réponse avec un statut 500 (Internal Server Error)
            // et l'erreur sous forme de JSON.
            res.status(500).json(err);
        }
    },

    findOneTaskAndUpdate: async (req, res) => {
        try {
            // Récupérer une tâche spécifique en utilisant son ID depuis les paramètres de la requête
            const task = await Task.findByIdAndUpdate(req.params.id, req.body, { new: true });
            if (!task) return res.status(404).send("Task not found");
            // Envoi d'une réponse avec un statut 200 (OK) et la tâche mise à jour sous forme de JSON.
            res.status(200).json(task);
        } catch (err) {
            // En cas d'erreur, envoi d'une réponse avec un statut 500 (Internal Server Error)
            // et l'erreur sous forme de JSON.
            res.status(500).json(err);
        }
    },

    findOneTaskAndDelete: async (req, res) => {
        try {
            // Récupérer une tâche spécifique en utilisant son ID depuis les paramètres de la requête
            const task = await Task.findByIdAndDelete(req.params.id);
            if (!task) return res.status(404).send("Task not found");
            // Envoi d'une réponse avec un statut 200 (OK) pour indiquer que la tâche a été supprimée avec succès.
            res.status(200).send("Task deleted successfully");
        } catch (err) {
            // En cas d'erreur, envoi d'une réponse avec un statut 500 (Internal Server Error)
            // et l'erreur sous forme de JSON.
            res.status(500).json(err);
        }
    }
};
