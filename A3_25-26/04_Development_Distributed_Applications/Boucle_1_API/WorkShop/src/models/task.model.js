// Import de la bibliothèque Mongoose pour interagir avec MongoDB
const mongoose = require('mongoose');

// Définition d'un schéma pour une collection de tâches
const taskSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true
    },
    content: {
        type: String,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    completed: {
        type: Boolean,
        default: false
    }
});

// Création d'un modèle basé sur le schéma
const Task = mongoose.model('Task', taskSchema);

// Exportation du modèle pour pouvoir l'utiliser dans d'autres fichiers
module.exports = Task;