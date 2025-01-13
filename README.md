# Webapp Local Installation Instructions

## Prerequisites

- Node (v20)
- MySQL

## Database

First, load the MySQL database using the dump provided in the deliverable files. This is needed to have the dummy data available.

## Backend

Initialize the backend server, by going to the **curbsprings-backend** folder, opening a command line and running 
```npm start```. This will install all needed libraries and start the server, which should listen to http://localhost:8000

**Attention**: You might need to modify the mysql2 package password inside Service/DefaultService.js to successfully connect tha DB with
the backend.

## Frontend

Initialize the frontend by running at first ```npm install``` to install all needed libraries.

 **Attention**:The frontend is based on the React framework, and installation might take a long time.

After installation is complete, run ```npm start``` and wait for the frontend to start. After starting, you can visit http://localhost:3000
within a browser to access the app.

# ! DISCLAIMER !

This app was developed for the thrid deliverable of Databases Course, Aristotle University 2024.

This is an app developed in a very short time period, and is untested and **might stop working at any time**.

