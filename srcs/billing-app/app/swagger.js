const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

// Configuration des options Swagger
const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'Billing Application API',
      version: '1.0.0',
      description: 'API for managing orders and billing processes.',
    },
    servers: [
      {
        url: 'http://localhost:3000', // Mettez à jour si nécessaire
      },
    ],
  },
  apis: ['./app/controllers/*.js', './server.js'], // Chemins vers vos fichiers de route et contrôleurs
};

// Générer la documentation Swagger
const swaggerDocs = swaggerJsDoc(swaggerOptions);

module.exports = (app) => {
  // Routes pour Swagger
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));
};
