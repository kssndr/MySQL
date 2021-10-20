CREATE DATABASE  IF NOT EXISTS `sd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sd`;
-- MySQL dump 10.13  Distrib 8.0.26, for macos11 (x86_64)
--
-- Host: localhost    Database: sd
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `client_profile`
--

DROP TABLE IF EXISTS `client_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_profile` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'сотрудник, ученик, клиент, партнёр',
  `id_client` int unsigned NOT NULL COMMENT 'сотрудник, ученик, клиент, партнёр',
  `company` varchar(255) DEFAULT NULL COMMENT 'Типы сессии (обычная, пакет, название программы)\n',
  `position` varchar(255) DEFAULT NULL,
  `hd_profile` varchar(255) DEFAULT NULL,
  `Current_qty_tracks` int unsigned DEFAULT NULL,
  `Current_qty_session` int unsigned DEFAULT '0',
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_to_client_idx` (`id_client`),
  CONSTRAINT `profile_to_client` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_profile`
--

LOCK TABLES `client_profile` WRITE;
/*!40000 ALTER TABLE `client_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_clients_type` int unsigned NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `client_to_type_idx` (`id_clients_type`),
  CONSTRAINT `client_to_type` FOREIGN KEY (`id_clients_type`) REFERENCES `clients_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients_reports`
--

DROP TABLE IF EXISTS `clients_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients_reports` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_track` int unsigned NOT NULL,
  `id_track_step` int unsigned NOT NULL,
  `id_session` int unsigned NOT NULL COMMENT 'Рефлексия и открытия\n',
  `introspection_start` text COMMENT 'Конспект встречи',
  `facts` text COMMENT 'Итоги дз\n',
  `delta` text COMMENT 'Что не соответствует плану\n',
  `kpd` text COMMENT 'Ключевая причина дельты\n',
  `hw` varchar(45) DEFAULT NULL COMMENT 'Домашнее задание',
  `introspection_end` text COMMENT 'Рефлексия и открытия по итогу',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `to_track_idx` (`id_track`),
  KEY `to_track_step_idx` (`id_track_step`),
  KEY `to_session_idx` (`id_session`),
  CONSTRAINT `to_session` FOREIGN KEY (`id_session`) REFERENCES `sessions_list` (`id`),
  CONSTRAINT `to_track` FOREIGN KEY (`id_track`) REFERENCES `tracks_list` (`id`),
  CONSTRAINT `to_track_step` FOREIGN KEY (`id_track_step`) REFERENCES `clients_steps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients_reports`
--

LOCK TABLES `clients_reports` WRITE;
/*!40000 ALTER TABLE `clients_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `clients_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients_steps`
--

DROP TABLE IF EXISTS `clients_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients_steps` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_track` int unsigned NOT NULL,
  `step` text,
  `period` text,
  `okr` text COMMENT 'Этап плана, OKR\n',
  `activity` text COMMENT 'Что буду делать',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `steps_to_track_idx` (`id_track`),
  CONSTRAINT `steps_to_track` FOREIGN KEY (`id_track`) REFERENCES `tracks_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients_steps`
--

LOCK TABLES `clients_steps` WRITE;
/*!40000 ALTER TABLE `clients_steps` DISABLE KEYS */;
/*!40000 ALTER TABLE `clients_steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients_type`
--

DROP TABLE IF EXISTS `clients_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'сотрудник, ученик, клиент, партнёр',
  `name` varchar(45) DEFAULT NULL COMMENT 'Типы сессии (обычная, пакет, название программы)\n',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients_type`
--

LOCK TABLES `clients_type` WRITE;
/*!40000 ALTER TABLE `clients_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `clients_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_profile`
--

DROP TABLE IF EXISTS `coach_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_profile` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'сотрудник, ученик, клиент, партнёр',
  `id_coach` int unsigned NOT NULL COMMENT 'сотрудник, ученик, клиент, партнёр',
  `main_certificate` varchar(255) DEFAULT NULL COMMENT 'Типы сессии (обычная, пакет, название программы)\n',
  `occupation` varchar(255) DEFAULT NULL,
  `hd_profile` varchar(255) DEFAULT NULL,
  `coach_profile` varchar(45) DEFAULT NULL,
  `Current_qty_session` int unsigned DEFAULT '0',
  `Current_qty_clients` int unsigned DEFAULT '0',
  `Current_qty_tracks` int unsigned DEFAULT '0',
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_to_coach_idx` (`id_coach`),
  CONSTRAINT `profile_to_coach` FOREIGN KEY (`id_coach`) REFERENCES `coaches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_profile`
--

LOCK TABLES `coach_profile` WRITE;
/*!40000 ALTER TABLE `coach_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `coach_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_report`
--

DROP TABLE IF EXISTS `coach_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_report` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_track` int unsigned NOT NULL,
  `track_step_id` int unsigned NOT NULL COMMENT 'Конспект встречи',
  `id_session` int unsigned NOT NULL COMMENT 'Рефлексия и открытия\n',
  `strategy_step` int unsigned NOT NULL COMMENT 'Конспект встречи',
  `seccion_goal` text COMMENT 'Цели на сессию по треку',
  `obstacles` text COMMENT 'Препятствия, КПД, ограничивающие установки в работе\n',
  `session_results` text COMMENT 'Итоги сессии по треку\n',
  `insights` text COMMENT 'Ключевые открытия клиента, инсайты, самое ценное по треку\n',
  `observation` varchar(45) DEFAULT NULL COMMENT 'Выводы/итоги\n',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `coach_report_to_track_idx` (`id_track`),
  KEY `coach_report_to_step_idx` (`track_step_id`),
  KEY `coach_report_to_session_idx` (`id_session`),
  KEY `coach_report_to_strategy_step_idx` (`strategy_step`),
  CONSTRAINT `coach_report_to_session` FOREIGN KEY (`id_session`) REFERENCES `sessions_list` (`id`),
  CONSTRAINT `coach_report_to_step` FOREIGN KEY (`track_step_id`) REFERENCES `clients_steps` (`id`),
  CONSTRAINT `coach_report_to_strategy_step` FOREIGN KEY (`strategy_step`) REFERENCES `coach_strategy` (`id`),
  CONSTRAINT `coach_report_to_track` FOREIGN KEY (`id_track`) REFERENCES `tracks_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_report`
--

LOCK TABLES `coach_report` WRITE;
/*!40000 ALTER TABLE `coach_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `coach_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_strategy`
--

DROP TABLE IF EXISTS `coach_strategy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_strategy` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_track` int unsigned NOT NULL,
  `step` text,
  `qty_sessions` text,
  `theme` text COMMENT 'Этап плана, OKR\n',
  `activity` text COMMENT 'Что буду делать',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `strategy_to_track_idx` (`id_track`),
  CONSTRAINT `strategy_to_track` FOREIGN KEY (`id_track`) REFERENCES `tracks_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_strategy`
--

LOCK TABLES `coach_strategy` WRITE;
/*!40000 ALTER TABLE `coach_strategy` DISABLE KEYS */;
/*!40000 ALTER TABLE `coach_strategy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_type`
--

DROP TABLE IF EXISTS `coach_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'сотрудник, ученик, клиент, партнёр',
  `name` varchar(45) DEFAULT NULL COMMENT 'Типы сессии (обычная, пакет, название программы)\n',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_type`
--

LOCK TABLES `coach_type` WRITE;
/*!40000 ALTER TABLE `coach_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `coach_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coaches`
--

DROP TABLE IF EXISTS `coaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coaches` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_coach_type` int unsigned NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  KEY `coach_to_type_idx` (`id_coach_type`),
  CONSTRAINT `coach_to_type` FOREIGN KEY (`id_coach_type`) REFERENCES `coach_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coaches`
--

LOCK TABLES `coaches` WRITE;
/*!40000 ALTER TABLE `coaches` DISABLE KEYS */;
/*!40000 ALTER TABLE `coaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_session` int unsigned NOT NULL,
  `start_coach_emotion` text,
  `start_coach_contest` text,
  `start_coach_ready` text,
  `start_client_emotion` text,
  `start_client_context` text,
  `start_client_request` text,
  `introspection` text COMMENT 'Конспект встречи',
  `outline` text COMMENT 'Конспект встречи',
  `resume` text COMMENT 'Конспект встречи',
  `end_coach_can_better` text,
  `end_coach_done` text,
  `end_coach_emotion` text,
  `end_client_insights` text,
  `end_client_results` text,
  `end_client_emotion` text,
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `reports_to_session_idx` (`id_session`),
  CONSTRAINT `reports_to_session` FOREIGN KEY (`id_session`) REFERENCES `sessions_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_format`
--

DROP TABLE IF EXISTS `session_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_format` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'онлайн, офлайн, зум, телефон, переписка',
  `name` varchar(45) DEFAULT NULL COMMENT 'Формат сессии (ZOOM, телефон, оффлайн)\n',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_format`
--

LOCK TABLES `session_format` WRITE;
/*!40000 ALTER TABLE `session_format` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions_list`
--

DROP TABLE IF EXISTS `sessions_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions_list` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `data` date DEFAULT NULL COMMENT 'Дата сессии',
  `start_time` time DEFAULT NULL COMMENT 'Время начало сессии',
  `end_time` time DEFAULT NULL COMMENT 'Время окончания сессии',
  `duration` time DEFAULT NULL COMMENT 'Длительность сессии вычисляется автоматически\n',
  `id_type_session` int unsigned NOT NULL COMMENT 'К какому виду сессии относится встреча\n',
  `id_format_session` int unsigned NOT NULL COMMENT 'Формат в котором проходи сессия',
  `id_client` int unsigned NOT NULL,
  `id_coach` int unsigned NOT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_to_format_idx` (`id_format_session`),
  KEY `session_to_type_idx` (`id_type_session`),
  KEY `session_to_client_idx` (`id_client`),
  KEY `session_to_coach_idx` (`id_coach`),
  CONSTRAINT `session_to_client` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id`),
  CONSTRAINT `session_to_coach` FOREIGN KEY (`id_coach`) REFERENCES `coaches` (`id`),
  CONSTRAINT `session_to_format` FOREIGN KEY (`id_format_session`) REFERENCES `session_format` (`id`),
  CONSTRAINT `session_to_type` FOREIGN KEY (`id_type_session`) REFERENCES `sessions_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions_list`
--

LOCK TABLES `sessions_list` WRITE;
/*!40000 ALTER TABLE `sessions_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions_type`
--

DROP TABLE IF EXISTS `sessions_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'программа(название), установочная, командная сессия, подготовка, рабочая встреча, диагностика, продажа\n',
  `name` varchar(45) DEFAULT NULL COMMENT 'Типы сессии (обычная, пакет, название программы)\n',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions_type`
--

LOCK TABLES `sessions_type` WRITE;
/*!40000 ALTER TABLE `sessions_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_view`
--

DROP TABLE IF EXISTS `track_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_view` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_track` int unsigned NOT NULL,
  `primery_request` text,
  `goal` text COMMENT 'Рабочий запрос (смартированный в цель)',
  `reality` text COMMENT 'Обстоятельства',
  `opportunity` text COMMENT 'Возможности, ресурсы',
  `willdoit` text COMMENT 'План работы клиента\n',
  `obstacles` text COMMENT 'ОУ, КПД',
  `coach_strategy` text COMMENT 'План работы коуча',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `track_to_track_list_idx` (`id_track`),
  CONSTRAINT `track_to_track_list` FOREIGN KEY (`id_track`) REFERENCES `tracks_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_view`
--

LOCK TABLES `track_view` WRITE;
/*!40000 ALTER TABLE `track_view` DISABLE KEYS */;
/*!40000 ALTER TABLE `track_view` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks_list`
--

DROP TABLE IF EXISTS `tracks_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracks_list` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `id_client` int unsigned NOT NULL,
  `id_coach` int unsigned NOT NULL,
  `id_status` int unsigned NOT NULL,
  `init_by` text COMMENT 'Кто/что инициировало трек',
  `start_track` datetime DEFAULT NULL,
  `end_track` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `track_to_status_idx` (`id_status`),
  KEY `track_to_client_idx` (`id_client`),
  KEY `track_to_coach_idx` (`id_coach`),
  CONSTRAINT `track_to_client` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id`),
  CONSTRAINT `track_to_coach` FOREIGN KEY (`id_coach`) REFERENCES `coaches` (`id`),
  CONSTRAINT `track_to_status` FOREIGN KEY (`id_status`) REFERENCES `tracks_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks_list`
--

LOCK TABLES `tracks_list` WRITE;
/*!40000 ALTER TABLE `tracks_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `tracks_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks_status`
--

DROP TABLE IF EXISTS `tracks_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracks_status` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'сотрудник, ученик, клиент, партнёр',
  `name` varchar(45) DEFAULT NULL COMMENT 'парковка, в работе, на рассмотрении',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks_status`
--

LOCK TABLES `tracks_status` WRITE;
/*!40000 ALTER TABLE `tracks_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `tracks_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-20 15:01:10
