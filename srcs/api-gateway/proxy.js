require('dotenv').config(); // Charger les variables d'environnement
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware'); // Utiliser createProxyMiddleware
const amqp = require('amqplib/callback_api');

const app = express();
app.use(express.json()); // Pour parser les requêtes JSON

// Charger les variables d'environnement depuis le fichier .env
const RABBITMQ_URL = process.env.RABBITMQ_URL;
const BILLING_API_URL = process.env.BILLING_API_URL;
const INVENTORY_API_URL = process.env.INVENTORY_API_URL;

// Proxy vers l'API Inventory
app.use('/api/inventory', createProxyMiddleware({
  target: INVENTORY_API_URL,
  changeOrigin: true,
  pathRewrite: {
    '^/api/inventory': '' // Réécriture de l'URL si nécessaire
  },
  onError: (err, req, res) => {
    console.error('Erreur de proxy:', err);
    res.status(500).send('Erreur de connexion à l\'API d\'inventaire');
  }
}));

// Endpoint pour la facturation
app.post('/api/billing', (req, res) => {
  amqp.connect(RABBITMQ_URL, (error0, connection) => {
    if (error0) {
      console.error('Erreur de connexion à RabbitMQ:', error0);
      return res.status(500).send('Erreur lors de la connexion à RabbitMQ');
    }

    connection.createChannel((error1, channel) => {
      if (error1) {
        console.error('Erreur lors de la création du canal:', error1);
        return res.status(500).send('Erreur lors de la création du canal');
      }

      const queue = 'billing_queue';
      const msg = JSON.stringify(req.body);

      channel.assertQueue(queue, {
        durable: true // Assurer que la file d'attente est durable
      });

      channel.sendToQueue(queue, Buffer.from(msg));
      console.log(`Message envoyé à la file d'attente ${queue}:`, msg);
      res.status(200).send('Commande envoyée pour traitement');
    });

    // Fermer la connexion après un délai pour permettre l'envoi du message
    setTimeout(() => {
      connection.close();
    }, 500);
  });
});

// Lancer l'API Gateway sur le port 4000
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});
