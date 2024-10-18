const express = require("express");
const orderController = require("./app/controllers/orderController"); // Vérifiez ce chemin
require("./app/services/rabbitMQ"); // Lancer RabbitMQ

const swaggerUi = require("swagger-ui-express"); // Importez les routes pour les films
const swaggerSetup = require("./app/swagger");
const YAML = require("yamljs");
const swaggerDocument = YAML.load("./app/openapi.yaml"); // Chemin vers votre fichier OpenAPI YAML

const app = express();
const PORT = process.env.PORT || 3000;
swaggerSetup(app);

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Middleware pour analyser le corps des requêtes en JSON
app.use(express.json());

// Route d'accueil
app.get("/", (req, res) => {
  res.send("Bienvenue dans l'application de facturattion !");
});

// Route pour créer une commande
app.post("/orders", orderController.createOrder);

// Route pour récupérer toutes les commandes
app.get("/orders", orderController.getAllOrders);

// Route pour récupérer une commande par ID
app.get("/orders/:id", orderController.getOrderById);

// Route pour supprimer une commande
app.delete("/orders/:id", orderController.deleteOrder);

// Middleware pour gérer les erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Une erreur est survenue" });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Serveur en cours d'exécution sur le port ${PORT}`);
});
