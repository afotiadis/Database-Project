-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CurbspringsDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `CurbspringsDB` ;

-- -----------------------------------------------------
-- Schema CurbspringsDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CurbspringsDB` DEFAULT CHARACTER SET utf8 ;
USE `CurbspringsDB` ;

-- -----------------------------------------------------
-- Table `CurbspringsDB`.`SpotOwner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`SpotOwner` (
  `spot_owner_id` INT NOT NULL,
  `spot_owner_name_surname` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `hash_password` VARCHAR(256) NULL,
  PRIMARY KEY (`spot_owner_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`ParkingSpot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`ParkingSpot` (
  `spot_id` INT NOT NULL,
  `spot_owner_id` INT NULL,
  `address` VARCHAR(35) NULL,
  `type` ENUM('Open', 'Garage', 'Underground') NULL,
  `has_charger` TINYINT NULL,
  `available` TINYINT NULL,
  PRIMARY KEY (`spot_id`),
  INDEX `spot_onwer_id_idx` (`spot_owner_id` ASC) VISIBLE,
  CONSTRAINT `spot_onwer_id_psfk`
    FOREIGN KEY (`spot_owner_id`)
    REFERENCES `CurbspringsDB`.`SpotOwner` (`spot_owner_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`User` (
  `user_id` INT NOT NULL,
  `user_name_surname` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `hash_password` VARCHAR(256) NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`Vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`Vehicle` (
  `license_plate` VARCHAR(7) NOT NULL,
  `vehicle_type` ENUM('Car', 'Truck', 'Motorcycle') NULL,
  PRIMARY KEY (`license_plate`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`User_owns_vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`User_owns_vehicle` (
  `user_id` INT NOT NULL,
  `license_plate` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`user_id`, `license_plate`),
  INDEX `license_plate_idx` (`license_plate` ASC) VISIBLE,
  CONSTRAINT `user_id_uovfk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CurbspringsDB`.`User` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `license_plate_uovfk`
    FOREIGN KEY (`license_plate`)
    REFERENCES `CurbspringsDB`.`Vehicle` (`license_plate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`Reservation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`Reservation` (
  `reservation_id` INT NOT NULL,
  `user_id` INT NULL,
  `spot_id` INT NULL,
  `license_plate` VARCHAR(7) NULL,
  `start_time` DATETIME NULL,
  `end_time` DATETIME NULL,
  `status` ENUM('Reserved', 'Cancelled', 'Completed') NULL,
  PRIMARY KEY (`reservation_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `spot_id_idx` (`spot_id` ASC) VISIBLE,
  INDEX `license_plate_idx` (`license_plate` ASC) VISIBLE,
  CONSTRAINT `user_id_rvfk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CurbspringsDB`.`User` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `spot_id_rvfk`
    FOREIGN KEY (`spot_id`)
    REFERENCES `CurbspringsDB`.`ParkingSpot` (`spot_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `license_plate_rvfk`
    FOREIGN KEY (`license_plate`)
    REFERENCES `CurbspringsDB`.`Vehicle` (`license_plate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`Payment` (
  `payment_id` INT NOT NULL,
  `user_id` INT NULL,
  `amount` DECIMAL(10,2) NULL,
  `payment_method` ENUM('DebitCard', 'CreditCard', 'GooglePay', 'ApplePay') NULL,
  `payment_status` ENUM('Pending', 'Completed', 'Failed') NULL,
  `transaction_date` DATETIME NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_id_pmfk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CurbspringsDB`.`User` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`Coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`Coupon` (
  `code` VARCHAR(50) NOT NULL,
  `discount_amount` DECIMAL(4,2) NULL,
  `is_active` TINYINT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`User_has_Coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`User_has_Coupon` (
  `user_id` INT NOT NULL,
  `code` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`user_id`, `code`),
  INDEX `code_idx` (`code` ASC) VISIBLE,
  CONSTRAINT `user_id_uhcfk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CurbspringsDB`.`User` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `code_uhcfk`
    FOREIGN KEY (`code`)
    REFERENCES `CurbspringsDB`.`Coupon` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CurbspringsDB`.`Review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`Review` (
  `review_id` INT NOT NULL,
  `user_id` INT NULL,
  `spot_id` INT NULL,
  `rating` ENUM('1', '2', '3', '4', '5') NULL,
  `review_text` TEXT NULL,
  `review_date` DATETIME NULL,
  PRIMARY KEY (`review_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `spot_id_idx` (`spot_id` ASC) VISIBLE,
  CONSTRAINT `user_id_refk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CurbspringsDB`.`User` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `spot_id_refk`
    FOREIGN KEY (`spot_id`)
    REFERENCES `CurbspringsDB`.`ParkingSpot` (`spot_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `CurbspringsDB` ;

-- -----------------------------------------------------
-- Placeholder table for view `CurbspringsDB`.`USER_VIEW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`USER_VIEW` (`start_time` INT, `end_time` INT, `status` INT, `address` INT, `license_plate` INT, `vehicle_type` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CurbspringsDB`.`SPOT_OWNER_VIEW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`SPOT_OWNER_VIEW` (`start_time` INT, `end_time` INT, `status` INT, `address` INT, `license_plate` INT, `vehicle_type` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CurbspringsDB`.`ADMIN_VIEW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CurbspringsDB`.`ADMIN_VIEW` (`user_id` INT, `spot_owner_id` INT, `start_time` INT, `end_time` INT, `status` INT, `address` INT, `license_plate` INT, `vehicle_type` INT);

-- -----------------------------------------------------
-- View `CurbspringsDB`.`USER_VIEW`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CurbspringsDB`.`USER_VIEW`;
USE `CurbspringsDB`;
CREATE  OR REPLACE VIEW USER_VIEW AS
SELECT Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate
WHERE Reservation.user_id = 1;

-- -----------------------------------------------------
-- View `CurbspringsDB`.`SPOT_OWNER_VIEW`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CurbspringsDB`.`SPOT_OWNER_VIEW`;
USE `CurbspringsDB`;
CREATE  OR REPLACE VIEW SPOT_OWNER_VIEW AS
SELECT Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate
WHERE ParkingSpot.spot_owner_id = 4;

-- -----------------------------------------------------
-- View `CurbspringsDB`.`ADMIN_VIEW`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CurbspringsDB`.`ADMIN_VIEW`;
USE `CurbspringsDB`;
CREATE  OR REPLACE VIEW ADMIN_VIEW AS
SELECT Reservation.user_id, ParkingSpot.spot_owner_id, Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`SpotOwner`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (1, 'Thanasis Tsarnadelis', 'tsarnadelis@gmail.com', '6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (2, 'Giorgos Pittis', 'pittis@outlook.com', '5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (3, 'Alexandros Fotiadis', 'fotiadis@yahoo.com', '6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (4, 'Thomas Karanikiotis', 'thomas@issel.com', 'eda71746c01c3f465ffd02b6da15a6518e6fbc8f06f1ac525be193be5507069d');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (5, 'Giorgos Siachamis', 'giorgos@cyclopt.com', '5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (6, 'Giorgos Stergiou', 'geoster@gmail.com', '59cfdd99fab00c358f81f7b8db69216e6a7ecaf896f3b21122b07481be9b6e71');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (7, 'Dimitris Papadopoulos', 'papadodim@gmail.com', '88e1fbd99f5670ec4aabab3aa7797d8768667190e3d8ecd8645c949752598465');
INSERT INTO `CurbspringsDB`.`SpotOwner` (`spot_owner_id`, `spot_owner_name_surname`, `email`, `hash_password`) VALUES (8, 'Fotis Dimitriou', 'fotis2014@yahoo.com', '3198acae4487cc5c9169ec9c310fae374e3b6b02adba27563d2d3c0baba1d34d');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`ParkingSpot`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (1, 1, 'Egnatias 42', 'Open', 1, 1);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (2, 1, 'Tsimiski 12', 'Garage', 0, 1);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (3, 3, 'Leof. Nikis 104', 'Underground', 0, 1);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (4, 5, 'Ippodromiou 58', 'Garage', 1, 0);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (5, 2, 'Agias Sofias 95', 'Open', 1, 0);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (6, 2, 'Aetoraxis 53', 'Open', 0, 1);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (7, 4, 'Agiou Dimitriou 87', 'Garage', 1, 0);
INSERT INTO `CurbspringsDB`.`ParkingSpot` (`spot_id`, `spot_owner_id`, `address`, `type`, `has_charger`, `available`) VALUES (8, 4, 'Iasonidou 31', 'Underground', 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`User`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`User` (`user_id`, `user_name_surname`, `email`, `hash_password`) VALUES (1, 'Thanasis Tsarnadelis', 'tsarnadelis@gmail.com', '6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7');
INSERT INTO `CurbspringsDB`.`User` (`user_id`, `user_name_surname`, `email`, `hash_password`) VALUES (2, 'Giorgos Pittis', 'pittis@outlook.com', '5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931');
INSERT INTO `CurbspringsDB`.`User` (`user_id`, `user_name_surname`, `email`, `hash_password`) VALUES (3, 'Alexandros Fotiadis', 'fotiadis@yahoo.com', '6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7');
INSERT INTO `CurbspringsDB`.`User` (`user_id`, `user_name_surname`, `email`, `hash_password`) VALUES (4, 'Thomas Karanikiotis', 'thomas@issel.com', 'eda71746c01c3f465ffd02b6da15a6518e6fbc8f06f1ac525be193be5507069d');
INSERT INTO `CurbspringsDB`.`User` (`user_id`, `user_name_surname`, `email`, `hash_password`) VALUES (5, 'Giorgos Siachamis', 'giorgos@cyclopt.com', '5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`Vehicle`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`Vehicle` (`license_plate`, `vehicle_type`) VALUES ('KBX5686', 'Car');
INSERT INTO `CurbspringsDB`.`Vehicle` (`license_plate`, `vehicle_type`) VALUES ('PPI7812', 'Motorcycle');
INSERT INTO `CurbspringsDB`.`Vehicle` (`license_plate`, `vehicle_type`) VALUES ('PMB3610', 'Truck');
INSERT INTO `CurbspringsDB`.`Vehicle` (`license_plate`, `vehicle_type`) VALUES ('IIH2673', 'Car');
INSERT INTO `CurbspringsDB`.`Vehicle` (`license_plate`, `vehicle_type`) VALUES ('NHB8964', 'Truck');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`User_owns_vehicle`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`User_owns_vehicle` (`user_id`, `license_plate`) VALUES (1, 'KBX5686');
INSERT INTO `CurbspringsDB`.`User_owns_vehicle` (`user_id`, `license_plate`) VALUES (2, 'PPI7812');
INSERT INTO `CurbspringsDB`.`User_owns_vehicle` (`user_id`, `license_plate`) VALUES (3, 'PMB3610');
INSERT INTO `CurbspringsDB`.`User_owns_vehicle` (`user_id`, `license_plate`) VALUES (4, 'IIH2673');
INSERT INTO `CurbspringsDB`.`User_owns_vehicle` (`user_id`, `license_plate`) VALUES (5, 'NHB8964');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`Reservation`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`Reservation` (`reservation_id`, `user_id`, `spot_id`, `license_plate`, `start_time`, `end_time`, `status`) VALUES (1, 1, 3, 'KBX5686', '2024-11-20 10:00', '2024-11-20 12:00', 'Reserved');
INSERT INTO `CurbspringsDB`.`Reservation` (`reservation_id`, `user_id`, `spot_id`, `license_plate`, `start_time`, `end_time`, `status`) VALUES (2, 2, 4, 'PPI7812', '2024-11-21 14:00', '2024-11-21 16:00', 'Completed');
INSERT INTO `CurbspringsDB`.`Reservation` (`reservation_id`, `user_id`, `spot_id`, `license_plate`, `start_time`, `end_time`, `status`) VALUES (3, 3, 2, 'PMB3610', '2024-11-22 9:00', '2024-11-22 11:00', 'Cancelled');
INSERT INTO `CurbspringsDB`.`Reservation` (`reservation_id`, `user_id`, `spot_id`, `license_plate`, `start_time`, `end_time`, `status`) VALUES (4, 4, 5, 'IIH2673', '2024-11-23 8:00', '2024-11-23 10:00', 'Reserved');
INSERT INTO `CurbspringsDB`.`Reservation` (`reservation_id`, `user_id`, `spot_id`, `license_plate`, `start_time`, `end_time`, `status`) VALUES (5, 5, 1, 'NHB8964', '2024-11-24 13:00', '2024-11-24 15:00', 'Completed');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`Payment`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`Payment` (`payment_id`, `user_id`, `amount`, `payment_method`, `payment_status`, `transaction_date`) VALUES (1, 1, 12.50, 'CreditCard', 'Completed', '2024-11-20 12:15');
INSERT INTO `CurbspringsDB`.`Payment` (`payment_id`, `user_id`, `amount`, `payment_method`, `payment_status`, `transaction_date`) VALUES (2, 2, 20.00, 'GooglePay', 'Completed', '2024-11-21 16:30');
INSERT INTO `CurbspringsDB`.`Payment` (`payment_id`, `user_id`, `amount`, `payment_method`, `payment_status`, `transaction_date`) VALUES (3, 3, 8.75, 'DebitCard', 'Failed', '2024-11-22 11:10');
INSERT INTO `CurbspringsDB`.`Payment` (`payment_id`, `user_id`, `amount`, `payment_method`, `payment_status`, `transaction_date`) VALUES (4, 4, 15.00, 'ApplePay', 'Completed', '2024-11-23 10:20');
INSERT INTO `CurbspringsDB`.`Payment` (`payment_id`, `user_id`, `amount`, `payment_method`, `payment_status`, `transaction_date`) VALUES (5, 5, 10.00, 'CreditCard', 'Pending', '2024-11-24 15:05');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`Coupon`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`Coupon` (`code`, `discount_amount`, `is_active`) VALUES ('COUPON10', 10.00, 1);
INSERT INTO `CurbspringsDB`.`Coupon` (`code`, `discount_amount`, `is_active`) VALUES ('WELCOME5', 5.00, 1);
INSERT INTO `CurbspringsDB`.`Coupon` (`code`, `discount_amount`, `is_active`) VALUES ('BONUS20', 20.00, 0);
INSERT INTO `CurbspringsDB`.`Coupon` (`code`, `discount_amount`, `is_active`) VALUES ('SPRING15', 15.00, 1);
INSERT INTO `CurbspringsDB`.`Coupon` (`code`, `discount_amount`, `is_active`) VALUES ('DISCOUNT7', 7.00, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`User_has_Coupon`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`User_has_Coupon` (`user_id`, `code`) VALUES (1, 'COUPON10');
INSERT INTO `CurbspringsDB`.`User_has_Coupon` (`user_id`, `code`) VALUES (2, 'WELCOME5');
INSERT INTO `CurbspringsDB`.`User_has_Coupon` (`user_id`, `code`) VALUES (3, 'BONUS20');
INSERT INTO `CurbspringsDB`.`User_has_Coupon` (`user_id`, `code`) VALUES (4, 'SPRING15');
INSERT INTO `CurbspringsDB`.`User_has_Coupon` (`user_id`, `code`) VALUES (5, 'DISCOUNT7');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CurbspringsDB`.`Review`
-- -----------------------------------------------------
START TRANSACTION;
USE `CurbspringsDB`;
INSERT INTO `CurbspringsDB`.`Review` (`review_id`, `user_id`, `spot_id`, `rating`, `review_text`, `review_date`) VALUES (1, 1, 3, '5', 'Very good', '2024-11-20 12:30');
INSERT INTO `CurbspringsDB`.`Review` (`review_id`, `user_id`, `spot_id`, `rating`, `review_text`, `review_date`) VALUES (2, 2, 4, '4', 'Good spot but expensive', '2024-11-21 16:45');
INSERT INTO `CurbspringsDB`.`Review` (`review_id`, `user_id`, `spot_id`, `rating`, `review_text`, `review_date`) VALUES (3, 3, 2, '3', 'I doesnt have good entrance', '2024-11-22 11:20');
INSERT INTO `CurbspringsDB`.`Review` (`review_id`, `user_id`, `spot_id`, `rating`, `review_text`, `review_date`) VALUES (4, 4, 5, '5', 'Ideal locaation', '2024-11-23 10:40');
INSERT INTO `CurbspringsDB`.`Review` (`review_id`, `user_id`, `spot_id`, `rating`, `review_text`, `review_date`) VALUES (5, 5, 1, '4', 'Very spacious spot', '2024-11-24 15:15');

COMMIT;

