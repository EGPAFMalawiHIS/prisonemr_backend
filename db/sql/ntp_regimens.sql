-- MySQL dump 10.13  Distrib 5.7.25, for Linux (x86_64)
--
-- Host: localhost    Database: mlambe_api
-- ------------------------------------------------------
-- Server version	5.7.25-0ubuntu0.18.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ntp_regimens`
--

DROP TABLE IF EXISTS `ntp_regimens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ntp_regimens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `drug_id` bigint(20) DEFAULT NULL,
  `am_dose` float DEFAULT NULL,
  `noon_dose` float DEFAULT '0',
  `pm_dose` float DEFAULT '0',
  `min_weight` float DEFAULT NULL,
  `max_weight` float DEFAULT NULL,
  `creator` int(11) DEFAULT '0',
  `retired_by` float DEFAULT '0',
  `voided` int(11) DEFAULT '0',
  `void_reason` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ntp_regimens_on_drug_id` (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ntp_regimens`
--

LOCK TABLES `ntp_regimens` WRITE;
/*!40000 ALTER TABLE `ntp_regimens` DISABLE KEYS */;
INSERT INTO `ntp_regimens` VALUES (1,986,1,0,0,0,7,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(2,986,2,0,0,8,11,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(3,986,3,0,0,12,15,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(4,986,4,0,0,16,24,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(5,987,1,0,0,4,7,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(6,987,2,0,0,8,11,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(7,987,3,0,0,12,15,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(8,987,4,0,0,16,24,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(9,103,1,0,0,0,7,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(10,103,2,0,0,8,11,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(11,103,3,0,0,12,15,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(12,103,4,0,0,16,24,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(13,988,2,0,0,25,37,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(14,988,3,0,0,38,54,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(15,988,4,0,0,55,74,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(16,988,5,0,0,75,1000,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(17,19,2,0,0,25,37,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(18,19,3,0,0,38,54,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(19,19,4,0,0,55,74,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(20,19,5,0,0,75,1000,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(21,989,1,0,0,30,35,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(22,990,1,0,0,36,45,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(23,991,1,0,0,46,1000,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(24,992,1,0,0,30,35,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(25,993,1,0,0,36,55,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(26,994,1,0,0,56,1000,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(27,995,1,0,0,30,35,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(28,996,1,0,0,36,45,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(29,997,1,0,0,46,55,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(30,998,1,0,0,56,70,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(31,999,1,0,0,71,1000,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(32,1000,1,0,0,30,35,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(33,1001,1,0,0,36,45,1,0,0,NULL,'2019-08-13 14:04:55','2019-08-13 14:04:55'),(34,1002,1,0,0,46,55,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(35,1003,1,0,0,56,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(36,1004,1,0,0,0,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(37,1005,1,0,1,30,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(38,1006,1,0,1,46,70,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(39,1007,1,0,1,71,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(40,1008,1,0,1,30,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(41,1009,1,0,1,46,70,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(42,1010,1,0,1,71,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(43,1011,1,0,1,30,55,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(44,1012,1,0,1,56,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(45,1013,1,0,1,30,70,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(46,1014,1,0,1,71,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(47,1015,1,0,0,30,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(48,1016,1,0,0,30,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(49,1017,1,0,0,30,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(50,1018,1,0,0,30,33,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(51,1019,1,0,0,34,40,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(52,1020,1,0,0,41,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(53,1021,1,0,0,46,50,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(54,1022,1,0,0,51,70,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(55,1023,1,0,0,71,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(56,1024,1,0,0,30,33,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(57,1025,1,0,0,34,40,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(58,1026,1,0,0,41,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(59,1027,1,0,0,46,50,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(60,1028,1,0,0,51,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(61,1029,1,0,0,30,33,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(62,1030,1,0,0,34,40,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(63,1031,1,0,0,41,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(64,1032,1,0,0,46,50,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(65,1033,1,0,0,51,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(66,1034,1,0,0,30,33,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(67,1035,1,0,0,34,40,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(68,1036,1,0,0,41,45,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(69,1037,1,0,0,46,50,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(70,1038,1,0,0,51,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(71,83,1,0,0,0,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(72,76,1,0,0,0,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56'),(73,1041,1,0,0,0,1000,1,0,0,NULL,'2019-08-13 14:04:56','2019-08-13 14:04:56');
/*!40000 ALTER TABLE `ntp_regimens` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-13 14:09:45