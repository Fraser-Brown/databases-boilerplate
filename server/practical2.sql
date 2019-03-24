-- MySQL dump 10.16  Distrib 10.2.19-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: feb7_cs3101_Practical2_db
-- ------------------------------------------------------
-- Server version	10.2.19-MariaDB

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
-- Table structure for table `audiobook`
--

DROP TABLE IF EXISTS `audiobook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiobook` (
  `ISBN` varchar(20) COLLATE utf8_bin NOT NULL,
  `title` tinytext COLLATE utf8_bin DEFAULT NULL,
  `narrator_id` int(11) DEFAULT NULL,
  `running_time` time DEFAULT NULL,
  `age_rating` int(11) DEFAULT NULL,
  `purchase_price` decimal(5,2) DEFAULT NULL,
  `publisher_name` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `published_date` date DEFAULT NULL,
  `audiofile` blob DEFAULT NULL,
  PRIMARY KEY (`ISBN`),
  KEY `narrator_id` (`narrator_id`),
  KEY `publisher_name` (`publisher_name`),
  CONSTRAINT `audiobook_ibfk_1` FOREIGN KEY (`narrator_id`) REFERENCES `contributor` (`ID`),
  CONSTRAINT `audiobook_ibfk_2` FOREIGN KEY (`publisher_name`) REFERENCES `publisher` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobook`
--

LOCK TABLES `audiobook` WRITE;
/*!40000 ALTER TABLE `audiobook` DISABLE KEYS */;
INSERT INTO `audiobook` VALUES ('860-1404211171','Fantastic Beasts and Where to Find Them',3,'01:45:00',0,12.00,'Pottermore Publishing','2017-01-14',''),('978-0099457046','Moab Is My Washpot',3,'11:33:00',12,22.00,'Random House AudioBooks','2017-01-01',''),('978-0393957242','Gulliver\'s Travels',4,'05:35:00',0,38.00,'Penguin Books Ltd','2012-01-12',''),('978-1408855652','Harry Potter and the Philosopher\'s Stone',3,'08:44:00',0,7.19,'Pottermore Publishing','2014-01-01',''),('978-1611749731','The Gun Seller',6,'10:45:00',16,16.00,'HighBridge Audio','2012-01-16','');
/*!40000 ALTER TABLE `audiobook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audiobookAuthor`
--

DROP TABLE IF EXISTS `audiobookAuthor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiobookAuthor` (
  `contributor_ID` int(11) NOT NULL,
  `ISBN` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`contributor_ID`,`ISBN`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `audiobookAuthor_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `audiobook` (`ISBN`),
  CONSTRAINT `audiobookAuthor_ibfk_2` FOREIGN KEY (`contributor_ID`) REFERENCES `contributor` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobookAuthor`
--

LOCK TABLES `audiobookAuthor` WRITE;
/*!40000 ALTER TABLE `audiobookAuthor` DISABLE KEYS */;
INSERT INTO `audiobookAuthor` VALUES (3,'978-0099457046'),(4,'978-1611749731'),(7,'860-1404211171'),(7,'978-1408855652'),(8,'860-1404211171'),(11,'978-0393957242');
/*!40000 ALTER TABLE `audiobookAuthor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audiobookPurchase`
--

DROP TABLE IF EXISTS `audiobookPurchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiobookPurchase` (
  `customer_ID` int(11) NOT NULL,
  `ISBN` varchar(20) COLLATE utf8_bin NOT NULL,
  `purchase_date` datetime DEFAULT NULL,
  PRIMARY KEY (`customer_ID`,`ISBN`),
  CONSTRAINT `audiobookPurchase_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobookPurchase`
--

LOCK TABLES `audiobookPurchase` WRITE;
/*!40000 ALTER TABLE `audiobookPurchase` DISABLE KEYS */;
INSERT INTO `audiobookPurchase` VALUES (3,'978-0099457046','2018-01-23 00:00:00'),(3,'978-1408855652','2018-01-23 00:00:00'),(4,'978-0393957242','2018-01-23 00:00:00'),(5,'978-0393957242','2018-01-23 00:00:00'),(7,'978-0393957242','2018-01-23 00:00:00'),(7,'978-1408855652','2018-01-23 00:00:00');
/*!40000 ALTER TABLE `audiobookPurchase` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`feb7`@`%`*/ /*!50003 trigger updatedVerified before insert on audiobookPurchase for each row begin if new.customer_ID + new.ISBN in (select customer_ID + ISBN from audiobookReview) then update audiobookReview set verified = TRUE where audiobookReview.customer_ID = new.customer_ID and audiobookReview.ISBN = new.ISBN ;end if;end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`feb7`@`%`*/ /*!50003 trigger ageCheck before insert on audiobookPurchase for each row begin if (select DATEDIFF(now(),person.date_of_birth)/365 from person where person.ID = new.customer_id) < (select age_rating from audiobook where audiobook.ISBN = new.ISBN) then signal sqlstate '45002' set message_text = "Too young";end if;end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `audiobookReview`
--

DROP TABLE IF EXISTS `audiobookReview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audiobookReview` (
  `customer_ID` int(11) NOT NULL,
  `ISBN` varchar(20) COLLATE utf8_bin NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `title` tinytext COLLATE utf8_bin DEFAULT NULL,
  `comment` text COLLATE utf8_bin DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`customer_ID`,`ISBN`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `audiobookReview_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`ID`),
  CONSTRAINT `audiobookReview_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `audiobook` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiobookReview`
--

LOCK TABLES `audiobookReview` WRITE;
/*!40000 ALTER TABLE `audiobookReview` DISABLE KEYS */;
INSERT INTO `audiobookReview` VALUES (1,'860-1404211171',4,'Fantastic Beasts and Where to Find Them',' Fantastic Book - Loved listening to this book before bed.',0),(7,'978-1408855652',5,'Harry Potter and the Philosopher\'s Stone',' Best audio book EVER! - Best audio book I ever listened to. Stephen Fry does an excellent job reading the superb prose written by a genius author.',1),(10,'860-1404211171',2,'Fantastic Beasts and Where to Find Them',' Not as good as Harry Potter - Never read the book, seen the movie or listened to the audio book but I can tell you right now - its not as good as harry potter',0);
/*!40000 ALTER TABLE `audiobookReview` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`feb7`@`%`*/ /*!50003 trigger 5StarRange before insert on audiobookReview for each row begin if new.rating not in (1,2,3,4,5) then signal sqlstate '45001' set message_text = "Out of 5 star range";end if;end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`feb7`@`%`*/ /*!50003 trigger checkVerified before insert on audiobookReview for each row begin if new.customer_ID + new.ISBN in (select customer_ID + ISBN from audiobookPurchase) then set new.verified = TRUE;else set new.verified = FALSE;end if;end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `boughtOwnBook`
--

DROP TABLE IF EXISTS `boughtOwnBook`;
/*!50001 DROP VIEW IF EXISTS `boughtOwnBook`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `boughtOwnBook` (
  `bobID` tinyint NOT NULL,
  `title` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `chapter`
--

DROP TABLE IF EXISTS `chapter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chapter` (
  `ISBN` varchar(20) COLLATE utf8_bin NOT NULL,
  `number` smallint(6) NOT NULL,
  `title` tinytext COLLATE utf8_bin DEFAULT NULL,
  `start` time DEFAULT NULL,
  PRIMARY KEY (`ISBN`,`number`),
  CONSTRAINT `chapter_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `audiobook` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chapter`
--

LOCK TABLES `chapter` WRITE;
/*!40000 ALTER TABLE `chapter` DISABLE KEYS */;
INSERT INTO `chapter` VALUES ('978-0393957242',1,' Part I: A Voyage to Lilliput:','00:00:00'),('978-0393957242',2,' Part II: A Voyage to Brobdingnag:','01:40:07'),('978-0393957242',3,' Part III: A Voyage to Laputa, Balnibarbi, Luggnagg, Glubbdubdrib and Japan:','03:01:09'),('978-0393957242',4,' Part IV: A Voyage to the Land of the Houyhnhnms:','04:22:05'),('978-1408855652',1,' The Boy Who Lived:','00:00:00'),('978-1408855652',2,' The Vanishing Glass:','00:35:03'),('978-1408855652',3,' The Letters from No One:','01:07:27'),('978-1408855652',4,' The Keeper of Keys:','01:38:01'),('978-1408855652',5,' Diagon Alley:','02:08:25'),('978-1408855652',6,' The Journey from Platform Nine and Three-Quarters:','02:38:50'),('978-1408855652',7,' The Sorting Hat:','03:09:43'),('978-1408855652',8,' The Potions Master:','03:40:03'),('978-1408855652',9,' The Midnight Due:','04:10:27'),('978-1408855652',10,' Hallowe\'en:','04:40:48'),('978-1408855652',11,' Quidditch:','05:11:06'),('978-1408855652',12,' The Mirror of Erised:','05:32:38'),('978-1408855652',13,' Nicholas Flamel:','06:11:56'),('978-1408855652',14,' Norbert the Norwegian Ridgeback:','06:52:20'),('978-1408855652',15,' The Forbidden Forest:','07:12:43'),('978-1408855652',16,' Through the Trapdoor:','07:43:05'),('978-1408855652',17,' The Man with Two Faces:','08:15:30');
/*!40000 ALTER TABLE `chapter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contributor`
--

DROP TABLE IF EXISTS `contributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contributor` (
  `ID` int(11) NOT NULL,
  `biography` text COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `contributor_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `person` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contributor`
--

LOCK TABLES `contributor` WRITE;
/*!40000 ALTER TABLE `contributor` DISABLE KEYS */;
INSERT INTO `contributor` VALUES (3,'An English comedian, actor, writer, presenter, and activist.'),(4,'An English actor, musician, comedian, and writer.'),(6,'An English actor and narrator. Initially a stage actor, he has a wide-ranging career in television drama, was a game show announcer in Britain, and a voice-over narrator for television, and film. In recent years he has narrated a large number of audio books and received an Audie (Audio book Oscar) in 2010.'),(7,'After finishing the first book and whilst training as a teacher, Harry Potter was accepted for publication by Bloomsbury. Harry Potter and the Philosopher’s Stone quickly became a bestseller on publication in 1997. As the book was translated into other languages, Harry Potter started spreading round the globe – and J.K. Rowling was soon receiving thousands of letters from fans.'),(8,'Famed expert in the field of Magizoology.'),(11,'Irish author, clergyman and satirist Jonathan Swift received a bachelor\'s degree from Trinity College and then worked as a statesman\'s assistant. Eventually, he became dean of St. Patrick\'s Cathedral in Dublin.');
/*!40000 ALTER TABLE `contributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `ID` int(11) NOT NULL,
  `email_address` tinytext COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `person` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'bob_jnr@bobson.com'),(2,'bob_snr@bobson.com'),(3,'sfry@email.com'),(4,'hugh@laurie.com'),(5,'ruth@letham.com'),(7,'jk@rowling.com'),(9,'pippa.smith@email.com'),(10,'jon@spellbad.com');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login` (
  `username` varchar(30) COLLATE utf8_bin NOT NULL,
  `password` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('hello','THOMJ67P1ifC71HVxFqvVlR/IeY=');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `onlyCustomers`
--

DROP TABLE IF EXISTS `onlyCustomers`;
/*!50001 DROP VIEW IF EXISTS `onlyCustomers`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `onlyCustomers` (
  `PID` tinyint NOT NULL,
  `forename` tinyint NOT NULL,
  `middle_initials` tinyint NOT NULL,
  `surname` tinyint NOT NULL,
  `email_address` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `forename` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `middle_initials` varchar(5) COLLATE utf8_bin DEFAULT NULL,
  `surname` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'Bob','B A','Bobson','2009-01-31'),(2,'Bob','A B','Bobson','1978-01-23'),(3,'Stephen','','Fry','1957-01-24'),(4,'Hugh','','Laurie','1959-01-10'),(5,'Ruth','','Letham','1978-01-23'),(6,'Simon','','Prebble','1942-01-13'),(7,'JK','','Rowling','1965-01-31'),(8,'Newton','A F','Scamander','1897-01-24'),(9,'Pippa','A','Smith','2005-01-01'),(10,'Jon','Q','Spellbad','2007-01-01'),(11,'Jonathan','','Swift','1667-01-30');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phoneNumber`
--

DROP TABLE IF EXISTS `phoneNumber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phoneNumber` (
  `ID` int(11) NOT NULL,
  `phone_number` varchar(14) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`,`phone_number`),
  CONSTRAINT `phoneNumber_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `customer` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phoneNumber`
--

LOCK TABLES `phoneNumber` WRITE;
/*!40000 ALTER TABLE `phoneNumber` DISABLE KEYS */;
INSERT INTO `phoneNumber` VALUES (5,'02222 111 333'),(9,' 07777 222 333'),(9,'01111 222 333');
/*!40000 ALTER TABLE `phoneNumber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `name` varchar(50) COLLATE utf8_bin NOT NULL,
  `building` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `street` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `city` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `country` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `postcode` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `phone_number` varchar(14) COLLATE utf8_bin DEFAULT NULL,
  `established_date` date DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES ('HighBridge Audio','270','Skipjack Road','Prince Frederick','USA','MD 20678','1-800-755-8532','1901-01-01'),('Penguin Books Ltd','80','Strand','London','UK','WC2R 0RL','861590','1981-01-01'),('Pottermore Publishing','PO Box 7828','','London','UK','W1A 4GE','12345','2011-01-31'),('Random House AudioBooks','20','Vauxhall Bridge Road','London','UK','SW1V2SA','+4402078408400','1928-01-01');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `q1`
--

DROP TABLE IF EXISTS `q1`;
/*!50001 DROP VIEW IF EXISTS `q1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `q1` (
  `PID` tinyint NOT NULL,
  `forename` tinyint NOT NULL,
  `middle_initials` tinyint NOT NULL,
  `surname` tinyint NOT NULL,
  `totalSpend` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `q2`
--

DROP TABLE IF EXISTS `q2`;
/*!50001 DROP VIEW IF EXISTS `q2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `q2` (
  `ISBN` tinyint NOT NULL,
  `title` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `q3`
--

DROP TABLE IF EXISTS `q3`;
/*!50001 DROP VIEW IF EXISTS `q3`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `q3` (
  `ID` tinyint NOT NULL,
  `forename` tinyint NOT NULL,
  `middle_initials` tinyint NOT NULL,
  `surname` tinyint NOT NULL,
  `group_concat(' ', title order by title asc)` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'feb7_cs3101_Practical2_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `addContributor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`feb7`@`%` PROCEDURE `addContributor`(f varchar(20), m varchar(5), s varchar(20), dob DATE, bio TEXT )
begin if not exists (select forename from person where person.forename = f) then insert into person (forename, middle_initials,surname,date_of_birth) values (f, m, s, dob)  ;end if;insert into contributor values ((select ID from person where person.forename = f and person.middle_initials = m and person.surname = s),bio); end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addCustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_bin */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`feb7`@`%` PROCEDURE `addCustomer`(f varchar(20), m varchar(5), s varchar(20), dob DATE, email TINYTEXT )
begin if not exists (select forename, middle_initials, surname from person where forename = f and middle_initials = m and surname = s) then insert into person (forename, middle_initials,surname,date_of_birth) values (f, m, s, dob)  ;end if;insert into customer values ((select ID from person where person.forename = f and person.middle_initials = m and person.surname = s),email); end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `boughtOwnBook`
--

/*!50001 DROP TABLE IF EXISTS `boughtOwnBook`*/;
/*!50001 DROP VIEW IF EXISTS `boughtOwnBook`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_bin */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`feb7`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `boughtOwnBook` AS select distinct `contributor`.`ID` AS `bobID`,`audiobook`.`title` AS `title` from (((`contributor` join `audiobook`) join `audiobookPurchase`) join `audiobookAuthor`) where `contributor`.`ID` = `audiobookPurchase`.`customer_ID` and `audiobookPurchase`.`ISBN` = `audiobook`.`ISBN` and (`contributor`.`ID` = `audiobook`.`narrator_id` or `contributor`.`ID` = `audiobookAuthor`.`contributor_ID` and `audiobookAuthor`.`ISBN` = `audiobook`.`ISBN`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `onlyCustomers`
--

/*!50001 DROP TABLE IF EXISTS `onlyCustomers`*/;
/*!50001 DROP VIEW IF EXISTS `onlyCustomers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_bin */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`feb7`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `onlyCustomers` AS select distinct `person`.`ID` AS `PID`,`person`.`forename` AS `forename`,`person`.`middle_initials` AS `middle_initials`,`person`.`surname` AS `surname`,`customer`.`email_address` AS `email_address` from (`person` join `customer`) where `person`.`ID` = `customer`.`ID` order by `person`.`forename` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `q1`
--

/*!50001 DROP TABLE IF EXISTS `q1`*/;
/*!50001 DROP VIEW IF EXISTS `q1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_bin */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`feb7`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `q1` AS select distinct `onlyCustomers`.`PID` AS `PID`,`onlyCustomers`.`forename` AS `forename`,`onlyCustomers`.`middle_initials` AS `middle_initials`,`onlyCustomers`.`surname` AS `surname`,case 1 when !(`onlyCustomers`.`PID` in (select `audiobookPurchase`.`customer_ID` from `audiobookPurchase`)) then 0 else sum(`audiobook`.`purchase_price`) end AS `totalSpend` from ((`onlyCustomers` join `audiobook`) join `audiobookPurchase`) where !(`onlyCustomers`.`PID` in (select `audiobookPurchase`.`customer_ID` from `audiobookPurchase`)) or `onlyCustomers`.`PID` = `audiobookPurchase`.`customer_ID` and `audiobook`.`ISBN` = `audiobookPurchase`.`ISBN` group by `onlyCustomers`.`PID` order by case 1 when !(`onlyCustomers`.`PID` in (select `audiobookPurchase`.`customer_ID` from `audiobookPurchase`)) then 0 else sum(`audiobook`.`purchase_price`) end desc,`onlyCustomers`.`forename` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `q2`
--

/*!50001 DROP TABLE IF EXISTS `q2`*/;
/*!50001 DROP VIEW IF EXISTS `q2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_bin */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`feb7`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `q2` AS select `audiobook`.`ISBN` AS `ISBN`,`audiobook`.`title` AS `title` from `audiobook` where !(`audiobook`.`ISBN` in (select `audiobookPurchase`.`ISBN` from `audiobookPurchase`)) order by `audiobook`.`title` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `q3`
--

/*!50001 DROP TABLE IF EXISTS `q3`*/;
/*!50001 DROP VIEW IF EXISTS `q3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_bin */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`feb7`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `q3` AS select `person`.`ID` AS `ID`,`person`.`forename` AS `forename`,`person`.`middle_initials` AS `middle_initials`,`person`.`surname` AS `surname`,group_concat(' ',`boughtOwnBook`.`title` order by `boughtOwnBook`.`title` ASC separator ',') AS `group_concat(' ', title order by title asc)` from (`person` join `boughtOwnBook`) where `person`.`ID` = `boughtOwnBook`.`bobID` group by `person`.`ID` order by `person`.`ID` */;
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

-- Dump completed on 2018-11-26 17:23:01
