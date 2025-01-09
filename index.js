'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const cors = require('cors');
const DefaultController = require('./controllers/Default');

// Load OpenAPI Specification
const openapiSpec = yaml.load(fs.readFileSync(path.join(__dirname, 'api/openapi.yaml'), 'utf8'));

const app = express();
const serverPort = process.env.PORT || 8080;

// Enable CORS
app.use(cors());

// Middleware
app.use(bodyParser.json());

// Serve Swagger UI for API documentation
app.use('/docs', swaggerUi.serve, swaggerUi.setup(openapiSpec));

// Routes
app.get('/spot', DefaultController.spotGET);
app.get('/spot/:id', DefaultController.spotIdGET);
app.get('/reservation', DefaultController.reservationGET);
app.post('/reservation', DefaultController.reservationPOST);
app.get('/reservation/:id', DefaultController.reservationIdGET);

// Error Handling Middleware
app.use((err, req, res, next) => {
    const statusCode = err.statusCode || 500; // Default to 500 Internal Server Error
    const message = err.message || 'Internal Server Error';
    console.error(`[ERROR] ${statusCode} - ${message}`);
    res.status(statusCode).json({ error: message });
});

// Start server
app.listen(serverPort, () => {
    console.log(`Your server is listening on port ${serverPort} (http://localhost:${serverPort})`);
    console.log(`Swagger-ui is available on http://localhost:${serverPort}/docs`);
});

