'use strict';

const mysql = require('mysql2');
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
    pool.query('SELECT reservation_id,start_time,end_time,status,address FROM reservation JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id', function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
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
    const query = 'SELECT reservation_id,start_time,end_time,status,address FROM reservation JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id WHERE reservation_id = ?';
    const params = [reservationId];

    pool.query(query, params, function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
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
exports.reservationPOST = function(reservation) { // TODO: This function does not work
  return new Promise(function(resolve, reject) {
    const query = 'INSERT INTO reservations (spot_id, user_id, start_time, end_time) VALUES (?, ?, ?, ?)';
    const params = [reservation.spot_id, reservation.user_id, reservation.start_time, reservation.end_time];

    pool.query(query, params, function(error, results, fields) {
      if (error) {
        console.error('Database query error:', error); // Log the error
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
    pool.query('SELECT spot_id,address,type,has_charger FROM parkingspot', function(error, results, fields) {
      if (error) {
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
    const query = 'SELECT spot_id,address,type,has_charger FROM parkingspot WHERE spot_id = ?';
    const params = [id];
    pool.query(query, params, function(error, results, fields) {
      if (error) {
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