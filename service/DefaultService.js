'use strict';

require('dotenv').config();
// const mysql = require('mysql2');
const sql = require('mssql');
const Joi = require('joi');

// const pool = mysql.createPool({
//   connectionLimit: 10,
//   host: 'localhost',
//   user: 'root',
//   password: 'thanasis',
//   database: 'curbspringsdb'
// });

// MSSQL configuration
const config = {
  user: process.env.DB_USER, // Azure SQL username
  password: process.env.DB_PASSWORD, // Azure SQL password
  server: process.env.DB_SERVER, // Azure SQL server
  database: process.env.DB_DATABASE, // Database name
  options: {
    encrypt: true, // For Azure SQL, encryption is required
    enableArithAbort: true
  },
  pool: {
    max: 10,
    min: 0,
    createRetryIntervalMillis: 200
  }
};

async function connectWithRetry(config, maxRetries = 15, retryInterval = 10000) {
  let retries = 0;
  while (true) {
    try {
      const pool = await new sql.ConnectionPool(config).connect();
      console.log('Connected to MSSQL');
      return pool;
    } catch (err) {
      retries++;
      console.error(`Database connection failed! Attempt ${retries}.\n`, err);

      if (retries >= maxRetries) {
        console.error('Maximum retry attempts reached. Exiting.');
        throw err;
      }

      console.log(`Retrying to connect in ${retryInterval / 1000} seconds...`);
      await new Promise(resolve => setTimeout(resolve, retryInterval));
    }
  }
}

// Create a pool promise
const poolPromise = connectWithRetry(config);

/**
 * Get all reservations
 * Returns a list of all reservations.
 *
 * returns List
 **/
exports.reservationGET = function () {
  return new Promise(async (resolve, reject) => {
    try {
      const pool = await poolPromise;
      const result = await pool
        .request()
        .query(
          `SELECT reservation_id, start_time, end_time, status, address 
           FROM reservation 
           JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id`
        );
      resolve(result.recordset);
    } catch (error) {
      console.error('Database query error:', error);
      error.statusCode = 500; // Internal Server Error
      reject(error);
    }
  });
};

/**
 * Get a reservation by ID
 * Returns a reservation by its ID.
 *
 * reservationId Long The ID of the reservation to retrieve.
 * returns Object
 **/
exports.reservationIdGET = function (reservationId) {
  return new Promise(async (resolve, reject) => {
    const schema = Joi.number().integer().required();
    const { error } = schema.validate(reservationId);

    if (error) {
      const validationError = new Error(
        'Fetching reservation failed: Invalid reservation ID.'
      );
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    try {
      const pool = await poolPromise;
      const result = await pool
        .request()
        .input('reservationId', sql.Int, reservationId)
        .query(
          `SELECT reservation_id, start_time, end_time, status, address 
           FROM reservation 
           JOIN parkingspot ON reservation.spot_id = parkingspot.spot_id 
           WHERE reservation_id = @reservationId`
        );
      resolve(result.recordset[0]);
    } catch (error) {
      console.error('Database query error:', error);
      error.statusCode = 500; // Internal Server Error
      reject(error);
    }
  });
};

/**
 * Create a new reservation
 * Adds a new reservation to the database.
 *
 * reservation Object The reservation to create.
 * returns Object
 **/
exports.reservationPOST = function (reservation) {
  return new Promise(async (resolve, reject) => {
    const schema = Joi.object({
      spot_id: Joi.number().integer().required(),
      license_plate: Joi.string().required(),
      start_time: Joi.string().isoDate().required(),
      end_time: Joi.string().isoDate().required()
    });

    const { error } = schema.validate(reservation);

    if (error) {
      const validationError = new Error(
        'Creating reservation failed: Invalid input data.'
      );
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    try {
      const pool = await poolPromise;
      const result = await pool
        .request()
        .input('spot_id', sql.Int, reservation.spot_id)
        .input('license_plate', sql.NVarChar, reservation.license_plate)
        .input('start_time', sql.DateTime, reservation.start_time)
        .input('end_time', sql.DateTime, reservation.end_time)
        .query(
          `INSERT INTO reservation (user_id, spot_id, license_plate, start_time, end_time, status) 
           VALUES (1, @spot_id, @license_plate, @start_time, @end_time, 'Reserved');
           SELECT SCOPE_IDENTITY() AS id;`
        );
      resolve({ id: result.recordset[0].id, ...reservation });
    } catch (error) {
      console.error('Database query error:', error);
      error.statusCode = 500; // Internal Server Error
      reject(error);
    }
  });
};

/**
 * Get spots based on filters
 * Returns a list of spots based on the provided filters.
 *
 * returns List
 **/
exports.spotGET = function () {
  return new Promise(async (resolve, reject) => {
    try {
      const pool = await poolPromise;
      const result = await pool
        .request()
        .query(
          `SELECT spot_id, address, type, has_charger, available 
           FROM parkingspot`
        );
      resolve(result.recordset);
    } catch (error) {
      console.error('Database query error:', error);
      error.statusCode = 500; // Internal Server Error
      reject(error);
    }
  });
};

/**
 * Get a parking spot by ID
 * Retrieves details of a specific parking spot by its unique ID.
 *
 * id Integer The ID of the parking spot to retrieve.
 * returns Spot
 **/
exports.spotIdGET = function (id) {
  return new Promise(async (resolve, reject) => {
    const schema = Joi.number().integer().required();
    const { error } = schema.validate(id);

    if (error) {
      const validationError = new Error(
        'Fetching spot failed: Invalid spot ID.'
      );
      validationError.statusCode = 400; // Bad Request
      reject(validationError);
      return;
    }

    try {
      const pool = await poolPromise;
      const result = await pool
        .request()
        .input('id', sql.Int, id)
        .query(
          `SELECT spot_id, address, type, has_charger 
           FROM parkingspot 
           WHERE spot_id = @id`
        );
      resolve(result.recordset[0]);
    } catch (error) {
      console.error('Database query error:', error);
      error.statusCode = 500; // Internal Server Error
      reject(error);
    }
  });
};

// Close the pool when the application terminates
process.on('SIGINT', async () => {
  try {
    const pool = await poolPromise;
    await pool.close();
    console.log('Closed the database connection.');
    process.exit(0);
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
});
