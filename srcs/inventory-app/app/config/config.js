const { Sequelize } = require('sequelize');

// Connexion à la base de données avec Sequelize
const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASS, {
  host: process.env.DB_HOST,
  dialect: 'postgres', // ou 'mysql' selon la base de données
});

module.exports = sequelize;
