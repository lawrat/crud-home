// Endpoint pour la facturation
/**
 * @swagger
 * /api/billing:
 *   post:
 *     summary: Create a billing request
 *     tags: [Billing]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               customerId:
 *                 type: string
 *                 description: ID of the customer making the billing request
 *               amount:
 *                 type: number
 *                 description: Amount to be billed
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     itemId:
 *                       type: string
 *                       description: ID of the item being billed
 *                     quantity:
 *                       type: integer
 *                       description: Quantity of the item
 *     responses:
 *       200:
 *         description: Command sent for processing successfully
 *       500:
 *         description: Error occurred while sending the message to the queue
 */
app.post('/api/billing', (req, res) => {
  console.log('Requête de facturation reçue:', req.body); // Log de la requête reçue
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

      const queue = 'billing_queue'; // Assurez-vous que cela correspond à ce que votre serveur de facturation écoute
      const msg = JSON.stringify(req.body);

      channel.assertQueue(queue, { durable: true });

      channel.sendToQueue(queue, Buffer.from(msg), {}, (error) => {
        if (error) {
          console.error('Erreur lors de l\'envoi du message:', error);
          return res.status(500).send('Erreur lors de l\'envoi du message à la file d\'attente');
        }
        console.log(`Message envoyé à la file d'attente ${queue}:`, msg);
        res.status(200).send('Commande envoyée pour traitement');
      });
    });

    setTimeout(() => {
      connection.close();
    }, 500);
  });
});
