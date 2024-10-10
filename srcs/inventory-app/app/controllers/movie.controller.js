const { Movie } = require('../models'); // Importez le modèle Movie
const { Op } = require('sequelize'); // Importez Op depuis sequelize

// Fonction pour obtenir tous les films
const getAllMovies = async (req, res) => {
  try {
    const title = req.query.title;
    const movies = title 
      ? await Movie.findAll({ where: { title: { [Op.like]: `%${title}%` } } })
      : await Movie.findAll();
    res.json(movies);
  } catch (error) {
    console.error('Erreur lors de la récupération des films:', error);
    res.status(500).json({ message: 'Erreur lors de la récupération des films.' });
  }
};

// Fonction pour ajouter un nouveau film
const addMovie = async (req, res) => {
  const { title, genre, year } = req.body;
  try {
    const newMovie = await Movie.create({ title, genre, year });
    res.status(201).json(newMovie);
  } catch (error) {
    console.error('Erreur lors de l\'ajout du film:', error);
    res.status(500).json({ message: 'Erreur lors de l\'ajout du film.' });
  }
};

// Fonction pour supprimer tous les films
const deleteAllMovies = async (req, res) => {
  try {
    await Movie.destroy({ where: {}, truncate: true });
    res.status(204).send();
  } catch (error) {
    console.error('Erreur lors de la suppression des films:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression des films.' });
  }
};

// Fonction pour obtenir un film par ID
const getMovieById = async (req, res) => {
  const { id } = req.params;
  try {
    const movie = await Movie.findByPk(id);
    if (!movie) {
      return res.status(404).json({ message: 'Film non trouvé.' });
    }
    res.json(movie);
  } catch (error) {
    console.error('Erreur lors de la récupération du film:', error);
    res.status(500).json({ message: 'Erreur lors de la récupération du film.' });
  }
};

// Fonction pour mettre à jour un film par ID
const updateMovieById = async (req, res) => {
  const { id } = req.params;
  const { title, genre, year } = req.body;
  try {
    const movie = await Movie.findByPk(id);
    if (!movie) {
      return res.status(404).json({ message: 'Film non trouvé.' });
    }
    movie.title = title;
    movie.genre = genre;
    movie.year = year;
    await movie.save();
    res.json(movie);
  } catch (error) {
    console.error('Erreur lors de la mise à jour du film:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du film.' });
  }
};

// Fonction pour supprimer un film par ID
const deleteMovieById = async (req, res) => {
  const { id } = req.params;
  try {
    const deleted = await Movie.destroy({ where: { id } });
    if (!deleted) {
      return res.status(404).json({ message: 'Film non trouvé.' });
    }
    res.status(204).send();
  } catch (error) {
    console.error('Erreur lors de la suppression du film:', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du film.' });
  }
};

module.exports = {
  getAllMovies,
  addMovie,
  deleteAllMovies,
  getMovieById,
  updateMovieById,
  deleteMovieById,
};
