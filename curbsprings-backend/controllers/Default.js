'use strict';

var utils = require('../utils/writer.js');
var Default = require('../service/DefaultService');

module.exports.reservationGET = function reservationGET (req, res, next) {
  Default.reservationGET()
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.reservationIdGET = function reservationIdGET (req, res, next) {
  const id = req.params.id;
  Default.reservationIdGET(id)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
// TODO: This function does not work
module.exports.reservationPOST = function reservationPOST (req, res, next, body) {
  Default.reservationPOST(body)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.spotGET = function spotGET (req, res, next) {
  Default.spotGET()
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.spotIdGET = function spotIdGET (req, res, next) {
  const id = req.params.id;
  Default.spotIdGET(id)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
