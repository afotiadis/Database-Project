'use strict';

const mysql = require('mysql2');
const Joi = require('joi');
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: 'thanasis',
  database: 'curbspringsdb'
});

/**
 * Get all reservations
 * Returns a list of all reservations.
 *
 * returns List
 **/
exports.reservationGET = function() {
  return new Promise(function(resolve, reject) {
    // Query the database
    pool.query('SELECT reservation_id,start_time,end_time,status,address FROM reservation JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id', function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
        error.statusCode = 500; // Internal Server Error
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
};

/**
 * Get a reservation by ID
 * Returns a reservation by its ID.
 *
 * reservationId Long The ID of the reservation to retrieve.
 * returns Object
 **/
exports.reservationIdGET = function(reservationId) {
  return new Promise(function(resolve, reject) {

    // Define the schema for validation
    const schema = Joi.number().integer().required();

    // Validate the input data
    const { error } = schema.validate(reservationId);
    if (error) {
      const validationError = new Error('Fetching reservation failed: Invalid reservation ID.');
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    // Query the database
    const query = 'SELECT reservation_id,start_time,end_time,status,address FROM reservation JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id WHERE reservation_id = ?';
    const params = [reservationId];

    pool.query(query, params, function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
        error.statusCode = 500; // Internal Server Error
        reject(error);
      } else {
        resolve(results[0]);
      }
    });
  });
};

/**
 * Create a new reservation
 * Adds a new reservation to the database.
 *
 * reservation Object The reservation to create.
 * returns Object
 **/
exports.reservationPOST = function(reservation) { // ATTENTION: reservation_id NEEDS TO BE AUTO-INCREMENTED
  return new Promise(function(resolve, reject) {

    // Define the schema for validation
    const schema = Joi.object({
      spot_id: Joi.number().integer().required(),
      license_plate: Joi.string().required(),
      start_time: Joi.string().isoDate().required(),
      end_time: Joi.string().isoDate().required()
    });

    // Validate the input data
    const { error } = schema.validate(reservation);
    if (error) {
      const validationError = new Error('Creating reservation failed: Invalid input data.');
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    const query = 'INSERT INTO reservation (user_id, spot_id, license_plate, start_time, end_time, status) VALUES (1, ?, ?, ?, ?, \'Reserved\')';
    // All reservations are made by user 1 for now
    const params = [reservation.spot_id, reservation.license_plate, reservation.start_time, reservation.end_time];
    
    pool.query(query, params, function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
        error.statusCode = 500; // Internal Server Error
        reject(error);
      } else {
        resolve({ id: results.insertId, ...reservation });
      }
    });
  });
};

/**
 * Get spots based on filters
 * Returns a list of spots based on the provided filters.
 *
 * address String Filter spots by address. (optional)
 * type String Filter spots by type. (optional)
 * vehicle_type String Filter spots by vehicle type. (optional)
 * charger Boolean Filter spots by whether they have a charger. (optional)
 * returns List
 **/
exports.spotGET = function() {
  return new Promise(function(resolve, reject) {
    pool.query('SELECT spot_id,address,type,has_charger,available FROM parkingspot', function(error, results, fields) {
      if (error) {
        error.statusCode = 500; // Internal Server Error
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
};

/**
 * Get a parking spot by ID
 * Retrieves details of a specific parking spot by its unique ID.
 *
 * id Integer The ID of the parking spot to retrieve.
 * returns Spot
 **/
exports.spotIdGET = function(id) {
  return new Promise(function(resolve, reject) {

    // Define the schema for validation
    const schema = Joi.number().integer().required();

    // Validate the input data
    const { error } = schema.validate(id);
    if (error) {
      const validationError = new Error('Fetching spot failed: Invalid spot ID.');
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    // Query the database
    const query = 'SELECT spot_id,address,type,has_charger FROM parkingspot WHERE spot_id = ?';
    const params = [id];
    pool.query(query, params, function(error, results, fields) {
      if (error) {
        error.statusCode = 500; // Internal Server Error
      reject(error);
      } else {
      resolve(results[0]);
      }
    });
  });
}

// Close the pool when the application terminates
process.on('SIGINT', () => {
  pool.end(err => {
    if (err) {
      console.error(err.message);
    } else {
      console.log('Closed the database connection.');
    }
    process.exit(0);
  });
});