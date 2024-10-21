const amqp = require("amqplib");
require("dotenv").config();
const { Order } = require("../models/orderModel");

async function processOrder(order) {
  try {
    console.log("Commande reçue pour insertion :", order);

    // Assurez-vous que les champs requis sont présents dans l'objet order
    if (!order.user_id || !order.number_of_items || !order.total_amount) {
      throw new Error(
        "Les champs requis (user_id, number_of_items, total_amount) sont manquants"
      );
    }

    const newOrder = await Order.create(order); // Utilisez le modèle Order ici
    console.log("Commande insérée :", newOrder);
  } catch (error) {
    console.error("Erreur lors du traitement de la commande:", error);
  }
}

async function start() {
  try {
    const connection = await amqp.connect(process.env.RABBITMQ_URL);
    console.log("Connexion à RabbitMQ réussie");

    const channel = await connection.createChannel();
    const queue = "billing_queue"; // Assurez-vous d'utiliser le même nom de queue

    await channel.assertQueue(queue, {
      durable: true,
    });

    console.log("En attente de messages dans la queue:", queue);

    channel.consume(queue, (msg) => {
      if (msg !== null) {
        const order = JSON.parse(msg.content.toString());
        console.log("Message reçu :", order); // Ajout d'un log ici
        processOrder(order);
        channel.ack(msg); // Accuse réception du message uniquement après le traitement
      } else {
        console.log("Aucun message à traiter");
      }
    });
  } catch (error) {
    console.error("Erreur de connexion à RabbitMQ:", error);
  }
}

start();
