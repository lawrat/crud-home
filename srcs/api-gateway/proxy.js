const { createProxyMiddleware } = require("http-proxy-middleware");
const amqp = require("amqplib/callback_api");
require("dotenv").config();
const fetch = require("node-fetch");
module.exports = (app) => {
  const INVENTORY_API_URL = process.env.INVENTORY_API_URL;
  const BILLING_API_URL = process.env.BILLING_API_URL;
  const RABBITMQ_URL = process.env.RABBITMQ_URL;
  console.log("URL de l'API Inventory:", INVENTORY_API_URL);
  console.log("URL de l'API Billing:", BILLING_API_URL);
  console.log("URL de RabbitMQ:", RABBITMQ_URL);
  

  // Proxy pour Inventory API
  app.use("/api/inventory", (req, res) => {
    // Vérifiez si c'est une requête POST
    if (req.method === "POST") {
      const inventoryRequestBody = req.body;

      // Tentative d'appel à l'API Inventory
      const inventoryApiRequestOptions = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(inventoryRequestBody),
      };

      fetch(INVENTORY_API_URL, inventoryApiRequestOptions)
        .then((response) => {
          if (!response.ok) {
            throw new Error("Erreur lors de l'appel à l'API Inventory");
          }
          return response.json();
        })
        .then((data) => {
          // Si la requête à l'API Inventory réussit
          res.status(200).json(data);
        })
        .catch((error) => {
          console.error("Erreur lors de l'appel à l'API Inventory:", error);
          res.status(500).send("Erreur lors de la connexion à l'API Inventory");
        });
    } else if (req.method === "GET") {
      // Gérer la requête GET ici
      fetch(INVENTORY_API_URL)
        .then((response) => {
          if (!response.ok) {
            throw new Error("Erreur lors de l'appel à l'API Inventory");
          }
          return response.json();
        })
        .then((data) => {
          res.status(200).json(data);
        })
        .catch((error) => {
          console.error(
            "Erreur lors de la récupération des données de l'inventaire:",
            error
          );
          res
            .status(500)
            .send("Erreur lors de la récupération des données de l'inventaire");
        });
    } else {
      // Gérer les autres méthodes HTTP (OPTIONS, PUT, DELETE, etc.)
      res.status(405).send("Méthode non autorisée");
    }
  });
  // Route pour Billing API gérant GET et POST
  app.use("/api/billing", (req, res) => {
    // Vérifiez si c'est une requête POST
    if (req.method === "POST") {
      const billingRequestBody = req.body;

      // Tentative d'appel à l'API de facturation
      const billingApiRequestOptions = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(billingRequestBody),
      };

      fetch(BILLING_API_URL, billingApiRequestOptions)
        .then((response) => {
          if (!response.ok) {
            throw new Error("Erreur lors de l'appel à l'API de facturation");
          }
          return response.json();
        })
        .then((data) => {
          // Si la requête à l'API de facturation réussit
          res.status(200).json(data);
        })
        .catch((error) => {
          console.error(
            "API de facturation non disponible, envoi à RabbitMQ:",
            error
          );

          // Si l'API de facturation échoue, envoyer le message à RabbitMQ
          amqp.connect(RABBITMQ_URL, (error0, connection) => {
            if (error0) {
              console.error("Erreur de connexion à RabbitMQ:", error0);
              return res
                .status(500)
                .send("Erreur lors de la connexion à RabbitMQ");
            }

            console.log("Connexion à RabbitMQ réussie.");
            connection.createChannel((error1, channel) => {
              if (error1) {
                console.error("Erreur lors de la création du canal:", error1);
                return res
                  .status(500)
                  .send("Erreur lors de la création du canal RabbitMQ");
              }

              const queue = "billing_queue";
              const msg = JSON.stringify(billingRequestBody);

              channel.assertQueue(queue, {
                durable: true,
              });

              channel.sendToQueue(queue, Buffer.from(msg));
              console.log(`Message envoyé à la file d'attente ${queue}:`, msg);
              res
                .status(200)
                .send("Commande envoyée pour traitement via RabbitMQ");

              // Fermer la connexion après un délai pour permettre l'envoi du message
              setTimeout(() => {
                connection.close();
                console.log("Connexion à RabbitMQ fermée.");
              }, 500);
            });
          });
        });
    } else if (req.method === "GET") {
      // Gérer la requête GET ici
      fetch(BILLING_API_URL)
        .then((response) => {
          if (!response.ok) {
            throw new Error("Erreur lors de l'appel à l'API de facturation");
          }
          return response.json();
        })
        .then((data) => {
          res.status(200).json(data);
        })
        .catch((error) => {
          console.error(
            "Erreur lors de la récupération des données de facturation:",
            error
          );
          res
            .status(500)
            .send("Erreur lors de la récupération des données de facturation");
        });
    }
  });
};
