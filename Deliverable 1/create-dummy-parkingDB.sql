-- Drop old database if it exists
DROP DATABASE IF EXISTS CurbspringsDB;

-- Create the database
CREATE DATABASE CurbspringsDB;
USE CurbspringsDB;

-- Create SpotOwner table
CREATE TABLE SpotOwner (
    spot_owner_id INT PRIMARY KEY,
    spot_owner_name_surname VARCHAR(50),
    email VARCHAR(50),
    hash_password VARCHAR(256)
);
INSERT INTO SpotOwner VALUES
(1, 'John Doe', 'john@example.com', 'hash1'),
(2, 'Jane Smith', 'jane@example.com', 'hash2'),
(3, 'Alice Brown', 'alice@example.com', 'hash3'),
(4, 'Bob White', 'bob@example.com', 'hash4'),
(5, 'Charlie Black', 'charlie@example.com', 'hash5');

-- Create ParkingSpot table
CREATE TABLE ParkingSpot (
    spot_id INT PRIMARY KEY,
    spot_owner_id INT,
    address VARCHAR(35),
    type ENUM('Open', 'Garage', 'Underground'),
    has_charger BOOLEAN,
    available BOOLEAN,
    FOREIGN KEY (spot_owner_id) REFERENCES SpotOwner(spot_owner_id)
);
INSERT INTO ParkingSpot VALUES
(1, 1, '123 Main St', 'Open', TRUE, TRUE),
(2, 2, '456 Elm St', 'Garage', FALSE, FALSE),
(3, 3, '789 Oak St', 'Underground', TRUE, TRUE),
(4, 4, '101 Pine St', 'Open', FALSE, TRUE),
(5, 5, '202 Maple St', 'Garage', TRUE, FALSE);

-- Create User table
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    username_surname VARCHAR(50),
    email VARCHAR(50),
    hash_password VARCHAR(256)
);
INSERT INTO User VALUES
(1, 'User One', 'user1@example.com', 'hash1'),
(2, 'User Two', 'user2@example.com', 'hash2'),
(3, 'User Three', 'user3@example.com', 'hash3'),
(4, 'User Four', 'user4@example.com', 'hash4'),
(5, 'User Five', 'user5@example.com', 'hash5');

-- Create Review table
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
INSERT INTO Review VALUES
(1, 1, 1, '5', 'Excellent spot!', '2024-11-01 10:00:00'),
(2, 2, 2, '4', 'Very good', '2024-11-02 11:00:00'),
(3, 3, 3, '3', 'Average', '2024-11-03 12:00:00'),
(4, 4, 4, '2', 'Not great', '2024-11-04 13:00:00'),
(5, 5, 5, '1', 'Terrible', '2024-11-05 14:00:00');

-- Create Vehicle table
CREATE TABLE Vehicle (
    license_plate VARCHAR(7) PRIMARY KEY,
    vehicle_type ENUM('Car', 'Truck', 'Motorcycle')
);
INSERT INTO Vehicle VALUES
('ABC1234', 'Car'),
('DEF5678', 'Truck'),
('GHI9012', 'Motorcycle'),
('JKL3456', 'Car'),
('MNO7890', 'Truck');

-- Create Reservation table
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
INSERT INTO Reservation VALUES
(1, 1, 1, 'ABC1234', '2024-11-01 10:00:00', '2024-11-01 12:00:00', 'Completed'),
(2, 2, 2, 'DEF5678', '2024-11-02 11:00:00', '2024-11-02 13:00:00', 'Cancelled'),
(3, 3, 3, 'GHI9012', '2024-11-03 12:00:00', '2024-11-03 14:00:00', 'Reserved'),
(4, 4, 4, 'JKL3456', '2024-11-04 13:00:00', '2024-11-04 15:00:00', 'Completed'),
(5, 5, 5, 'MNO7890', '2024-11-05 14:00:00', '2024-11-05 16:00:00', 'Completed');

-- Create Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    payment_method ENUM('DebitCard', 'CreditCard', 'GooglePay', 'ApplePay'),
    payment_status ENUM('Pending', 'Completed', 'Failed'),
    transaction_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
INSERT INTO Payment VALUES
(1, 1, 50.00, 'DebitCard', 'Completed', '2024-11-01 10:30:00'),
(2, 2, 30.50, 'CreditCard', 'Completed', '2024-11-02 11:30:00'),
(3, 3, 75.00, 'GooglePay', 'Pending', '2024-11-03 12:30:00'),
(4, 4, 20.00, 'ApplePay', 'Failed', '2024-11-04 13:30:00'),
(5, 5, 100.00, 'DebitCard', 'Completed', '2024-11-05 14:30:00');

-- Create Coupon table
CREATE TABLE Coupon (
    code VARCHAR(50) PRIMARY KEY,
    discount_amount DECIMAL(4,2),
    is_active BOOLEAN
);
INSERT INTO Coupon VALUES
('WELCOME10', 10.00, TRUE),
('DISCOUNT20', 20.00, TRUE),
('SAVE5', 5.00, TRUE),
('SUMMER25', 25.00, FALSE),
('HOLIDAY15', 15.00, TRUE);coupon
