--------------------------------------------------------------
-- TODO: Check rights for all types of users


-- Create admin: Full privileges for managing the database
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adminpassword';
CREATE USER 'admin'@'%' IDENTIFIED BY 'adminpassword';
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'admin'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'admin'@'%' WITH GRANT OPTION;

-- Create user: Can perform SELECT and INSERT queries in the DB
CREATE USER 'user'@'localhost' IDENTIFIED BY 'userpassword';
CREATE USER 'user'@'%' IDENTIFIED BY 'userpassword';
GRANT SELECT, INSERT ON CurbspringsDB.* TO 'user'@'localhost';
GRANT SELECT, INSERT ON CurbspringsDB.* TO 'user'@'%';

-- Create owner: Can perform all operations on tables owned by their account
CREATE USER 'owner'@'localhost' IDENTIFIED BY 'ownerpassword';
CREATE USER 'owner'@'%' IDENTIFIED BY 'ownerpassword';
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'owneruser'@'localhost';
GRANT ALL PRIVILEGES ON CurbspringsDB.* TO 'owneruser'@'%';