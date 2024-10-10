const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Gateway Documentation',
      version: '1.0.0',
      description: 'API Gateway for managing inventory and billing',
    },
    servers: [
      {
        url: 'http://localhost:4000', // Modifier si votre serveur utilise un autre port
      },
    ],
  },
  apis: ['./routes/*.js'], // Indiquer le chemin vers les fichiers des routes
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);

const setupSwagger = (app) => {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));
};

module.exports = setupSwagger;
