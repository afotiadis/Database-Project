DROP SCHEMA IF EXISTS `curbspringsdb`;
CREATE SCHEMA `curbspringsdb`;
USE `curbspringsdb`;
-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: curbspringsdb
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `admin_view`
--

DROP TABLE IF EXISTS `admin_view`;
/*!50001 DROP VIEW IF EXISTS `admin_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `admin_view` AS SELECT 
 1 AS `user_id`,
 1 AS `spot_owner_id`,
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `status`,
 1 AS `address`,
 1 AS `license_plate`,
 1 AS `vehicle_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `code` varchar(50) NOT NULL,
  `discount_amount` decimal(4,2) DEFAULT NULL,
  `is_active` tinyint DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES ('BONUS20',20.00,0),('COUPON10',10.00,1),('DISCOUNT7',7.00,1),('SPRING15',15.00,1),('WELCOME5',5.00,1);
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parkingspot`
--

DROP TABLE IF EXISTS `parkingspot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parkingspot` (
  `spot_id` int NOT NULL,
  `spot_owner_id` int DEFAULT NULL,
  `address` varchar(35) DEFAULT NULL,
  `type` enum('Open','Garage','Underground') DEFAULT NULL,
  `has_charger` tinyint DEFAULT NULL,
  `available` tinyint DEFAULT NULL,
  PRIMARY KEY (`spot_id`),
  KEY `spot_onwer_id_idx` (`spot_owner_id`),
  CONSTRAINT `spot_onwer_id_psfk` FOREIGN KEY (`spot_owner_id`) REFERENCES `spotowner` (`spot_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parkingspot`
--

LOCK TABLES `parkingspot` WRITE;
/*!40000 ALTER TABLE `parkingspot` DISABLE KEYS */;
INSERT INTO `parkingspot` VALUES (1,1,'Egnatias 42','Open',1,1),(2,1,'Tsimiski 12','Garage',0,1),(3,3,'Leof. Nikis 104','Underground',0,1),(4,5,'Ippodromiou 58','Garage',1,0),(5,2,'Agias Sofias 95','Open',1,0),(6,2,'Aetoraxis 53','Open',0,1),(7,4,'Agiou Dimitriou 87','Garage',1,0),(8,4,'Iasonidou 31','Underground',1,1);
/*!40000 ALTER TABLE `parkingspot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` enum('DebitCard','CreditCard','GooglePay','ApplePay') DEFAULT NULL,
  `payment_status` enum('Pending','Completed','Failed') DEFAULT NULL,
  `transaction_date` datetime DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `user_id_pmfk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,12.50,'CreditCard','Completed','2024-11-20 12:15:00'),(2,2,20.00,'GooglePay','Completed','2024-11-21 16:30:00'),(3,3,8.75,'DebitCard','Failed','2024-11-22 11:10:00'),(4,4,15.00,'ApplePay','Completed','2024-11-23 10:20:00'),(5,5,10.00,'CreditCard','Pending','2024-11-24 15:05:00');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservation_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `spot_id` int DEFAULT NULL,
  `license_plate` varchar(7) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('Reserved','Cancelled','Completed') DEFAULT NULL,
  PRIMARY KEY (`reservation_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `spot_id_idx` (`spot_id`),
  KEY `license_plate_idx` (`license_plate`),
  CONSTRAINT `license_plate_rvfk` FOREIGN KEY (`license_plate`) REFERENCES `vehicle` (`license_plate`),
  CONSTRAINT `spot_id_rvfk` FOREIGN KEY (`spot_id`) REFERENCES `parkingspot` (`spot_id`),
  CONSTRAINT `user_id_rvfk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,1,3,'KBX5686','2024-11-20 10:00:00','2024-11-20 12:00:00','Reserved'),(2,2,4,'PPI7812','2024-11-21 14:00:00','2024-11-21 16:00:00','Completed'),(3,3,2,'PMB3610','2024-11-22 09:00:00','2024-11-22 11:00:00','Cancelled'),(4,4,5,'IIH2673','2024-11-23 08:00:00','2024-11-23 10:00:00','Reserved'),(5,5,1,'NHB8964','2024-11-24 13:00:00','2024-11-24 15:00:00','Completed');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `spot_id` int DEFAULT NULL,
  `rating` enum('1','2','3','4','5') DEFAULT NULL,
  `review_text` text,
  `review_date` datetime DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `spot_id_idx` (`spot_id`),
  CONSTRAINT `spot_id_refk` FOREIGN KEY (`spot_id`) REFERENCES `parkingspot` (`spot_id`),
  CONSTRAINT `user_id_refk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,1,3,'5','Very good','2024-11-20 12:30:00'),(2,2,4,'4','Good spot but expensive','2024-11-21 16:45:00'),(3,3,2,'3','I doesnt have good entrance','2024-11-22 11:20:00'),(4,4,5,'5','Ideal location','2024-11-23 10:40:00'),(5,5,1,'4','Very spacious spot','2024-11-24 15:15:00'),(6,5,2,'4','Remote location but good prices','2024-10-24 15:00:00'),(7,4,6,'5','Spot has available charger','2024-11-17 12:15:00'),(8,3,1,'2','Bad service','2024-09-24 11:00:00');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `spot_owner_view`
--

DROP TABLE IF EXISTS `spot_owner_view`;
/*!50001 DROP VIEW IF EXISTS `spot_owner_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `spot_owner_view` AS SELECT 
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `status`,
 1 AS `address`,
 1 AS `license_plate`,
 1 AS `vehicle_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `spotowner`
--

DROP TABLE IF EXISTS `spotowner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spotowner` (
  `spot_owner_id` int NOT NULL,
  `spot_owner_name_surname` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `hash_password` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`spot_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spotowner`
--

LOCK TABLES `spotowner` WRITE;
/*!40000 ALTER TABLE `spotowner` DISABLE KEYS */;
INSERT INTO `spotowner` VALUES (1,'Thanasis Tsarnadelis','tsarnadelis@gmail.com','6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7'),(2,'Giorgos Pittis','pittis@outlook.com','5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931'),(3,'Alexandros Fotiadis','fotiadis@yahoo.com','6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7'),(4,'Thomas Karanikiotis','thomas@issel.com','eda71746c01c3f465ffd02b6da15a6518e6fbc8f06f1ac525be193be5507069d'),(5,'Giorgos Siachamis','giorgos@cyclopt.com','5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931'),(6,'Giorgos Stergiou','geoster@gmail.com','59cfdd99fab00c358f81f7b8db69216e6a7ecaf896f3b21122b07481be9b6e71'),(7,'Dimitris Papadopoulos','papadodim@gmail.com','88e1fbd99f5670ec4aabab3aa7797d8768667190e3d8ecd8645c949752598465'),(8,'Fotis Dimitriou','fotis2014@yahoo.com','3198acae4487cc5c9169ec9c310fae374e3b6b02adba27563d2d3c0baba1d34d');
/*!40000 ALTER TABLE `spotowner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `user_name_surname` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `hash_password` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Thanasis Tsarnadelis','tsarnadelis@gmail.com','6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7'),(2,'Giorgos Pittis','pittis@outlook.com','5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931'),(3,'Alexandros Fotiadis','fotiadis@yahoo.com','6f7ed1b31c53f788252395a08cc586e989d3ecf6a6611c82cba8b27c04f1e0a7'),(4,'Thomas Karanikiotis','thomas@issel.com','eda71746c01c3f465ffd02b6da15a6518e6fbc8f06f1ac525be193be5507069d'),(5,'Giorgos Siachamis','giorgos@cyclopt.com','5417922f2aeb237ec72f7d466610635a5d110f5f343ec0020e71f4b17f4d9931');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_has_coupon`
--

DROP TABLE IF EXISTS `user_has_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_has_coupon` (
  `user_id` int NOT NULL,
  `code` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`,`code`),
  KEY `code_idx` (`code`),
  CONSTRAINT `code_uhcfk` FOREIGN KEY (`code`) REFERENCES `coupon` (`code`),
  CONSTRAINT `user_id_uhcfk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_has_coupon`
--

LOCK TABLES `user_has_coupon` WRITE;
/*!40000 ALTER TABLE `user_has_coupon` DISABLE KEYS */;
INSERT INTO `user_has_coupon` VALUES (3,'BONUS20'),(1,'COUPON10'),(5,'DISCOUNT7'),(4,'SPRING15'),(2,'WELCOME5');
/*!40000 ALTER TABLE `user_has_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_owns_vehicle`
--

DROP TABLE IF EXISTS `user_owns_vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_owns_vehicle` (
  `user_id` int NOT NULL,
  `license_plate` varchar(7) NOT NULL,
  PRIMARY KEY (`user_id`,`license_plate`),
  KEY `license_plate_idx` (`license_plate`),
  CONSTRAINT `license_plate_uovfk` FOREIGN KEY (`license_plate`) REFERENCES `vehicle` (`license_plate`),
  CONSTRAINT `user_id_uovfk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_owns_vehicle`
--

LOCK TABLES `user_owns_vehicle` WRITE;
/*!40000 ALTER TABLE `user_owns_vehicle` DISABLE KEYS */;
INSERT INTO `user_owns_vehicle` VALUES (4,'IIH2673'),(1,'KBX5686'),(5,'NHB8964'),(3,'PMB3610'),(2,'PPI7812');
/*!40000 ALTER TABLE `user_owns_vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_view`
--

DROP TABLE IF EXISTS `user_view`;
/*!50001 DROP VIEW IF EXISTS `user_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_view` AS SELECT 
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `status`,
 1 AS `address`,
 1 AS `license_plate`,
 1 AS `vehicle_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `license_plate` varchar(7) NOT NULL,
  `vehicle_type` enum('Car','Truck','Motorcycle') DEFAULT NULL,
  PRIMARY KEY (`license_plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES ('IIH2673','Car'),('KBX5686','Car'),('NHB8964','Truck'),('PMB3610','Truck'),('PPI7812','Motorcycle');
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `admin_view`
--

/*!50001 DROP VIEW IF EXISTS `admin_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_view` AS select `reservation`.`user_id` AS `user_id`,`parkingspot`.`spot_owner_id` AS `spot_owner_id`,`reservation`.`start_time` AS `start_time`,`reservation`.`end_time` AS `end_time`,`reservation`.`status` AS `status`,`parkingspot`.`address` AS `address`,`vehicle`.`license_plate` AS `license_plate`,`vehicle`.`vehicle_type` AS `vehicle_type` from ((`reservation` join `parkingspot` on((`parkingspot`.`spot_id` = `reservation`.`spot_id`))) join `vehicle` on((`vehicle`.`license_plate` = `reservation`.`license_plate`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `spot_owner_view`
--

/*!50001 DROP VIEW IF EXISTS `spot_owner_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `spot_owner_view` AS select `reservation`.`start_time` AS `start_time`,`reservation`.`end_time` AS `end_time`,`reservation`.`status` AS `status`,`parkingspot`.`address` AS `address`,`vehicle`.`license_plate` AS `license_plate`,`vehicle`.`vehicle_type` AS `vehicle_type` from ((`reservation` join `parkingspot` on((`parkingspot`.`spot_id` = `reservation`.`spot_id`))) join `vehicle` on((`vehicle`.`license_plate` = `reservation`.`license_plate`))) where (`parkingspot`.`spot_owner_id` = 4) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_view`
--

/*!50001 DROP VIEW IF EXISTS `user_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_view` AS select `reservation`.`start_time` AS `start_time`,`reservation`.`end_time` AS `end_time`,`reservation`.`status` AS `status`,`parkingspot`.`address` AS `address`,`vehicle`.`license_plate` AS `license_plate`,`vehicle`.`vehicle_type` AS `vehicle_type` from ((`reservation` join `parkingspot` on((`parkingspot`.`spot_id` = `reservation`.`spot_id`))) join `vehicle` on((`vehicle`.`license_plate` = `reservation`.`license_plate`))) where (`reservation`.`user_id` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-19 16:06:28
