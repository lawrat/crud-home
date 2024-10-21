const amqp = require("amqplib");

async function testRabbitMQ() {
  try {
    // Connexion à RabbitMQ
    const connection = await amqp.connect(process.env.RABBITMQ_URL);
    const channel = await connection.createChannel();
    const queue = "billing_queue";

    // Assurez-vous que la queue existe
    await channel.assertQueue(queue, { durable: true });
    console.log(`Connecté à RabbitMQ. La queue "${queue}" est prête.`);

    // Fermez la connexion et le canal
    await channel.close();
    await connection.close();
  } catch (error) {
    console.error("Erreur de connexion à RabbitMQ:", error);
  }
}

testRabbitMQ();
