require('dotenv').config();
const app = require('./app');
const sequelize = require('./config/database.config');

const port = process.env.API_PORT || 3000;

// Nombre de tentatives et délai entre chaque essai de connexion à la base.
// Utile au démarrage du compose : Postgres peut mettre quelques secondes
// avant d'accepter les connexions.
const MAX_RETRIES = parseInt(process.env.DB_MAX_RETRIES, 10) || 10;
const RETRY_DELAY_MS = parseInt(process.env.DB_RETRY_DELAY_MS, 10) || 3000;

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function connectWithRetry() {
  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    try {
      await sequelize.authenticate();
      console.log('Database connection has been established successfully.');
      return;
    } catch (err) {
      console.warn(
        `DB connection attempt ${attempt}/${MAX_RETRIES} failed: ${err.message}`
      );
      if (attempt === MAX_RETRIES) throw err;
      await wait(RETRY_DELAY_MS);
    }
  }
}

async function startServer() {
  try {
    await connectWithRetry();

    await sequelize.sync({ alter: true });
    console.log('Tables synchronized');

    app.listen(port, () => {
      console.log(`Server is running on http://localhost:${port}`);
    });
  } catch (err) {
    // Échec définitif : on quitte avec un code d'erreur pour que Docker
    // (politique restart) puisse relancer le conteneur proprement.
    console.error('Unable to connect to the database after retries:', err.message);
    process.exit(1);
  }
}

startServer();
