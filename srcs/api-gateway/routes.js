const express = require("express");
const amqp = require("amqplib/callback_api");

const router = express.Router();
let isBillingProcessing = false;

module.exports = (app) => {
  // Swagger documentation for Billing API
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
   */

  // Endpoint for billing
  router.post("/billing", (req, res) => {
    console.log("Billing request received:", req.body);

    if (isBillingProcessing) {
      console.log("Billing already in process. Processing order directly.");
      return res.status(200).send("Order processed without billing.");
    }

    isBillingProcessing = true;
    console.log("Starting billing process...");

    amqp.connect(process.env.RABBITMQ_URL, (error0, connection) => {
      if (error0) {
        console.error("RabbitMQ connection error:", error0);
        isBillingProcessing = false;
        return res
          .status(500)
          .send("Order processed directly, billing skipped.");
      }

      connection.createChannel((error1, channel) => {
        if (error1) {
          console.error("Channel creation error:", error1);
          isBillingProcessing = false;
          return res.status(500).send("Channel creation error");
        }

        const queue = "billing_queue";
        const msg = JSON.stringify(req.body);

        channel.assertQueue(queue, { durable: true });
        channel.sendToQueue(queue, Buffer.from(msg));
        console.log(`Message sent to queue ${queue}:`, msg);
        res.status(200).send("Order sent for processing");

        setTimeout(() => {
          connection.close();
          console.log("RabbitMQ connection closed.");
          isBillingProcessing = false;
        }, 500);
      });
    });
  });

  // Swagger documentation for Inventory API
  /**
   * @swagger
   * /api/inventory:
   *   post:
   *     summary: Add an item to inventory
   *     tags: [Inventory]
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             properties:
   *               itemName:
   *                 type: string
   *                 description: Name of the item
   *               quantity:
   *                 type: integer
   *                 description: Quantity to be added
   *   get:
   *     summary: Get inventory items
   *     tags: [Inventory]
   *     responses:
   *       200:
   *         description: List of inventory items
   *       500:
   *         description: Error fetching inventory data
   */

  // Endpoint for adding inventory item
  router.post("/inventory", async (req, res) => {
    try {
      console.log("Inventory add request received:", req.body);
      // Simulate inventory addition, replace with real logic
      res
        .status(201)
        .json({ message: "Item added to inventory", data: req.body });
    } catch (error) {
      console.error("Error adding inventory:", error);
      res.status(500).json({ message: "Error adding to inventory" });
    }
  });

  // Use the router in the app
  app.use("/api", router);
};
