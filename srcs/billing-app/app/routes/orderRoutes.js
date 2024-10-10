const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController'); // Importer le contrôleur
const { body, param } = require('express-validator');

/**
 * @swagger
 * tags:
 *   name: Orders
 *   description: API for managing orders
 */

/**
 * @swagger
 * /api/orders:
 *   post:
 *     summary: Create a new order
 *     tags: [Orders]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               user_id:
 *                 type: integer
 *               number_of_items:
 *                 type: integer
 *               total_amount:
 *                 type: number
 *                 format: float
 *     responses:
 *       201:
 *         description: Order created successfully
 *       400:
 *         description: Invalid input
 */
router.post('/orders', [
    body('user_id').isInt().withMessage('user_id doit être un entier'),
    body('number_of_items').isInt({ gt: 0 }).withMessage('number_of_items doit être un entier supérieur à 0'),
    body('total_amount').isDecimal({ decimal_digits: '2' }).withMessage('total_amount doit être un nombre décimal avec 2 chiffres après la virgule'),
], orderController.createOrder);

/**
 * @swagger
 * /api/orders:
 *   get:
 *     summary: Retrieve all orders
 *     tags: [Orders]
 *     responses:
 *       200:
 *         description: A list of orders
 */
router.get('/orders', orderController.getAllOrders);

/**
 * @swagger
 * /api/orders/{id}:
 *   get:
 *     summary: Retrieve an order by ID
 *     tags: [Orders]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: The ID of the order to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: A single order
 *       404:
 *         description: Order not found
 */
router.get('/orders/:id', orderController.getOrderById);

/**
 * @swagger
 * /api/orders/{id}:
 *   delete:
 *     summary: Delete an order by ID
 *     tags: [Orders]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: The ID of the order to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Order deleted successfully
 *       404:
 *         description: Order not found
 */
router.delete('/orders/:id', orderController.deleteOrder);

// (Optionnel) Ajouter une route pour mettre à jour une commande
// router.put('/orders/:id', orderController.updateOrder);

module.exports = router;
