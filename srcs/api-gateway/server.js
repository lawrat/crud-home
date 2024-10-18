// server.js

// Importez les modules nécessaires
require("dotenv").config(); // Charger les variables d'environnement
const express = require("express");
const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");
const swaggerDocument = YAML.load("./openapi.yaml"); // Chemin vers votre fichier OpenAPI YAML
const cors = require("cors");

// Vérifiez que toutes les variables d'environnement nécessaires sont définies
const requiredEnvVars = [
  "PORT",
  "INVENTORY_API_URL",
  "BILLING_API_URL",
  "RABBITMQ_URL",
];
requiredEnvVars.forEach((varName) => {
  if (!process.env[varName]) {
    console.error(
      `Erreur : La variable d'environnement ${varName} est manquante.`
    );
    process.exit(1);
  }
});

const app = express();
app.use(express.json());
app.use(cors()); // Assurez-vous que CORS est appliqué avant vos routes

// Configurez Swagger pour la documentation
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Importez le proxy pour gérer les requêtes vers les API externes
require("./proxy")(app); // Utilise le proxy défini dans proxy.js

// Importez les routes locales
require("./routes")(app); // Passer une fonction pour accéder à l'état

// Route d'accueil
app.get("/", (req, res) => {
  res.send("Bienvenue dans l'application Gateway !");
});

// Middleware de gestion des erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Quelque chose s'est mal passé !");
});

// Lancer l'API Gateway sur le port défini
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`API Gateway en cours d'exécution sur le port ${PORT}`);
});
