'use strict';

var utils = require('../utils/writer.js');
var Default = require('../service/DefaultService');

module.exports.reservationGET = function reservationGET (req, res, next) {
  Default.reservationGET()
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (error) {
      res.status(error.statusCode).json({ error: error.message });
    });
};

module.exports.reservationIdGET = function reservationIdGET (req, res, next) {
  const id = req.params.id;
  Default.reservationIdGET(id)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (error) {
      res.status(error.statusCode).json({ error: error.message });
    });
};

module.exports.reservationPOST = function reservationPOST (req, res, next) {
  Default.reservationPOST(req.body)
    .then(function (response) {
      res.status(201).json(response); // Created
    })
    .catch(function (error) {
      res.status(error.statusCode).json({ error: error.message });
    });
};

module.exports.spotGET = function spotGET (req, res, next) {
  Default.spotGET()
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (error) {
      res.status(error.statusCode).json({ error: error.message });
    });
};

module.exports.spotIdGET = function spotIdGET (req, res, next) {
  const id = req.params.id;
  Default.spotIdGET(id)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (error) {
      res.status(error.statusCode).json({ error: error.message });
    });
};
