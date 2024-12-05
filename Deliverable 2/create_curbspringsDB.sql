-- Drop old database if exists
DROP SCHEMA IF EXISTS `CurbspringsDB`;
CREATE SCHEMA `CurbspringsDB`;
USE `CurbspringsDB`;

-- Create the database
CREATE DATABASE CurbspringsDB;
USE CurbspringsDB;

-- Table: SpotOwner
CREATE TABLE SpotOwner (
    spot_owner_id INT PRIMARY KEY,
    spot_owner_name_surname VARCHAR(50),
    email VARCHAR(50),
    hash_password VARCHAR(256)
);

-- Table: ParkingSpot
CREATE TABLE ParkingSpot (
    spot_id INT PRIMARY KEY,
    spot_owner_id INT,
    address VARCHAR(35),
    type ENUM('Open', 'Garage', 'Underground'),
    has_charger BOOLEAN,
    available BOOLEAN,
    FOREIGN KEY (spot_owner_id) REFERENCES SpotOwner(spot_owner_id)
);

-- Table: User
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    user_name_surname VARCHAR(50),
    email VARCHAR(50),
    hash_password VARCHAR(256)
);

-- Table: Vehicle
CREATE TABLE Vehicle (
    license_plate VARCHAR(7) PRIMARY KEY,
    vehicle_type ENUM('Car', 'Truck', 'Motorcycle')
);

-- Table: User_owns_Vehicle
CREATE TABLE User_owns_Vehicle (
    user_id INT,
    license_plate VARCHAR(7),
    PRIMARY KEY (user_id, license_plate),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (license_plate) REFERENCES Vehicle(license_plate)
);

-- Table: Reservation
CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    user_id INT,
    spot_id INT,
    license_plate VARCHAR(7),
    start_time DATETIME,
    end_time DATETIME,
    status ENUM('Reserved', 'Cancelled', 'Completed'),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (spot_id) REFERENCES ParkingSpot(spot_id),
    FOREIGN KEY (license_plate) REFERENCES Vehicle(license_plate)
);

-- Table: Payment
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    payment_method ENUM('DebitCard', 'CreditCard', 'GooglePay', 'ApplePay'),
    payment_status ENUM('Pending', 'Completed', 'Failed'),
    transaction_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Table: Coupon
CREATE TABLE Coupon (
    code VARCHAR(50) PRIMARY KEY,
    discount_amount DECIMAL(4,2),
    is_active BOOLEAN
);

-- Table: User_has_Coupon
CREATE TABLE User_has_Coupon (
    user_id INT,
    code VARCHAR(50),
    PRIMARY KEY (user_id, code),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (code) REFERENCES Coupon(code)
);

-- Table: Review
CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    user_id INT,
    spot_id INT,
    rating ENUM('1', '2', '3', '4', '5'),
    review_text TEXT,
    review_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (spot_id) REFERENCES ParkingSpot(spot_id)
);

------------------------------------------------------------
-- TODO: Check the info beeing entered in the tables
------------------------------------------------------------

-- Populate tables with example data
INSERT INTO SpotOwner VALUES
(1, 'Θανάσης Τσαρναδέλης', 'tsarnadelis@gmail.com', '6f7ed1b31c53f78825239'),
(2, 'Γιώργος Πίττης', 'pittis@outlook.com', '5417922f2aeb237ec72f7'),
(3, 'Αλέξανδρος Φωτιάδης', 'fotiadis@yahoo.com', '6f7ed1b31c53f78825239'),
(4, 'Θωμάς Καρανικιώτης', 'thomas@issel.com', 'eda71746c01c3f465ffd0'),
(5, 'Γιώργος Σιαχάμης', 'giorgos@cyclopt.com', '5417922f2aeb237ec72f7'),
(6, 'Γιώργος Στεργίου', 'geoster@gmail.com', '59cfdd99fab00c358f81f'),
(7, 'Δημήτρης Παπαδόπουλος', 'papadodim@gmail.com', '88e1fbd99f5670ec4aaba'),
(8, 'Φώτης Δημητρίου', 'fotis2014@yahoo.com', '3198acae4487cc5c9169e');

INSERT INTO ParkingSpot VALUES
(1, 1, 'Εγνατίας 42', 'Open', 1, 1),
(2, 1, 'Τσιμισκή 12', 'Garage', 0, 1),
(3, 3, 'Λεωφ. Νίκης 104', 'Underground', 0, 1),
(4, 5, 'Ιπποδρομίου 58', 'Garage', 1, 0),
(5, 2, 'Αγίας Σοφίας 95', 'Open', 1, 0),
(6, 2, 'Αετοράχης 53', 'Open', 0, 1),
(7, 4, 'Αγίου Δημητρίου 87', 'Garage', 1, 0),
(8, 4, 'Ιασωνίδου 31', 'Underground', 1, 1);

INSERT INTO User VALUES
(1, 'Θανάσης Τσαρναδέλης', 'tsarnadelis@gmail.com', '6f7ed1b31c53f78825239'),
(2, 'Γιώργος Πίττης', 'pittis@outlook.com', '5417922f2aeb237ec72f7'),
(3, 'Αλέξανδρος Φωτιάδης', 'fotiadis@yahoo.com', '6f7ed1b31c53f78825239'),
(4, 'Θωμάς Καρανικιώτης', 'thomas@issel.com', 'eda71746c01c3f465ffd0'),
(5, 'Γιώργος Σιαχάμης', 'giorgos@cyclopt.com', '5417922f2aeb237ec72f7');

INSERT INTO Vehicle VALUES
('ΚΒΧ5686', 'Car'),
('ΡΡΙ7812', 'Motorcycle'),
('ΡΜΒ3610', 'Truck'),
('ΙΙΗ2673', 'Car'),
('ΝΗΒ8964', 'Truck');

INSERT INTO User_owns_Vehicle VALUES
(1, 'ΚΒΧ5686'),
(2, 'ΡΡΙ7812'),
(3, 'ΡΜΒ3610'),
(4, 'ΙΙΗ2673'),
(5, 'ΝΗΒ8964');

INSERT INTO Reservation VALUES
(1, 1, 3, 'ΚΒΧ5686', '2024-11-20 10:00', '2024-11-20 12:00', 'Reserved'),
(2, 2, 4, 'ΡΡΙ7812', '2024-11-21 14:00', '2024-11-21 16:00', 'Completed'),
(3, 3, 2, 'ΡΜΒ3610', '2024-11-22 09:00', '2024-11-22 11:00', 'Cancelled'),
(4, 4, 5, 'ΙΙΗ2673', '2024-11-23 08:00', '2024-11-23 10:00', 'Reserved'),
(5, 5, 1, 'ΝΗΒ8964', '2024-11-24 13:00', '2024-11-24 15:00', 'Completed');

INSERT INTO Payment VALUES
(1, 1, 12.50, 'CreditCard', 'Completed', '2024-11-20 12:15'),
(2, 2, 20.00, 'GooglePay', 'Completed', '2024-11-21 16:30'),
(3, 3, 8.75, 'DebitCard', 'Failed', '2024-11-22 11:10'),
(4, 4, 15.00, 'ApplePay', 'Completed', '2024-11-23 10:20'),
(5, 5, 10.00, 'CreditCard', 'Pending', '2024-11-24 15:05');

INSERT INTO Coupon VALUES
('COUPON10', 10.00, 1),
('WELCOME5', 5.00, 1),
('BONUS20', 20.00, 0),
('SPRING15', 15.00, 1),
('DISCOUNT7', 7.00, 1);

INSERT INTO User_has_Coupon VALUES
(1, 'COUPON10'),
(2, 'WELCOME5'),
(3, 'BONUS20'),
(4, 'SPRING15'),
(5, 'DISCOUNT7');

INSERT INTO Review VALUES
(1, 1, 3, '5', 'Πολύ καλή εξυπηρέτηση', '2024-11-20 12:30'),
(2, 2, 4, '4', 'Καλή θέση αλλά ακριβή', '2024-11-21 16:45'),
(3, 3, 2, '3', 'Δεν είχε καλή πρόσβαση', '2024-11-22 11:20'),
(4, 4, 5, '5', 'Ιδανική τοποθεσία', '2024-11-23 10:40'),
(5, 5, 1, '4', 'Πολύ ευρύχωρη θέση', '2024-11-24 15:15');
