const { DataTypes } = require('sequelize');
const sequelize = require('../config/db'); // Chemin vers votre configuration de base de données

const Order = sequelize.define('Order', {
    user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    number_of_items: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    total_amount: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
    },
}, {
    tableName: 'orders', // Assurez-vous que cela correspond au nom de votre table
    timestamps: false, // Crée les champs createdAt et updatedAt
});

// Synchroniser le modèle avec la base de données (à faire uniquement en développement)
// Order.sync(); // À commenter si déjà synchronisé dans une autre partie de l'application

module.exports = { Order }; // Pour exporter un objet avec la clé Order
