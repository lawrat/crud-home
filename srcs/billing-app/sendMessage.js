const amqp = require('amqplib');
require('dotenv').config();

async function sendMessage(order) {
    try {
        const connection = await amqp.connect(process.env.RABBITMQ_URL);
        const channel = await connection.createChannel();
        const queue = 'billing_queue';

        await channel.assertQueue(queue, {
            durable: true,
        });

        channel.sendToQueue(queue, Buffer.from(JSON.stringify(order)), {
            persistent: true,
        });

        console.log('Message envoyé:', order);
        await channel.close();
        await connection.close();
    } catch (error) {
        console.error('Erreur d\'envoi du message:', error);
    }
}

// Exemple de commande à envoyer
const order = {
    user_id: 6,          // Remplace par l'ID de l'utilisateur
    number_of_items: 2,  // Quantité d'articles
    total_amount: 174.90   // Montant total de la commande
};
sendMessage(order);
