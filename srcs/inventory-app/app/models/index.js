const sequelize = require('../config/config');
const Movie = require('./movie.model');

const db = {
  sequelize,
  Movie,
};

module.exports = db;
