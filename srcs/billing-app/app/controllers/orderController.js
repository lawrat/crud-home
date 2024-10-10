const { Order } = require('../models/orderModel');

// Créer une commande
exports.createOrder = async (req, res) => {
    const { user_id, number_of_items, total_amount } = req.body;

    // Validation des données requises
    if (!user_id || !number_of_items || !total_amount) {
        return res.status(400).json({ error: 'user_id, number_of_items et total_amount sont requis.' });
    }

    try {
        const order = await Order.create({
            user_id,
            number_of_items,
            total_amount
        });
        res.status(201).json(order);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Récupérer toutes les commandes
exports.getAllOrders = async (req, res) => {
    try {
        const orders = await Order.findAll();
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Récupérer une commande par ID
exports.getOrderById = async (req, res) => {
    try {
        const order = await Order.findByPk(req.params.id);
        if (order) {
            res.status(200).json(order);
        } else {
            res.status(404).json({ error: 'Commande non trouvée' });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Supprimer une commande
exports.deleteOrder = async (req, res) => {
    try {
        const order = await Order.destroy({ where: { id: req.params.id } });
        if (order) {
            res.status(204).send();
        } else {
            res.status(404).json({ error: 'Commande non trouvée' });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
