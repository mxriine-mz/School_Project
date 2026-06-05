//Importation du module 'express' pour créer une application web
const express = require('express');

// Importer la bibliothèque Mongoose pour interagir avec MongoDB
const mongoose = require('mongoose');

// Importer le module 'dotenv' pour charger les variables d'environnement à partir d'un fichier .env
// On précise le chemin car le .env se trouve dans le dossier src/ (à côté de ce fichier)
require('dotenv').config({ path: require('path').join(__dirname, '.env') });

// Création d'une instance de l'application Express
const app = express();

// Définition du port sur lequel l'application va écouter les requêtes
const port = 3000;

// Middleware pour parser les données JSON dans les requêtes entrantes
app.use(express.json());

// Toutes les requêtes commençant par '/api/tasks' seront dirigées vers le module de routes défini dans './routes/tasks.routes'
app.use('/api/tasks', require('./routes/tasks.routes'));

// Définition d'une route GET pour la racine du site ('/') qui envoie une réponse "Hello World!" lorsque cette route est accédée
app.get('/', (req, res) => {
  res.send('Hello World!');
});

// Connexion à la base de donnée MongoDB en utilisant Mongoose
mongoose
    .connect("mongodb://" + process.env.MONGO_HOST + ":" + process.env.MONGO_PORT + "/" + process.env.MONGO_DB_NAME)
    .then(() => {
        console.log("Connected to MongoDB");
        
        // Démarrage de l'application en écoutant sur le port défini et affichage d'un message dans la console lorsque l'application est prête à recevoir des requêtes
        app.listen(port, () => {
        console.log(`Example app listening on port ${port}`);
        });
    })
    .catch((err) => {
        console.error("Error connecting to MongoDB:", err);
    });

