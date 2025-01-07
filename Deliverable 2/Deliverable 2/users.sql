-- Drop existing users if they exist. So I can run the users.sql file more than once.
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'admin'@'%';
DROP USER IF EXISTS 'user'@'localhost';
DROP USER IF EXISTS 'user'@'%';
DROP USER IF EXISTS 'owner'@'localhost';
DROP USER IF EXISTS 'owner'@'%';

-- Create admin: Full privileges for managing the database
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adminpassword';
CREATE USER 'admin'@'%' IDENTIFIED BY 'adminpassword';
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'admin'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'admin'@'%' WITH GRANT OPTION;

-- Create user: Can perform SELECT and INSERT and UPDATE queries in the DB
CREATE USER 'user'@'localhost' IDENTIFIED BY 'userpassword';
CREATE USER 'user'@'%' IDENTIFIED BY 'userpassword';
GRANT SELECT ON CurbspringsDB.* TO 'user'@'localhost';
GRANT SELECT ON CurbspringsDB.* TO 'user'@'%';
-- INSERT permissions
GRANT INSERT ON CurbspringsDB.reservation  TO 'user'@'localhost';
GRANT INSERT ON CurbspringsDB.reservation  TO 'user'@'%';
GRANT INSERT ON CurbspringsDB.vehicle  TO 'user'@'localhost';
GRANT INSERT ON CurbspringsDB.vehicle  TO 'user'@'%';
GRANT INSERT ON CurbspringsDB.review  TO 'user'@'localhost';
GRANT INSERT ON CurbspringsDB.review  TO 'user'@'%';
GRANT INSERT ON CurbspringsDB.payment  TO 'user'@'localhost';
GRANT INSERT ON CurbspringsDB.payment  TO 'user'@'%';
-- UPDATE permissions
GRANT UPDATE ON CurbspringsDB.reservation TO 'user'@'localhost';
GRANT UPDATE ON CurbspringsDB.reservation TO 'user'@'%';
GRANT UPDATE ON CurbspringsDB.review TO 'user'@'localhost';
GRANT UPDATE ON CurbspringsDB.review TO 'user'@'%';

-- Create owner: Can perform all operations on tables owned by their account
CREATE USER 'owner'@'localhost' IDENTIFIED BY 'ownerpassword';
CREATE USER 'owner'@'%' IDENTIFIED BY 'ownerpassword';
GRANT SELECT ON CurbspringsDB.* TO 'owner'@'localhost';
GRANT SELECT ON CurbspringsDB.* TO 'owner'@'%';
-- INSERT permissions
GRANT INSERT ON CurbspringsDB.parkingspot  TO 'owner'@'localhost';
GRANT INSERT ON CurbspringsDB.parkingspot  TO 'owner'@'%';
-- UPDATE permissions
GRANT UPDATE ON CurbspringsDB.parkingspot TO 'owner'@'localhost';
GRANT UPDATE ON CurbspringsDB.parkingspot TO 'owner'@'%';