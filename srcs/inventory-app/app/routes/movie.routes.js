const express = require('express');
const {
  getAllMovies,
  addMovie,
  deleteAllMovies,
  getMovieById,
  updateMovieById,
  deleteMovieById,
} = require('../controllers/movie.controller');

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Movies
 *   description: API for managing movies
 */

/**
 * @swagger
 * /api/movies:
 *   get:
 *     summary: Retrieve all movies
 *     tags: [Movies]
 *     responses:
 *       200:
 *         description: A list of movies
 */
router.get('/', getAllMovies);

/**
 * @swagger
 * /api/movies:
 *   post:
 *     summary: Add a new movie
 *     tags: [Movies]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               director:
 *                 type: string
 *               year:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Movie added successfully
 *       400:
 *         description: Invalid input
 */
router.post('/', addMovie);

/**
 * @swagger
 * /api/movies:
 *   delete:
 *     summary: Delete all movies
 *     tags: [Movies]
 *     responses:
 *       204:
 *         description: All movies deleted successfully
 */
router.delete('/', deleteAllMovies);

/**
 * @swagger
 * /api/movies/{id}:
 *   get:
 *     summary: Retrieve a movie by ID
 *     tags: [Movies]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: The ID of the movie to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: A single movie
 *       404:
 *         description: Movie not found
 */
router.get('/:id', getMovieById);

/**
 * @swagger
 * /api/movies/{id}:
 *   put:
 *     summary: Update a movie by ID
 *     tags: [Movies]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: The ID of the movie to update
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               director:
 *                 type: string
 *               year:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Movie updated successfully
 *       400:
 *         description: Invalid input
 *       404:
 *         description: Movie not found
 */
router.put('/:id', updateMovieById);

/**
 * @swagger
 * /api/movies/{id}:
 *   delete:
 *     summary: Delete a movie by ID
 *     tags: [Movies]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: The ID of the movie to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Movie deleted successfully
 *       404:
 *         description: Movie not found
 */
router.delete('/:id', deleteMovieById);

module.exports = router;
