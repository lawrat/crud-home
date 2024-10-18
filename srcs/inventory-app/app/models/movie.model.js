const { DataTypes } = require("sequelize");
const sequelize = require("../config/config");

const Movie = sequelize.define(
  "Movie",
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  {
    tableName: "movies",
    timestamps: false, // Désactiver createdAt et updatedAt
  }
);

module.exports = Movie;
