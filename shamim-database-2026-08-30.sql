-- MySQL dump 10.13  Distrib 5.7.24, for osx11.1 (x86_64)
--
-- Host: 127.0.0.1    Database: shamim
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `address_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_address_id` int unsigned DEFAULT NULL,
  `customer_id` int unsigned DEFAULT NULL COMMENT 'null if guest checkout',
  `cart_id` int unsigned DEFAULT NULL COMMENT 'only for cart_addresses',
  `order_id` int unsigned DEFAULT NULL COMMENT 'only for order_addresses',
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'only for customer_addresses',
  `use_for_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_customer_id_foreign` (`customer_id`),
  KEY `addresses_cart_id_foreign` (`cart_id`),
  KEY `addresses_order_id_foreign` (`order_id`),
  KEY `addresses_parent_address_id_foreign` (`parent_address_id`),
  CONSTRAINT `addresses_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addresses_parent_address_id_foreign` FOREIGN KEY (`parent_address_id`) REFERENCES `addresses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'cart_billing',NULL,NULL,5,NULL,'Ehsan','Hoseinzadeh',NULL,'','دددد','اردبیل','اردبیل','IR','1111','ehvbpc@gmail.com','111111',NULL,0,1,NULL,'2026-08-16 16:20:12','2026-08-16 16:20:12'),(2,'cart_shipping',NULL,NULL,5,NULL,'Ehsan','Hoseinzadeh',NULL,'','دددد','اردبیل','اردبیل','IR','1111','ehvbpc@gmail.com','111111',NULL,0,0,NULL,'2026-08-16 16:20:12','2026-08-16 16:20:12'),(3,'order_shipping',NULL,NULL,NULL,1,'Ehsan','Hoseinzadeh',NULL,'','دددد','اردبیل','اردبیل','IR','1111','ehvbpc@gmail.com','111111',NULL,0,0,NULL,'2026-08-16 17:00:08','2026-08-16 17:00:08'),(4,'order_billing',NULL,NULL,NULL,1,'Ehsan','Hoseinzadeh',NULL,'','دددد','اردبیل','اردبیل','IR','1111','ehvbpc@gmail.com','111111',NULL,0,0,NULL,'2026-08-16 17:00:08','2026-08-16 17:00:08'),(13,'cart_billing',NULL,NULL,10,NULL,'Ehsan','Hoseinzadeh',NULL,'','mmm','اردبیل','اردبیل',NULL,'777','ehvbpc@gmail.com','777',NULL,0,1,NULL,'2026-08-16 17:33:13','2026-08-16 17:33:13'),(14,'cart_shipping',NULL,NULL,10,NULL,'Ehsan','Hoseinzadeh',NULL,'','mmm','اردبیل','اردبیل',NULL,'777','ehvbpc@gmail.com','777',NULL,0,0,NULL,'2026-08-16 17:33:13','2026-08-16 17:33:13'),(15,'cart_billing',NULL,10,12,NULL,'احسان','حسین زاده',NULL,'','kkk','Istanbul','Istanbul',NULL,'123','ehsan.hsnzd@gmail.com','123',NULL,0,1,NULL,'2026-08-18 22:43:36','2026-08-18 22:43:36'),(16,'cart_shipping',NULL,10,12,NULL,'احسان','حسین زاده',NULL,'','kkk','Istanbul','Istanbul',NULL,'123','ehsan.hsnzd@gmail.com','123',NULL,0,0,NULL,'2026-08-18 22:43:36','2026-08-18 22:43:36');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_password_resets`
--

DROP TABLE IF EXISTS `admin_password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `admin_password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_password_resets`
--

LOCK TABLES `admin_password_resets` WRITE;
/*!40000 ALTER TABLE `admin_password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `role_id` int unsigned NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_backup_codes` json DEFAULT NULL,
  `two_factor_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admins_email_unique` (`email`),
  UNIQUE KEY `admins_api_token_unique` (`api_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Admin','admin@example.com','$2y$12$TWr4lltGXvHxcP4E4jO9yOB1M/eFM0Kjm4FicMOi7dday5bQG4wvO',NULL,1,1,NULL,NULL,NULL,0,NULL,NULL,'2026-08-05 22:11:39','2026-08-05 22:11:39');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_conversation_messages`
--

DROP TABLE IF EXISTS `agent_conversation_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_conversation_messages` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conversation_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `agent` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachments` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tool_calls` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tool_results` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `usage` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `conversation_index` (`conversation_id`,`user_id`,`updated_at`),
  KEY `agent_conversation_messages_user_id_index` (`user_id`),
  KEY `agent_conversation_messages_conversation_id_index` (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_conversation_messages`
--

LOCK TABLES `agent_conversation_messages` WRITE;
/*!40000 ALTER TABLE `agent_conversation_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_conversation_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_conversations`
--

DROP TABLE IF EXISTS `agent_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_conversations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `agent_conversations_user_id_updated_at_index` (`user_id`,`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_conversations`
--

LOCK TABLES `agent_conversations` WRITE;
/*!40000 ALTER TABLE `agent_conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_families`
--

DROP TABLE IF EXISTS `attribute_families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_families` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `is_user_defined` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_families`
--

LOCK TABLES `attribute_families` WRITE;
/*!40000 ALTER TABLE `attribute_families` DISABLE KEYS */;
INSERT INTO `attribute_families` VALUES (1,'default','Default',0,1);
/*!40000 ALTER TABLE `attribute_families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_group_mappings`
--

DROP TABLE IF EXISTS `attribute_group_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_group_mappings` (
  `attribute_id` int unsigned NOT NULL,
  `attribute_group_id` int unsigned NOT NULL,
  `position` int DEFAULT NULL,
  PRIMARY KEY (`attribute_id`,`attribute_group_id`),
  KEY `attribute_group_mappings_attribute_group_id_foreign` (`attribute_group_id`),
  CONSTRAINT `attribute_group_mappings_attribute_group_id_foreign` FOREIGN KEY (`attribute_group_id`) REFERENCES `attribute_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attribute_group_mappings_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_group_mappings`
--

LOCK TABLES `attribute_group_mappings` WRITE;
/*!40000 ALTER TABLE `attribute_group_mappings` DISABLE KEYS */;
INSERT INTO `attribute_group_mappings` VALUES (1,1,1),(2,1,3),(3,1,4),(4,1,5),(5,6,1),(6,6,2),(7,6,3),(8,6,4),(9,2,1),(10,2,2),(11,4,1),(12,4,2),(13,4,3),(14,4,4),(15,4,5),(16,3,1),(17,3,2),(18,3,3),(19,5,1),(20,5,2),(21,5,3),(22,5,4),(23,1,6),(24,1,7),(25,1,8),(26,6,5),(27,1,2),(28,7,1),(29,8,1),(30,8,2);
/*!40000 ALTER TABLE `attribute_group_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_groups`
--

DROP TABLE IF EXISTS `attribute_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_groups` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attribute_family_id` int unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `column` int NOT NULL DEFAULT '1',
  `position` int NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_groups_attribute_family_id_name_unique` (`attribute_family_id`,`name`),
  CONSTRAINT `attribute_groups_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_groups`
--

LOCK TABLES `attribute_groups` WRITE;
/*!40000 ALTER TABLE `attribute_groups` DISABLE KEYS */;
INSERT INTO `attribute_groups` VALUES (1,'general',1,'General',1,1,0),(2,'description',1,'Description',1,2,0),(3,'meta_description',1,'Meta Description',1,3,0),(4,'price',1,'Price',2,1,0),(5,'shipping',1,'Shipping',2,2,0),(6,'settings',1,'Settings',2,3,0),(7,'inventories',1,'Inventories',2,4,0),(8,'rma',1,'RMA',2,5,0);
/*!40000 ALTER TABLE `attribute_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_option_translations`
--

DROP TABLE IF EXISTS `attribute_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_option_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `attribute_option_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_option_locale_unique` (`attribute_option_id`,`locale`),
  CONSTRAINT `attribute_option_translations_attribute_option_id_foreign` FOREIGN KEY (`attribute_option_id`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_option_translations`
--

LOCK TABLES `attribute_option_translations` WRITE;
/*!40000 ALTER TABLE `attribute_option_translations` DISABLE KEYS */;
INSERT INTO `attribute_option_translations` VALUES (1,1,'en','Red'),(2,2,'en','Green'),(3,3,'en','Yellow'),(4,4,'en','Black'),(5,5,'en','White'),(6,6,'en','S'),(7,7,'en','M'),(8,8,'en','L'),(9,9,'en','XL'),(10,10,'en','XXL'),(39,39,'en','Orange'),(40,40,'en','Free Size'),(41,41,'en','Blue'),(42,42,'en','Pink'),(43,43,'en','Purple'),(44,46,'en','Grey'),(45,47,'en','Dual Tone'),(52,54,'en','Brown'),(57,1,'fa','قرمز'),(58,2,'fa','سبز'),(59,3,'fa','زرد'),(60,4,'fa','مشکی'),(61,5,'fa','سفید'),(62,39,'fa','نارنجی'),(63,41,'fa','آبی'),(64,42,'fa','صورتی'),(65,43,'fa','بنفش'),(66,46,'fa','خاکستری'),(67,47,'fa','دو رنگ'),(68,54,'fa','کرافت / قهوه‌ای'),(69,6,'fa','کوچک'),(70,7,'fa','متوسط'),(71,8,'fa','بزرگ'),(72,9,'fa','خیلی بزرگ'),(73,10,'fa','نیم‌متری'),(74,40,'fa','بدون سایز');
/*!40000 ALTER TABLE `attribute_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_options`
--

DROP TABLE IF EXISTS `attribute_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_options` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` int unsigned NOT NULL,
  `admin_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int DEFAULT NULL,
  `swatch_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attribute_options_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `attribute_options_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_options`
--

LOCK TABLES `attribute_options` WRITE;
/*!40000 ALTER TABLE `attribute_options` DISABLE KEYS */;
INSERT INTO `attribute_options` VALUES (1,23,'Red',0,NULL),(2,23,'Green',1,NULL),(3,23,'Yellow',2,NULL),(4,23,'Black',3,NULL),(5,23,'White',4,NULL),(6,24,'S',1,NULL),(7,24,'M',2,NULL),(8,24,'L',3,NULL),(9,24,'XL',4,NULL),(10,24,'XXL',4,NULL),(39,23,'Orange',5,'#ff6600'),(40,24,'Free Size',5,NULL),(41,23,'Blue',6,'#0000ff'),(42,23,'Pink',7,'#e33d94'),(43,23,'Purple',8,'#6611bb'),(46,23,'Grey',9,'#949494'),(47,23,'Dual Tone',10,'#5286ad'),(54,23,'Brown',11,'#3d2424');
/*!40000 ALTER TABLE `attribute_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attribute_translations`
--

DROP TABLE IF EXISTS `attribute_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_translations_attribute_id_locale_unique` (`attribute_id`,`locale`),
  CONSTRAINT `attribute_translations_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_translations`
--

LOCK TABLES `attribute_translations` WRITE;
/*!40000 ALTER TABLE `attribute_translations` DISABLE KEYS */;
INSERT INTO `attribute_translations` VALUES (1,1,'en','SKU'),(2,2,'en','Name'),(3,3,'en','URL Key'),(4,4,'en','Tax Category'),(5,5,'en','New'),(6,6,'en','Featured'),(7,7,'en','Visible Individually'),(8,8,'en','Status'),(9,9,'en','Short Description'),(10,10,'en','Description'),(11,11,'en','Price'),(12,12,'en','Cost'),(13,13,'en','Special Price'),(14,14,'en','Special Price From'),(15,15,'en','Special Price To'),(16,16,'en','Meta Title'),(17,17,'en','Meta Keywords'),(18,18,'en','Meta Description'),(19,19,'en','Length'),(20,20,'en','Width'),(21,21,'en','Height'),(22,22,'en','Weight'),(23,23,'en','Color'),(24,24,'en','Size'),(25,25,'en','Brand'),(26,26,'en','Guest Checkout'),(27,27,'en','Product Number'),(28,28,'en','Manage Stock'),(29,29,'en','Allow RMA'),(30,30,'en','RMA Rules'),(41,23,'fa','رنگ'),(42,11,'fa','قیمت'),(43,24,'fa','اندازه بسته‌بندی'),(44,25,'fa','برند');
/*!40000 ALTER TABLE `attribute_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attributes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `swatch_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `validation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `regex` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_unique` tinyint(1) NOT NULL DEFAULT '0',
  `is_filterable` tinyint(1) NOT NULL DEFAULT '0',
  `is_comparable` tinyint(1) NOT NULL DEFAULT '0',
  `is_configurable` tinyint(1) NOT NULL DEFAULT '0',
  `is_user_defined` tinyint(1) NOT NULL DEFAULT '1',
  `is_visible_on_front` tinyint(1) NOT NULL DEFAULT '0',
  `value_per_locale` tinyint(1) NOT NULL DEFAULT '0',
  `value_per_channel` tinyint(1) NOT NULL DEFAULT '0',
  `default_value` int DEFAULT NULL,
  `enable_wysiwyg` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attributes_code_unique` (`code`),
  KEY `attributes_code_index` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attributes`
--

LOCK TABLES `attributes` WRITE;
/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
INSERT INTO `attributes` VALUES (1,'sku','SKU','text',NULL,NULL,NULL,1,1,1,0,0,0,0,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(2,'name','Name','text',NULL,NULL,NULL,3,1,0,0,1,0,0,0,1,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(3,'url_key','URL Key','text',NULL,NULL,NULL,4,1,1,0,0,0,0,0,1,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(4,'tax_category_id','Tax Category','select',NULL,NULL,NULL,5,0,0,0,0,0,0,0,0,1,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(5,'new','New','boolean',NULL,NULL,NULL,6,0,0,0,0,0,0,0,0,0,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(6,'featured','Featured','boolean',NULL,NULL,NULL,7,0,0,0,0,0,0,0,0,0,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(7,'visible_individually','Visible Individually','boolean',NULL,NULL,NULL,9,1,0,0,0,0,0,0,0,0,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(8,'status','Status','boolean',NULL,NULL,NULL,10,1,0,0,0,0,0,0,0,1,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(9,'short_description','Short Description','textarea',NULL,NULL,NULL,11,1,0,0,0,0,0,0,1,0,NULL,1,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(10,'description','Description','textarea',NULL,NULL,NULL,12,1,0,0,1,0,0,0,1,0,NULL,1,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(11,'price','Price','price',NULL,'decimal',NULL,13,1,0,1,1,0,0,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(12,'cost','Cost','price',NULL,'decimal',NULL,14,0,0,0,0,0,1,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(13,'special_price','Special Price','price',NULL,'decimal',NULL,15,0,0,0,0,0,0,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(14,'special_price_from','Special Price From','date',NULL,NULL,NULL,16,0,0,0,0,0,0,0,0,1,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(15,'special_price_to','Special Price To','date',NULL,NULL,NULL,17,0,0,0,0,0,0,0,0,1,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(16,'meta_title','Meta Title','textarea',NULL,NULL,NULL,18,0,0,0,0,0,0,0,1,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(17,'meta_keywords','Meta Keywords','textarea',NULL,NULL,NULL,20,0,0,0,0,0,0,0,1,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(18,'meta_description','Meta Description','textarea',NULL,NULL,NULL,21,0,0,0,0,0,1,0,1,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(19,'length','Length','text',NULL,'decimal',NULL,22,0,0,0,0,0,1,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(20,'width','Width','text',NULL,'decimal',NULL,23,0,0,0,0,0,1,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(21,'height','Height','text',NULL,'decimal',NULL,24,0,0,0,0,0,1,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(22,'weight','Weight','text',NULL,'decimal',NULL,25,1,0,0,0,0,0,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(23,'color','Color','select','dropdown',NULL,NULL,26,0,0,1,0,1,1,1,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-15 18:49:56'),(24,'size','Size','select',NULL,NULL,NULL,27,0,0,1,0,1,1,1,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(25,'brand','Brand','select','dropdown',NULL,NULL,28,0,0,0,0,0,1,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-21 15:54:35'),(26,'guest_checkout','Guest Checkout','boolean',NULL,NULL,NULL,8,1,0,0,0,0,0,0,0,0,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(27,'product_number','Product Number','text',NULL,NULL,NULL,2,0,1,0,0,0,0,0,0,0,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(28,'manage_stock','Manage Stock','boolean',NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,1,1,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(29,'allow_rma','Allow RMA','boolean',NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,1,0,0,'2026-08-05 22:11:36','2026-08-05 22:11:36'),(30,'rma_rule_id','RMA Rules','select',NULL,NULL,NULL,5,0,0,0,0,0,0,0,0,1,NULL,0,'2026-08-05 22:11:36','2026-08-05 22:11:36');
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_appointment_slots`
--

DROP TABLE IF EXISTS `booking_product_appointment_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_appointment_slots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int unsigned NOT NULL,
  `duration` int DEFAULT NULL,
  `break_time` int DEFAULT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` json DEFAULT NULL,
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `booking_product_appointment_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_appointment_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_appointment_slots`
--

LOCK TABLES `booking_product_appointment_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_appointment_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_appointment_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_default_slots`
--

DROP TABLE IF EXISTS `booking_product_default_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_default_slots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int unsigned NOT NULL,
  `booking_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int DEFAULT NULL,
  `break_time` int DEFAULT NULL,
  `slots` json DEFAULT NULL,
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `booking_product_default_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_default_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_default_slots`
--

LOCK TABLES `booking_product_default_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_default_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_default_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_event_ticket_translations`
--

DROP TABLE IF EXISTS `booking_product_event_ticket_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_event_ticket_translations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_event_ticket_id` bigint unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bpet_locale_unique` (`booking_product_event_ticket_id`,`locale`),
  CONSTRAINT `bpet_translations_fk` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_event_ticket_translations`
--

LOCK TABLES `booking_product_event_ticket_translations` WRITE;
/*!40000 ALTER TABLE `booking_product_event_ticket_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_event_ticket_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_event_tickets`
--

DROP TABLE IF EXISTS `booking_product_event_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_event_tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int unsigned NOT NULL,
  `price` decimal(12,4) DEFAULT '0.0000',
  `qty` int DEFAULT '0',
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` datetime DEFAULT NULL,
  `special_price_to` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_product_event_tickets_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_event_tickets_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_event_tickets`
--

LOCK TABLES `booking_product_event_tickets` WRITE;
/*!40000 ALTER TABLE `booking_product_event_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_event_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_rental_slots`
--

DROP TABLE IF EXISTS `booking_product_rental_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_rental_slots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int unsigned NOT NULL,
  `renting_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `daily_price` decimal(12,4) DEFAULT '0.0000',
  `hourly_price` decimal(12,4) DEFAULT '0.0000',
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_product_rental_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_rental_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_rental_slots`
--

LOCK TABLES `booking_product_rental_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_rental_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_rental_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_product_table_slots`
--

DROP TABLE IF EXISTS `booking_product_table_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_product_table_slots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `booking_product_id` int unsigned NOT NULL,
  `price_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guest_limit` int NOT NULL DEFAULT '0',
  `duration` int NOT NULL,
  `break_time` int NOT NULL,
  `prevent_scheduling_before` int NOT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` json DEFAULT NULL,
  `allow_slot_overlap` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_product_table_slots_booking_product_id_foreign` (`booking_product_id`),
  CONSTRAINT `booking_product_table_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_product_table_slots`
--

LOCK TABLES `booking_product_table_slots` WRITE;
/*!40000 ALTER TABLE `booking_product_table_slots` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_product_table_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_products`
--

DROP TABLE IF EXISTS `booking_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int DEFAULT '0',
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_location` tinyint(1) NOT NULL DEFAULT '0',
  `available_every_week` tinyint(1) DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_to` datetime DEFAULT NULL,
  `allow_cancellation` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_products_product_id_foreign` (`product_id`),
  CONSTRAINT `booking_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_products`
--

LOCK TABLES `booking_products` WRITE;
/*!40000 ALTER TABLE `booking_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `qty` int DEFAULT '0',
  `from` int DEFAULT NULL,
  `to` int DEFAULT NULL,
  `allow_cancellation` tinyint(1) NOT NULL DEFAULT '1',
  `booking_product_event_ticket_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_order_item_id_foreign` (`order_item_id`),
  KEY `bookings_booking_product_event_ticket_id_foreign` (`booking_product_event_ticket_id`),
  KEY `bookings_order_id_foreign` (`order_id`),
  KEY `bookings_product_id_foreign` (`product_id`),
  CONSTRAINT `bookings_booking_product_event_ticket_id_foreign` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT '0',
  `items_count` int DEFAULT NULL,
  `items_qty` decimal(12,4) DEFAULT NULL,
  `exchange_rate` decimal(12,4) DEFAULT NULL,
  `global_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) DEFAULT '0.0000',
  `sub_total` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total` decimal(12,4) DEFAULT '0.0000',
  `tax_total` decimal(12,4) DEFAULT '0.0000',
  `base_tax_total` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `checkout_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `applied_cart_rule_ids` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int unsigned DEFAULT NULL,
  `channel_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_customer_id_foreign` (`customer_id`),
  KEY `cart_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cart_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,NULL,NULL,NULL,NULL,NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','IRR',600.0000,600.0000,600.0000,600.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,600.0000,600.0000,NULL,1,1,NULL,NULL,1,'2026-08-06 11:58:09','2026-08-06 11:58:21'),(2,NULL,NULL,NULL,NULL,NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','IRR',600.0000,600.0000,600.0000,600.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,600.0000,600.0000,NULL,1,1,NULL,NULL,1,'2026-08-07 12:14:08','2026-08-07 12:14:09'),(3,NULL,NULL,NULL,NULL,NULL,0,1,2.0000,NULL,'IRR','IRR','IRR','IRR',2020000.0000,2020000.0000,2020000.0000,2020000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,2020000.0000,2020000.0000,NULL,1,1,NULL,NULL,1,'2026-08-15 18:46:24','2026-08-15 19:14:41'),(5,'ehvbpc@gmail.com','Ehsan','Hoseinzadeh','free_free',NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','IRR',1010000.0000,1010000.0000,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,NULL,1,0,NULL,NULL,1,'2026-08-16 15:44:32','2026-08-16 17:00:08'),(10,'ehvbpc@gmail.com','Ehsan','Hoseinzadeh','flatrate_flatrate',NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','IRR',1010010.0000,1010010.0000,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,10.0000,10.0000,10.0000,10.0000,1010000.0000,1010000.0000,NULL,1,1,NULL,NULL,1,'2026-08-16 17:32:51','2026-08-16 17:33:33'),(11,'ehvbpc@gmail.com','Ehsan','Hoseinzadeh',NULL,NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','IRR',1010000.0000,1010000.0000,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,NULL,0,1,NULL,8,1,'2026-08-18 20:25:57','2026-08-18 21:30:09'),(12,'ehsan.hsnzd@gmail.com','کاربر','6492','flatrate_flatrate',NULL,0,1,1.0000,NULL,'IRR','IRR','IRR','TMN',10110.0000,10110.0000,10100.0000,10100.0000,0.0000,0.0000,0.0000,0.0000,10.0000,10.0000,10.0000,10.0000,10100.0000,10100.0000,NULL,0,1,NULL,10,1,'2026-08-18 21:30:20','2026-08-30 12:21:48');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_item_inventories`
--

DROP TABLE IF EXISTS `cart_item_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_item_inventories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qty` int unsigned NOT NULL DEFAULT '0',
  `inventory_source_id` int unsigned DEFAULT NULL,
  `cart_item_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_item_inventories`
--

LOCK TABLES `cart_item_inventories` WRITE;
/*!40000 ALTER TABLE `cart_item_inventories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_item_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL DEFAULT '0',
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_weight` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_weight` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price` decimal(12,4) NOT NULL DEFAULT '1.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `custom_price` decimal(12,4) DEFAULT NULL,
  `total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_percent` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `applied_tax_rate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `product_id` int unsigned NOT NULL,
  `cart_id` int unsigned NOT NULL,
  `tax_category_id` int unsigned DEFAULT NULL,
  `applied_cart_rule_ids` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_items_parent_id_foreign` (`parent_id`),
  KEY `cart_items_product_id_foreign` (`product_id`),
  KEY `cart_items_cart_id_foreign` (`cart_id`),
  KEY `cart_items_tax_category_id_foreign` (`tax_category_id`),
  CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `cart_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (3,2,'100','simple','دو تیکه',NULL,1.0000,2.0000,2.0000,1010000.0000,1010000.0000,NULL,2020000.0000,2020000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,2020000.0000,2020000.0000,NULL,NULL,152,3,NULL,NULL,'{\"cart_id\": 3, \"quantity\": 2, \"product_id\": 152}','2026-08-15 18:46:24','2026-08-15 18:46:46'),(5,1,'100','simple','سوخاری دو تیکه',NULL,1.0000,1.0000,1.0000,1010000.0000,1010000.0000,NULL,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,NULL,152,5,NULL,NULL,'{\"cart_id\": 5, \"quantity\": 1, \"product_id\": 152}','2026-08-16 15:44:32','2026-08-16 15:44:32'),(10,1,'100','simple','سوخاری دو تیکه',NULL,1.0000,1.0000,1.0000,1010000.0000,1010000.0000,NULL,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,NULL,152,10,NULL,NULL,'{\"cart_id\": 10, \"quantity\": 1, \"product_id\": 152}','2026-08-16 17:32:51','2026-08-16 17:32:51'),(11,1,'100','simple','جعبه سوخاری دو تکه کرافت',NULL,1.0000,1.0000,1.0000,1010000.0000,1010000.0000,NULL,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,NULL,152,11,NULL,NULL,'{\"cart_id\": 11, \"quantity\": 1, \"product_id\": 152}','2026-08-18 20:25:57','2026-08-18 20:25:57'),(12,1,'100','simple','جعبه سوخاری دو تکه کرافت',NULL,1.0000,1.0000,1.0000,10100.0000,10100.0000,NULL,10100.0000,10100.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,10100.0000,10100.0000,10100.0000,10100.0000,NULL,NULL,152,12,NULL,NULL,'{\"cart_id\": 12, \"quantity\": 1, \"product_id\": 152}','2026-08-18 21:30:20','2026-08-22 17:01:52');
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_payment`
--

DROP TABLE IF EXISTS `cart_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_payment_cart_id_foreign` (`cart_id`),
  CONSTRAINT `cart_payment_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_payment`
--

LOCK TABLES `cart_payment` WRITE;
/*!40000 ALTER TABLE `cart_payment` DISABLE KEYS */;
INSERT INTO `cart_payment` VALUES (9,'cashondelivery','Cash On Delivery',5,'2026-08-16 17:00:06','2026-08-16 17:00:06'),(11,'zarinpal','پرداخت امن زرین پال',10,'2026-08-16 17:33:31','2026-08-16 17:33:31'),(12,'zarinpal','پرداخت امن زرین پال',12,'2026-08-18 22:43:42','2026-08-18 22:43:42');
/*!40000 ALTER TABLE `cart_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_channels`
--

DROP TABLE IF EXISTS `cart_rule_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_channels` (
  `cart_rule_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  PRIMARY KEY (`cart_rule_id`,`channel_id`),
  KEY `cart_rule_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cart_rule_channels_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_channels`
--

LOCK TABLES `cart_rule_channels` WRITE;
/*!40000 ALTER TABLE `cart_rule_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_coupon_usage`
--

DROP TABLE IF EXISTS `cart_rule_coupon_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_coupon_usage` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `times_used` int NOT NULL DEFAULT '0',
  `cart_rule_coupon_id` int unsigned NOT NULL,
  `customer_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` (`cart_rule_coupon_id`),
  KEY `cart_rule_coupon_usage_customer_id_foreign` (`customer_id`),
  CONSTRAINT `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` FOREIGN KEY (`cart_rule_coupon_id`) REFERENCES `cart_rule_coupons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_coupon_usage_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_coupon_usage`
--

LOCK TABLES `cart_rule_coupon_usage` WRITE;
/*!40000 ALTER TABLE `cart_rule_coupon_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_coupon_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_coupons`
--

DROP TABLE IF EXISTS `cart_rule_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_coupons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usage_limit` int unsigned NOT NULL DEFAULT '0',
  `usage_per_customer` int unsigned NOT NULL DEFAULT '0',
  `times_used` int unsigned NOT NULL DEFAULT '0',
  `type` int unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `expired_at` date DEFAULT NULL,
  `cart_rule_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_coupons_cart_rule_id_foreign` (`cart_rule_id`),
  CONSTRAINT `cart_rule_coupons_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_coupons`
--

LOCK TABLES `cart_rule_coupons` WRITE;
/*!40000 ALTER TABLE `cart_rule_coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_customer_groups`
--

DROP TABLE IF EXISTS `cart_rule_customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_customer_groups` (
  `cart_rule_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned NOT NULL,
  PRIMARY KEY (`cart_rule_id`,`customer_group_id`),
  KEY `cart_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `cart_rule_customer_groups_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_customer_groups`
--

LOCK TABLES `cart_rule_customer_groups` WRITE;
/*!40000 ALTER TABLE `cart_rule_customer_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_customers`
--

DROP TABLE IF EXISTS `cart_rule_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_customers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `times_used` bigint unsigned NOT NULL DEFAULT '0',
  `customer_id` int unsigned NOT NULL,
  `cart_rule_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_rule_customers_cart_rule_id_foreign` (`cart_rule_id`),
  KEY `cart_rule_customers_customer_id_foreign` (`customer_id`),
  CONSTRAINT `cart_rule_customers_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_rule_customers_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_customers`
--

LOCK TABLES `cart_rule_customers` WRITE;
/*!40000 ALTER TABLE `cart_rule_customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rule_translations`
--

DROP TABLE IF EXISTS `cart_rule_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rule_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci,
  `cart_rule_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cart_rule_translations_cart_rule_id_locale_unique` (`cart_rule_id`,`locale`),
  CONSTRAINT `cart_rule_translations_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rule_translations`
--

LOCK TABLES `cart_rule_translations` WRITE;
/*!40000 ALTER TABLE `cart_rule_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rule_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_rules`
--

DROP TABLE IF EXISTS `cart_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_rules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `coupon_type` int NOT NULL DEFAULT '1',
  `use_auto_generation` tinyint(1) NOT NULL DEFAULT '0',
  `usage_per_customer` int NOT NULL DEFAULT '0',
  `uses_per_coupon` int NOT NULL DEFAULT '0',
  `times_used` int unsigned NOT NULL DEFAULT '0',
  `condition_type` tinyint(1) NOT NULL DEFAULT '1',
  `conditions` json DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT '0',
  `uses_attribute_conditions` tinyint(1) NOT NULL DEFAULT '0',
  `action_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_quantity` int NOT NULL DEFAULT '1',
  `discount_step` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `apply_to_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `free_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_rules`
--

LOCK TABLES `cart_rules` WRITE;
/*!40000 ALTER TABLE `cart_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_shipping_rates`
--

DROP TABLE IF EXISTS `cart_shipping_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_shipping_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `carrier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double DEFAULT '0',
  `base_price` double DEFAULT '0',
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_percent` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `applied_tax_rate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_calculate_tax` tinyint(1) NOT NULL DEFAULT '1',
  `cart_address_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cart_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_shipping_rates_cart_id_foreign` (`cart_id`),
  CONSTRAINT `cart_shipping_rates_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_shipping_rates`
--

LOCK TABLES `cart_shipping_rates` WRITE;
/*!40000 ALTER TABLE `cart_shipping_rates` DISABLE KEYS */;
INSERT INTO `cart_shipping_rates` VALUES (29,'flatrate','Flat Rate','flatrate_flatrate','Flat Rate','Flat Rate Shipping',10,10,0.0000,0.0000,0.0000,0.0000,0.0000,10.0000,10.0000,NULL,1,2,'2026-08-16 17:00:04','2026-08-16 17:00:04',5),(30,'free','Free Shipping','free_free','Free Shipping','Free Shipping',0,0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,1,2,'2026-08-16 17:00:04','2026-08-16 17:00:04',5),(37,'flatrate','Flat Rate','flatrate_flatrate','Flat Rate','Flat Rate Shipping',10,10,0.0000,0.0000,0.0000,0.0000,0.0000,10.0000,10.0000,NULL,1,14,'2026-08-16 17:33:30','2026-08-16 17:33:30',10),(38,'free','Free Shipping','free_free','Free Shipping','Free Shipping',0,0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,1,14,'2026-08-16 17:33:30','2026-08-16 17:33:30',10),(41,'flatrate','Flat Rate','flatrate_flatrate','Flat Rate','Flat Rate Shipping',10,10,0.0000,0.0000,0.0000,0.0000,0.0000,10.0000,10.0000,NULL,1,16,'2026-08-18 22:43:39','2026-08-18 22:43:39',12),(42,'free','Free Shipping','free_free','Free Shipping','Free Shipping',0,0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,NULL,1,16,'2026-08-18 22:43:39','2026-08-18 22:43:39',12);
/*!40000 ALTER TABLE `cart_shipping_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_channels`
--

DROP TABLE IF EXISTS `catalog_rule_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_channels` (
  `catalog_rule_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  PRIMARY KEY (`catalog_rule_id`,`channel_id`),
  KEY `catalog_rule_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_channels_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_channels`
--

LOCK TABLES `catalog_rule_channels` WRITE;
/*!40000 ALTER TABLE `catalog_rule_channels` DISABLE KEYS */;
INSERT INTO `catalog_rule_channels` VALUES (1,1),(3,1);
/*!40000 ALTER TABLE `catalog_rule_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_customer_groups`
--

DROP TABLE IF EXISTS `catalog_rule_customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_customer_groups` (
  `catalog_rule_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned NOT NULL,
  PRIMARY KEY (`catalog_rule_id`,`customer_group_id`),
  KEY `catalog_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `catalog_rule_customer_groups_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_customer_groups`
--

LOCK TABLES `catalog_rule_customer_groups` WRITE;
/*!40000 ALTER TABLE `catalog_rule_customer_groups` DISABLE KEYS */;
INSERT INTO `catalog_rule_customer_groups` VALUES (1,1),(3,1),(1,2),(3,2),(1,3),(3,3);
/*!40000 ALTER TABLE `catalog_rule_customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_product_prices`
--

DROP TABLE IF EXISTS `catalog_rule_product_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_product_prices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `rule_date` date NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `product_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned NOT NULL,
  `catalog_rule_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catalog_rule_product_prices_product_id_foreign` (`product_id`),
  KEY `catalog_rule_product_prices_customer_group_id_foreign` (`customer_group_id`),
  KEY `catalog_rule_product_prices_catalog_rule_id_foreign` (`catalog_rule_id`),
  KEY `catalog_rule_product_prices_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_product_prices_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_product_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4970 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_product_prices`
--

LOCK TABLES `catalog_rule_product_prices` WRITE;
/*!40000 ALTER TABLE `catalog_rule_product_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_product_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rule_products`
--

DROP TABLE IF EXISTS `catalog_rule_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rule_products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT '0',
  `action_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned NOT NULL,
  `catalog_rule_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catalog_rule_products_product_id_foreign` (`product_id`),
  KEY `catalog_rule_products_customer_group_id_foreign` (`customer_group_id`),
  KEY `catalog_rule_products_catalog_rule_id_foreign` (`catalog_rule_id`),
  KEY `catalog_rule_products_channel_id_foreign` (`channel_id`),
  CONSTRAINT `catalog_rule_products_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_rule_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1657 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rule_products`
--

LOCK TABLES `catalog_rule_products` WRITE;
/*!40000 ALTER TABLE `catalog_rule_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_rule_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_rules`
--

DROP TABLE IF EXISTS `catalog_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_rules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_from` date DEFAULT NULL,
  `ends_till` date DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `condition_type` tinyint(1) NOT NULL DEFAULT '1',
  `conditions` json DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT '0',
  `action_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_rules`
--

LOCK TABLES `catalog_rules` WRITE;
/*!40000 ALTER TABLE `catalog_rules` DISABLE KEYS */;
INSERT INTO `catalog_rules` VALUES (1,'jashnvare','',NULL,NULL,0,1,'[]',0,'by_percent',20.0000,0,'2026-08-21 13:36:11','2026-08-21 15:26:45'),(3,'afzayesh','',NULL,NULL,0,1,'[{\"value\": \"0\", \"operator\": \">\", \"attribute\": \"product|price\", \"attribute_type\": \"price\"}]',0,'by_percent_increase',10.0000,0,'2026-08-21 15:24:26','2026-08-22 16:59:09');
/*!40000 ALTER TABLE `catalog_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `position` int NOT NULL DEFAULT '0',
  `logo_path` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `display_mode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'products_and_description',
  `_lft` int unsigned NOT NULL DEFAULT '0',
  `_rgt` int unsigned NOT NULL DEFAULT '0',
  `parent_id` int unsigned DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `banner_path` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,1,NULL,1,'products_and_description',1,86,NULL,NULL,NULL,'2026-08-05 22:11:36','2026-08-15 19:01:32'),(42,1,NULL,1,'products_and_description',2,5,1,NULL,NULL,'2026-08-15 18:20:12','2026-08-15 19:01:32'),(43,1,NULL,1,'products_and_description',3,4,42,NULL,NULL,'2026-08-15 18:21:41','2026-08-15 19:03:29'),(44,1,NULL,1,'products_only',6,7,1,NULL,NULL,'2026-08-15 18:59:14','2026-08-15 19:01:32'),(45,2,NULL,1,'products_only',8,9,1,NULL,NULL,'2026-08-15 18:59:14','2026-08-15 19:01:32'),(47,4,NULL,1,'products_only',10,11,1,NULL,NULL,'2026-08-15 18:59:14','2026-08-15 19:01:32'),(48,5,NULL,1,'products_only',12,13,1,NULL,NULL,'2026-08-15 18:59:14','2026-08-15 19:01:32'),(49,10,NULL,1,'products_and_description',16,23,1,NULL,NULL,'2026-08-19 18:53:17','2026-08-19 18:53:18'),(50,10,NULL,1,'products_and_description',17,18,49,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(51,10,NULL,1,'products_and_description',19,20,49,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(52,10,NULL,1,'products_and_description',21,22,49,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(53,10,NULL,1,'products_and_description',24,31,1,NULL,NULL,'2026-08-19 18:53:18','2026-08-19 18:53:18'),(54,10,NULL,1,'products_and_description',25,26,53,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(55,10,NULL,1,'products_and_description',27,28,53,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(56,10,NULL,1,'products_and_description',29,30,53,NULL,NULL,'2026-08-19 18:53:18','2026-08-20 21:15:46'),(57,10,NULL,1,'products_and_description',32,33,1,NULL,NULL,'2026-08-19 18:53:18','2026-08-19 18:53:18'),(58,10,NULL,1,'products_and_description',34,39,1,NULL,NULL,'2026-08-19 19:26:02','2026-08-19 19:26:02'),(59,10,NULL,1,'products_and_description',35,36,58,NULL,NULL,'2026-08-19 19:26:02','2026-08-20 21:15:46'),(60,10,NULL,1,'products_and_description',37,38,58,NULL,NULL,'2026-08-19 19:26:02','2026-08-20 21:15:46'),(61,10,NULL,1,'products_and_description',40,41,1,NULL,NULL,'2026-08-20 00:01:34','2026-08-20 00:01:34'),(62,10,NULL,1,'products_and_description',42,43,1,NULL,NULL,'2026-08-20 00:01:34','2026-08-20 00:01:34'),(63,10,NULL,1,'products_and_description',57,58,73,NULL,NULL,'2026-08-20 00:01:34','2026-08-20 21:15:45'),(64,10,NULL,1,'products_and_description',59,60,73,NULL,NULL,'2026-08-20 00:01:34','2026-08-20 21:15:45'),(65,10,NULL,1,'products_and_description',44,47,1,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 00:01:35'),(66,10,NULL,1,'products_and_description',79,80,81,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 21:15:46'),(67,10,NULL,1,'products_and_description',81,82,81,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 21:15:46'),(68,10,NULL,1,'products_and_description',48,49,1,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 00:01:35'),(69,10,NULL,1,'products_and_description',50,51,1,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 00:01:35'),(70,10,NULL,1,'products_and_description',83,84,81,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 21:15:46'),(71,10,NULL,1,'products_and_description',52,53,1,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 00:01:35'),(72,10,NULL,1,'products_and_description',54,55,1,NULL,NULL,'2026-08-20 00:01:35','2026-08-20 00:01:35'),(73,10,NULL,1,'products_and_description',56,63,1,NULL,NULL,'2026-08-20 21:02:53','2026-08-20 21:02:53'),(74,10,NULL,1,'products_and_description',64,65,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(75,10,NULL,1,'products_and_description',66,67,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(76,10,NULL,1,'products_and_description',68,69,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(77,10,NULL,1,'products_and_description',70,71,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(78,10,NULL,1,'products_and_description',72,73,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(79,10,NULL,1,'products_and_description',74,75,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(80,10,NULL,1,'products_and_description',76,77,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(81,10,NULL,1,'products_and_description',78,85,1,NULL,NULL,'2026-08-20 21:02:54','2026-08-20 21:02:54'),(82,10,NULL,1,'products_and_description',61,62,73,NULL,NULL,'2026-08-20 21:02:55','2026-08-20 21:15:45'),(83,10,NULL,1,'products_and_description',45,46,65,NULL,NULL,'2026-08-20 21:02:55','2026-08-20 21:15:46');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_filterable_attributes`
--

DROP TABLE IF EXISTS `category_filterable_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_filterable_attributes` (
  `category_id` int unsigned NOT NULL,
  `attribute_id` int unsigned NOT NULL,
  KEY `category_filterable_attributes_category_id_foreign` (`category_id`),
  KEY `category_filterable_attributes_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `category_filterable_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_filterable_attributes_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_filterable_attributes`
--

LOCK TABLES `category_filterable_attributes` WRITE;
/*!40000 ALTER TABLE `category_filterable_attributes` DISABLE KEYS */;
INSERT INTO `category_filterable_attributes` VALUES (43,11),(43,23),(43,24),(42,11),(42,23),(42,24),(73,23),(73,11),(73,24),(49,23),(49,11),(49,24),(50,23),(50,11),(50,24),(51,23),(51,11),(51,24),(52,23),(52,11),(52,24),(53,23),(53,11),(53,24),(54,23),(54,11),(54,24),(55,23),(55,11),(55,24),(56,23),(56,11),(56,24),(57,23),(57,11),(57,24),(58,23),(58,11),(58,24),(59,23),(59,11),(59,24),(60,23),(60,11),(60,24),(74,23),(74,11),(74,24),(75,23),(75,11),(75,24),(76,23),(76,11),(76,24),(77,23),(77,11),(77,24),(78,23),(78,11),(78,24),(79,23),(79,11),(79,24),(80,23),(80,11),(80,24),(81,23),(81,11),(81,24),(61,23),(61,11),(61,24),(62,23),(62,11),(62,24),(63,23),(63,11),(63,24),(64,23),(64,11),(64,24),(65,23),(65,11),(65,24),(66,23),(66,11),(66,24),(67,23),(67,11),(67,24),(68,23),(68,11),(68,24),(69,23),(69,11),(69,24),(70,23),(70,11),(70,24),(71,23),(71,11),(71,24),(72,23),(72,11),(72,24),(82,23),(82,11),(82,24),(83,23),(83,11),(83,24);
/*!40000 ALTER TABLE `category_filterable_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_translations`
--

DROP TABLE IF EXISTS `category_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_path` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `meta_title` text COLLATE utf8mb4_unicode_ci,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci,
  `locale_id` int unsigned DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_translations_category_id_slug_locale_unique` (`category_id`,`slug`,`locale`),
  KEY `category_translations_locale_id_foreign` (`locale_id`),
  CONSTRAINT `category_translations_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `category_translations_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_translations`
--

LOCK TABLES `category_translations` WRITE;
/*!40000 ALTER TABLE `category_translations` DISABLE KEYS */;
INSERT INTO `category_translations` VALUES (1,1,'Root','root','','Root Category Description','','','',NULL,'en'),(42,42,'جعبه','جعبه','','<p>جعبه</p>','جعبه فست فود','جعبه فست فود','جعبه فست فود',2,'fa'),(43,42,'جعبه','جعبه','','<p>جعبه</p>','جعبه فست فود','جعبه فست فود','جعبه فست فود',1,'en'),(44,43,'جعبه سوخاری','جعبه-سوخاری','','<p>جعبه سوخاری</p>','جعبه سوخاری','جعبه سوخاری','جعبه سوخاری',2,'fa'),(45,43,'جعبه سوخاری','جعبه-سوخاری','','<p>جعبه سوخاری</p>','جعبه سوخاری','جعبه سوخاری','جعبه سوخاری',1,'en'),(46,44,'جعبه برگر','burger-box','','خرید جعبه برگر مناسب بسته‌بندی مواد غذایی','جعبه برگر','خرید جعبه برگر از شمیم پک','جعبه برگر',2,'fa'),(47,44,'جعبه برگر','burger-box','','خرید جعبه برگر مناسب بسته‌بندی مواد غذایی','جعبه برگر','خرید جعبه برگر از شمیم پک','جعبه برگر',1,'en'),(48,45,'جعبه ساندویچ','sandwich-box','','خرید جعبه ساندویچ مناسب بسته‌بندی مواد غذایی','جعبه ساندویچ','خرید جعبه ساندویچ از شمیم پک','جعبه ساندویچ',2,'fa'),(49,45,'جعبه ساندویچ','sandwich-box','','خرید جعبه ساندویچ مناسب بسته‌بندی مواد غذایی','جعبه ساندویچ','خرید جعبه ساندویچ از شمیم پک','جعبه ساندویچ',1,'en'),(52,47,'جعبه سیب‌زمینی','french-fries-box','','خرید جعبه سیب‌زمینی مناسب بسته‌بندی مواد غذایی','جعبه سیب‌زمینی','خرید جعبه سیب‌زمینی از شمیم پک','جعبه سیب‌زمینی',2,'fa'),(53,47,'جعبه سیب‌زمینی','french-fries-box','','خرید جعبه سیب‌زمینی مناسب بسته‌بندی مواد غذایی','جعبه سیب‌زمینی','خرید جعبه سیب‌زمینی از شمیم پک','جعبه سیب‌زمینی',1,'en'),(54,48,'کاغذ کرافت','kraft-paper','','خرید کاغذ کرافت مناسب بسته‌بندی مواد غذایی','کاغذ کرافت','خرید کاغذ کرافت از شمیم پک','کاغذ کرافت',2,'fa'),(55,48,'کاغذ کرافت','kraft-paper','','خرید کاغذ کرافت مناسب بسته‌بندی مواد غذایی','کاغذ کرافت','خرید کاغذ کرافت از شمیم پک','کاغذ کرافت',1,'en'),(56,49,'جعبه سوخاری','fried-chicken-boxes','','<p>خرید و سفارش عمده جعبه مرغ سوخاری در مدل‌های ۲ تکه، ۳ تکه، ۵ تکه، دسته‌دار و سفره‌ای.</p>','جعبه سوخاری | خرید عمده از شمیم پک','خرید و سفارش عمده جعبه مرغ سوخاری در مدل‌های ۲ تکه، ۳ تکه، ۵ تکه، دسته‌دار و سفره‌ای. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(57,49,'جعبه سوخاری','fried-chicken-boxes','','<p>خرید و سفارش عمده جعبه مرغ سوخاری در مدل‌های ۲ تکه، ۳ تکه، ۵ تکه، دسته‌دار و سفره‌ای.</p>','جعبه سوخاری | خرید عمده از شمیم پک','خرید و سفارش عمده جعبه مرغ سوخاری در مدل‌های ۲ تکه، ۳ تکه، ۵ تکه، دسته‌دار و سفره‌ای. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(58,50,'جعبه سوخاری ساده','standard-fried-chicken-boxes','','<p>جعبه سوخاری ایندربرد سفید و مشکی برای بسته‌بندی مرغ و غذای گرم.</p>','جعبه سوخاری ساده | خرید عمده از شمیم پک','جعبه سوخاری ایندربرد سفید و مشکی برای بسته‌بندی مرغ و غذای گرم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری ساده, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(59,50,'جعبه سوخاری ساده','standard-fried-chicken-boxes','','<p>جعبه سوخاری ایندربرد سفید و مشکی برای بسته‌بندی مرغ و غذای گرم.</p>','جعبه سوخاری ساده | خرید عمده از شمیم پک','جعبه سوخاری ایندربرد سفید و مشکی برای بسته‌بندی مرغ و غذای گرم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری ساده, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(60,51,'جعبه سوخاری دسته‌دار','handled-fried-chicken-boxes','','<p>باکس سوخاری دسته‌دار مناسب بیرون‌بر، ارسال و سفارش‌های چندتکه.</p>','جعبه سوخاری دسته‌دار | خرید عمده از شمیم پک','باکس سوخاری دسته‌دار مناسب بیرون‌بر، ارسال و سفارش‌های چندتکه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری دسته‌دار, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(61,51,'جعبه سوخاری دسته‌دار','handled-fried-chicken-boxes','','<p>باکس سوخاری دسته‌دار مناسب بیرون‌بر، ارسال و سفارش‌های چندتکه.</p>','جعبه سوخاری دسته‌دار | خرید عمده از شمیم پک','باکس سوخاری دسته‌دار مناسب بیرون‌بر، ارسال و سفارش‌های چندتکه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سوخاری دسته‌دار, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(62,52,'ظروف سرو سوخاری','fried-chicken-serving-packaging','','<p>بشقاب و جعبه سفره‌ای برای سرو سوخاری، فست‌فود و غذای بیرون‌بر.</p>','ظروف سرو سوخاری | خرید عمده از شمیم پک','بشقاب و جعبه سفره‌ای برای سرو سوخاری، فست‌فود و غذای بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظروف سرو سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(63,52,'ظروف سرو سوخاری','fried-chicken-serving-packaging','','<p>بشقاب و جعبه سفره‌ای برای سرو سوخاری، فست‌فود و غذای بیرون‌بر.</p>','ظروف سرو سوخاری | خرید عمده از شمیم پک','بشقاب و جعبه سفره‌ای برای سرو سوخاری، فست‌فود و غذای بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظروف سرو سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(64,53,'جعبه سیب زمینی','french-fries-boxes','','<p>انواع جعبه و پاکت سیب‌زمینی سرخ‌کرده در مدل صندوقی، قایقی، قیفی، هرمی و نیوکلاسیک.</p>','جعبه سیب زمینی | خرید عمده از شمیم پک','انواع جعبه و پاکت سیب‌زمینی سرخ‌کرده در مدل صندوقی، قایقی، قیفی، هرمی و نیوکلاسیک. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(65,53,'جعبه سیب زمینی','french-fries-boxes','','<p>انواع جعبه و پاکت سیب‌زمینی سرخ‌کرده در مدل صندوقی، قایقی، قیفی، هرمی و نیوکلاسیک.</p>','جعبه سیب زمینی | خرید عمده از شمیم پک','انواع جعبه و پاکت سیب‌زمینی سرخ‌کرده در مدل صندوقی، قایقی، قیفی، هرمی و نیوکلاسیک. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(66,54,'جعبه سیب زمینی صندوقی','carton-french-fries-boxes','','<p>جعبه سیب‌زمینی صندوقی ایندربرد برای حفظ شکل و حمل آسان.</p>','جعبه سیب زمینی صندوقی | خرید عمده از شمیم پک','جعبه سیب‌زمینی صندوقی ایندربرد برای حفظ شکل و حمل آسان. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی صندوقی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(67,54,'جعبه سیب زمینی صندوقی','carton-french-fries-boxes','','<p>جعبه سیب‌زمینی صندوقی ایندربرد برای حفظ شکل و حمل آسان.</p>','جعبه سیب زمینی صندوقی | خرید عمده از شمیم پک','جعبه سیب‌زمینی صندوقی ایندربرد برای حفظ شکل و حمل آسان. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی صندوقی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(68,55,'جعبه سیب زمینی قایقی','boat-french-fries-trays','','<p>ظرف قایقی سیب‌زمینی در سایز کوچک و بزرگ مناسب سرو فوری.</p>','جعبه سیب زمینی قایقی | خرید عمده از شمیم پک','ظرف قایقی سیب‌زمینی در سایز کوچک و بزرگ مناسب سرو فوری. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی قایقی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(69,55,'جعبه سیب زمینی قایقی','boat-french-fries-trays','','<p>ظرف قایقی سیب‌زمینی در سایز کوچک و بزرگ مناسب سرو فوری.</p>','جعبه سیب زمینی قایقی | خرید عمده از شمیم پک','ظرف قایقی سیب‌زمینی در سایز کوچک و بزرگ مناسب سرو فوری. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه سیب زمینی قایقی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(70,56,'پاکت و جعبه سیب زمینی','special-french-fries-packaging','','<p>مدل‌های قیفی، نیوکلاسیک و هرمی برای سرو حرفه‌ای سیب‌زمینی.</p>','پاکت و جعبه سیب زمینی | خرید عمده از شمیم پک','مدل‌های قیفی، نیوکلاسیک و هرمی برای سرو حرفه‌ای سیب‌زمینی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پاکت و جعبه سیب زمینی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(71,56,'پاکت و جعبه سیب زمینی','special-french-fries-packaging','','<p>مدل‌های قیفی، نیوکلاسیک و هرمی برای سرو حرفه‌ای سیب‌زمینی.</p>','پاکت و جعبه سیب زمینی | خرید عمده از شمیم پک','مدل‌های قیفی، نیوکلاسیک و هرمی برای سرو حرفه‌ای سیب‌زمینی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پاکت و جعبه سیب زمینی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(72,57,'کاغذ ساندویچ','sandwich-wrapping-paper','','<p>کاغذ کرافت ساندویچ و فست‌فود در سایزهای کاربردی برای بسته‌بندی بهداشتی.</p>','کاغذ ساندویچ | خرید عمده از شمیم پک','کاغذ کرافت ساندویچ و فست‌فود در سایزهای کاربردی برای بسته‌بندی بهداشتی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','کاغذ ساندویچ, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(73,57,'کاغذ ساندویچ','sandwich-wrapping-paper','','<p>کاغذ کرافت ساندویچ و فست‌فود در سایزهای کاربردی برای بسته‌بندی بهداشتی.</p>','کاغذ ساندویچ | خرید عمده از شمیم پک','کاغذ کرافت ساندویچ و فست‌فود در سایزهای کاربردی برای بسته‌بندی بهداشتی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','کاغذ ساندویچ, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(74,58,'جعبه پیتزا','pizza-boxes','','<p>جعبه پیتزا دو رو کرافت ایفلوت در سایزهای ۲۴ تا ۵۰ سانتی‌متر، مناسب پیتزافروشی و سفارش بیرون‌بر.</p>','جعبه پیتزا | خرید عمده از شمیم پک','جعبه پیتزا دو رو کرافت ایفلوت در سایزهای ۲۴ تا ۵۰ سانتی‌متر، مناسب پیتزافروشی و سفارش بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(75,58,'جعبه پیتزا','pizza-boxes','','<p>جعبه پیتزا دو رو کرافت ایفلوت در سایزهای ۲۴ تا ۵۰ سانتی‌متر، مناسب پیتزافروشی و سفارش بیرون‌بر.</p>','جعبه پیتزا | خرید عمده از شمیم پک','جعبه پیتزا دو رو کرافت ایفلوت در سایزهای ۲۴ تا ۵۰ سانتی‌متر، مناسب پیتزافروشی و سفارش بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(76,59,'جعبه پیتزا استاندارد','standard-pizza-boxes','','<p>جعبه پیتزا کرافت طاقدیس در سایزهای استاندارد ۲۴، ۲۸، ۳۰ و ۳۲ سانتی‌متر.</p>','جعبه پیتزا استاندارد | خرید عمده از شمیم پک','جعبه پیتزا کرافت طاقدیس در سایزهای استاندارد ۲۴، ۲۸، ۳۰ و ۳۲ سانتی‌متر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا استاندارد, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(77,59,'جعبه پیتزا استاندارد','standard-pizza-boxes','','<p>جعبه پیتزا کرافت طاقدیس در سایزهای استاندارد ۲۴، ۲۸، ۳۰ و ۳۲ سانتی‌متر.</p>','جعبه پیتزا استاندارد | خرید عمده از شمیم پک','جعبه پیتزا کرافت طاقدیس در سایزهای استاندارد ۲۴، ۲۸، ۳۰ و ۳۲ سانتی‌متر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا استاندارد, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(78,60,'جعبه پیتزا نیم متری','large-pizza-boxes','','<p>جعبه پیتزا نیم متری کرافت پارس و طاقدیس برای پیتزاهای بزرگ و خانوادگی.</p>','جعبه پیتزا نیم متری | خرید عمده از شمیم پک','جعبه پیتزا نیم متری کرافت پارس و طاقدیس برای پیتزاهای بزرگ و خانوادگی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا نیم متری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(79,60,'جعبه پیتزا نیم متری','large-pizza-boxes','','<p>جعبه پیتزا نیم متری کرافت پارس و طاقدیس برای پیتزاهای بزرگ و خانوادگی.</p>','جعبه پیتزا نیم متری | خرید عمده از شمیم پک','جعبه پیتزا نیم متری کرافت پارس و طاقدیس برای پیتزاهای بزرگ و خانوادگی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه پیتزا نیم متری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(80,61,'پاکت بیرون‌بر','takeaway-bags','','<p>پاکت کرافت بیرون‌بر و حمل غذا برای رستوران، کافه، فست‌فود و سفارش‌های تحویل.</p>','پاکت بیرون‌بر | خرید عمده از شمیم پک','پاکت کرافت بیرون‌بر و حمل غذا برای رستوران، کافه، فست‌فود و سفارش‌های تحویل. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پاکت بیرون‌بر, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(81,61,'پاکت بیرون‌بر','takeaway-bags','','<p>پاکت کرافت بیرون‌بر و حمل غذا برای رستوران، کافه، فست‌فود و سفارش‌های تحویل.</p>','پاکت بیرون‌بر | خرید عمده از شمیم پک','پاکت کرافت بیرون‌بر و حمل غذا برای رستوران، کافه، فست‌فود و سفارش‌های تحویل. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پاکت بیرون‌بر, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(82,62,'پک قاشق و چنگال','cutlery-packs','','<p>پک بهداشتی قاشق، چنگال، کارد و دستمال برای سفارش بیرون‌بر و پذیرایی.</p>','پک قاشق و چنگال | خرید عمده از شمیم پک','پک بهداشتی قاشق، چنگال، کارد و دستمال برای سفارش بیرون‌بر و پذیرایی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پک قاشق و چنگال, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(83,62,'پک قاشق و چنگال','cutlery-packs','','<p>پک بهداشتی قاشق، چنگال، کارد و دستمال برای سفارش بیرون‌بر و پذیرایی.</p>','پک قاشق و چنگال | خرید عمده از شمیم پک','پک بهداشتی قاشق، چنگال، کارد و دستمال برای سفارش بیرون‌بر و پذیرایی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','پک قاشق و چنگال, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(84,63,'لیوان کاغذی یک‌بارمصرف','disposable-paper-cups','','<p>لیوان کاغذی نوشیدنی گرم در سایزهای متنوع با امکان درب و چاپ اختصاصی.</p>','لیوان کاغذی یک‌بارمصرف | خرید عمده از شمیم پک','لیوان کاغذی نوشیدنی گرم در سایزهای متنوع با امکان درب و چاپ اختصاصی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان کاغذی یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(85,63,'لیوان کاغذی یک‌بارمصرف','disposable-paper-cups','','<p>لیوان کاغذی نوشیدنی گرم در سایزهای متنوع با امکان درب و چاپ اختصاصی.</p>','لیوان کاغذی یک‌بارمصرف | خرید عمده از شمیم پک','لیوان کاغذی نوشیدنی گرم در سایزهای متنوع با امکان درب و چاپ اختصاصی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان کاغذی یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(86,64,'لیوان پلاستیکی یک‌بارمصرف','disposable-plastic-cups','','<p>لیوان شفاف نوشیدنی سرد با درب تخت یا گنبدی مناسب کافه و آبمیوه‌فروشی.</p>','لیوان پلاستیکی یک‌بارمصرف | خرید عمده از شمیم پک','لیوان شفاف نوشیدنی سرد با درب تخت یا گنبدی مناسب کافه و آبمیوه‌فروشی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان پلاستیکی یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(87,64,'لیوان پلاستیکی یک‌بارمصرف','disposable-plastic-cups','','<p>لیوان شفاف نوشیدنی سرد با درب تخت یا گنبدی مناسب کافه و آبمیوه‌فروشی.</p>','لیوان پلاستیکی یک‌بارمصرف | خرید عمده از شمیم پک','لیوان شفاف نوشیدنی سرد با درب تخت یا گنبدی مناسب کافه و آبمیوه‌فروشی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان پلاستیکی یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(88,65,'بسته‌بندی بستنی','ice-cream-packaging','','<p>کاپ کاغذی بستنی و دسر در سایزهای تک‌نفره و خانوادگی.</p>','بسته‌بندی بستنی | خرید عمده از شمیم پک','کاپ کاغذی بستنی و دسر در سایزهای تک‌نفره و خانوادگی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی بستنی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(89,65,'بسته‌بندی بستنی','ice-cream-packaging','','<p>کاپ کاغذی بستنی و دسر در سایزهای تک‌نفره و خانوادگی.</p>','بسته‌بندی بستنی | خرید عمده از شمیم پک','کاپ کاغذی بستنی و دسر در سایزهای تک‌نفره و خانوادگی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی بستنی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(90,66,'ظرف سالاد یک‌بارمصرف','disposable-salad-containers','','<p>ظرف شفاف درب‌دار برای سالاد، میوه، دسر و غذای سرد.</p>','ظرف سالاد یک‌بارمصرف | خرید عمده از شمیم پک','ظرف شفاف درب‌دار برای سالاد، میوه، دسر و غذای سرد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف سالاد یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(91,66,'ظرف سالاد یک‌بارمصرف','disposable-salad-containers','','<p>ظرف شفاف درب‌دار برای سالاد، میوه، دسر و غذای سرد.</p>','ظرف سالاد یک‌بارمصرف | خرید عمده از شمیم پک','ظرف شفاف درب‌دار برای سالاد، میوه، دسر و غذای سرد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف سالاد یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(92,67,'ظرف سس یک‌بارمصرف','disposable-sauce-cups','','<p>کاپ کوچک شفاف درب‌دار برای انواع سس، چاشنی و دورچین.</p>','ظرف سس یک‌بارمصرف | خرید عمده از شمیم پک','کاپ کوچک شفاف درب‌دار برای انواع سس، چاشنی و دورچین. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف سس یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(93,67,'ظرف سس یک‌بارمصرف','disposable-sauce-cups','','<p>کاپ کوچک شفاف درب‌دار برای انواع سس، چاشنی و دورچین.</p>','ظرف سس یک‌بارمصرف | خرید عمده از شمیم پک','کاپ کوچک شفاف درب‌دار برای انواع سس، چاشنی و دورچین. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف سس یک‌بارمصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(94,68,'نی و سیخ چوبی','straws-and-wooden-skewers','','<p>نی نوشیدنی و سیخ چوبی یک‌بارمصرف مناسب کافه، رستوران و پذیرایی.</p>','نی و سیخ چوبی | خرید عمده از شمیم پک','نی نوشیدنی و سیخ چوبی یک‌بارمصرف مناسب کافه، رستوران و پذیرایی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','نی و سیخ چوبی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(95,68,'نی و سیخ چوبی','straws-and-wooden-skewers','','<p>نی نوشیدنی و سیخ چوبی یک‌بارمصرف مناسب کافه، رستوران و پذیرایی.</p>','نی و سیخ چوبی | خرید عمده از شمیم پک','نی نوشیدنی و سیخ چوبی یک‌بارمصرف مناسب کافه، رستوران و پذیرایی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','نی و سیخ چوبی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(96,69,'بسته‌بندی آجیل و خشکبار','nuts-packaging','','<p>پاکت کرافت پنجره‌دار و ایستاده برای آجیل، خشکبار، قهوه و تنقلات.</p>','بسته‌بندی آجیل و خشکبار | خرید عمده از شمیم پک','پاکت کرافت پنجره‌دار و ایستاده برای آجیل، خشکبار، قهوه و تنقلات. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی آجیل و خشکبار, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(97,69,'بسته‌بندی آجیل و خشکبار','nuts-packaging','','<p>پاکت کرافت پنجره‌دار و ایستاده برای آجیل، خشکبار، قهوه و تنقلات.</p>','بسته‌بندی آجیل و خشکبار | خرید عمده از شمیم پک','پاکت کرافت پنجره‌دار و ایستاده برای آجیل، خشکبار، قهوه و تنقلات. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی آجیل و خشکبار, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(98,70,'ظرف مایکروویوی','microwave-food-containers','','<p>ظرف مقاوم در برابر حرارت با درب شفاف برای غذای گرم و ارسال بیرون‌بر.</p>','ظرف مایکروویوی | خرید عمده از شمیم پک','ظرف مقاوم در برابر حرارت با درب شفاف برای غذای گرم و ارسال بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف مایکروویوی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(99,70,'ظرف مایکروویوی','microwave-food-containers','','<p>ظرف مقاوم در برابر حرارت با درب شفاف برای غذای گرم و ارسال بیرون‌بر.</p>','ظرف مایکروویوی | خرید عمده از شمیم پک','ظرف مقاوم در برابر حرارت با درب شفاف برای غذای گرم و ارسال بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظرف مایکروویوی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(100,71,'سینی و ظرف سرو غذا','food-serving-trays','','<p>سینی کرافت مخصوص سرو فست‌فود، سوخاری، سیب‌زمینی و غذای آماده.</p>','سینی و ظرف سرو غذا | خرید عمده از شمیم پک','سینی کرافت مخصوص سرو فست‌فود، سوخاری، سیب‌زمینی و غذای آماده. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینی و ظرف سرو غذا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(101,71,'سینی و ظرف سرو غذا','food-serving-trays','','<p>سینی کرافت مخصوص سرو فست‌فود، سوخاری، سیب‌زمینی و غذای آماده.</p>','سینی و ظرف سرو غذا | خرید عمده از شمیم پک','سینی کرافت مخصوص سرو فست‌فود، سوخاری، سیب‌زمینی و غذای آماده. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینی و ظرف سرو غذا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(102,72,'ملزومات سرو میز','table-service-supplies','','<p>جا دستمالی، دستمال کاغذی و ملزومات کاربردی میز رستوران و کافه.</p>','ملزومات سرو میز | خرید عمده از شمیم پک','جا دستمالی، دستمال کاغذی و ملزومات کاربردی میز رستوران و کافه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ملزومات سرو میز, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(103,72,'ملزومات سرو میز','table-service-supplies','','<p>جا دستمالی، دستمال کاغذی و ملزومات کاربردی میز رستوران و کافه.</p>','ملزومات سرو میز | خرید عمده از شمیم پک','جا دستمالی، دستمال کاغذی و ملزومات کاربردی میز رستوران و کافه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ملزومات سرو میز, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(104,73,'لیوان یکبار مصرف','disposable-cups','','<p>انواع لیوان کاغذی و شفاف یکبار مصرف برای نوشیدنی گرم و سرد، کافه و رستوران.</p>','لیوان یکبار مصرف | خرید عمده از شمیم پک','انواع لیوان کاغذی و شفاف یکبار مصرف برای نوشیدنی گرم و سرد، کافه و رستوران. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان یکبار مصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(105,73,'لیوان یکبار مصرف','disposable-cups','','<p>انواع لیوان کاغذی و شفاف یکبار مصرف برای نوشیدنی گرم و سرد، کافه و رستوران.</p>','لیوان یکبار مصرف | خرید عمده از شمیم پک','انواع لیوان کاغذی و شفاف یکبار مصرف برای نوشیدنی گرم و سرد، کافه و رستوران. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','لیوان یکبار مصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(106,74,'جعبه برگر','burger-boxes','','<p>جعبه برگر کرافت و ایندربرد در مدل‌های صدفی، لاک‌باتوم و سفره‌ای برای فست‌فود و بیرون‌بر.</p>','جعبه برگر | خرید عمده از شمیم پک','جعبه برگر کرافت و ایندربرد در مدل‌های صدفی، لاک‌باتوم و سفره‌ای برای فست‌فود و بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه برگر, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(107,74,'جعبه برگر','burger-boxes','','<p>جعبه برگر کرافت و ایندربرد در مدل‌های صدفی، لاک‌باتوم و سفره‌ای برای فست‌فود و بیرون‌بر.</p>','جعبه برگر | خرید عمده از شمیم پک','جعبه برگر کرافت و ایندربرد در مدل‌های صدفی، لاک‌باتوم و سفره‌ای برای فست‌فود و بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه برگر, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(108,75,'جعبه ساندویچ','sandwich-boxes','','<p>جعبه ساندویچ و هات‌داگ در مدل‌های کرافت، کشویی و صدفی با ابعاد استاندارد.</p>','جعبه ساندویچ | خرید عمده از شمیم پک','جعبه ساندویچ و هات‌داگ در مدل‌های کرافت، کشویی و صدفی با ابعاد استاندارد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه ساندویچ, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(109,75,'جعبه ساندویچ','sandwich-boxes','','<p>جعبه ساندویچ و هات‌داگ در مدل‌های کرافت، کشویی و صدفی با ابعاد استاندارد.</p>','جعبه ساندویچ | خرید عمده از شمیم پک','جعبه ساندویچ و هات‌داگ در مدل‌های کرافت، کشویی و صدفی با ابعاد استاندارد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه ساندویچ, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(110,76,'بسته‌بندی ساشه','single-serve-sachets','','<p>ساشه تک‌نفره نمک، فلفل، آویشن و ادویه با امکان چاپ اختصاصی برای رستوران و فست‌فود.</p>','بسته‌بندی ساشه | خرید عمده از شمیم پک','ساشه تک‌نفره نمک، فلفل، آویشن و ادویه با امکان چاپ اختصاصی برای رستوران و فست‌فود. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی ساشه, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(111,76,'بسته‌بندی ساشه','single-serve-sachets','','<p>ساشه تک‌نفره نمک، فلفل، آویشن و ادویه با امکان چاپ اختصاصی برای رستوران و فست‌فود.</p>','بسته‌بندی ساشه | خرید عمده از شمیم پک','ساشه تک‌نفره نمک، فلفل، آویشن و ادویه با امکان چاپ اختصاصی برای رستوران و فست‌فود. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','بسته‌بندی ساشه, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(112,77,'جعبه غذا','takeaway-food-boxes','','<p>جعبه و پک غذای بیرون‌بر کرافت برای رستوران، کترینگ و غذای گرم.</p>','جعبه غذا | خرید عمده از شمیم پک','جعبه و پک غذای بیرون‌بر کرافت برای رستوران، کترینگ و غذای گرم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه غذا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(113,77,'جعبه غذا','takeaway-food-boxes','','<p>جعبه و پک غذای بیرون‌بر کرافت برای رستوران، کترینگ و غذای گرم.</p>','جعبه غذا | خرید عمده از شمیم پک','جعبه و پک غذای بیرون‌بر کرافت برای رستوران، کترینگ و غذای گرم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جعبه غذا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(114,78,'سطل سوخاری','fried-chicken-buckets','','<p>سطل مقوایی مرغ سوخاری در ظرفیت‌های تک‌نفره و خانوادگی مناسب بیرون‌بر.</p>','سطل سوخاری | خرید عمده از شمیم پک','سطل مقوایی مرغ سوخاری در ظرفیت‌های تک‌نفره و خانوادگی مناسب بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سطل سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(115,78,'سطل سوخاری','fried-chicken-buckets','','<p>سطل مقوایی مرغ سوخاری در ظرفیت‌های تک‌نفره و خانوادگی مناسب بیرون‌بر.</p>','سطل سوخاری | خرید عمده از شمیم پک','سطل مقوایی مرغ سوخاری در ظرفیت‌های تک‌نفره و خانوادگی مناسب بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سطل سوخاری, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(116,79,'سفره','disposable-tablecloths','','<p>سفره یکبار مصرف و ملزومات بهداشتی سرو غذا برای رستوران، کترینگ و مراسم.</p>','سفره | خرید عمده از شمیم پک','سفره یکبار مصرف و ملزومات بهداشتی سرو غذا برای رستوران، کترینگ و مراسم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سفره, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(117,79,'سفره','disposable-tablecloths','','<p>سفره یکبار مصرف و ملزومات بهداشتی سرو غذا برای رستوران، کترینگ و مراسم.</p>','سفره | خرید عمده از شمیم پک','سفره یکبار مصرف و ملزومات بهداشتی سرو غذا برای رستوران، کترینگ و مراسم. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سفره, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(118,80,'سینگل زیر پیتزا','pizza-boards','','<p>سینگل و زیرپیتزایی مقوایی مقاوم برای سرو پیتزا و جلوگیری از تغییر شکل جعبه.</p>','سینگل زیر پیتزا | خرید عمده از شمیم پک','سینگل و زیرپیتزایی مقوایی مقاوم برای سرو پیتزا و جلوگیری از تغییر شکل جعبه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینگل زیر پیتزا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(119,80,'سینگل زیر پیتزا','pizza-boards','','<p>سینگل و زیرپیتزایی مقوایی مقاوم برای سرو پیتزا و جلوگیری از تغییر شکل جعبه.</p>','سینگل زیر پیتزا | خرید عمده از شمیم پک','سینگل و زیرپیتزایی مقوایی مقاوم برای سرو پیتزا و جلوگیری از تغییر شکل جعبه. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینگل زیر پیتزا, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(120,81,'ظروف یکبار مصرف','disposable-food-containers','','<p>انواع ظروف یکبار مصرف درب‌دار برای سالاد، سس، غذای گرم، دسر و ارسال بیرون‌بر.</p>','ظروف یکبار مصرف | خرید عمده از شمیم پک','انواع ظروف یکبار مصرف درب‌دار برای سالاد، سس، غذای گرم، دسر و ارسال بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظروف یکبار مصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(121,81,'ظروف یکبار مصرف','disposable-food-containers','','<p>انواع ظروف یکبار مصرف درب‌دار برای سالاد، سس، غذای گرم، دسر و ارسال بیرون‌بر.</p>','ظروف یکبار مصرف | خرید عمده از شمیم پک','انواع ظروف یکبار مصرف درب‌دار برای سالاد، سس، غذای گرم، دسر و ارسال بیرون‌بر. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','ظروف یکبار مصرف, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(122,82,'جالیوانی مقوایی','cardboard-cup-carriers','','<p>جالیوانی مقوایی دوخانه و چهارخانه برای حمل ایمن نوشیدنی‌های گرم و سرد.</p>','جالیوانی مقوایی | خرید عمده از شمیم پک','جالیوانی مقوایی دوخانه و چهارخانه برای حمل ایمن نوشیدنی‌های گرم و سرد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جالیوانی مقوایی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(123,82,'جالیوانی مقوایی','cardboard-cup-carriers','','<p>جالیوانی مقوایی دوخانه و چهارخانه برای حمل ایمن نوشیدنی‌های گرم و سرد.</p>','جالیوانی مقوایی | خرید عمده از شمیم پک','جالیوانی مقوایی دوخانه و چهارخانه برای حمل ایمن نوشیدنی‌های گرم و سرد. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','جالیوانی مقوایی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa'),(124,83,'سینی مقوایی بستنی','ice-cream-cardboard-trays','','<p>سینی مقوایی بستنی برای حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی.</p>','سینی مقوایی بستنی | خرید عمده از شمیم پک','سینی مقوایی بستنی برای حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینی مقوایی بستنی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',1,'en'),(125,83,'سینی مقوایی بستنی','ice-cream-cardboard-trays','','<p>سینی مقوایی بستنی برای حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی.</p>','سینی مقوایی بستنی | خرید عمده از شمیم پک','سینی مقوایی بستنی برای حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی. مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از شمیم پک.','سینی مقوایی بستنی, بسته بندی فست فود, خرید عمده بسته بندی, شمیم پک',2,'fa');
/*!40000 ALTER TABLE `category_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_currencies`
--

DROP TABLE IF EXISTS `channel_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_currencies` (
  `channel_id` int unsigned NOT NULL,
  `currency_id` int unsigned NOT NULL,
  PRIMARY KEY (`channel_id`,`currency_id`),
  KEY `channel_currencies_currency_id_foreign` (`currency_id`),
  KEY `channel_currencies_cid_cyid_idx` (`channel_id`,`currency_id`),
  CONSTRAINT `channel_currencies_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_currencies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_currencies`
--

LOCK TABLES `channel_currencies` WRITE;
/*!40000 ALTER TABLE `channel_currencies` DISABLE KEYS */;
INSERT INTO `channel_currencies` VALUES (1,2);
/*!40000 ALTER TABLE `channel_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_inventory_sources`
--

DROP TABLE IF EXISTS `channel_inventory_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_inventory_sources` (
  `channel_id` int unsigned NOT NULL,
  `inventory_source_id` int unsigned NOT NULL,
  UNIQUE KEY `channel_inventory_source_unique` (`channel_id`,`inventory_source_id`),
  KEY `channel_inventory_sources_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `channel_inventory_sources_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_inventory_sources_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_inventory_sources`
--

LOCK TABLES `channel_inventory_sources` WRITE;
/*!40000 ALTER TABLE `channel_inventory_sources` DISABLE KEYS */;
INSERT INTO `channel_inventory_sources` VALUES (1,1);
/*!40000 ALTER TABLE `channel_inventory_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_locales`
--

DROP TABLE IF EXISTS `channel_locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_locales` (
  `channel_id` int unsigned NOT NULL,
  `locale_id` int unsigned NOT NULL,
  PRIMARY KEY (`channel_id`,`locale_id`),
  KEY `channel_locales_locale_id_foreign` (`locale_id`),
  KEY `channel_locales_cid_lid_idx` (`channel_id`,`locale_id`),
  CONSTRAINT `channel_locales_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `channel_locales_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_locales`
--

LOCK TABLES `channel_locales` WRITE;
/*!40000 ALTER TABLE `channel_locales` DISABLE KEYS */;
INSERT INTO `channel_locales` VALUES (1,2);
/*!40000 ALTER TABLE `channel_locales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_translations`
--

DROP TABLE IF EXISTS `channel_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_translations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `maintenance_mode_text` text COLLATE utf8mb4_unicode_ci,
  `home_seo` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_translations_channel_id_locale_unique` (`channel_id`,`locale`),
  KEY `channel_translations_locale_index` (`locale`),
  CONSTRAINT `channel_translations_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_translations`
--

LOCK TABLES `channel_translations` WRITE;
/*!40000 ALTER TABLE `channel_translations` DISABLE KEYS */;
INSERT INTO `channel_translations` VALUES (1,1,'en','Default','','','{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}',NULL,'2026-08-06 17:45:13'),(2,1,'fa','شمیم','','','{\"meta_title\": \"شمیم پک\", \"meta_keywords\": \"شمیم پک\", \"meta_description\": \"شمیم پک\"}','2026-08-15 18:43:35','2026-08-16 16:41:52');
/*!40000 ALTER TABLE `channel_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channels` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timezone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `theme` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hostname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favicon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `home_seo` json DEFAULT NULL,
  `is_maintenance_on` tinyint(1) NOT NULL DEFAULT '0',
  `allowed_ips` text COLLATE utf8mb4_unicode_ci,
  `root_category_id` int unsigned DEFAULT NULL,
  `default_locale_id` int unsigned NOT NULL,
  `base_currency_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `channels_root_category_id_foreign` (`root_category_id`),
  KEY `channels_default_locale_id_foreign` (`default_locale_id`),
  KEY `channels_base_currency_id_foreign` (`base_currency_id`),
  KEY `channels_hostname_idx` (`hostname`),
  CONSTRAINT `channels_base_currency_id_foreign` FOREIGN KEY (`base_currency_id`) REFERENCES `currencies` (`id`),
  CONSTRAINT `channels_default_locale_id_foreign` FOREIGN KEY (`default_locale_id`) REFERENCES `locales` (`id`),
  CONSTRAINT `channels_root_category_id_foreign` FOREIGN KEY (`root_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
INSERT INTO `channels` VALUES (1,'default',NULL,'shamim-pack','http://127.0.0.1:8000','channel/1/KMZByLbYAbMmiOHE7wP2kU7bJ8hDaUmMKyQts3e3.png',NULL,NULL,0,'',1,2,2,'2026-08-05 22:11:37','2026-08-20 13:12:23');
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_channels`
--

DROP TABLE IF EXISTS `cms_page_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_channels` (
  `cms_page_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  UNIQUE KEY `cms_page_channels_cms_page_id_channel_id_unique` (`cms_page_id`,`channel_id`),
  KEY `cms_page_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `cms_page_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cms_page_channels_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_channels`
--

LOCK TABLES `cms_page_channels` WRITE;
/*!40000 ALTER TABLE `cms_page_channels` DISABLE KEYS */;
INSERT INTO `cms_page_channels` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1);
/*!40000 ALTER TABLE `cms_page_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_translations`
--

DROP TABLE IF EXISTS `cms_page_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `page_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `html_content` longtext COLLATE utf8mb4_unicode_ci,
  `meta_title` text COLLATE utf8mb4_unicode_ci,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cms_page_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cms_page_translations_cms_page_id_url_key_locale_unique` (`cms_page_id`,`url_key`,`locale`),
  CONSTRAINT `cms_page_translations_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_translations`
--

LOCK TABLES `cms_page_translations` WRITE;
/*!40000 ALTER TABLE `cms_page_translations` DISABLE KEYS */;
INSERT INTO `cms_page_translations` VALUES (1,'About Us','about-us','<div class=\"static-container\"><div class=\"mb-5\">About Us Page Content</div></div>','about us','','aboutus','en',1),(2,'Return Policy','return-policy','<div class=\"static-container\"><div class=\"mb-5\">Return Policy Page Content</div></div>','return policy','','return, policy','en',2),(3,'Refund Policy','refund-policy','<div class=\"static-container\"><div class=\"mb-5\">Refund Policy Page Content</div></div>','Refund policy','','refund, policy','en',3),(4,'Terms & Conditions','terms-conditions','<div class=\"static-container\"><div class=\"mb-5\">Terms & Conditions Page Content</div></div>','Terms & Conditions','','term, conditions','en',4),(5,'Terms of Use','terms-of-use','<div class=\"static-container\"><div class=\"mb-5\">Terms of Use Page Content</div></div>','Terms of use','','term, use','en',5),(6,'Customer Service','customer-service','<div class=\"static-container\"><div class=\"mb-5\">Customer Service Page Content</div></div>','Customer Service','','customer, service','en',6),(7,'What\'s New','whats-new','<div class=\"static-container\"><div class=\"mb-5\">What\'s New page content</div></div>','What\'s New','','new','en',7),(8,'Payment Policy','payment-policy','<div class=\"static-container\"><div class=\"mb-5\">Payment Policy Page Content</div></div>','Payment Policy','','payment, policy','en',8),(9,'Shipping Policy','shipping-policy','<div class=\"static-container\"><div class=\"mb-5\">Shipping Policy Page Content</div></div>','Shipping Policy','','shipping, policy','en',9),(10,'Privacy Policy','privacy-policy','<div class=\"static-container\"><div class=\"mb-5\">Privacy Policy Page Content</div></div>','Privacy Policy','','privacy, policy','en',10),(11,'برای غذای گرم چه جعبه‌ای مناسب‌تر است؟','entekhab-jabe-ghazaye-garm','<img src=\"/themes/shop/shamim-pack/images/pack-chicken.png\" alt=\"برای غذای گرم چه جعبه‌ای مناسب‌تر است؟\"><h2>سه معیار اصلی برای غذای گرم</h2><p>جعبه مناسب باید گرما را حفظ کند، بخار اضافی را بیرون بدهد و در تماس با روغن تغییر شکل ندهد. بسته‌بندی کاملاً بسته برای غذای ترد مناسب نیست؛ چون بخار داخل آن جمع می‌شود و بافت غذا را نرم می‌کند.</p><h2>جنس جعبه را بر اساس نوع غذا انتخاب کنید</h2><ul><li><strong>سوخاری و سیب‌زمینی:</strong> جعبه دارای دریچه تهویه و کاغذ مقاوم به چربی.</li><li><strong>برگر و ساندویچ:</strong> مقوای Food Grade با ساختار محکم و ابعاد متناسب.</li><li><strong>غذاهای سس‌دار:</strong> پوشش داخلی مقاوم به رطوبت و قفل مطمئن.</li></ul><h2>اندازه دقیق، کیفیت بیشتر</h2><p>فضای خالی زیاد باعث حرکت محصول و افت ظاهر آن می‌شود. پیش از سفارش عمده، ابعاد محصول نهایی را اندازه بگیرید.</p>','برای غذای گرم چه جعبه‌ای مناسب‌تر است؟ | شمیم پک','راهنمای انتخاب بسته‌بندی مناسب برای حفظ دما، بافت و کیفیت غذای گرم در مسیر ارسال.','جعبه غذای گرم، بسته بندی غذا، جعبه فست فود','fa',11),(12,'چاپ اختصاصی و برندینگ روی بسته‌بندی غذا','chap-branding-bastebandi','<img src=\"/themes/shop/shamim-pack/images/pack-burger.png\" alt=\"چاپ اختصاصی و برندینگ روی بسته‌بندی غذا\"><h2>جعبه، بخشی از تجربه برند است</h2><p>مشتری پیش از دیدن غذا، بسته‌بندی را می‌بیند. لوگوی خوانا، رنگ ثابت و پیام کوتاه حس حرفه‌ای بودن را منتقل می‌کند.</p><h2>چه چیزی روی جعبه چاپ کنیم؟</h2><ul><li>لوگو و نام برند در نقطه‌ای واضح</li><li>آدرس شبکه اجتماعی یا QR Code</li><li>پیام کوتاه درباره کیفیت مواد اولیه</li><li>اطلاعات تماس و سفارش مجدد</li></ul><h2>سادگی بهتر دیده می‌شود</h2><p>یک رنگ اصلی، یک رنگ مکمل و فضای سفید کافی معمولاً نتیجه‌ای حرفه‌ای‌تر از طرح شلوغ دارد.</p>','چاپ اختصاصی و برندینگ روی بسته‌بندی غذا | شمیم پک','چطور با رنگ، لوگو و پیام درست، جعبه غذا را به یک رسانه تبلیغاتی مؤثر تبدیل کنیم؟','چاپ جعبه غذا، چاپ اختصاصی، برندینگ رستوران','fa',12),(13,'بسته‌بندی چگونه فروش دوباره را بیشتر می‌کند؟','bastebandi-foroush-dobare','<img src=\"/themes/shop/shamim-pack/images/pack-sandwich.png\" alt=\"بسته‌بندی چگونه فروش دوباره را بیشتر می‌کند؟\"><h2>کیفیت غذا باید تا لحظه تحویل حفظ شود</h2><p>نشتی سس، له شدن جعبه یا سرد شدن سریع غذا مستقیماً روی قضاوت مشتری اثر می‌گذارد. بسته‌بندی مناسب، آخرین مرحله کنترل کیفیت شماست.</p><h2>باز کردن آسان و حمل مطمئن</h2><p>قفل مناسب، چیدمان درست و امکان حمل آسان، تجربه مشتری را بهتر می‌کند و احتمال سفارش دوباره را بالا می‌برد.</p><h2>راه بازگشت مشتری را کوتاه کنید</h2><p>شماره تماس، آدرس سایت یا QR Code سفارش را روی جعبه قرار دهید. یک پیام دوستانه کوتاه نیز جعبه را به ابزار وفادارسازی تبدیل می‌کند.</p>','بسته‌بندی چگونه فروش دوباره را بیشتر می‌کند؟ | شمیم پک','بسته‌بندی سالم، خوش‌دست و به‌یادماندنی یکی از ساده‌ترین راه‌های افزایش رضایت و سفارش مجدد است.','افزایش فروش رستوران، بسته بندی حرفه ای، تجربه مشتری','fa',13),(14,'راهنمای انتخاب جعبه سوخاری، برگر و ساندویچ','rahnamaye-entekhab-jabe-fastfood','<img src=\"/themes/shop/shamim-pack/images/pack-fries.png\" alt=\"راهنمای انتخاب جعبه سوخاری، برگر و ساندویچ\"><h2>جعبه سوخاری</h2><p>برای مرغ و قطعات سوخاری، استحکام کف و گردش هوا اهمیت بیشتری دارد. جعبه باید در برابر چربی مقاوم باشد.</p><h2>جعبه برگر و ساندویچ</h2><p>ابعاد نزدیک به محصول، مانع جابه‌جایی محتویات می‌شود. برای برگرهای حجیم، ارتفاع درب و مقاومت گوشه‌ها را جدی بگیرید.</p><h2>جعبه سیب‌زمینی و کاغذ کرافت</h2><p>ساختار باز جعبه سیب‌زمینی به خروج بخار کمک می‌کند. کاغذ کرافت نیز ظاهری طبیعی و گرم دارد.</p><h2>پیش از تولید عمده نمونه بگیرید</h2><p>نمونه را با غذای واقعی و در مدت زمان معمول ارسال آزمایش کنید.</p>','راهنمای انتخاب جعبه سوخاری، برگر و ساندویچ | شمیم پک','مقایسه کاربردی انواع جعبه فست‌فود برای انتخاب ابعاد، جنس و ساختار مناسب هر محصول.','جعبه سوخاری، جعبه برگر، جعبه ساندویچ، کاغذ کرافت','fa',14);
/*!40000 ALTER TABLE `cms_page_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_pages`
--

DROP TABLE IF EXISTS `cms_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_pages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `layout` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_pages`
--

LOCK TABLES `cms_pages` WRITE;
/*!40000 ALTER TABLE `cms_pages` DISABLE KEYS */;
INSERT INTO `cms_pages` VALUES (1,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(2,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(3,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(4,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(5,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(6,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(7,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(8,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(9,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(10,NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(11,'default','2026-08-18 19:21:55','2026-08-18 19:21:55'),(12,'default','2026-08-18 19:21:55','2026-08-18 19:21:55'),(13,'default','2026-08-18 19:21:55','2026-08-18 19:21:55'),(14,'default','2026-08-18 19:21:55','2026-08-18 19:21:55');
/*!40000 ALTER TABLE `cms_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compare_items`
--

DROP TABLE IF EXISTS `compare_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compare_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compare_items_product_id_foreign` (`product_id`),
  KEY `compare_items_customer_id_foreign` (`customer_id`),
  CONSTRAINT `compare_items_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compare_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compare_items`
--

LOCK TABLES `compare_items` WRITE;
/*!40000 ALTER TABLE `compare_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `compare_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_config`
--

DROP TABLE IF EXISTS `core_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_config`
--

LOCK TABLES `core_config` WRITE;
/*!40000 ALTER TABLE `core_config` DISABLE KEYS */;
INSERT INTO `core_config` VALUES (1,'sales.checkout.shopping_cart.allow_guest_checkout','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(2,'emails.general.notifications.emails.general.notifications.registration','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(3,'emails.general.notifications.emails.general.notifications.customer_registration_confirmation_mail_to_admin','0',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(4,'emails.general.notifications.emails.general.notifications.customer_account_credentials','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(5,'emails.general.notifications.emails.general.notifications.new_order','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(6,'emails.general.notifications.emails.general.notifications.new_order_mail_to_admin','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(7,'emails.general.notifications.emails.general.notifications.new_invoice','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(8,'emails.general.notifications.emails.general.notifications.new_invoice_mail_to_admin','0',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(9,'emails.general.notifications.emails.general.notifications.new_refund','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(10,'emails.general.notifications.emails.general.notifications.new_refund_mail_to_admin','0',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(11,'emails.general.notifications.emails.general.notifications.new_shipment','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(12,'emails.general.notifications.emails.general.notifications.new_shipment_mail_to_admin','0',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(13,'emails.general.notifications.emails.general.notifications.new_inventory_source','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(14,'emails.general.notifications.emails.general.notifications.cancel_order','1',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(15,'emails.general.notifications.emails.general.notifications.cancel_order_mail_to_admin','0',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(16,'general.design.categories.category_view','sidebar',NULL,NULL,'2026-08-05 22:11:37','2026-08-05 22:11:37'),(17,'customer.settings.social_login.enable_facebook','1','default',NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(18,'customer.settings.social_login.enable_twitter','1','default',NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(19,'customer.settings.social_login.enable_google','1','default',NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(20,'customer.settings.social_login.enable_linkedin','1','default',NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(21,'customer.settings.social_login.enable_github','1','default',NULL,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(22,'catalog.inventory.stock_options.back_orders','1',NULL,NULL,'2026-08-16 15:56:43','2026-08-16 15:56:43'),(23,'catalog.inventory.stock_options.out_of_stock_threshold','0',NULL,NULL,'2026-08-16 15:56:43','2026-08-16 15:56:43'),(24,'customer.address.requirements.country','0','default',NULL,'2026-08-16 15:57:03','2026-08-16 15:57:03'),(25,'customer.address.requirements.state','1','default',NULL,'2026-08-16 15:57:03','2026-08-16 15:57:03'),(26,'customer.address.requirements.postcode','1','default',NULL,'2026-08-16 15:57:03','2026-08-16 15:57:03'),(27,'customer.address.information.street_lines','1','default',NULL,'2026-08-16 15:57:03','2026-08-16 15:57:03'),(28,'sales.shipping.origin.country','IR','default','fa','2026-08-16 15:58:35','2026-08-16 15:58:35'),(29,'sales.shipping.origin.state','آذربایجان شرقی','default','fa','2026-08-16 15:58:35','2026-08-16 15:58:35'),(30,'sales.shipping.origin.city','تبریز','default','fa','2026-08-16 15:58:35','2026-08-16 15:58:35'),(31,'sales.shipping.origin.address','اول جاده مایان. کوی پدرام.','default','fa','2026-08-16 15:58:35','2026-08-16 16:09:24'),(32,'sales.shipping.origin.zipcode','111','default','fa','2026-08-16 15:58:35','2026-08-16 16:09:34'),(33,'sales.shipping.origin.store_name','شمیم','default','fa','2026-08-16 15:58:35','2026-08-16 15:58:35'),(34,'sales.shipping.origin.vat_number','','default',NULL,'2026-08-16 15:58:35','2026-08-16 15:58:35'),(35,'sales.shipping.origin.contact','','default',NULL,'2026-08-16 15:58:35','2026-08-16 15:58:35'),(36,'sales.shipping.origin.bank_details','','default','fa','2026-08-16 15:58:35','2026-08-16 15:58:35'),(37,'general.design.admin_logo.logo_image','configuration/dOm9kazqmp1QoRPExk8qa24l6uXAHkdF0lT0grow.png',NULL,NULL,'2026-08-16 16:14:45','2026-08-16 16:14:45'),(38,'sales.payment_methods.stripe.active','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(39,'sales.payment_methods.zarinpal.active','1','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(40,'sales.payment_methods.zarinpal.title','پرداخت امن زرین پال','default','fa','2026-08-16 16:55:58','2026-08-16 16:55:58'),(41,'sales.payment_methods.zarinpal.description','پرداخت توسط کلیه کارتهای عضو شبکه شتاب با پرداخت امن زرین پال','default','fa','2026-08-16 16:55:58','2026-08-16 16:55:58'),(42,'sales.payment_methods.zarinpal.merchant_id','111','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(43,'sales.payment_methods.zarinpal.sandbox','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(44,'sales.payment_methods.zarinpal.api_base_url','https://payment.zarinpal.com','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(45,'sales.payment_methods.zarinpal.sandbox_base_url','https://sandbox.zarinpal.com','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(46,'sales.payment_methods.zarinpal.request_url','pg/v4/payment/request.json','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(47,'sales.payment_methods.zarinpal.verify_url','pg/v4/payment/verify.json','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(48,'sales.payment_methods.zarinpal.redirect_url','pg/StartPay/','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(49,'sales.payment_methods.zarinpal.callback_url','','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(50,'sales.payment_methods.zarinpal.sort','1','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(51,'sales.payment_methods.razorpay.active','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(52,'sales.payment_methods.payu.active','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(53,'sales.payment_methods.phonepe.active','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(54,'sales.payment_methods.paypal_smart_button.active','0','default',NULL,'2026-08-16 16:55:58','2026-08-16 16:55:58'),(55,'sales.payment_methods.paypal_standard.active','0','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(56,'sales.payment_methods.cashondelivery.active','1','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(57,'sales.payment_methods.cashondelivery.title','Cash On Delivery','default','fa','2026-08-16 16:55:59','2026-08-16 16:55:59'),(58,'sales.payment_methods.cashondelivery.description','Cash On Delivery','default','fa','2026-08-16 16:55:59','2026-08-16 16:55:59'),(59,'sales.payment_methods.cashondelivery.instructions','','default','fa','2026-08-16 16:55:59','2026-08-16 16:55:59'),(60,'sales.payment_methods.cashondelivery.generate_invoice','0','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(61,'sales.payment_methods.cashondelivery.sort','7','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(62,'sales.payment_methods.moneytransfer.active','1','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(63,'sales.payment_methods.moneytransfer.title','Money Transfer','default','fa','2026-08-16 16:55:59','2026-08-16 16:55:59'),(64,'sales.payment_methods.moneytransfer.description','Money Transfer','default','fa','2026-08-16 16:55:59','2026-08-16 16:55:59'),(65,'sales.payment_methods.moneytransfer.generate_invoice','0','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(66,'sales.payment_methods.moneytransfer.mailing_address','','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(67,'sales.payment_methods.moneytransfer.sort','8','default',NULL,'2026-08-16 16:55:59','2026-08-16 16:55:59'),(68,'catalog.rich_snippets.products.enable','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(69,'catalog.rich_snippets.products.show_sku','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(70,'catalog.rich_snippets.products.show_categories','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(71,'catalog.rich_snippets.products.show_images','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(72,'catalog.rich_snippets.categories.enable','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(73,'catalog.rich_snippets.categories.show_search_input_field','1','default',NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(74,'general.design.admin_logo.favicon','configuration/v9ZQSc2lKEaD3KyV6L9VtmQNVjTCemWU3uwYTsAf.png',NULL,NULL,'2026-08-22 16:55:37','2026-08-22 16:55:37');
/*!40000 ALTER TABLE `core_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'AF','Afghanistan'),(2,'AX','Åland Islands'),(3,'AL','Albania'),(4,'DZ','Algeria'),(5,'AS','American Samoa'),(6,'AD','Andorra'),(7,'AO','Angola'),(8,'AI','Anguilla'),(9,'AQ','Antarctica'),(10,'AG','Antigua & Barbuda'),(11,'AR','Argentina'),(12,'AM','Armenia'),(13,'AW','Aruba'),(14,'AC','Ascension Island'),(15,'AU','Australia'),(16,'AT','Austria'),(17,'AZ','Azerbaijan'),(18,'BS','Bahamas'),(19,'BH','Bahrain'),(20,'BD','Bangladesh'),(21,'BB','Barbados'),(22,'BY','Belarus'),(23,'BE','Belgium'),(24,'BZ','Belize'),(25,'BJ','Benin'),(26,'BM','Bermuda'),(27,'BT','Bhutan'),(28,'BO','Bolivia'),(29,'BA','Bosnia & Herzegovina'),(30,'BW','Botswana'),(31,'BR','Brazil'),(32,'IO','British Indian Ocean Territory'),(33,'VG','British Virgin Islands'),(34,'BN','Brunei'),(35,'BG','Bulgaria'),(36,'BF','Burkina Faso'),(37,'BI','Burundi'),(38,'KH','Cambodia'),(39,'CM','Cameroon'),(40,'CA','Canada'),(41,'IC','Canary Islands'),(42,'CV','Cape Verde'),(43,'BQ','Caribbean Netherlands'),(44,'KY','Cayman Islands'),(45,'CF','Central African Republic'),(46,'EA','Ceuta & Melilla'),(47,'TD','Chad'),(48,'CL','Chile'),(49,'CN','China'),(50,'CX','Christmas Island'),(51,'CC','Cocos (Keeling) Islands'),(52,'CO','Colombia'),(53,'KM','Comoros'),(54,'CG','Congo - Brazzaville'),(55,'CD','Congo - Kinshasa'),(56,'CK','Cook Islands'),(57,'CR','Costa Rica'),(58,'CI','Côte d’Ivoire'),(59,'HR','Croatia'),(60,'CU','Cuba'),(61,'CW','Curaçao'),(62,'CY','Cyprus'),(63,'CZ','Czechia'),(64,'DK','Denmark'),(65,'DG','Diego Garcia'),(66,'DJ','Djibouti'),(67,'DM','Dominica'),(68,'DO','Dominican Republic'),(69,'EC','Ecuador'),(70,'EG','Egypt'),(71,'SV','El Salvador'),(72,'GQ','Equatorial Guinea'),(73,'ER','Eritrea'),(74,'EE','Estonia'),(75,'ET','Ethiopia'),(76,'EZ','Eurozone'),(77,'FK','Falkland Islands'),(78,'FO','Faroe Islands'),(79,'FJ','Fiji'),(80,'FI','Finland'),(81,'FR','France'),(82,'GF','French Guiana'),(83,'PF','French Polynesia'),(84,'TF','French Southern Territories'),(85,'GA','Gabon'),(86,'GM','Gambia'),(87,'GE','Georgia'),(88,'DE','Germany'),(89,'GH','Ghana'),(90,'GI','Gibraltar'),(91,'GR','Greece'),(92,'GL','Greenland'),(93,'GD','Grenada'),(94,'GP','Guadeloupe'),(95,'GU','Guam'),(96,'GT','Guatemala'),(97,'GG','Guernsey'),(98,'GN','Guinea'),(99,'GW','Guinea-Bissau'),(100,'GY','Guyana'),(101,'HT','Haiti'),(102,'HN','Honduras'),(103,'HK','Hong Kong SAR China'),(104,'HU','Hungary'),(105,'IS','Iceland'),(106,'IN','India'),(107,'ID','Indonesia'),(108,'IR','Iran'),(109,'IQ','Iraq'),(110,'IE','Ireland'),(111,'IM','Isle of Man'),(112,'IL','Israel'),(113,'IT','Italy'),(114,'JM','Jamaica'),(115,'JP','Japan'),(116,'JE','Jersey'),(117,'JO','Jordan'),(118,'KZ','Kazakhstan'),(119,'KE','Kenya'),(120,'KI','Kiribati'),(121,'XK','Kosovo'),(122,'KW','Kuwait'),(123,'KG','Kyrgyzstan'),(124,'LA','Laos'),(125,'LV','Latvia'),(126,'LB','Lebanon'),(127,'LS','Lesotho'),(128,'LR','Liberia'),(129,'LY','Libya'),(130,'LI','Liechtenstein'),(131,'LT','Lithuania'),(132,'LU','Luxembourg'),(133,'MO','Macau SAR China'),(134,'MK','Macedonia'),(135,'MG','Madagascar'),(136,'MW','Malawi'),(137,'MY','Malaysia'),(138,'MV','Maldives'),(139,'ML','Mali'),(140,'MT','Malta'),(141,'MH','Marshall Islands'),(142,'MQ','Martinique'),(143,'MR','Mauritania'),(144,'MU','Mauritius'),(145,'YT','Mayotte'),(146,'MX','Mexico'),(147,'FM','Micronesia'),(148,'MD','Moldova'),(149,'MC','Monaco'),(150,'MN','Mongolia'),(151,'ME','Montenegro'),(152,'MS','Montserrat'),(153,'MA','Morocco'),(154,'MZ','Mozambique'),(155,'MM','Myanmar (Burma)'),(156,'NA','Namibia'),(157,'NR','Nauru'),(158,'NP','Nepal'),(159,'NL','Netherlands'),(160,'NC','New Caledonia'),(161,'NZ','New Zealand'),(162,'NI','Nicaragua'),(163,'NE','Niger'),(164,'NG','Nigeria'),(165,'NU','Niue'),(166,'NF','Norfolk Island'),(167,'KP','North Korea'),(168,'MP','Northern Mariana Islands'),(169,'NO','Norway'),(170,'OM','Oman'),(171,'PK','Pakistan'),(172,'PW','Palau'),(173,'PS','Palestinian Territories'),(174,'PA','Panama'),(175,'PG','Papua New Guinea'),(176,'PY','Paraguay'),(177,'PE','Peru'),(178,'PH','Philippines'),(179,'PN','Pitcairn Islands'),(180,'PL','Poland'),(181,'PT','Portugal'),(182,'PR','Puerto Rico'),(183,'QA','Qatar'),(184,'RE','Réunion'),(185,'RO','Romania'),(186,'RU','Russia'),(187,'RW','Rwanda'),(188,'WS','Samoa'),(189,'SM','San Marino'),(190,'ST','São Tomé & Príncipe'),(191,'SA','Saudi Arabia'),(192,'SN','Senegal'),(193,'RS','Serbia'),(194,'SC','Seychelles'),(195,'SL','Sierra Leone'),(196,'SG','Singapore'),(197,'SX','Sint Maarten'),(198,'SK','Slovakia'),(199,'SI','Slovenia'),(200,'SB','Solomon Islands'),(201,'SO','Somalia'),(202,'ZA','South Africa'),(203,'GS','South Georgia & South Sandwich Islands'),(204,'KR','South Korea'),(205,'SS','South Sudan'),(206,'ES','Spain'),(207,'LK','Sri Lanka'),(208,'BL','St. Barthélemy'),(209,'SH','St. Helena'),(210,'KN','St. Kitts & Nevis'),(211,'LC','St. Lucia'),(212,'MF','St. Martin'),(213,'PM','St. Pierre & Miquelon'),(214,'VC','St. Vincent & Grenadines'),(215,'SD','Sudan'),(216,'SR','Suriname'),(217,'SJ','Svalbard & Jan Mayen'),(218,'SZ','Swaziland'),(219,'SE','Sweden'),(220,'CH','Switzerland'),(221,'SY','Syria'),(222,'TW','Taiwan'),(223,'TJ','Tajikistan'),(224,'TZ','Tanzania'),(225,'TH','Thailand'),(226,'TL','Timor-Leste'),(227,'TG','Togo'),(228,'TK','Tokelau'),(229,'TO','Tonga'),(230,'TT','Trinidad & Tobago'),(231,'TA','Tristan da Cunha'),(232,'TN','Tunisia'),(233,'TR','Turkey'),(234,'TM','Turkmenistan'),(235,'TC','Turks & Caicos Islands'),(236,'TV','Tuvalu'),(237,'UM','U.S. Outlying Islands'),(238,'VI','U.S. Virgin Islands'),(239,'UG','Uganda'),(240,'UA','Ukraine'),(241,'AE','United Arab Emirates'),(242,'GB','United Kingdom'),(244,'US','United States'),(245,'UY','Uruguay'),(246,'UZ','Uzbekistan'),(247,'VU','Vanuatu'),(248,'VA','Vatican City'),(249,'VE','Venezuela'),(250,'VN','Vietnam'),(251,'WF','Wallis & Futuna'),(252,'EH','Western Sahara'),(253,'YE','Yemen'),(254,'ZM','Zambia'),(255,'ZW','Zimbabwe');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_state_translations`
--

DROP TABLE IF EXISTS `country_state_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_state_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `country_state_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `default_name` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `country_state_translations_country_state_id_foreign` (`country_state_id`),
  CONSTRAINT `country_state_translations_country_state_id_foreign` FOREIGN KEY (`country_state_id`) REFERENCES `country_states` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_state_translations`
--

LOCK TABLES `country_state_translations` WRITE;
/*!40000 ALTER TABLE `country_state_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `country_state_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_states`
--

DROP TABLE IF EXISTS `country_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_states` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `country_id` int unsigned DEFAULT NULL,
  `country_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_states_country_id_foreign` (`country_id`),
  CONSTRAINT `country_states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=587 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_states`
--

LOCK TABLES `country_states` WRITE;
/*!40000 ALTER TABLE `country_states` DISABLE KEYS */;
INSERT INTO `country_states` VALUES (1,244,'US','AL','Alabama'),(2,244,'US','AK','Alaska'),(3,244,'US','AS','American Samoa'),(4,244,'US','AZ','Arizona'),(5,244,'US','AR','Arkansas'),(6,244,'US','AE','Armed Forces Africa'),(7,244,'US','AA','Armed Forces Americas'),(8,244,'US','AE','Armed Forces Canada'),(9,244,'US','AE','Armed Forces Europe'),(10,244,'US','AE','Armed Forces Middle East'),(11,244,'US','AP','Armed Forces Pacific'),(12,244,'US','CA','California'),(13,244,'US','CO','Colorado'),(14,244,'US','CT','Connecticut'),(15,244,'US','DE','Delaware'),(16,244,'US','DC','District of Columbia'),(17,244,'US','FM','Federated States Of Micronesia'),(18,244,'US','FL','Florida'),(19,244,'US','GA','Georgia'),(20,244,'US','GU','Guam'),(21,244,'US','HI','Hawaii'),(22,244,'US','ID','Idaho'),(23,244,'US','IL','Illinois'),(24,244,'US','IN','Indiana'),(25,244,'US','IA','Iowa'),(26,244,'US','KS','Kansas'),(27,244,'US','KY','Kentucky'),(28,244,'US','LA','Louisiana'),(29,244,'US','ME','Maine'),(30,244,'US','MH','Marshall Islands'),(31,244,'US','MD','Maryland'),(32,244,'US','MA','Massachusetts'),(33,244,'US','MI','Michigan'),(34,244,'US','MN','Minnesota'),(35,244,'US','MS','Mississippi'),(36,244,'US','MO','Missouri'),(37,244,'US','MT','Montana'),(38,244,'US','NE','Nebraska'),(39,244,'US','NV','Nevada'),(40,244,'US','NH','New Hampshire'),(41,244,'US','NJ','New Jersey'),(42,244,'US','NM','New Mexico'),(43,244,'US','NY','New York'),(44,244,'US','NC','North Carolina'),(45,244,'US','ND','North Dakota'),(46,244,'US','MP','Northern Mariana Islands'),(47,244,'US','OH','Ohio'),(48,244,'US','OK','Oklahoma'),(49,244,'US','OR','Oregon'),(50,244,'US','PW','Palau'),(51,244,'US','PA','Pennsylvania'),(52,244,'US','PR','Puerto Rico'),(53,244,'US','RI','Rhode Island'),(54,244,'US','SC','South Carolina'),(55,244,'US','SD','South Dakota'),(56,244,'US','TN','Tennessee'),(57,244,'US','TX','Texas'),(58,244,'US','UT','Utah'),(59,244,'US','VT','Vermont'),(60,244,'US','VI','Virgin Islands'),(61,244,'US','VA','Virginia'),(62,244,'US','WA','Washington'),(63,244,'US','WV','West Virginia'),(64,244,'US','WI','Wisconsin'),(65,244,'US','WY','Wyoming'),(66,40,'CA','AB','Alberta'),(67,40,'CA','BC','British Columbia'),(68,40,'CA','MB','Manitoba'),(69,40,'CA','NL','Newfoundland and Labrador'),(70,40,'CA','NB','New Brunswick'),(71,40,'CA','NS','Nova Scotia'),(72,40,'CA','NT','Northwest Territories'),(73,40,'CA','NU','Nunavut'),(74,40,'CA','ON','Ontario'),(75,40,'CA','PE','Prince Edward Island'),(76,40,'CA','QC','Quebec'),(77,40,'CA','SK','Saskatchewan'),(78,40,'CA','YT','Yukon Territory'),(79,88,'DE','NDS','Niedersachsen'),(80,88,'DE','BAW','Baden-Württemberg'),(81,88,'DE','BAY','Bayern'),(82,88,'DE','BER','Berlin'),(83,88,'DE','BRG','Brandenburg'),(84,88,'DE','BRE','Bremen'),(85,88,'DE','HAM','Hamburg'),(86,88,'DE','HES','Hessen'),(87,88,'DE','MEC','Mecklenburg-Vorpommern'),(88,88,'DE','NRW','Nordrhein-Westfalen'),(89,88,'DE','RHE','Rheinland-Pfalz'),(90,88,'DE','SAR','Saarland'),(91,88,'DE','SAS','Sachsen'),(92,88,'DE','SAC','Sachsen-Anhalt'),(93,88,'DE','SCN','Schleswig-Holstein'),(94,88,'DE','THE','Thüringen'),(95,16,'AT','WI','Wien'),(96,16,'AT','NO','Niederösterreich'),(97,16,'AT','OO','Oberösterreich'),(98,16,'AT','SB','Salzburg'),(99,16,'AT','KN','Kärnten'),(100,16,'AT','ST','Steiermark'),(101,16,'AT','TI','Tirol'),(102,16,'AT','BL','Burgenland'),(103,16,'AT','VB','Vorarlberg'),(104,220,'CH','AG','Aargau'),(105,220,'CH','AI','Appenzell Innerrhoden'),(106,220,'CH','AR','Appenzell Ausserrhoden'),(107,220,'CH','BE','Bern'),(108,220,'CH','BL','Basel-Landschaft'),(109,220,'CH','BS','Basel-Stadt'),(110,220,'CH','FR','Freiburg'),(111,220,'CH','GE','Genf'),(112,220,'CH','GL','Glarus'),(113,220,'CH','GR','Graubünden'),(114,220,'CH','JU','Jura'),(115,220,'CH','LU','Luzern'),(116,220,'CH','NE','Neuenburg'),(117,220,'CH','NW','Nidwalden'),(118,220,'CH','OW','Obwalden'),(119,220,'CH','SG','St. Gallen'),(120,220,'CH','SH','Schaffhausen'),(121,220,'CH','SO','Solothurn'),(122,220,'CH','SZ','Schwyz'),(123,220,'CH','TG','Thurgau'),(124,220,'CH','TI','Tessin'),(125,220,'CH','UR','Uri'),(126,220,'CH','VD','Waadt'),(127,220,'CH','VS','Wallis'),(128,220,'CH','ZG','Zug'),(129,220,'CH','ZH','Zürich'),(130,206,'ES','A Coruсa','A Coruña'),(131,206,'ES','Alava','Alava'),(132,206,'ES','Albacete','Albacete'),(133,206,'ES','Alicante','Alicante'),(134,206,'ES','Almeria','Almeria'),(135,206,'ES','Asturias','Asturias'),(136,206,'ES','Avila','Avila'),(137,206,'ES','Badajoz','Badajoz'),(138,206,'ES','Baleares','Baleares'),(139,206,'ES','Barcelona','Barcelona'),(140,206,'ES','Burgos','Burgos'),(141,206,'ES','Caceres','Caceres'),(142,206,'ES','Cadiz','Cadiz'),(143,206,'ES','Cantabria','Cantabria'),(144,206,'ES','Castellon','Castellon'),(145,206,'ES','Ceuta','Ceuta'),(146,206,'ES','Ciudad Real','Ciudad Real'),(147,206,'ES','Cordoba','Cordoba'),(148,206,'ES','Cuenca','Cuenca'),(149,206,'ES','Girona','Girona'),(150,206,'ES','Granada','Granada'),(151,206,'ES','Guadalajara','Guadalajara'),(152,206,'ES','Guipuzcoa','Guipuzcoa'),(153,206,'ES','Huelva','Huelva'),(154,206,'ES','Huesca','Huesca'),(155,206,'ES','Jaen','Jaen'),(156,206,'ES','La Rioja','La Rioja'),(157,206,'ES','Las Palmas','Las Palmas'),(158,206,'ES','Leon','Leon'),(159,206,'ES','Lleida','Lleida'),(160,206,'ES','Lugo','Lugo'),(161,206,'ES','Madrid','Madrid'),(162,206,'ES','Malaga','Malaga'),(163,206,'ES','Melilla','Melilla'),(164,206,'ES','Murcia','Murcia'),(165,206,'ES','Navarra','Navarra'),(166,206,'ES','Ourense','Ourense'),(167,206,'ES','Palencia','Palencia'),(168,206,'ES','Pontevedra','Pontevedra'),(169,206,'ES','Salamanca','Salamanca'),(170,206,'ES','Santa Cruz de Tenerife','Santa Cruz de Tenerife'),(171,206,'ES','Segovia','Segovia'),(172,206,'ES','Sevilla','Sevilla'),(173,206,'ES','Soria','Soria'),(174,206,'ES','Tarragona','Tarragona'),(175,206,'ES','Teruel','Teruel'),(176,206,'ES','Toledo','Toledo'),(177,206,'ES','Valencia','Valencia'),(178,206,'ES','Valladolid','Valladolid'),(179,206,'ES','Vizcaya','Vizcaya'),(180,206,'ES','Zamora','Zamora'),(181,206,'ES','Zaragoza','Zaragoza'),(182,81,'FR','1','Ain'),(183,81,'FR','2','Aisne'),(184,81,'FR','3','Allier'),(185,81,'FR','4','Alpes-de-Haute-Provence'),(186,81,'FR','5','Hautes-Alpes'),(187,81,'FR','6','Alpes-Maritimes'),(188,81,'FR','7','Ardèche'),(189,81,'FR','8','Ardennes'),(190,81,'FR','9','Ariège'),(191,81,'FR','10','Aube'),(192,81,'FR','11','Aude'),(193,81,'FR','12','Aveyron'),(194,81,'FR','13','Bouches-du-Rhône'),(195,81,'FR','14','Calvados'),(196,81,'FR','15','Cantal'),(197,81,'FR','16','Charente'),(198,81,'FR','17','Charente-Maritime'),(199,81,'FR','18','Cher'),(200,81,'FR','19','Corrèze'),(201,81,'FR','2A','Corse-du-Sud'),(202,81,'FR','2B','Haute-Corse'),(203,81,'FR','21','Côte-d\'Or'),(204,81,'FR','22','Côtes-d\'Armor'),(205,81,'FR','23','Creuse'),(206,81,'FR','24','Dordogne'),(207,81,'FR','25','Doubs'),(208,81,'FR','26','Drôme'),(209,81,'FR','27','Eure'),(210,81,'FR','28','Eure-et-Loir'),(211,81,'FR','29','Finistère'),(212,81,'FR','30','Gard'),(213,81,'FR','31','Haute-Garonne'),(214,81,'FR','32','Gers'),(215,81,'FR','33','Gironde'),(216,81,'FR','34','Hérault'),(217,81,'FR','35','Ille-et-Vilaine'),(218,81,'FR','36','Indre'),(219,81,'FR','37','Indre-et-Loire'),(220,81,'FR','38','Isère'),(221,81,'FR','39','Jura'),(222,81,'FR','40','Landes'),(223,81,'FR','41','Loir-et-Cher'),(224,81,'FR','42','Loire'),(225,81,'FR','43','Haute-Loire'),(226,81,'FR','44','Loire-Atlantique'),(227,81,'FR','45','Loiret'),(228,81,'FR','46','Lot'),(229,81,'FR','47','Lot-et-Garonne'),(230,81,'FR','48','Lozère'),(231,81,'FR','49','Maine-et-Loire'),(232,81,'FR','50','Manche'),(233,81,'FR','51','Marne'),(234,81,'FR','52','Haute-Marne'),(235,81,'FR','53','Mayenne'),(236,81,'FR','54','Meurthe-et-Moselle'),(237,81,'FR','55','Meuse'),(238,81,'FR','56','Morbihan'),(239,81,'FR','57','Moselle'),(240,81,'FR','58','Nièvre'),(241,81,'FR','59','Nord'),(242,81,'FR','60','Oise'),(243,81,'FR','61','Orne'),(244,81,'FR','62','Pas-de-Calais'),(245,81,'FR','63','Puy-de-Dôme'),(246,81,'FR','64','Pyrénées-Atlantiques'),(247,81,'FR','65','Hautes-Pyrénées'),(248,81,'FR','66','Pyrénées-Orientales'),(249,81,'FR','67','Bas-Rhin'),(250,81,'FR','68','Haut-Rhin'),(251,81,'FR','69','Rhône'),(252,81,'FR','70','Haute-Saône'),(253,81,'FR','71','Saône-et-Loire'),(254,81,'FR','72','Sarthe'),(255,81,'FR','73','Savoie'),(256,81,'FR','74','Haute-Savoie'),(257,81,'FR','75','Paris'),(258,81,'FR','76','Seine-Maritime'),(259,81,'FR','77','Seine-et-Marne'),(260,81,'FR','78','Yvelines'),(261,81,'FR','79','Deux-Sèvres'),(262,81,'FR','80','Somme'),(263,81,'FR','81','Tarn'),(264,81,'FR','82','Tarn-et-Garonne'),(265,81,'FR','83','Var'),(266,81,'FR','84','Vaucluse'),(267,81,'FR','85','Vendée'),(268,81,'FR','86','Vienne'),(269,81,'FR','87','Haute-Vienne'),(270,81,'FR','88','Vosges'),(271,81,'FR','89','Yonne'),(272,81,'FR','90','Territoire-de-Belfort'),(273,81,'FR','91','Essonne'),(274,81,'FR','92','Hauts-de-Seine'),(275,81,'FR','93','Seine-Saint-Denis'),(276,81,'FR','94','Val-de-Marne'),(277,81,'FR','95','Val-d\'Oise'),(278,185,'RO','AB','Alba'),(279,185,'RO','AR','Arad'),(280,185,'RO','AG','Argeş'),(281,185,'RO','BC','Bacău'),(282,185,'RO','BH','Bihor'),(283,185,'RO','BN','Bistriţa-Năsăud'),(284,185,'RO','BT','Botoşani'),(285,185,'RO','BV','Braşov'),(286,185,'RO','BR','Brăila'),(287,185,'RO','B','Bucureşti'),(288,185,'RO','BZ','Buzău'),(289,185,'RO','CS','Caraş-Severin'),(290,185,'RO','CL','Călăraşi'),(291,185,'RO','CJ','Cluj'),(292,185,'RO','CT','Constanţa'),(293,185,'RO','CV','Covasna'),(294,185,'RO','DB','Dâmboviţa'),(295,185,'RO','DJ','Dolj'),(296,185,'RO','GL','Galaţi'),(297,185,'RO','GR','Giurgiu'),(298,185,'RO','GJ','Gorj'),(299,185,'RO','HR','Harghita'),(300,185,'RO','HD','Hunedoara'),(301,185,'RO','IL','Ialomiţa'),(302,185,'RO','IS','Iaşi'),(303,185,'RO','IF','Ilfov'),(304,185,'RO','MM','Maramureş'),(305,185,'RO','MH','Mehedinţi'),(306,185,'RO','MS','Mureş'),(307,185,'RO','NT','Neamţ'),(308,185,'RO','OT','Olt'),(309,185,'RO','PH','Prahova'),(310,185,'RO','SM','Satu-Mare'),(311,185,'RO','SJ','Sălaj'),(312,185,'RO','SB','Sibiu'),(313,185,'RO','SV','Suceava'),(314,185,'RO','TR','Teleorman'),(315,185,'RO','TM','Timiş'),(316,185,'RO','TL','Tulcea'),(317,185,'RO','VS','Vaslui'),(318,185,'RO','VL','Vâlcea'),(319,185,'RO','VN','Vrancea'),(320,80,'FI','Lappi','Lappi'),(321,80,'FI','Pohjois-Pohjanmaa','Pohjois-Pohjanmaa'),(322,80,'FI','Kainuu','Kainuu'),(323,80,'FI','Pohjois-Karjala','Pohjois-Karjala'),(324,80,'FI','Pohjois-Savo','Pohjois-Savo'),(325,80,'FI','Etelä-Savo','Etelä-Savo'),(326,80,'FI','Etelä-Pohjanmaa','Etelä-Pohjanmaa'),(327,80,'FI','Pohjanmaa','Pohjanmaa'),(328,80,'FI','Pirkanmaa','Pirkanmaa'),(329,80,'FI','Satakunta','Satakunta'),(330,80,'FI','Keski-Pohjanmaa','Keski-Pohjanmaa'),(331,80,'FI','Keski-Suomi','Keski-Suomi'),(332,80,'FI','Varsinais-Suomi','Varsinais-Suomi'),(333,80,'FI','Etelä-Karjala','Etelä-Karjala'),(334,80,'FI','Päijät-Häme','Päijät-Häme'),(335,80,'FI','Kanta-Häme','Kanta-Häme'),(336,80,'FI','Uusimaa','Uusimaa'),(337,80,'FI','Itä-Uusimaa','Itä-Uusimaa'),(338,80,'FI','Kymenlaakso','Kymenlaakso'),(339,80,'FI','Ahvenanmaa','Ahvenanmaa'),(340,74,'EE','EE-37','Harjumaa'),(341,74,'EE','EE-39','Hiiumaa'),(342,74,'EE','EE-44','Ida-Virumaa'),(343,74,'EE','EE-49','Jõgevamaa'),(344,74,'EE','EE-51','Järvamaa'),(345,74,'EE','EE-57','Läänemaa'),(346,74,'EE','EE-59','Lääne-Virumaa'),(347,74,'EE','EE-65','Põlvamaa'),(348,74,'EE','EE-67','Pärnumaa'),(349,74,'EE','EE-70','Raplamaa'),(350,74,'EE','EE-74','Saaremaa'),(351,74,'EE','EE-78','Tartumaa'),(352,74,'EE','EE-82','Valgamaa'),(353,74,'EE','EE-84','Viljandimaa'),(354,74,'EE','EE-86','Võrumaa'),(355,125,'LV','LV-DGV','Daugavpils'),(356,125,'LV','LV-JEL','Jelgava'),(357,125,'LV','Jēkabpils','Jēkabpils'),(358,125,'LV','LV-JUR','Jūrmala'),(359,125,'LV','LV-LPX','Liepāja'),(360,125,'LV','LV-LE','Liepājas novads'),(361,125,'LV','LV-REZ','Rēzekne'),(362,125,'LV','LV-RIX','Rīga'),(363,125,'LV','LV-RI','Rīgas novads'),(364,125,'LV','Valmiera','Valmiera'),(365,125,'LV','LV-VEN','Ventspils'),(366,125,'LV','Aglonas novads','Aglonas novads'),(367,125,'LV','LV-AI','Aizkraukles novads'),(368,125,'LV','Aizputes novads','Aizputes novads'),(369,125,'LV','Aknīstes novads','Aknīstes novads'),(370,125,'LV','Alojas novads','Alojas novads'),(371,125,'LV','Alsungas novads','Alsungas novads'),(372,125,'LV','LV-AL','Alūksnes novads'),(373,125,'LV','Amatas novads','Amatas novads'),(374,125,'LV','Apes novads','Apes novads'),(375,125,'LV','Auces novads','Auces novads'),(376,125,'LV','Babītes novads','Babītes novads'),(377,125,'LV','Baldones novads','Baldones novads'),(378,125,'LV','Baltinavas novads','Baltinavas novads'),(379,125,'LV','LV-BL','Balvu novads'),(380,125,'LV','LV-BU','Bauskas novads'),(381,125,'LV','Beverīnas novads','Beverīnas novads'),(382,125,'LV','Brocēnu novads','Brocēnu novads'),(383,125,'LV','Burtnieku novads','Burtnieku novads'),(384,125,'LV','Carnikavas novads','Carnikavas novads'),(385,125,'LV','Cesvaines novads','Cesvaines novads'),(386,125,'LV','Ciblas novads','Ciblas novads'),(387,125,'LV','LV-CE','Cēsu novads'),(388,125,'LV','Dagdas novads','Dagdas novads'),(389,125,'LV','LV-DA','Daugavpils novads'),(390,125,'LV','LV-DO','Dobeles novads'),(391,125,'LV','Dundagas novads','Dundagas novads'),(392,125,'LV','Durbes novads','Durbes novads'),(393,125,'LV','Engures novads','Engures novads'),(394,125,'LV','Garkalnes novads','Garkalnes novads'),(395,125,'LV','Grobiņas novads','Grobiņas novads'),(396,125,'LV','LV-GU','Gulbenes novads'),(397,125,'LV','Iecavas novads','Iecavas novads'),(398,125,'LV','Ikšķiles novads','Ikšķiles novads'),(399,125,'LV','Ilūkstes novads','Ilūkstes novads'),(400,125,'LV','Inčukalna novads','Inčukalna novads'),(401,125,'LV','Jaunjelgavas novads','Jaunjelgavas novads'),(402,125,'LV','Jaunpiebalgas novads','Jaunpiebalgas novads'),(403,125,'LV','Jaunpils novads','Jaunpils novads'),(404,125,'LV','LV-JL','Jelgavas novads'),(405,125,'LV','LV-JK','Jēkabpils novads'),(406,125,'LV','Kandavas novads','Kandavas novads'),(407,125,'LV','Kokneses novads','Kokneses novads'),(408,125,'LV','Krimuldas novads','Krimuldas novads'),(409,125,'LV','Krustpils novads','Krustpils novads'),(410,125,'LV','LV-KR','Krāslavas novads'),(411,125,'LV','LV-KU','Kuldīgas novads'),(412,125,'LV','Kārsavas novads','Kārsavas novads'),(413,125,'LV','Lielvārdes novads','Lielvārdes novads'),(414,125,'LV','LV-LM','Limbažu novads'),(415,125,'LV','Lubānas novads','Lubānas novads'),(416,125,'LV','LV-LU','Ludzas novads'),(417,125,'LV','Līgatnes novads','Līgatnes novads'),(418,125,'LV','Līvānu novads','Līvānu novads'),(419,125,'LV','LV-MA','Madonas novads'),(420,125,'LV','Mazsalacas novads','Mazsalacas novads'),(421,125,'LV','Mālpils novads','Mālpils novads'),(422,125,'LV','Mārupes novads','Mārupes novads'),(423,125,'LV','Naukšēnu novads','Naukšēnu novads'),(424,125,'LV','Neretas novads','Neretas novads'),(425,125,'LV','Nīcas novads','Nīcas novads'),(426,125,'LV','LV-OG','Ogres novads'),(427,125,'LV','Olaines novads','Olaines novads'),(428,125,'LV','Ozolnieku novads','Ozolnieku novads'),(429,125,'LV','LV-PR','Preiļu novads'),(430,125,'LV','Priekules novads','Priekules novads'),(431,125,'LV','Priekuļu novads','Priekuļu novads'),(432,125,'LV','Pārgaujas novads','Pārgaujas novads'),(433,125,'LV','Pāvilostas novads','Pāvilostas novads'),(434,125,'LV','Pļaviņu novads','Pļaviņu novads'),(435,125,'LV','Raunas novads','Raunas novads'),(436,125,'LV','Riebiņu novads','Riebiņu novads'),(437,125,'LV','Rojas novads','Rojas novads'),(438,125,'LV','Ropažu novads','Ropažu novads'),(439,125,'LV','Rucavas novads','Rucavas novads'),(440,125,'LV','Rugāju novads','Rugāju novads'),(441,125,'LV','Rundāles novads','Rundāles novads'),(442,125,'LV','LV-RE','Rēzeknes novads'),(443,125,'LV','Rūjienas novads','Rūjienas novads'),(444,125,'LV','Salacgrīvas novads','Salacgrīvas novads'),(445,125,'LV','Salas novads','Salas novads'),(446,125,'LV','Salaspils novads','Salaspils novads'),(447,125,'LV','LV-SA','Saldus novads'),(448,125,'LV','Saulkrastu novads','Saulkrastu novads'),(449,125,'LV','Siguldas novads','Siguldas novads'),(450,125,'LV','Skrundas novads','Skrundas novads'),(451,125,'LV','Skrīveru novads','Skrīveru novads'),(452,125,'LV','Smiltenes novads','Smiltenes novads'),(453,125,'LV','Stopiņu novads','Stopiņu novads'),(454,125,'LV','Strenču novads','Strenču novads'),(455,125,'LV','Sējas novads','Sējas novads'),(456,125,'LV','LV-TA','Talsu novads'),(457,125,'LV','LV-TU','Tukuma novads'),(458,125,'LV','Tērvetes novads','Tērvetes novads'),(459,125,'LV','Vaiņodes novads','Vaiņodes novads'),(460,125,'LV','LV-VK','Valkas novads'),(461,125,'LV','LV-VM','Valmieras novads'),(462,125,'LV','Varakļānu novads','Varakļānu novads'),(463,125,'LV','Vecpiebalgas novads','Vecpiebalgas novads'),(464,125,'LV','Vecumnieku novads','Vecumnieku novads'),(465,125,'LV','LV-VE','Ventspils novads'),(466,125,'LV','Viesītes novads','Viesītes novads'),(467,125,'LV','Viļakas novads','Viļakas novads'),(468,125,'LV','Viļānu novads','Viļānu novads'),(469,125,'LV','Vārkavas novads','Vārkavas novads'),(470,125,'LV','Zilupes novads','Zilupes novads'),(471,125,'LV','Ādažu novads','Ādažu novads'),(472,125,'LV','Ērgļu novads','Ērgļu novads'),(473,125,'LV','Ķeguma novads','Ķeguma novads'),(474,125,'LV','Ķekavas novads','Ķekavas novads'),(475,131,'LT','LT-AL','Alytaus Apskritis'),(476,131,'LT','LT-KU','Kauno Apskritis'),(477,131,'LT','LT-KL','Klaipėdos Apskritis'),(478,131,'LT','LT-MR','Marijampolės Apskritis'),(479,131,'LT','LT-PN','Panevėžio Apskritis'),(480,131,'LT','LT-SA','Šiaulių Apskritis'),(481,131,'LT','LT-TA','Tauragės Apskritis'),(482,131,'LT','LT-TE','Telšių Apskritis'),(483,131,'LT','LT-UT','Utenos Apskritis'),(484,131,'LT','LT-VL','Vilniaus Apskritis'),(485,31,'BR','AC','Acre'),(486,31,'BR','AL','Alagoas'),(487,31,'BR','AP','Amapá'),(488,31,'BR','AM','Amazonas'),(489,31,'BR','BA','Bahia'),(490,31,'BR','CE','Ceará'),(491,31,'BR','ES','Espírito Santo'),(492,31,'BR','GO','Goiás'),(493,31,'BR','MA','Maranhão'),(494,31,'BR','MT','Mato Grosso'),(495,31,'BR','MS','Mato Grosso do Sul'),(496,31,'BR','MG','Minas Gerais'),(497,31,'BR','PA','Pará'),(498,31,'BR','PB','Paraíba'),(499,31,'BR','PR','Paraná'),(500,31,'BR','PE','Pernambuco'),(501,31,'BR','PI','Piauí'),(502,31,'BR','RJ','Rio de Janeiro'),(503,31,'BR','RN','Rio Grande do Norte'),(504,31,'BR','RS','Rio Grande do Sul'),(505,31,'BR','RO','Rondônia'),(506,31,'BR','RR','Roraima'),(507,31,'BR','SC','Santa Catarina'),(508,31,'BR','SP','São Paulo'),(509,31,'BR','SE','Sergipe'),(510,31,'BR','TO','Tocantins'),(511,31,'BR','DF','Distrito Federal'),(512,59,'HR','HR-01','Zagrebačka županija'),(513,59,'HR','HR-02','Krapinsko-zagorska županija'),(514,59,'HR','HR-03','Sisačko-moslavačka županija'),(515,59,'HR','HR-04','Karlovačka županija'),(516,59,'HR','HR-05','Varaždinska županija'),(517,59,'HR','HR-06','Koprivničko-križevačka županija'),(518,59,'HR','HR-07','Bjelovarsko-bilogorska županija'),(519,59,'HR','HR-08','Primorsko-goranska županija'),(520,59,'HR','HR-09','Ličko-senjska županija'),(521,59,'HR','HR-10','Virovitičko-podravska županija'),(522,59,'HR','HR-11','Požeško-slavonska županija'),(523,59,'HR','HR-12','Brodsko-posavska županija'),(524,59,'HR','HR-13','Zadarska županija'),(525,59,'HR','HR-14','Osječko-baranjska županija'),(526,59,'HR','HR-15','Šibensko-kninska županija'),(527,59,'HR','HR-16','Vukovarsko-srijemska županija'),(528,59,'HR','HR-17','Splitsko-dalmatinska županija'),(529,59,'HR','HR-18','Istarska županija'),(530,59,'HR','HR-19','Dubrovačko-neretvanska županija'),(531,59,'HR','HR-20','Međimurska županija'),(532,59,'HR','HR-21','Grad Zagreb'),(533,106,'IN','AN','Andaman and Nicobar Islands'),(534,106,'IN','AP','Andhra Pradesh'),(535,106,'IN','AR','Arunachal Pradesh'),(536,106,'IN','AS','Assam'),(537,106,'IN','BR','Bihar'),(538,106,'IN','CH','Chandigarh'),(539,106,'IN','CT','Chhattisgarh'),(540,106,'IN','DN','Dadra and Nagar Haveli'),(541,106,'IN','DD','Daman and Diu'),(542,106,'IN','DL','Delhi'),(543,106,'IN','GA','Goa'),(544,106,'IN','GJ','Gujarat'),(545,106,'IN','HR','Haryana'),(546,106,'IN','HP','Himachal Pradesh'),(547,106,'IN','JK','Jammu and Kashmir'),(548,106,'IN','JH','Jharkhand'),(549,106,'IN','KA','Karnataka'),(550,106,'IN','KL','Kerala'),(551,106,'IN','LD','Lakshadweep'),(552,106,'IN','MP','Madhya Pradesh'),(553,106,'IN','MH','Maharashtra'),(554,106,'IN','MN','Manipur'),(555,106,'IN','ML','Meghalaya'),(556,106,'IN','MZ','Mizoram'),(557,106,'IN','NL','Nagaland'),(558,106,'IN','OR','Odisha'),(559,106,'IN','PY','Puducherry'),(560,106,'IN','PB','Punjab'),(561,106,'IN','RJ','Rajasthan'),(562,106,'IN','SK','Sikkim'),(563,106,'IN','TN','Tamil Nadu'),(564,106,'IN','TG','Telangana'),(565,106,'IN','TR','Tripura'),(566,106,'IN','UP','Uttar Pradesh'),(567,106,'IN','UT','Uttarakhand'),(568,106,'IN','WB','West Bengal'),(569,176,'PY','PY-16','Alto Paraguay'),(570,176,'PY','PY-10','Alto Paraná'),(571,176,'PY','PY-13','Amambay'),(572,176,'PY','PY-ASU','Asunción'),(573,176,'PY','PY-19','Boquerón'),(574,176,'PY','PY-5','Caaguazú'),(575,176,'PY','PY-6','Caazapá'),(576,176,'PY','PY-14','Canindeyú'),(577,176,'PY','PY-11','Central'),(578,176,'PY','PY-1','Concepción'),(579,176,'PY','PY-3','Cordillera'),(580,176,'PY','PY-4','Guairá'),(581,176,'PY','PY-7','Itapúa'),(582,176,'PY','PY-8','Misiones'),(583,176,'PY','PY-9','Paraguarí'),(584,176,'PY','PY-15','Presidente Hayes'),(585,176,'PY','PY-2','San Pedro'),(586,176,'PY','PY-12','Ñeembucú');
/*!40000 ALTER TABLE `country_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_translations`
--

DROP TABLE IF EXISTS `country_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `country_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `country_translations_country_id_foreign` (`country_id`),
  CONSTRAINT `country_translations_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_translations`
--

LOCK TABLES `country_translations` WRITE;
/*!40000 ALTER TABLE `country_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `country_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currencies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decimal` int unsigned NOT NULL DEFAULT '2',
  `group_separator` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ',',
  `decimal_separator` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '.',
  `currency_position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
INSERT INTO `currencies` VALUES (1,'IRR','installer::app.seeders.core.currencies.IRR','ریال',0,',','.','right_with_space',NULL,NULL),(2,'TMN','installer::app.seeders.core.currencies.TMN','تومان',0,',','.','right_with_space','2026-08-16 16:54:59','2026-08-16 16:54:59');
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency_exchange_rates`
--

DROP TABLE IF EXISTS `currency_exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency_exchange_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rate` decimal(24,12) NOT NULL,
  `target_currency` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_exchange_rates_target_currency_unique` (`target_currency`),
  CONSTRAINT `currency_exchange_rates_target_currency_foreign` FOREIGN KEY (`target_currency`) REFERENCES `currencies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency_exchange_rates`
--

LOCK TABLES `currency_exchange_rates` WRITE;
/*!40000 ALTER TABLE `currency_exchange_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `currency_exchange_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_groups`
--

DROP TABLE IF EXISTS `customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_groups` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_groups_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_groups`
--

LOCK TABLES `customer_groups` WRITE;
/*!40000 ALTER TABLE `customer_groups` DISABLE KEYS */;
INSERT INTO `customer_groups` VALUES (1,'guest','Guest',0,NULL,NULL),(2,'general','General',0,NULL,NULL),(3,'wholesale','Wholesale',0,NULL,NULL);
/*!40000 ALTER TABLE `customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_notes`
--

DROP TABLE IF EXISTS `customer_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int unsigned DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_notified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_notes_customer_id_foreign` (`customer_id`),
  CONSTRAINT `customer_notes_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_notes`
--

LOCK TABLES `customer_notes` WRITE;
/*!40000 ALTER TABLE `customer_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_password_resets`
--

DROP TABLE IF EXISTS `customer_password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `customer_password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_password_resets`
--

LOCK TABLES `customer_password_resets` WRITE;
/*!40000 ALTER TABLE `customer_password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_social_accounts`
--

DROP TABLE IF EXISTS `customer_social_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_social_accounts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int unsigned NOT NULL,
  `provider_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_social_accounts_provider_id_unique` (`provider_id`),
  KEY `customer_social_accounts_customer_id_foreign` (`customer_id`),
  CONSTRAINT `customer_social_accounts_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_social_accounts`
--

LOCK TABLES `customer_social_accounts` WRITE;
/*!40000 ALTER TABLE `customer_social_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_social_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_group_id` int unsigned DEFAULT NULL,
  `channel_id` int unsigned DEFAULT NULL,
  `subscribed_to_news_letter` tinyint(1) NOT NULL DEFAULT '0',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `is_suspended` tinyint unsigned NOT NULL DEFAULT '0',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_phone_unique` (`phone`),
  UNIQUE KEY `customers_api_token_unique` (`api_token`),
  UNIQUE KEY `customers_email_channel_unique` (`email`,`channel_id`),
  KEY `customers_customer_group_id_foreign` (`customer_group_id`),
  KEY `customers_channel_id_foreign` (`channel_id`),
  CONSTRAINT `customers_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `customers_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (8,'Ehsan','Hoseinzadeh',NULL,NULL,'ehvbpc@gmail.com',NULL,NULL,1,'$2y$12$r3zjm1IvC0v1k6H4MpSIG.xmplCwUQKFvERZSh0tFlBBHGj/k3EDq','6b7cpM2iQ7p82zE7p3n0AqBcCEp3p15z5OUXzdEDhrsqoaVD9CYNL1RqDhqG6Jqa6EXorskHlcIZwCsA',2,1,0,1,0,'4f26feb385a39cc58c832868185c697a',NULL,'2026-08-18 21:24:48','2026-08-18 21:24:48'),(10,'کاربر','6492',NULL,NULL,NULL,'09125126492',NULL,1,'$2y$12$Otu1X20pWGnK8NJMJnsyEONchlrTstL4PzIWFfqqOV.1.NmUKSDrC',NULL,2,1,1,1,0,NULL,'PPRAqpi0GKogKzf6rAVfsUS6UTvDrsra9diiCBOlOQoMZi9zsL7b6BUrgqxV','2026-08-18 22:13:28','2026-08-29 13:58:11');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datagrid_saved_filters`
--

DROP TABLE IF EXISTS `datagrid_saved_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datagrid_saved_filters` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `src` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `datagrid_saved_filters_user_id_name_src_unique` (`user_id`,`name`,`src`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datagrid_saved_filters`
--

LOCK TABLES `datagrid_saved_filters` WRITE;
/*!40000 ALTER TABLE `datagrid_saved_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `datagrid_saved_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_purchased`
--

DROP TABLE IF EXISTS `downloadable_link_purchased`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_purchased` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `download_bought` int NOT NULL DEFAULT '0',
  `download_used` int NOT NULL DEFAULT '0',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int unsigned NOT NULL,
  `order_id` int unsigned NOT NULL,
  `order_item_id` int unsigned NOT NULL,
  `download_canceled` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `downloadable_link_purchased_customer_id_foreign` (`customer_id`),
  KEY `downloadable_link_purchased_order_id_foreign` (`order_id`),
  KEY `downloadable_link_purchased_order_item_id_foreign` (`order_item_id`),
  CONSTRAINT `downloadable_link_purchased_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `downloadable_link_purchased_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `downloadable_link_purchased_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_purchased`
--

LOCK TABLES `downloadable_link_purchased` WRITE;
/*!40000 ALTER TABLE `downloadable_link_purchased` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_purchased` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eu_withdrawals`
--

DROP TABLE IF EXISTS `eu_withdrawals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eu_withdrawals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` int unsigned NOT NULL,
  `customer_id` int unsigned DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT '0',
  `customer_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` int unsigned NOT NULL,
  `locale` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason_text` text COLLATE utf8mb4_unicode_ci,
  `received_at` timestamp NOT NULL,
  `confirmation_sent_at` timestamp NULL DEFAULT NULL,
  `final_confirmation_sent_at` timestamp NULL DEFAULT NULL,
  `confirmation_error` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'received',
  `declined_at` timestamp NULL DEFAULT NULL,
  `declined_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `declined_by_user_id` int unsigned DEFAULT NULL,
  `refunded_at` timestamp NULL DEFAULT NULL,
  `refunded_by_user_id` int unsigned DEFAULT NULL,
  `refund_note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eu_withdrawals_order_id_unique` (`order_id`),
  UNIQUE KEY `eu_withdrawals_uuid_unique` (`uuid`),
  KEY `eu_withdrawals_customer_id_index` (`customer_id`),
  KEY `eu_withdrawals_channel_id_status_index` (`channel_id`,`status`),
  KEY `eu_withdrawals_received_at_index` (`received_at`),
  KEY `eu_withdrawals_declined_by_user_id_foreign` (`declined_by_user_id`),
  KEY `eu_withdrawals_refunded_by_user_id_foreign` (`refunded_by_user_id`),
  CONSTRAINT `eu_withdrawals_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `eu_withdrawals_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eu_withdrawals_declined_by_user_id_foreign` FOREIGN KEY (`declined_by_user_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eu_withdrawals_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eu_withdrawals_refunded_by_user_id_foreign` FOREIGN KEY (`refunded_by_user_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eu_withdrawals`
--

LOCK TABLES `eu_withdrawals` WRITE;
/*!40000 ALTER TABLE `eu_withdrawals` DISABLE KEYS */;
/*!40000 ALTER TABLE `eu_withdrawals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gdpr_data_request`
--

DROP TABLE IF EXISTS `gdpr_data_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gdpr_data_request` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int unsigned NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gdpr_data_request_customer_id_foreign` (`customer_id`),
  CONSTRAINT `gdpr_data_request_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gdpr_data_request`
--

LOCK TABLES `gdpr_data_request` WRITE;
/*!40000 ALTER TABLE `gdpr_data_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `gdpr_data_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_batches`
--

DROP TABLE IF EXISTS `import_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_batches` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `data` json NOT NULL,
  `summary` json DEFAULT NULL,
  `import_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `import_batches_import_id_foreign` (`import_id`),
  CONSTRAINT `import_batches_import_id_foreign` FOREIGN KEY (`import_id`) REFERENCES `imports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_batches`
--

LOCK TABLES `import_batches` WRITE;
/*!40000 ALTER TABLE `import_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imports`
--

DROP TABLE IF EXISTS `imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imports` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `process_in_queue` tinyint(1) NOT NULL DEFAULT '1',
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `validation_strategy` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `allowed_errors` int NOT NULL DEFAULT '0',
  `processed_rows_count` int NOT NULL DEFAULT '0',
  `invalid_rows_count` int NOT NULL DEFAULT '0',
  `errors_count` int NOT NULL DEFAULT '0',
  `errors` json DEFAULT NULL,
  `field_separator` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `images_directory_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'directory',
  `images_archive_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error_file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `summary` json DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imports`
--

LOCK TABLES `imports` WRITE;
/*!40000 ALTER TABLE `imports` DISABLE KEYS */;
/*!40000 ALTER TABLE `imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_sources`
--

DROP TABLE IF EXISTS `inventory_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory_sources` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `contact_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_fax` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postcode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int NOT NULL DEFAULT '0',
  `latitude` decimal(10,5) DEFAULT NULL,
  `longitude` decimal(10,5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_sources_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_sources`
--

LOCK TABLES `inventory_sources` WRITE;
/*!40000 ALTER TABLE `inventory_sources` DISABLE KEYS */;
INSERT INTO `inventory_sources` VALUES (1,'default','Default',NULL,'Default','warehouse@example.com','1234567899',NULL,'US','MI','Detroit','12th Street','48127',0,NULL,NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `inventory_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_id` int unsigned DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  `invoice_id` int unsigned DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  KEY `invoice_items_parent_id_foreign` (`parent_id`),
  CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `invoice_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT '0',
  `total_qty` int DEFAULT NULL,
  `base_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_total` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total` decimal(12,4) DEFAULT '0.0000',
  `grand_total` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `order_id` int unsigned DEFAULT NULL,
  `transaction_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reminders` int NOT NULL DEFAULT '0',
  `next_reminder_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_order_id_foreign` (`order_id`),
  CONSTRAINT `invoices_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locales`
--

DROP TABLE IF EXISTS `locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direction` enum('ltr','rtl') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ltr',
  `logo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `locales_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locales`
--

LOCK TABLES `locales` WRITE;
/*!40000 ALTER TABLE `locales` DISABLE KEYS */;
INSERT INTO `locales` VALUES (1,'en','English','rtl','locales/4Sz8LeoEAby1rp9No3D7BDejPhRxLjPMX1JtFQX0.png',NULL,NULL),(2,'fa','farsi','rtl',NULL,'2026-08-15 17:54:13','2026-08-15 17:54:13');
/*!40000 ALTER TABLE `locales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaigns`
--

DROP TABLE IF EXISTS `marketing_campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaigns` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mail_to` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `spooling` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_id` int unsigned DEFAULT NULL,
  `customer_group_id` int unsigned DEFAULT NULL,
  `marketing_template_id` int unsigned DEFAULT NULL,
  `marketing_event_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaigns_channel_id_foreign` (`channel_id`),
  KEY `marketing_campaigns_customer_group_id_foreign` (`customer_group_id`),
  KEY `marketing_campaigns_marketing_template_id_foreign` (`marketing_template_id`),
  KEY `marketing_campaigns_marketing_event_id_foreign` (`marketing_event_id`),
  CONSTRAINT `marketing_campaigns_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_marketing_event_id_foreign` FOREIGN KEY (`marketing_event_id`) REFERENCES `marketing_events` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marketing_campaigns_marketing_template_id_foreign` FOREIGN KEY (`marketing_template_id`) REFERENCES `marketing_templates` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaigns`
--

LOCK TABLES `marketing_campaigns` WRITE;
/*!40000 ALTER TABLE `marketing_campaigns` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaigns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_events`
--

DROP TABLE IF EXISTS `marketing_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_events` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_events`
--

LOCK TABLES `marketing_events` WRITE;
/*!40000 ALTER TABLE `marketing_events` DISABLE KEYS */;
INSERT INTO `marketing_events` VALUES (1,'Birthday','Birthday',NULL,NULL,NULL);
/*!40000 ALTER TABLE `marketing_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_templates`
--

DROP TABLE IF EXISTS `marketing_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_templates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_templates`
--

LOCK TABLES `marketing_templates` WRITE;
/*!40000 ALTER TABLE `marketing_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_admin_password_resets_table',1),(3,'2014_10_12_100000_create_password_resets_table',1),(4,'2018_06_12_111907_create_admins_table',1),(5,'2018_06_13_055341_create_roles_table',1),(6,'2018_07_05_130148_create_attributes_table',1),(7,'2018_07_05_132854_create_attribute_translations_table',1),(8,'2018_07_05_135150_create_attribute_families_table',1),(9,'2018_07_05_135152_create_attribute_groups_table',1),(10,'2018_07_05_140832_create_attribute_options_table',1),(11,'2018_07_05_140856_create_attribute_option_translations_table',1),(12,'2018_07_05_142820_create_categories_table',1),(13,'2018_07_10_055143_create_locales_table',1),(14,'2018_07_20_054426_create_countries_table',1),(15,'2018_07_20_054502_create_currencies_table',1),(16,'2018_07_20_054542_create_currency_exchange_rates_table',1),(17,'2018_07_20_064849_create_channels_table',1),(18,'2018_07_21_142836_create_category_translations_table',1),(19,'2018_07_23_110040_create_inventory_sources_table',1),(20,'2018_07_24_082635_create_customer_groups_table',1),(21,'2018_07_24_082930_create_customers_table',1),(22,'2018_07_27_065727_create_products_table',1),(23,'2018_07_27_070011_create_product_attribute_values_table',1),(24,'2018_07_27_092623_create_product_reviews_table',1),(25,'2018_07_27_113941_create_product_images_table',1),(26,'2018_07_27_113956_create_product_inventories_table',1),(27,'2018_08_30_064755_create_tax_categories_table',1),(28,'2018_08_30_065042_create_tax_rates_table',1),(29,'2018_08_30_065840_create_tax_mappings_table',1),(30,'2018_09_05_150444_create_cart_table',1),(31,'2018_09_05_150915_create_cart_items_table',1),(32,'2018_09_11_064045_customer_password_resets',1),(33,'2018_09_19_093453_create_cart_payment',1),(34,'2018_09_19_093508_create_cart_shipping_rates_table',1),(35,'2018_09_20_060658_create_core_config_table',1),(36,'2018_09_27_113154_create_orders_table',1),(37,'2018_09_27_113207_create_order_items_table',1),(38,'2018_09_27_115022_create_shipments_table',1),(39,'2018_09_27_115029_create_shipment_items_table',1),(40,'2018_09_27_115135_create_invoices_table',1),(41,'2018_09_27_115144_create_invoice_items_table',1),(42,'2018_10_01_095504_create_order_payment_table',1),(43,'2018_10_03_025230_create_wishlist_table',1),(44,'2018_10_12_101803_create_country_translations_table',1),(45,'2018_10_12_101913_create_country_states_table',1),(46,'2018_10_12_101923_create_country_state_translations_table',1),(47,'2018_11_16_173504_create_subscribers_list_table',1),(48,'2018_11_21_144411_create_cart_item_inventories_table',1),(49,'2018_12_06_185202_create_product_flat_table',1),(50,'2018_12_24_123812_create_channel_inventory_sources_table',1),(51,'2018_12_26_165327_create_product_ordered_inventories_table',1),(52,'2019_05_13_024321_create_cart_rules_table',1),(53,'2019_05_13_024322_create_cart_rule_channels_table',1),(54,'2019_05_13_024323_create_cart_rule_customer_groups_table',1),(55,'2019_05_13_024324_create_cart_rule_translations_table',1),(56,'2019_05_13_024325_create_cart_rule_customers_table',1),(57,'2019_05_13_024326_create_cart_rule_coupons_table',1),(58,'2019_05_13_024327_create_cart_rule_coupon_usage_table',1),(59,'2019_06_17_180258_create_product_downloadable_samples_table',1),(60,'2019_06_17_180314_create_product_downloadable_sample_translations_table',1),(61,'2019_06_17_180325_create_product_downloadable_links_table',1),(62,'2019_06_17_180346_create_product_downloadable_link_translations_table',1),(63,'2019_06_21_202249_create_downloadable_link_purchased_table',1),(64,'2019_07_02_180307_create_booking_products_table',1),(65,'2019_07_05_154415_create_booking_product_default_slots_table',1),(66,'2019_07_05_154429_create_booking_product_appointment_slots_table',1),(67,'2019_07_05_154440_create_booking_product_event_tickets_table',1),(68,'2019_07_05_154451_create_booking_product_rental_slots_table',1),(69,'2019_07_05_154502_create_booking_product_table_slots_table',1),(70,'2019_07_30_153530_create_cms_pages_table',1),(71,'2019_07_31_143339_create_category_filterable_attributes_table',1),(72,'2019_08_02_105320_create_product_grouped_products_table',1),(73,'2019_08_20_170510_create_product_bundle_options_table',1),(74,'2019_08_20_170520_create_product_bundle_option_translations_table',1),(75,'2019_08_20_170528_create_product_bundle_option_products_table',1),(76,'2019_09_11_184511_create_refunds_table',1),(77,'2019_09_11_184519_create_refund_items_table',1),(78,'2019_12_03_184613_create_catalog_rules_table',1),(79,'2019_12_03_184651_create_catalog_rule_channels_table',1),(80,'2019_12_03_184732_create_catalog_rule_customer_groups_table',1),(81,'2019_12_06_101110_create_catalog_rule_products_table',1),(82,'2019_12_06_110507_create_catalog_rule_product_prices_table',1),(83,'2019_12_14_000001_create_personal_access_tokens_table',1),(84,'2020_01_14_191854_create_cms_page_translations_table',1),(85,'2020_01_15_130209_create_cms_page_channels_table',1),(86,'2020_02_18_165639_create_bookings_table',1),(87,'2020_02_21_121201_create_booking_product_event_ticket_translations_table',1),(88,'2020_04_16_185147_add_table_addresses',1),(89,'2020_05_06_171638_create_order_comments_table',1),(90,'2020_05_21_171500_create_product_customer_group_prices_table',1),(91,'2020_06_25_162154_create_customer_social_accounts_table',1),(92,'2020_08_07_174804_create_gdpr_data_request_table',1),(93,'2020_11_19_112228_create_product_videos_table',1),(94,'2020_11_26_141455_create_marketing_templates_table',1),(95,'2020_11_26_150534_create_marketing_events_table',1),(96,'2020_11_26_150644_create_marketing_campaigns_table',1),(97,'2020_12_21_000200_create_channel_translations_table',1),(98,'2020_12_27_121950_create_jobs_table',1),(99,'2021_03_11_212124_create_order_transactions_table',1),(100,'2021_04_07_132010_create_product_review_images_table',1),(101,'2021_12_15_104544_notifications',1),(102,'2022_03_15_160510_create_failed_jobs_table',1),(103,'2022_04_01_094622_create_sitemaps_table',1),(104,'2022_10_03_144232_create_product_price_indices_table',1),(105,'2022_10_04_144444_create_job_batches_table',1),(106,'2022_10_08_134150_create_product_inventory_indices_table',1),(107,'2023_05_26_213105_create_wishlist_items_table',1),(108,'2023_05_26_213120_create_compare_items_table',1),(109,'2023_06_27_163529_rename_product_review_images_to_product_review_attachments',1),(110,'2023_07_06_140013_add_logo_path_column_to_locales',1),(111,'2023_07_10_184256_create_theme_customizations_table',1),(112,'2023_07_12_181722_remove_home_page_and_footer_content_column_from_channel_translations_table',1),(113,'2023_07_20_185324_add_column_column_in_attribute_groups_table',1),(114,'2023_07_25_145943_add_regex_column_in_attributes_table',1),(115,'2023_07_25_165945_drop_notes_column_from_customers_table',1),(116,'2023_07_25_171058_create_customer_notes_table',1),(117,'2023_07_31_125232_rename_image_and_category_banner_columns_from_categories_table',1),(118,'2023_09_15_170053_create_theme_customization_translations_table',1),(119,'2023_09_20_102031_add_default_value_column_in_attributes_table',1),(120,'2023_09_20_102635_add_inventories_group_in_attribute_groups_table',1),(121,'2023_09_26_155709_add_columns_to_currencies',1),(122,'2023_10_12_090446_add_tax_category_id_column_in_order_items_table',1),(123,'2023_11_08_054614_add_code_column_in_attribute_groups_table',1),(124,'2023_11_08_140116_create_search_terms_table',1),(125,'2023_11_09_162805_create_url_rewrites_table',1),(126,'2023_11_17_150401_create_search_synonyms_table',1),(127,'2023_12_11_054614_add_channel_id_column_in_product_price_indices_table',1),(128,'2024_01_11_154640_create_imports_table',1),(129,'2024_01_11_154741_create_import_batches_table',1),(130,'2024_01_19_170350_add_unique_id_column_in_product_attribute_values_table',1),(131,'2024_01_19_170350_add_unique_id_column_in_product_customer_group_prices_table',1),(132,'2024_01_22_170814_add_unique_index_in_mapping_tables',1),(133,'2024_02_26_153000_add_columns_to_addresses_table',1),(134,'2024_03_07_193421_rename_address1_column_in_addresses_table',1),(135,'2024_04_16_144400_add_cart_id_column_in_cart_shipping_rates_table',1),(136,'2024_04_19_102939_add_incl_tax_columns_in_orders_table',1),(137,'2024_04_19_135405_add_incl_tax_columns_in_cart_items_table',1),(138,'2024_04_19_144641_add_incl_tax_columns_in_order_items_table',1),(139,'2024_04_23_133154_add_incl_tax_columns_in_cart_table',1),(140,'2024_04_23_150945_add_incl_tax_columns_in_cart_shipping_rates_table',1),(141,'2024_04_24_102939_add_incl_tax_columns_in_invoices_table',1),(142,'2024_04_24_102939_add_incl_tax_columns_in_refunds_table',1),(143,'2024_04_24_144641_add_incl_tax_columns_in_invoice_items_table',1),(144,'2024_04_24_144641_add_incl_tax_columns_in_refund_items_table',1),(145,'2024_04_24_144641_add_incl_tax_columns_in_shipment_items_table',1),(146,'2024_05_10_152848_create_saved_filters_table',1),(147,'2024_06_03_174128_create_product_channels_table',1),(148,'2024_06_04_130527_add_channel_id_column_in_customers_table',1),(149,'2024_06_04_130600_make_email_unique_per_channel',1),(150,'2024_06_13_184426_add_theme_column_into_theme_customizations_table',1),(151,'2024_07_17_172645_add_additional_column_to_sitemaps_table',1),(152,'2024_10_11_135010_create_product_customizable_options_table',1),(153,'2024_10_11_135110_create_product_customizable_option_translations_table',1),(154,'2024_10_11_135228_create_product_customizable_option_prices_table',1),(155,'2025_05_07_121250_update_total_weight_columns_in_shipments_and_weight_shipment_items_tables',1),(156,'2025_09_05_000100_add_indexes_to_channels_tables',1),(157,'2025_09_05_000200_add_indexes_to_product_relation_tables',1),(158,'2025_09_05_000300_add_indexes_to_product_media_and_attributes',1),(159,'2025_09_05_000400_add_indexes_to_attributes_and_product_types',1),(160,'2025_09_05_000500_add_indexes_to_product_grouped_products_and_product_bundle_option_products',1),(161,'2025_09_05_000500_add_indexes_to_url_rewrites_and_visits',1),(162,'2025_09_11_140301_add_two_factor_to_admins',1),(163,'2025_11_14_173810_create_rma_statuses_table',1),(164,'2025_11_14_173812_create_rma_table',1),(165,'2025_11_14_173906_create_rma_reasons_table',1),(166,'2025_11_14_173959_create_rma_items_table',1),(167,'2025_11_14_174030_create_rma_images_table',1),(168,'2025_11_14_174059_create_rma_messages_table',1),(169,'2025_11_14_174134_create_rma_reason_resolutions_table',1),(170,'2025_11_14_174205_create_rma_rules_table',1),(171,'2025_11_14_174355_create_rma_custom_fields_table',1),(172,'2025_11_14_174426_create_rma_custom_field_options_table',1),(173,'2025_11_14_174509_create_rma_additional_fields_table',1),(174,'2026_02_03_151924_create_sessions_table',1),(175,'2026_02_11_095547_add_rma_return_period_to_order_items_table',1),(176,'2026_03_11_113926_create_agent_conversations_table',1),(177,'2026_04_09_120000_change_tax_category_id_fk_on_cart_items_to_null_on_delete',1),(178,'2026_04_09_120100_change_tax_category_id_fk_on_order_items_to_null_on_delete',1),(179,'2026_04_17_000001_add_booking_product_enhancements',1),(180,'2026_04_17_000002_add_allow_cancellation_snapshot_to_bookings',1),(181,'2026_05_27_114230_create_eu_withdrawals_table',1),(182,'2026_06_24_000000_rename_received_package_rma_status',1),(183,'2026_06_24_000001_rename_neutral_rma_statuses',1),(184,'2026_07_03_170000_create_sitemap_channels_table',1),(185,'2026_07_27_000001_add_image_source_to_imports_table',1),(186,'2023_02_21_220543_create_zarinpal_transactions_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `order_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_order_id_foreign` (`order_id`),
  CONSTRAINT `notifications_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,'order',0,1,'2026-08-16 17:00:08','2026-08-16 17:00:08');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_comments`
--

DROP TABLE IF EXISTS `order_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_comments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_notified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_comments_order_id_foreign` (`order_id`),
  CONSTRAINT `order_comments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_comments`
--

LOCK TABLES `order_comments` WRITE;
/*!40000 ALTER TABLE `order_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT '0.0000',
  `total_weight` decimal(12,4) DEFAULT '0.0000',
  `qty_ordered` int DEFAULT '0',
  `qty_shipped` int DEFAULT '0',
  `qty_invoiced` int DEFAULT '0',
  `qty_canceled` int DEFAULT '0',
  `qty_refunded` int DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `amount_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_amount_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `discount_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_discount_refunded` decimal(12,4) DEFAULT '0.0000',
  `tax_percent` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_amount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `tax_amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_id` int unsigned DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `tax_category_id` int unsigned DEFAULT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `rma_return_period` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_parent_id_foreign` (`parent_id`),
  KEY `order_items_tax_category_id_foreign` (`tax_category_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,'100','simple','سوخاری دو تیکه',NULL,1.0000,1.0000,1,0,0,0,0,1010000.0000,1010000.0000,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,1010000.0000,1010000.0000,152,'Webkul\\Product\\Models\\Product',1,NULL,NULL,'{\"locale\": \"fa\", \"cart_id\": 5, \"quantity\": 1, \"product_id\": 152}',NULL,'2026-08-16 17:00:08','2026-08-16 17:00:08');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_payment`
--

DROP TABLE IF EXISTS `order_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned DEFAULT NULL,
  `method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_payment_order_id_foreign` (`order_id`),
  CONSTRAINT `order_payment_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_payment`
--

LOCK TABLES `order_payment` WRITE;
/*!40000 ALTER TABLE `order_payment` DISABLE KEYS */;
INSERT INTO `order_payment` VALUES (1,1,'cashondelivery','Cash On Delivery',NULL,'2026-08-16 17:00:08','2026-08-16 17:00:08');
/*!40000 ALTER TABLE `order_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_transactions`
--

DROP TABLE IF EXISTS `order_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(12,4) DEFAULT '0.0000',
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` json DEFAULT NULL,
  `invoice_id` int unsigned NOT NULL,
  `order_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_transactions_order_id_foreign` (`order_id`),
  CONSTRAINT `order_transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_transactions`
--

LOCK TABLES `order_transactions` WRITE;
/*!40000 ALTER TABLE `order_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `customer_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT '0',
  `total_item_count` int DEFAULT NULL,
  `total_qty_ordered` int DEFAULT NULL,
  `base_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) DEFAULT '0.0000',
  `grand_total_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total_invoiced` decimal(12,4) DEFAULT '0.0000',
  `grand_total_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total_refunded` decimal(12,4) DEFAULT '0.0000',
  `sub_total` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total` decimal(12,4) DEFAULT '0.0000',
  `sub_total_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total_invoiced` decimal(12,4) DEFAULT '0.0000',
  `sub_total_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total_refunded` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `discount_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_discount_refunded` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_amount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `tax_amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `shipping_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_invoiced` decimal(12,4) DEFAULT '0.0000',
  `shipping_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_refunded` decimal(12,4) DEFAULT '0.0000',
  `shipping_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_tax_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_tax_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `customer_id` int unsigned DEFAULT NULL,
  `customer_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_id` int unsigned DEFAULT NULL,
  `channel_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_id` int DEFAULT NULL,
  `applied_cart_rule_ids` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_increment_id_unique` (`increment_id`),
  KEY `orders_customer_id_foreign` (`customer_id`),
  KEY `orders_channel_id_foreign` (`channel_id`),
  CONSTRAINT `orders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'1','pending','شمیم',1,'ehvbpc@gmail.com','Ehsan','Hoseinzadeh','free_free','Free Shipping - Free Shipping','Free Shipping',NULL,0,1,1,'IRR','IRR','IRR',1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,1010000.0000,1010000.0000,0.0000,0.0000,NULL,NULL,1,'Webkul\\Core\\Models\\Channel',5,NULL,'2026-08-16 17:00:08','2026-08-16 17:00:08');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_attribute_values`
--

DROP TABLE IF EXISTS `product_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_attribute_values` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_value` text COLLATE utf8mb4_unicode_ci,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `integer_value` int DEFAULT NULL,
  `float_value` decimal(12,4) DEFAULT NULL,
  `datetime_value` datetime DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `json_value` json DEFAULT NULL,
  `product_id` int unsigned NOT NULL,
  `attribute_id` int unsigned NOT NULL,
  `unique_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chanel_locale_attribute_value_index_unique` (`channel`,`locale`,`attribute_id`,`product_id`),
  UNIQUE KEY `product_attribute_values_unique_id_unique` (`unique_id`),
  KEY `product_attribute_values_attribute_id_foreign` (`attribute_id`),
  KEY `prod_attr_product_id_idx` (`product_id`),
  CONSTRAINT `product_attribute_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_attribute_values_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_attribute_values`
--

LOCK TABLES `product_attribute_values` WRITE;
/*!40000 ALTER TABLE `product_attribute_values` DISABLE KEYS */;
INSERT INTO `product_attribute_values` VALUES (2957,'fa',NULL,'<p>جعبه سوخاری دو تیکه (۱۰۰ عدد)</p>',NULL,NULL,NULL,NULL,NULL,NULL,152,9,'fa|152|9'),(2958,'fa',NULL,'<p>جعبه سوخاری دو تیکه</p>\n<div class=\"bt-notranslate\">\n<div class=\"bt-notranslate\">\n<div style=\"width:32px;height:32px;\"> </div>\n</div>\n</div>',NULL,NULL,NULL,NULL,NULL,NULL,152,10,'fa|152|10'),(2959,NULL,NULL,'100',NULL,NULL,NULL,NULL,NULL,NULL,152,1,'152|1'),(2960,'fa',NULL,'جعبه سوخاری دو تکه کرافت',NULL,NULL,NULL,NULL,NULL,NULL,152,2,'fa|152|2'),(2961,'fa',NULL,'جعبه-سوخاری-دو-تکه-کرافت',NULL,NULL,NULL,NULL,NULL,NULL,152,3,'fa|152|3'),(2962,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,4,'default|152|4'),(2963,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,152,23,'152|23'),(2964,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,24,'152|24'),(2965,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,25,'152|25'),(2966,NULL,NULL,'جعبه سوخاری دو تکه کرافت',NULL,NULL,NULL,NULL,NULL,NULL,152,27,'152|27'),(2967,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,152,28,'default|152|28'),(2968,'fa',NULL,'جعبه سوخاری دو تیکه',NULL,NULL,NULL,NULL,NULL,NULL,152,16,'fa|152|16'),(2969,'fa',NULL,'جعبه سوخاری دو تیکه',NULL,NULL,NULL,NULL,NULL,NULL,152,17,'fa|152|17'),(2970,'fa',NULL,'جعبه سوخاری دو تیکه',NULL,NULL,NULL,NULL,NULL,NULL,152,18,'fa|152|18'),(2971,NULL,NULL,NULL,NULL,NULL,10100.0000,NULL,NULL,NULL,152,11,'152|11'),(2972,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,12,'152|12'),(2973,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,13,'152|13'),(2974,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,14,'default|152|14'),(2975,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,15,'default|152|15'),(2976,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,152,29,'default|152|29'),(2977,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,152,30,'default|152|30'),(2978,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,152,5,'152|5'),(2979,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,152,6,'152|6'),(2980,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,152,7,'152|7'),(2981,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,152,8,'default|152|8'),(2982,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,152,26,'152|26'),(2983,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,152,19,'152|19'),(2984,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,152,20,'152|20'),(2985,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,152,21,'152|21'),(2986,NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,152,22,'152|22'),(3113,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,158,9,'fa|158|9'),(3114,'fa',NULL,'<p>جعبه سوخاری دو تکه سفید با ساختار مقاوم و فضای مناسب برای سرو مرغ سوخاری؛ مناسب رستوران و سفارش بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,158,10,'fa|158|10'),(3115,NULL,NULL,'SP-FC-002-W',NULL,NULL,NULL,NULL,NULL,NULL,158,1,'158|1'),(3116,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,158,2,'fa|158|2'),(3117,'fa',NULL,'fried-chicken-box-2-piece-white-230g',NULL,NULL,NULL,NULL,NULL,NULL,158,3,'fa|158|3'),(3118,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,158,28,'default|158|28'),(3119,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,158,16,'fa|158|16'),(3120,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,158,17,'fa|158|17'),(3121,'fa',NULL,'خرید عمده جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',NULL,NULL,NULL,NULL,NULL,NULL,158,18,'fa|158|18'),(3122,NULL,NULL,NULL,NULL,NULL,10100.0000,NULL,NULL,NULL,158,11,'158|11'),(3123,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,158,12,'158|12'),(3124,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,158,29,'default|158|29'),(3125,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,158,5,'158|5'),(3126,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,158,6,'158|6'),(3127,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,158,7,'158|7'),(3128,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,158,8,'default|158|8'),(3129,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,158,26,'158|26'),(3130,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,158,22,'158|22'),(3131,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,159,9,'fa|159|9'),(3132,'fa',NULL,'<p>جعبه سه تکه سوخاری سفید با ابعاد کاربردی برای چیدمان منظم مرغ و حفظ ظاهر سفارش هنگام تحویل.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,159,10,'fa|159|10'),(3133,NULL,NULL,'SP-FC-003-W',NULL,NULL,NULL,NULL,NULL,NULL,159,1,'159|1'),(3134,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,159,2,'fa|159|2'),(3135,'fa',NULL,'fried-chicken-box-3-piece-white-230g',NULL,NULL,NULL,NULL,NULL,NULL,159,3,'fa|159|3'),(3136,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,159,28,'default|159|28'),(3137,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,159,16,'fa|159|16'),(3138,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,159,17,'fa|159|17'),(3139,'fa',NULL,'خرید عمده جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو',NULL,NULL,NULL,NULL,NULL,NULL,159,18,'fa|159|18'),(3140,NULL,NULL,NULL,NULL,NULL,13100.0000,NULL,NULL,NULL,159,11,'159|11'),(3141,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,159,12,'159|12'),(3142,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,159,29,'default|159|29'),(3143,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,159,5,'159|5'),(3144,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,159,6,'159|6'),(3145,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,159,7,'159|7'),(3146,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,159,8,'default|159|8'),(3147,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,159,26,'159|26'),(3148,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,159,22,'159|22'),(3149,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,160,9,'fa|160|9'),(3150,'fa',NULL,'<p>جعبه پنج تکه سوخاری سفید با ارتفاع بیشتر، مناسب سفارش‌های خانوادگی و پک‌های چندتکه فست‌فود.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,160,10,'fa|160|10'),(3151,NULL,NULL,'SP-FC-005-W',NULL,NULL,NULL,NULL,NULL,NULL,160,1,'160|1'),(3152,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,160,2,'fa|160|2'),(3153,'fa',NULL,'fried-chicken-box-5-piece-white-230g',NULL,NULL,NULL,NULL,NULL,NULL,160,3,'fa|160|3'),(3154,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,160,28,'default|160|28'),(3155,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,160,16,'fa|160|16'),(3156,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,160,17,'fa|160|17'),(3157,'fa',NULL,'خرید عمده جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب',NULL,NULL,NULL,NULL,NULL,NULL,160,18,'fa|160|18'),(3158,NULL,NULL,NULL,NULL,NULL,13900.0000,NULL,NULL,NULL,160,11,'160|11'),(3159,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,160,12,'160|12'),(3160,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,160,29,'default|160|29'),(3161,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,160,5,'160|5'),(3162,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,160,6,'160|6'),(3163,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,160,7,'160|7'),(3164,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,160,8,'default|160|8'),(3165,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,160,26,'160|26'),(3166,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,160,22,'160|22'),(3167,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,161,9,'fa|161|9'),(3168,'fa',NULL,'<p>باکس سوخاری دو تکه مشکی با چاپ جذاب و مقوای ۲۵۰ گرم برای ارائه حرفه‌ای سفارش‌های بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,161,10,'fa|161|10'),(3169,NULL,NULL,'SP-FC-002-B',NULL,NULL,NULL,NULL,NULL,NULL,161,1,'161|1'),(3170,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,161,2,'fa|161|2'),(3171,'fa',NULL,'fried-chicken-box-2-piece-black-250g',NULL,NULL,NULL,NULL,NULL,NULL,161,3,'fa|161|3'),(3172,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,161,28,'default|161|28'),(3173,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,161,16,'fa|161|16'),(3174,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,161,17,'fa|161|17'),(3175,'fa',NULL,'خرید عمده جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',NULL,NULL,NULL,NULL,NULL,NULL,161,18,'fa|161|18'),(3176,NULL,NULL,NULL,NULL,NULL,11600.0000,NULL,NULL,NULL,161,11,'161|11'),(3177,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,161,12,'161|12'),(3178,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,161,29,'default|161|29'),(3179,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,161,5,'161|5'),(3180,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,161,6,'161|6'),(3181,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,161,7,'161|7'),(3182,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,161,8,'default|161|8'),(3183,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,161,26,'161|26'),(3184,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,161,22,'161|22'),(3185,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,162,9,'fa|162|9'),(3186,'fa',NULL,'<p>جعبه سه تکه سوخاری مشکی مناسب رستوران‌هایی که بسته‌بندی تیره، مقاوم و متمایز می‌خواهند.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,162,10,'fa|162|10'),(3187,NULL,NULL,'SP-FC-003-B',NULL,NULL,NULL,NULL,NULL,NULL,162,1,'162|1'),(3188,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,162,2,'fa|162|2'),(3189,'fa',NULL,'fried-chicken-box-3-piece-black-250g',NULL,NULL,NULL,NULL,NULL,NULL,162,3,'fa|162|3'),(3190,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,162,28,'default|162|28'),(3191,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,162,16,'fa|162|16'),(3192,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,162,17,'fa|162|17'),(3193,'fa',NULL,'خرید عمده جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو',NULL,NULL,NULL,NULL,NULL,NULL,162,18,'fa|162|18'),(3194,NULL,NULL,NULL,NULL,NULL,14200.0000,NULL,NULL,NULL,162,11,'162|11'),(3195,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,162,12,'162|12'),(3196,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,162,29,'default|162|29'),(3197,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,162,5,'162|5'),(3198,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,162,6,'162|6'),(3199,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,162,7,'162|7'),(3200,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,162,8,'default|162|8'),(3201,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,162,26,'162|26'),(3202,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,162,22,'162|22'),(3203,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,163,9,'fa|163|9'),(3204,'fa',NULL,'<p>جعبه پنج تکه سوخاری مشکی با ظرفیت بیشتر برای سفارش‌های خانوادگی، پک مرغ و غذای بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,163,10,'fa|163|10'),(3205,NULL,NULL,'SP-FC-005-B',NULL,NULL,NULL,NULL,NULL,NULL,163,1,'163|1'),(3206,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,163,2,'fa|163|2'),(3207,'fa',NULL,'fried-chicken-box-5-piece-black-250g',NULL,NULL,NULL,NULL,NULL,NULL,163,3,'fa|163|3'),(3208,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,163,28,'default|163|28'),(3209,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,163,16,'fa|163|16'),(3210,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,163,17,'fa|163|17'),(3211,'fa',NULL,'خرید عمده جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب',NULL,NULL,NULL,NULL,NULL,NULL,163,18,'fa|163|18'),(3212,NULL,NULL,NULL,NULL,NULL,15300.0000,NULL,NULL,NULL,163,11,'163|11'),(3213,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,163,12,'163|12'),(3214,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,163,29,'default|163|29'),(3215,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,163,5,'163|5'),(3216,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,163,6,'163|6'),(3217,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,163,7,'163|7'),(3218,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,163,8,'default|163|8'),(3219,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,163,26,'163|26'),(3220,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,163,22,'163|22'),(3221,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,164,9,'fa|164|9'),(3222,'fa',NULL,'<p>جعبه سوخاری دسته‌دار سفید برای حمل آسان‌تر سفارش و تحویل مرتب غذا به مشتری.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,164,10,'fa|164|10'),(3223,NULL,NULL,'SP-FC-HANDLE-W',NULL,NULL,NULL,NULL,NULL,NULL,164,1,'164|1'),(3224,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,164,2,'fa|164|2'),(3225,'fa',NULL,'handled-fried-chicken-box-white-230g',NULL,NULL,NULL,NULL,NULL,NULL,164,3,'fa|164|3'),(3226,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,164,28,'default|164|28'),(3227,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,164,16,'fa|164|16'),(3228,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,164,17,'fa|164|17'),(3229,'fa',NULL,'خرید عمده جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',NULL,NULL,NULL,NULL,NULL,NULL,164,18,'fa|164|18'),(3230,NULL,NULL,NULL,NULL,NULL,17900.0000,NULL,NULL,NULL,164,11,'164|11'),(3231,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,164,12,'164|12'),(3232,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,164,29,'default|164|29'),(3233,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,164,5,'164|5'),(3234,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,164,6,'164|6'),(3235,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,164,7,'164|7'),(3236,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,164,8,'default|164|8'),(3237,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,164,26,'164|26'),(3238,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,164,22,'164|22'),(3239,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,165,9,'fa|165|9'),(3240,'fa',NULL,'<p>جعبه سوخاری دسته‌دار مشکی با ظاهر حرفه‌ای و ساختار مناسب حمل سفارش‌های فست‌فودی.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,165,10,'fa|165|10'),(3241,NULL,NULL,'SP-FC-HANDLE-B',NULL,NULL,NULL,NULL,NULL,NULL,165,1,'165|1'),(3242,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,165,2,'fa|165|2'),(3243,'fa',NULL,'handled-fried-chicken-box-black-250g',NULL,NULL,NULL,NULL,NULL,NULL,165,3,'fa|165|3'),(3244,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,165,28,'default|165|28'),(3245,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,165,16,'fa|165|16'),(3246,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,165,17,'fa|165|17'),(3247,'fa',NULL,'خرید عمده جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',NULL,NULL,NULL,NULL,NULL,NULL,165,18,'fa|165|18'),(3248,NULL,NULL,NULL,NULL,NULL,20100.0000,NULL,NULL,NULL,165,11,'165|11'),(3249,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,165,12,'165|12'),(3250,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,165,29,'default|165|29'),(3251,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,165,5,'165|5'),(3252,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,165,6,'165|6'),(3253,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,165,7,'165|7'),(3254,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,165,8,'default|165|8'),(3255,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,165,26,'165|26'),(3256,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,165,22,'165|22'),(3257,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,166,9,'fa|166|9'),(3258,'fa',NULL,'<p>جعبه سوخاری سفره‌ای کوچک که پس از بازشدن سطح مناسبی برای سرو مستقیم غذا فراهم می‌کند.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۹.۵ × ۱۵ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,166,10,'fa|166|10'),(3259,NULL,NULL,'SP-FC-TABLE-S',NULL,NULL,NULL,NULL,NULL,NULL,166,1,'166|1'),(3260,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,166,2,'fa|166|2'),(3261,'fa',NULL,'small-tabletop-fried-chicken-box-250g',NULL,NULL,NULL,NULL,NULL,NULL,166,3,'fa|166|3'),(3262,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,166,28,'default|166|28'),(3263,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,166,16,'fa|166|16'),(3264,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,166,17,'fa|166|17'),(3265,'fa',NULL,'خرید عمده جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',NULL,NULL,NULL,NULL,NULL,NULL,166,18,'fa|166|18'),(3266,NULL,NULL,NULL,NULL,NULL,23400.0000,NULL,NULL,NULL,166,11,'166|11'),(3267,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,166,12,'166|12'),(3268,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,166,29,'default|166|29'),(3269,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,166,5,'166|5'),(3270,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,166,6,'166|6'),(3271,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,166,7,'166|7'),(3272,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,166,8,'default|166|8'),(3273,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,166,26,'166|26'),(3274,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,166,22,'166|22'),(3275,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,167,9,'fa|167|9'),(3276,'fa',NULL,'<p>جعبه سوخاری سفره‌ای بزرگ برای پک‌های حجیم و سفارش‌های خانوادگی با امکان سرو آسان.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,167,10,'fa|167|10'),(3277,NULL,NULL,'SP-FC-TABLE-L',NULL,NULL,NULL,NULL,NULL,NULL,167,1,'167|1'),(3278,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,167,2,'fa|167|2'),(3279,'fa',NULL,'large-tabletop-fried-chicken-box-250g',NULL,NULL,NULL,NULL,NULL,NULL,167,3,'fa|167|3'),(3280,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,167,28,'default|167|28'),(3281,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,167,16,'fa|167|16'),(3282,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,167,17,'fa|167|17'),(3283,'fa',NULL,'خرید عمده جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سف',NULL,NULL,NULL,NULL,NULL,NULL,167,18,'fa|167|18'),(3284,NULL,NULL,NULL,NULL,NULL,29500.0000,NULL,NULL,NULL,167,11,'167|11'),(3285,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,167,12,'167|12'),(3286,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,167,29,'default|167|29'),(3287,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,167,5,'167|5'),(3288,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,167,6,'167|6'),(3289,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,167,7,'167|7'),(3290,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,167,8,'default|167|8'),(3291,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,167,26,'167|26'),(3292,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,167,22,'167|22'),(3293,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,168,9,'fa|168|9'),(3294,'fa',NULL,'<p>بشقاب مقوایی سوخاری قفل‌دار با لبه‌های بلند برای سرو مرتب و دسترسی آسان به غذا در سالن یا بیرون‌بر.</p>\n<h2>مشخصات بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۵ × ۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,168,10,'fa|168|10'),(3295,NULL,NULL,'SP-FC-PLATE',NULL,NULL,NULL,NULL,NULL,NULL,168,1,'168|1'),(3296,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,168,2,'fa|168|2'),(3297,'fa',NULL,'fried-chicken-locking-serving-plate-250g',NULL,NULL,NULL,NULL,NULL,NULL,168,3,'fa|168|3'),(3298,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,168,28,'default|168|28'),(3299,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,168,16,'fa|168|16'),(3300,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,168,17,'fa|168|17'),(3301,'fa',NULL,'خرید عمده بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. مشاهده مشخ',NULL,NULL,NULL,NULL,NULL,NULL,168,18,'fa|168|18'),(3302,NULL,NULL,NULL,NULL,NULL,5700.0000,NULL,NULL,NULL,168,11,'168|11'),(3303,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,168,12,'168|12'),(3304,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,168,29,'default|168|29'),(3305,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,168,5,'168|5'),(3306,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,168,6,'168|6'),(3307,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,168,7,'168|7'),(3308,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,168,8,'default|168|8'),(3309,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,168,26,'168|26'),(3310,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,168,22,'168|22'),(3311,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,169,9,'fa|169|9'),(3312,'fa',NULL,'<p>جعبه سیب‌زمینی صندوقی کوچک با درب یکپارچه برای حمل تمیز، حفظ فرم و جلوگیری از پراکندگی محتویات.</p>\n<h2>مشخصات جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۸ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,169,10,'fa|169|10'),(3313,NULL,NULL,'SP-FF-BOX',NULL,NULL,NULL,NULL,NULL,NULL,169,1,'169|1'),(3314,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,169,2,'fa|169|2'),(3315,'fa',NULL,'small-carton-french-fries-box-230g',NULL,NULL,NULL,NULL,NULL,NULL,169,3,'fa|169|3'),(3316,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,169,28,'default|169|28'),(3317,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,169,16,'fa|169|16'),(3318,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,169,17,'fa|169|17'),(3319,'fa',NULL,'خرید عمده جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ',NULL,NULL,NULL,NULL,NULL,NULL,169,18,'fa|169|18'),(3320,NULL,NULL,NULL,NULL,NULL,6900.0000,NULL,NULL,NULL,169,11,'169|11'),(3321,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,169,12,'169|12'),(3322,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,169,29,'default|169|29'),(3323,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,169,5,'169|5'),(3324,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,169,6,'169|6'),(3325,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,169,7,'169|7'),(3326,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,169,8,'default|169|8'),(3327,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,169,26,'169|26'),(3328,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,169,22,'169|22'),(3329,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,170,9,'fa|170|9'),(3330,'fa',NULL,'<p>ظرف قایقی کوچک سیب‌زمینی برای سرو تک‌نفره، دسترسی سریع و نمایش بهتر محصول.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۵ × ۱۱.۵ × ۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,170,10,'fa|170|10'),(3331,NULL,NULL,'SP-FF-BOAT-S',NULL,NULL,NULL,NULL,NULL,NULL,170,1,'170|1'),(3332,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,170,2,'fa|170|2'),(3333,'fa',NULL,'small-boat-french-fries-tray-230g',NULL,NULL,NULL,NULL,NULL,NULL,170,3,'fa|170|3'),(3334,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,170,28,'default|170|28'),(3335,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,170,16,'fa|170|16'),(3336,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,170,17,'fa|170|17'),(3337,'fa',NULL,'خرید عمده جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود',NULL,NULL,NULL,NULL,NULL,NULL,170,18,'fa|170|18'),(3338,NULL,NULL,NULL,NULL,NULL,3600.0000,NULL,NULL,NULL,170,11,'170|11'),(3339,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,170,12,'170|12'),(3340,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,170,29,'default|170|29'),(3341,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,170,5,'170|5'),(3342,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,170,6,'170|6'),(3343,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,170,7,'170|7'),(3344,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,170,8,'default|170|8'),(3345,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,170,26,'170|26'),(3346,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,170,22,'170|22'),(3347,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,171,9,'fa|171|9'),(3348,'fa',NULL,'<p>ظرف قایقی بزرگ سیب‌زمینی برای پرس‌های حجیم‌تر، سیب‌زمینی ویژه و سرو اشتراکی.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۱.۵ × ۱۰ × ۶ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,171,10,'fa|171|10'),(3349,NULL,NULL,'SP-FF-BOAT-L',NULL,NULL,NULL,NULL,NULL,NULL,171,1,'171|1'),(3350,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,171,2,'fa|171|2'),(3351,'fa',NULL,'large-boat-french-fries-tray-230g',NULL,NULL,NULL,NULL,NULL,NULL,171,3,'fa|171|3'),(3352,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,171,28,'default|171|28'),(3353,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,171,16,'fa|171|16'),(3354,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,171,17,'fa|171|17'),(3355,'fa',NULL,'خرید عمده جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود',NULL,NULL,NULL,NULL,NULL,NULL,171,18,'fa|171|18'),(3356,NULL,NULL,NULL,NULL,NULL,5100.0000,NULL,NULL,NULL,171,11,'171|11'),(3357,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,171,12,'171|12'),(3358,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,171,29,'default|171|29'),(3359,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,171,5,'171|5'),(3360,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,171,6,'171|6'),(3361,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,171,7,'171|7'),(3362,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,171,8,'default|171|8'),(3363,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,171,26,'171|26'),(3364,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,171,22,'171|22'),(3365,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,172,9,'fa|172|9'),(3366,'fa',NULL,'<p>جعبه قیفی بلند سیب‌زمینی با فرم متمایز برای سرو ایستاده و ارائه جذاب در فست‌فود و رویداد.</p>\n<h2>مشخصات جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,172,10,'fa|172|10'),(3367,NULL,NULL,'SP-FF-CONE',NULL,NULL,NULL,NULL,NULL,NULL,172,1,'172|1'),(3368,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,172,2,'fa|172|2'),(3369,'fa',NULL,'cone-french-fries-box-250g',NULL,NULL,NULL,NULL,NULL,NULL,172,3,'fa|172|3'),(3370,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,172,28,'default|172|28'),(3371,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,172,16,'fa|172|16'),(3372,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,172,17,'fa|172|17'),(3373,'fa',NULL,'خرید عمده جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فو',NULL,NULL,NULL,NULL,NULL,NULL,172,18,'fa|172|18'),(3374,NULL,NULL,NULL,NULL,NULL,8300.0000,NULL,NULL,NULL,172,11,'172|11'),(3375,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,172,12,'172|12'),(3376,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,172,29,'default|172|29'),(3377,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,172,5,'172|5'),(3378,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,172,6,'172|6'),(3379,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,172,7,'172|7'),(3380,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,172,8,'default|172|8'),(3381,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,172,26,'172|26'),(3382,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,172,22,'172|22'),(3383,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,173,9,'fa|173|9'),(3384,'fa',NULL,'<p>باکس سیب‌زمینی نیوکلاسیک با دهانه باز و فرم مدرن برای سرو حرفه‌ای و برندینگ فست‌فود.</p>\n<h2>مشخصات جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۴ × ۱۱ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,173,10,'fa|173|10'),(3385,NULL,NULL,'SP-FF-NEO',NULL,NULL,NULL,NULL,NULL,NULL,173,1,'173|1'),(3386,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,173,2,'fa|173|2'),(3387,'fa',NULL,'neo-classic-french-fries-box-230g',NULL,NULL,NULL,NULL,NULL,NULL,173,3,'fa|173|3'),(3388,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,173,28,'default|173|28'),(3389,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,173,16,'fa|173|16'),(3390,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,173,17,'fa|173|17'),(3391,'fa',NULL,'خرید عمده جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ک',NULL,NULL,NULL,NULL,NULL,NULL,173,18,'fa|173|18'),(3392,NULL,NULL,NULL,NULL,NULL,9300.0000,NULL,NULL,NULL,173,11,'173|11'),(3393,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,173,12,'173|12'),(3394,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,173,29,'default|173|29'),(3395,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,173,5,'173|5'),(3396,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,173,6,'173|6'),(3397,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,173,7,'173|7'),(3398,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,173,8,'default|173|8'),(3399,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,173,26,'173|26'),(3400,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,173,22,'173|22'),(3401,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,174,9,'fa|174|9'),(3402,'fa',NULL,'<p>جعبه هرمی کوچک سیب‌زمینی برای پرس تک‌نفره با ظاهر خاص و اشغال فضای کم روی میز.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,174,10,'fa|174|10'),(3403,NULL,NULL,'SP-FF-PYRAMID-S',NULL,NULL,NULL,NULL,NULL,NULL,174,1,'174|1'),(3404,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,174,2,'fa|174|2'),(3405,'fa',NULL,'small-pyramid-french-fries-box-230g',NULL,NULL,NULL,NULL,NULL,NULL,174,3,'fa|174|3'),(3406,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,174,28,'default|174|28'),(3407,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,174,16,'fa|174|16'),(3408,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,174,17,'fa|174|17'),(3409,'fa',NULL,'خرید عمده جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی ',NULL,NULL,NULL,NULL,NULL,NULL,174,18,'fa|174|18'),(3410,NULL,NULL,NULL,NULL,NULL,6900.0000,NULL,NULL,NULL,174,11,'174|11'),(3411,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,174,12,'174|12'),(3412,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,174,29,'default|174|29'),(3413,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,174,5,'174|5'),(3414,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,174,6,'174|6'),(3415,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,174,7,'174|7'),(3416,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,174,8,'default|174|8'),(3417,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,174,26,'174|26'),(3418,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,174,22,'174|22'),(3419,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,175,9,'fa|175|9'),(3420,'fa',NULL,'<p>جعبه هرمی بزرگ سیب‌زمینی با ظرفیت بیشتر برای پرس ویژه و ارائه متفاوت محصول.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,175,10,'fa|175|10'),(3421,NULL,NULL,'SP-FF-PYRAMID-L',NULL,NULL,NULL,NULL,NULL,NULL,175,1,'175|1'),(3422,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم',NULL,NULL,NULL,NULL,NULL,NULL,175,2,'fa|175|2'),(3423,'fa',NULL,'large-pyramid-french-fries-box-230g',NULL,NULL,NULL,NULL,NULL,NULL,175,3,'fa|175|3'),(3424,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,175,28,'default|175|28'),(3425,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,175,16,'fa|175|16'),(3426,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,175,17,'fa|175|17'),(3427,'fa',NULL,'خرید عمده جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌ز',NULL,NULL,NULL,NULL,NULL,NULL,175,18,'fa|175|18'),(3428,NULL,NULL,NULL,NULL,NULL,9400.0000,NULL,NULL,NULL,175,11,'175|11'),(3429,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,175,12,'175|12'),(3430,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,175,29,'default|175|29'),(3431,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,175,5,'175|5'),(3432,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,175,6,'175|6'),(3433,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,175,7,'175|7'),(3434,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,175,8,'default|175|8'),(3435,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,175,26,'175|26'),(3436,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,175,22,'175|22'),(3437,'fa',NULL,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر، کاغذ کرافت، ابعاد ۲۵ × ۳۵ سانتی‌متر. مناسب پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,176,9,'fa|176|9'),(3438,'fa',NULL,'<p>کاغذ کرافت ساندویچ سایز ۲۵ در ۳۵ برای بسته‌بندی جمع‌وجور برگر، ساندویچ و میان‌وعده.</p>\n<h2>مشخصات کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۳۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,176,10,'fa|176|10'),(3439,NULL,NULL,'SP-PAPER-2535',NULL,NULL,NULL,NULL,NULL,NULL,176,1,'176|1'),(3440,'fa',NULL,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر',NULL,NULL,NULL,NULL,NULL,NULL,176,2,'fa|176|2'),(3441,'fa',NULL,'kraft-sandwich-paper-25x35',NULL,NULL,NULL,NULL,NULL,NULL,176,3,'fa|176|3'),(3442,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,176,28,'default|176|28'),(3443,'fa',NULL,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,176,16,'fa|176|16'),(3444,'fa',NULL,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,176,17,'fa|176|17'),(3445,'fa',NULL,'خرید عمده کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر. کاغذ کرافت با ابعاد ۲۵ × ۳۵ سانتی‌متر. مناسب پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر. مشاهده مشخصات و ا',NULL,NULL,NULL,NULL,NULL,NULL,176,18,'fa|176|18'),(3446,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,176,11,'176|11'),(3447,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,176,12,'176|12'),(3448,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,176,29,'default|176|29'),(3449,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,176,5,'176|5'),(3450,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,176,6,'176|6'),(3451,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,176,7,'176|7'),(3452,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,176,8,'default|176|8'),(3453,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,176,26,'176|26'),(3454,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,176,22,'176|22'),(3455,'fa',NULL,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر، کاغذ کرافت، ابعاد ۳۵ × ۵۰ سانتی‌متر. مناسب پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,177,9,'fa|177|9'),(3456,'fa',NULL,'<p>کاغذ کرافت ساندویچ سایز ۳۵ در ۵۰ برای بسته‌بندی محصولات بزرگ‌تر و پوشش کامل‌تر غذا.</p>\n<h2>مشخصات کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت</li>\n    <li><strong>ابعاد:</strong> ۳۵ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,177,10,'fa|177|10'),(3457,NULL,NULL,'SP-PAPER-3550',NULL,NULL,NULL,NULL,NULL,NULL,177,1,'177|1'),(3458,'fa',NULL,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر',NULL,NULL,NULL,NULL,NULL,NULL,177,2,'fa|177|2'),(3459,'fa',NULL,'kraft-sandwich-paper-35x50',NULL,NULL,NULL,NULL,NULL,NULL,177,3,'fa|177|3'),(3460,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,177,28,'default|177|28'),(3461,'fa',NULL,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,177,16,'fa|177|16'),(3462,'fa',NULL,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,177,17,'fa|177|17'),(3463,'fa',NULL,'خرید عمده کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر. کاغذ کرافت با ابعاد ۳۵ × ۵۰ سانتی‌متر. مناسب پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر. مشاهده مشخصا',NULL,NULL,NULL,NULL,NULL,NULL,177,18,'fa|177|18'),(3464,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,177,11,'177|11'),(3465,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,177,12,'177|12'),(3466,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,177,29,'default|177|29'),(3467,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,177,5,'177|5'),(3468,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,177,6,'177|6'),(3469,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,177,7,'177|7'),(3470,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,177,8,'default|177|8'),(3471,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,177,26,'177|26'),(3472,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,177,22,'177|22'),(3473,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,178,9,'fa|178|9'),(3474,'fa',NULL,'<p>جعبه پیتزا نیم متری پارس با ساختار مقاوم دو رو کرافت و فضای مناسب برای پیتزاهای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری پارس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری پارس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,178,10,'fa|178|10'),(3475,NULL,NULL,'SP-PIZZA-50-PARS',NULL,NULL,NULL,NULL,NULL,NULL,178,1,'178|1'),(3476,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,178,2,'fa|178|2'),(3477,'fa',NULL,'pars-half-meter-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,178,3,'fa|178|3'),(3478,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,178,28,'default|178|28'),(3479,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,178,16,'fa|178|16'),(3480,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,178,17,'fa|178|17'),(3481,'fa',NULL,'خرید عمده جعبه پیتزا نیم متری پارس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌ب',NULL,NULL,NULL,NULL,NULL,NULL,178,18,'fa|178|18'),(3482,NULL,NULL,NULL,NULL,NULL,19200.0000,NULL,NULL,NULL,178,11,'178|11'),(3483,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,178,12,'178|12'),(3484,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,178,29,'default|178|29'),(3485,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,178,5,'178|5'),(3486,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,178,6,'178|6'),(3487,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,178,7,'178|7'),(3488,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,178,8,'default|178|8'),(3489,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,178,26,'178|26'),(3490,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,178,22,'178|22'),(3491,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,179,9,'fa|179|9'),(3492,'fa',NULL,'<p>جعبه پیتزا نیم متری طاقدیس با مقوای ایفلوت مقاوم برای حمل مطمئن پیتزای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,179,10,'fa|179|10'),(3493,NULL,NULL,'SP-PIZZA-50-TAGHDIS',NULL,NULL,NULL,NULL,NULL,NULL,179,1,'179|1'),(3494,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,179,2,'fa|179|2'),(3495,'fa',NULL,'taghdis-half-meter-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,179,3,'fa|179|3'),(3496,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,179,28,'default|179|28'),(3497,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,179,16,'fa|179|16'),(3498,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,179,17,'fa|179|17'),(3499,'fa',NULL,'خرید عمده جعبه پیتزا نیم متری طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون',NULL,NULL,NULL,NULL,NULL,NULL,179,18,'fa|179|18'),(3500,NULL,NULL,NULL,NULL,NULL,20600.0000,NULL,NULL,NULL,179,11,'179|11'),(3501,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,179,12,'179|12'),(3502,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,179,29,'default|179|29'),(3503,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,179,5,'179|5'),(3504,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,179,6,'179|6'),(3505,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,179,7,'179|7'),(3506,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,179,8,'default|179|8'),(3507,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,179,26,'179|26'),(3508,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,179,22,'179|22'),(3509,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,180,9,'fa|180|9'),(3510,'fa',NULL,'<p>جعبه پیتزا ۳۲ سانتی طاقدیس با استحکام مناسب، ظاهر کرافت حرفه‌ای و فضای استاندارد پیتزا.</p>\n<h2>مشخصات جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۲ × ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,180,10,'fa|180|10'),(3511,NULL,NULL,'SP-PIZZA-32-TAGHDIS',NULL,NULL,NULL,NULL,NULL,NULL,180,1,'180|1'),(3512,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,180,2,'fa|180|2'),(3513,'fa',NULL,'taghdis-32cm-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,180,3,'fa|180|3'),(3514,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,180,28,'default|180|28'),(3515,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,180,16,'fa|180|16'),(3516,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,180,17,'fa|180|17'),(3517,'fa',NULL,'خرید عمده جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. مشاهده',NULL,NULL,NULL,NULL,NULL,NULL,180,18,'fa|180|18'),(3518,NULL,NULL,NULL,NULL,NULL,25100.0000,NULL,NULL,NULL,180,11,'180|11'),(3519,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,180,12,'180|12'),(3520,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,180,29,'default|180|29'),(3521,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,180,5,'180|5'),(3522,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,180,6,'180|6'),(3523,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,180,7,'180|7'),(3524,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,180,8,'default|180|8'),(3525,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,180,26,'180|26'),(3526,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,180,22,'180|22'),(3527,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,181,9,'fa|181|9'),(3528,'fa',NULL,'<p>جعبه پیتزا ۳۰ سانتی طاقدیس، مناسب پیتزای استاندارد با ساختار ایفلوت و مقاومت مناسب حمل.</p>\n<h2>مشخصات جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۰ × ۳۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,181,10,'fa|181|10'),(3529,NULL,NULL,'SP-PIZZA-30-TAGHDIS',NULL,NULL,NULL,NULL,NULL,NULL,181,1,'181|1'),(3530,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,181,2,'fa|181|2'),(3531,'fa',NULL,'taghdis-30cm-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,181,3,'fa|181|3'),(3532,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,181,28,'default|181|28'),(3533,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,181,16,'fa|181|16'),(3534,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,181,17,'fa|181|17'),(3535,'fa',NULL,'خرید عمده جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. مشاهده',NULL,NULL,NULL,NULL,NULL,NULL,181,18,'fa|181|18'),(3536,NULL,NULL,NULL,NULL,NULL,22700.0000,NULL,NULL,NULL,181,11,'181|11'),(3537,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,181,12,'181|12'),(3538,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,181,29,'default|181|29'),(3539,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,181,5,'181|5'),(3540,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,181,6,'181|6'),(3541,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,181,7,'181|7'),(3542,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,181,8,'default|181|8'),(3543,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,181,26,'181|26'),(3544,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,181,22,'181|22'),(3545,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,182,9,'fa|182|9'),(3546,'fa',NULL,'<p>جعبه پیتزا ۲۸ سانتی طاقدیس با ابعاد جمع‌وجور و مقوای کرافت ایفلوت مناسب ارسال.</p>\n<h2>مشخصات جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۸ × ۲۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,182,10,'fa|182|10'),(3547,NULL,NULL,'SP-PIZZA-28-TAGHDIS',NULL,NULL,NULL,NULL,NULL,NULL,182,1,'182|1'),(3548,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,182,2,'fa|182|2'),(3549,'fa',NULL,'taghdis-28cm-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,182,3,'fa|182|3'),(3550,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,182,28,'default|182|28'),(3551,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,182,16,'fa|182|16'),(3552,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,182,17,'fa|182|17'),(3553,'fa',NULL,'خرید عمده جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. مشاهده',NULL,NULL,NULL,NULL,NULL,NULL,182,18,'fa|182|18'),(3554,NULL,NULL,NULL,NULL,NULL,18700.0000,NULL,NULL,NULL,182,11,'182|11'),(3555,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,182,12,'182|12'),(3556,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,182,29,'default|182|29'),(3557,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,182,5,'182|5'),(3558,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,182,6,'182|6'),(3559,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,182,7,'182|7'),(3560,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,182,8,'default|182|8'),(3561,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,182,26,'182|26'),(3562,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,182,22,'182|22'),(3563,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.',NULL,NULL,NULL,NULL,NULL,NULL,183,9,'fa|183|9'),(3564,'fa',NULL,'<p>جعبه پیتزا ۲۴ سانتی طاقدیس برای پیتزای کوچک و تک‌نفره با حمل آسان و ظاهر کرافت.</p>\n<h2>مشخصات جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۲۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,183,10,'fa|183|10'),(3565,NULL,NULL,'SP-PIZZA-24-TAGHDIS',NULL,NULL,NULL,NULL,NULL,NULL,183,1,'183|1'),(3566,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت',NULL,NULL,NULL,NULL,NULL,NULL,183,2,'fa|183|2'),(3567,'fa',NULL,'taghdis-24cm-kraft-pizza-box',NULL,NULL,NULL,NULL,NULL,NULL,183,3,'fa|183|3'),(3568,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,183,28,'default|183|28'),(3569,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,183,16,'fa|183|16'),(3570,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,183,17,'fa|183|17'),(3571,'fa',NULL,'خرید عمده جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. م',NULL,NULL,NULL,NULL,NULL,NULL,183,18,'fa|183|18'),(3572,NULL,NULL,NULL,NULL,NULL,14100.0000,NULL,NULL,NULL,183,11,'183|11'),(3573,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,183,12,'183|12'),(3574,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,183,29,'default|183|29'),(3575,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,183,5,'183|5'),(3576,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,183,6,'183|6'),(3577,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,183,7,'183|7'),(3578,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,183,8,'default|183|8'),(3579,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,183,26,'183|26'),(3580,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,183,22,'183|22'),(3581,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,158,23,'158|23'),(3582,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,158,24,'158|24'),(3583,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,159,23,'159|23'),(3584,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,159,24,'159|24'),(3585,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,160,23,'160|23'),(3586,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,160,24,'160|24'),(3587,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,161,23,'161|23'),(3588,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,161,24,'161|24'),(3589,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,162,23,'162|23'),(3590,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,162,24,'162|24'),(3591,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,163,23,'163|23'),(3592,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,163,24,'163|24'),(3593,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,164,23,'164|23'),(3594,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,164,24,'164|24'),(3595,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,165,23,'165|23'),(3596,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,165,24,'165|24'),(3597,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,166,23,'166|23'),(3598,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,166,24,'166|24'),(3599,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,167,23,'167|23'),(3600,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,167,24,'167|24'),(3601,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,168,23,'168|23'),(3602,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,168,24,'168|24'),(3603,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,169,23,'169|23'),(3604,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,169,24,'169|24'),(3605,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,170,23,'170|23'),(3606,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,170,24,'170|24'),(3607,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,171,23,'171|23'),(3608,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,171,24,'171|24'),(3609,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,172,23,'172|23'),(3610,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,172,24,'172|24'),(3611,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,173,23,'173|23'),(3612,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,173,24,'173|24'),(3613,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,174,23,'174|23'),(3614,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,174,24,'174|24'),(3615,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,175,23,'175|23'),(3616,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,175,24,'175|24'),(3617,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,176,23,'176|23'),(3618,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,176,24,'176|24'),(3619,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,177,23,'177|23'),(3620,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,177,24,'177|24'),(3621,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,178,23,'178|23'),(3622,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,178,24,'178|24'),(3623,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,179,23,'179|23'),(3624,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,179,24,'179|24'),(3625,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,180,23,'180|23'),(3626,NULL,NULL,NULL,NULL,9,NULL,NULL,NULL,NULL,180,24,'180|24'),(3627,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,181,23,'181|23'),(3628,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,181,24,'181|24'),(3629,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,182,23,'182|23'),(3630,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,182,24,'182|24'),(3631,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,183,23,'183|23'),(3632,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,183,24,'183|24'),(3633,'fa',NULL,'پاکت کرافت بیرون‌بر دسته‌دار، کاغذ کرافت Food Grade، ابعاد سایزبندی متنوع. مناسب حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,184,9,'fa|184|9'),(3634,'fa',NULL,'<p>پاکت کرافت مقاوم با دسته یکپارچه برای تحویل مرتب سفارش و امکان چاپ اختصاصی لوگوی مجموعه.</p>\n<h2>مشخصات پاکت کرافت بیرون‌بر دسته‌دار</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پاکت کرافت بیرون‌بر دسته‌دار، پاکت بیرون بر، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,184,10,'fa|184|10'),(3635,NULL,NULL,'SP-BAG-KRAFT',NULL,NULL,NULL,NULL,NULL,NULL,184,1,'184|1'),(3636,'fa',NULL,'پاکت کرافت بیرون‌بر دسته‌دار',NULL,NULL,NULL,NULL,NULL,NULL,184,2,'fa|184|2'),(3637,'fa',NULL,'kraft-takeaway-carry-bag',NULL,NULL,NULL,NULL,NULL,NULL,184,3,'fa|184|3'),(3638,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,184,23,'184|23'),(3639,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,184,24,'184|24'),(3640,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,184,28,'default|184|28'),(3641,'fa',NULL,'پاکت کرافت بیرون‌بر دسته‌دار | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,184,16,'fa|184|16'),(3642,'fa',NULL,'پاکت کرافت بیرون‌بر دسته‌دار, پاکت بیرون بر, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,184,17,'fa|184|17'),(3643,'fa',NULL,'خرید عمده پاکت کرافت بیرون‌بر دسته‌دار. کاغذ کرافت Food Grade با ابعاد سایزبندی متنوع. مناسب حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه. مشاهده مشخصات و استعل',NULL,NULL,NULL,NULL,NULL,NULL,184,18,'fa|184|18'),(3644,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,184,11,'184|11'),(3645,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,184,12,'184|12'),(3646,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,184,29,'default|184|29'),(3647,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,184,5,'184|5'),(3648,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,184,6,'184|6'),(3649,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,184,7,'184|7'),(3650,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,184,8,'default|184|8'),(3651,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,184,26,'184|26'),(3652,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,184,22,'184|22'),(3653,'fa',NULL,'پک چوبی قاشق چنگال کارد و دستمال، چوب بهداشتی و لفاف شفاف، ابعاد پک تک‌نفره. مناسب سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,185,9,'fa|185|9'),(3654,'fa',NULL,'<p>پک کامل و بهداشتی قاشق، چنگال، کارد و دستمال برای تکمیل سفارش‌های بیرون‌بر و پذیرایی حرفه‌ای.</p>\n<h2>مشخصات پک چوبی قاشق چنگال کارد و دستمال</h2>\n<ul>\n    <li><strong>جنس:</strong> چوب بهداشتی و لفاف شفاف</li>\n    <li><strong>ابعاد:</strong> پک تک‌نفره</li>\n    <li><strong>کاربرد:</strong> سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پک چوبی قاشق چنگال کارد و دستمال، پک قاشق و چنگال، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,185,10,'fa|185|10'),(3655,NULL,NULL,'SP-CUTLERY-WOOD',NULL,NULL,NULL,NULL,NULL,NULL,185,1,'185|1'),(3656,'fa',NULL,'پک چوبی قاشق چنگال کارد و دستمال',NULL,NULL,NULL,NULL,NULL,NULL,185,2,'fa|185|2'),(3657,'fa',NULL,'wooden-cutlery-pack',NULL,NULL,NULL,NULL,NULL,NULL,185,3,'fa|185|3'),(3658,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,185,23,'185|23'),(3659,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,185,24,'185|24'),(3660,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,185,28,'default|185|28'),(3661,'fa',NULL,'پک چوبی قاشق چنگال کارد و دستمال | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,185,16,'fa|185|16'),(3662,'fa',NULL,'پک چوبی قاشق چنگال کارد و دستمال, پک قاشق و چنگال, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,185,17,'fa|185|17'),(3663,'fa',NULL,'خرید عمده پک چوبی قاشق چنگال کارد و دستمال. چوب بهداشتی و لفاف شفاف با ابعاد پک تک‌نفره. مناسب سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی. مشاهده مشخصات و استع',NULL,NULL,NULL,NULL,NULL,NULL,185,18,'fa|185|18'),(3664,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,185,11,'185|11'),(3665,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,185,12,'185|12'),(3666,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,185,29,'default|185|29'),(3667,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,185,5,'185|5'),(3668,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,185,6,'185|6'),(3669,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,185,7,'185|7'),(3670,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,185,8,'default|185|8'),(3671,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,185,26,'185|26'),(3672,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,185,22,'185|22'),(3673,'fa',NULL,'لیوان کاغذی یک‌بارمصرف درب‌دار، کاغذ مخصوص نوشیدنی Food Grade، ابعاد سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر. مناسب قهوه، چای، دمنوش و نوشیدنی گرم. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,186,9,'fa|186|9'),(3674,'fa',NULL,'<p>لیوان کاغذی مقاوم با امکان انتخاب درب و چاپ اختصاصی، مناسب کافه، رستوران و رویداد.</p>\n<h2>مشخصات لیوان کاغذی یک‌بارمصرف درب‌دار</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ مخصوص نوشیدنی Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر</li>\n    <li><strong>کاربرد:</strong> قهوه، چای، دمنوش و نوشیدنی گرم</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> لیوان کاغذی یک‌بارمصرف درب‌دار، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,186,10,'fa|186|10'),(3675,NULL,NULL,'SP-CUP-PAPER',NULL,NULL,NULL,NULL,NULL,NULL,186,1,'186|1'),(3676,'fa',NULL,'لیوان کاغذی یک‌بارمصرف درب‌دار',NULL,NULL,NULL,NULL,NULL,NULL,186,2,'fa|186|2'),(3677,'fa',NULL,'disposable-paper-cup-with-lid',NULL,NULL,NULL,NULL,NULL,NULL,186,3,'fa|186|3'),(3678,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,186,23,'186|23'),(3679,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,186,24,'186|24'),(3680,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,186,28,'default|186|28'),(3681,'fa',NULL,'لیوان کاغذی یک‌بارمصرف درب‌دار | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,186,16,'fa|186|16'),(3682,'fa',NULL,'لیوان کاغذی یک‌بارمصرف درب‌دار, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,186,17,'fa|186|17'),(3683,'fa',NULL,'خرید عمده لیوان کاغذی یک‌بارمصرف درب‌دار. کاغذ مخصوص نوشیدنی Food Grade با ابعاد سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر. مناسب قهوه، چای، دمنوش و نوشیدنی گرم. مشاهده مش',NULL,NULL,NULL,NULL,NULL,NULL,186,18,'fa|186|18'),(3684,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,186,11,'186|11'),(3685,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,186,12,'186|12'),(3686,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,186,29,'default|186|29'),(3687,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,186,5,'186|5'),(3688,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,186,6,'186|6'),(3689,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,186,7,'186|7'),(3690,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,186,8,'default|186|8'),(3691,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,186,26,'186|26'),(3692,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,186,22,'186|22'),(3693,'fa',NULL,'لیوان شفاف یک‌بارمصرف درب گنبدی، پلاستیک شفاف Food Grade، ابعاد سایزبندی متنوع. مناسب آبمیوه، شیک، اسموتی و نوشیدنی سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,187,9,'fa|187|9'),(3694,'fa',NULL,'<p>لیوان شفاف با درب گنبدی برای نمایش بهتر نوشیدنی و حمل مطمئن سفارش‌های سرد.</p>\n<h2>مشخصات لیوان شفاف یک‌بارمصرف درب گنبدی</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> آبمیوه، شیک، اسموتی و نوشیدنی سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> لیوان شفاف یک‌بارمصرف درب گنبدی، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,187,10,'fa|187|10'),(3695,NULL,NULL,'SP-CUP-PLASTIC',NULL,NULL,NULL,NULL,NULL,NULL,187,1,'187|1'),(3696,'fa',NULL,'لیوان شفاف یک‌بارمصرف درب گنبدی',NULL,NULL,NULL,NULL,NULL,NULL,187,2,'fa|187|2'),(3697,'fa',NULL,'clear-plastic-cup-dome-lid',NULL,NULL,NULL,NULL,NULL,NULL,187,3,'fa|187|3'),(3698,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,187,23,'187|23'),(3699,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,187,24,'187|24'),(3700,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,187,28,'default|187|28'),(3701,'fa',NULL,'لیوان شفاف یک‌بارمصرف درب گنبدی | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,187,16,'fa|187|16'),(3702,'fa',NULL,'لیوان شفاف یک‌بارمصرف درب گنبدی, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,187,17,'fa|187|17'),(3703,'fa',NULL,'خرید عمده لیوان شفاف یک‌بارمصرف درب گنبدی. پلاستیک شفاف Food Grade با ابعاد سایزبندی متنوع. مناسب آبمیوه، شیک، اسموتی و نوشیدنی سرد. مشاهده مشخصات و استعلام ق',NULL,NULL,NULL,NULL,NULL,NULL,187,18,'fa|187|18'),(3704,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,187,11,'187|11'),(3705,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,187,12,'187|12'),(3706,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,187,29,'default|187|29'),(3707,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,187,5,'187|5'),(3708,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,187,6,'187|6'),(3709,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,187,7,'187|7'),(3710,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,187,8,'default|187|8'),(3711,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,187,26,'187|26'),(3712,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,187,22,'187|22'),(3713,'fa',NULL,'کاپ کاغذی بستنی و دسر، کاغذ روکش‌دار Food Grade، ابعاد سایزهای تک‌نفره و خانوادگی. مناسب بستنی، دسر، ژله و خوراکی سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,188,9,'fa|188|9'),(3714,'fa',NULL,'<p>کاپ کاغذی مستحکم برای سرو بستنی و دسر با قابلیت سفارش درب و چاپ اختصاصی برند.</p>\n<h2>مشخصات کاپ کاغذی بستنی و دسر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ روکش‌دار Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای تک‌نفره و خانوادگی</li>\n    <li><strong>کاربرد:</strong> بستنی، دسر، ژله و خوراکی سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاپ کاغذی بستنی و دسر، بسته بندی بستنی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,188,10,'fa|188|10'),(3715,NULL,NULL,'SP-ICECREAM-CUP',NULL,NULL,NULL,NULL,NULL,NULL,188,1,'188|1'),(3716,'fa',NULL,'کاپ کاغذی بستنی و دسر',NULL,NULL,NULL,NULL,NULL,NULL,188,2,'fa|188|2'),(3717,'fa',NULL,'paper-ice-cream-dessert-cup',NULL,NULL,NULL,NULL,NULL,NULL,188,3,'fa|188|3'),(3718,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,188,23,'188|23'),(3719,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,188,24,'188|24'),(3720,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,188,28,'default|188|28'),(3721,'fa',NULL,'کاپ کاغذی بستنی و دسر | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,188,16,'fa|188|16'),(3722,'fa',NULL,'کاپ کاغذی بستنی و دسر, بسته بندی بستنی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,188,17,'fa|188|17'),(3723,'fa',NULL,'خرید عمده کاپ کاغذی بستنی و دسر. کاغذ روکش‌دار Food Grade با ابعاد سایزهای تک‌نفره و خانوادگی. مناسب بستنی، دسر، ژله و خوراکی سرد. مشاهده مشخصات و استعلام قیم',NULL,NULL,NULL,NULL,NULL,NULL,188,18,'fa|188|18'),(3724,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,188,11,'188|11'),(3725,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,188,12,'188|12'),(3726,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,188,29,'default|188|29'),(3727,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,188,5,'188|5'),(3728,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,188,6,'188|6'),(3729,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,188,7,'188|7'),(3730,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,188,8,'default|188|8'),(3731,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,188,26,'188|26'),(3732,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,188,22,'188|22'),(3733,'fa',NULL,'ظرف شفاف درب‌دار سالاد، پلاستیک شفاف Food Grade، ابعاد سایزبندی متنوع. مناسب سالاد، میوه، سبزیجات و غذای سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,189,9,'fa|189|9'),(3734,'fa',NULL,'<p>ظرف شفاف درب‌دار با نمایش کامل محتویات و بسته‌شدن مطمئن برای سفارش‌های سرد و بیرون‌بر.</p>\n<h2>مشخصات ظرف شفاف درب‌دار سالاد</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> سالاد، میوه، سبزیجات و غذای سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ظرف شفاف درب‌دار سالاد، ظرف سالاد یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,189,10,'fa|189|10'),(3735,NULL,NULL,'SP-SALAD-CLEAR',NULL,NULL,NULL,NULL,NULL,NULL,189,1,'189|1'),(3736,'fa',NULL,'ظرف شفاف درب‌دار سالاد',NULL,NULL,NULL,NULL,NULL,NULL,189,2,'fa|189|2'),(3737,'fa',NULL,'clear-salad-container-with-lid',NULL,NULL,NULL,NULL,NULL,NULL,189,3,'fa|189|3'),(3738,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,189,23,'189|23'),(3739,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,189,24,'189|24'),(3740,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,189,28,'default|189|28'),(3741,'fa',NULL,'ظرف شفاف درب‌دار سالاد | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,189,16,'fa|189|16'),(3742,'fa',NULL,'ظرف شفاف درب‌دار سالاد, ظرف سالاد یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,189,17,'fa|189|17'),(3743,'fa',NULL,'خرید عمده ظرف شفاف درب‌دار سالاد. پلاستیک شفاف Food Grade با ابعاد سایزبندی متنوع. مناسب سالاد، میوه، سبزیجات و غذای سرد. مشاهده مشخصات و استعلام قیمت از شمیم',NULL,NULL,NULL,NULL,NULL,NULL,189,18,'fa|189|18'),(3744,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,189,11,'189|11'),(3745,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,189,12,'189|12'),(3746,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,189,29,'default|189|29'),(3747,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,189,5,'189|5'),(3748,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,189,6,'189|6'),(3749,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,189,7,'189|7'),(3750,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,189,8,'default|189|8'),(3751,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,189,26,'189|26'),(3752,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,189,22,'189|22'),(3753,'fa',NULL,'کاپ شفاف درب‌دار سس، پلاستیک شفاف Food Grade، ابعاد سایزهای کوچک. مناسب سس، چاشنی، ترشی و دورچین. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,190,9,'fa|190|9'),(3754,'fa',NULL,'<p>کاپ کوچک درب‌دار برای بسته‌بندی بهداشتی سس و چاشنی در سفارش‌های رستورانی و فست‌فودی.</p>\n<h2>مشخصات کاپ شفاف درب‌دار سس</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای کوچک</li>\n    <li><strong>کاربرد:</strong> سس، چاشنی، ترشی و دورچین</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاپ شفاف درب‌دار سس، ظرف سس یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,190,10,'fa|190|10'),(3755,NULL,NULL,'SP-SAUCE-CUP',NULL,NULL,NULL,NULL,NULL,NULL,190,1,'190|1'),(3756,'fa',NULL,'کاپ شفاف درب‌دار سس',NULL,NULL,NULL,NULL,NULL,NULL,190,2,'fa|190|2'),(3757,'fa',NULL,'clear-sauce-cup-with-lid',NULL,NULL,NULL,NULL,NULL,NULL,190,3,'fa|190|3'),(3758,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,190,23,'190|23'),(3759,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,190,24,'190|24'),(3760,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,190,28,'default|190|28'),(3761,'fa',NULL,'کاپ شفاف درب‌دار سس | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,190,16,'fa|190|16'),(3762,'fa',NULL,'کاپ شفاف درب‌دار سس, ظرف سس یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,190,17,'fa|190|17'),(3763,'fa',NULL,'خرید عمده کاپ شفاف درب‌دار سس. پلاستیک شفاف Food Grade با ابعاد سایزهای کوچک. مناسب سس، چاشنی، ترشی و دورچین. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,NULL,NULL,190,18,'fa|190|18'),(3764,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,190,11,'190|11'),(3765,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,190,12,'190|12'),(3766,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,190,29,'default|190|29'),(3767,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,190,5,'190|5'),(3768,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,190,6,'190|6'),(3769,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,190,7,'190|7'),(3770,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,190,8,'default|190|8'),(3771,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,190,26,'190|26'),(3772,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,190,22,'190|22'),(3773,'fa',NULL,'پک نی و سیخ چوبی یک‌بارمصرف، چوب و کاغذ بهداشتی، ابعاد سایزبندی متنوع. مناسب نوشیدنی، فینگرفود، کباب و پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,191,9,'fa|191|9'),(3774,'fa',NULL,'<p>مجموعه نی و سیخ چوبی سازگار با سرو حرفه‌ای کافه، رستوران، فست‌فود و مراسم.</p>\n<h2>مشخصات پک نی و سیخ چوبی یک‌بارمصرف</h2>\n<ul>\n    <li><strong>جنس:</strong> چوب و کاغذ بهداشتی</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> نوشیدنی، فینگرفود، کباب و پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پک نی و سیخ چوبی یک‌بارمصرف، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,191,10,'fa|191|10'),(3775,NULL,NULL,'SP-STRAW-SKEWER',NULL,NULL,NULL,NULL,NULL,NULL,191,1,'191|1'),(3776,'fa',NULL,'پک نی و سیخ چوبی یک‌بارمصرف',NULL,NULL,NULL,NULL,NULL,NULL,191,2,'fa|191|2'),(3777,'fa',NULL,'disposable-straws-wooden-skewers',NULL,NULL,NULL,NULL,NULL,NULL,191,3,'fa|191|3'),(3778,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,191,23,'191|23'),(3779,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,191,24,'191|24'),(3780,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,191,28,'default|191|28'),(3781,'fa',NULL,'پک نی و سیخ چوبی یک‌بارمصرف | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,191,16,'fa|191|16'),(3782,'fa',NULL,'پک نی و سیخ چوبی یک‌بارمصرف, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,191,17,'fa|191|17'),(3783,'fa',NULL,'خرید عمده پک نی و سیخ چوبی یک‌بارمصرف. چوب و کاغذ بهداشتی با ابعاد سایزبندی متنوع. مناسب نوشیدنی، فینگرفود، کباب و پذیرایی. مشاهده مشخصات و استعلام قیمت از شم',NULL,NULL,NULL,NULL,NULL,NULL,191,18,'fa|191|18'),(3784,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,191,11,'191|11'),(3785,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,191,12,'191|12'),(3786,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,191,29,'default|191|29'),(3787,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,191,5,'191|5'),(3788,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,191,6,'191|6'),(3789,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,191,7,'191|7'),(3790,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,191,8,'default|191|8'),(3791,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,191,26,'191|26'),(3792,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,191,22,'191|22'),(3793,'fa',NULL,'پاکت کرافت پنجره‌دار آجیل و خشکبار، کرافت چندلایه Food Grade، ابعاد سایزبندی متنوع. مناسب آجیل، خشکبار، قهوه، ادویه و تنقلات. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,192,9,'fa|192|9'),(3794,'fa',NULL,'<p>پاکت کرافت ایستاده با پنجره شفاف برای نمایش محصول، نگهداری بهتر و امکان چاپ اختصاصی برند.</p>\n<h2>مشخصات پاکت کرافت پنجره‌دار آجیل و خشکبار</h2>\n<ul>\n    <li><strong>جنس:</strong> کرافت چندلایه Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> آجیل، خشکبار، قهوه، ادویه و تنقلات</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پاکت کرافت پنجره‌دار آجیل و خشکبار، بسته بندی آجیل و خشکبار، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,192,10,'fa|192|10'),(3795,NULL,NULL,'SP-NUTS-POUCH',NULL,NULL,NULL,NULL,NULL,NULL,192,1,'192|1'),(3796,'fa',NULL,'پاکت کرافت پنجره‌دار آجیل و خشکبار',NULL,NULL,NULL,NULL,NULL,NULL,192,2,'fa|192|2'),(3797,'fa',NULL,'kraft-window-nuts-pouch',NULL,NULL,NULL,NULL,NULL,NULL,192,3,'fa|192|3'),(3798,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,192,23,'192|23'),(3799,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,192,24,'192|24'),(3800,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,192,28,'default|192|28'),(3801,'fa',NULL,'پاکت کرافت پنجره‌دار آجیل و خشکبار | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,192,16,'fa|192|16'),(3802,'fa',NULL,'پاکت کرافت پنجره‌دار آجیل و خشکبار, بسته بندی آجیل و خشکبار, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,192,17,'fa|192|17'),(3803,'fa',NULL,'خرید عمده پاکت کرافت پنجره‌دار آجیل و خشکبار. کرافت چندلایه Food Grade با ابعاد سایزبندی متنوع. مناسب آجیل، خشکبار، قهوه، ادویه و تنقلات. مشاهده مشخصات و استع',NULL,NULL,NULL,NULL,NULL,NULL,192,18,'fa|192|18'),(3804,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,192,11,'192|11'),(3805,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,192,12,'192|12'),(3806,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,192,29,'default|192|29'),(3807,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,192,5,'192|5'),(3808,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,192,6,'192|6'),(3809,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,192,7,'192|7'),(3810,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,192,8,'default|192|8'),(3811,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,192,26,'192|26'),(3812,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,192,22,'192|22'),(3813,'fa',NULL,'ظرف مشکی مایکروویوی درب شفاف، پلی‌پروپیلن Food Grade، ابعاد تک‌خانه و چندخانه. مناسب غذای گرم، برنج، خوراک و سفارش بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,193,9,'fa|193|9'),(3814,'fa',NULL,'<p>ظرف مقاوم در برابر حرارت با درب شفاف و بسته‌شدن مطمئن، مناسب ارسال و گرم‌کردن غذا.</p>\n<h2>مشخصات ظرف مشکی مایکروویوی درب شفاف</h2>\n<ul>\n    <li><strong>جنس:</strong> پلی‌پروپیلن Food Grade</li>\n    <li><strong>ابعاد:</strong> تک‌خانه و چندخانه</li>\n    <li><strong>کاربرد:</strong> غذای گرم، برنج، خوراک و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ظرف مشکی مایکروویوی درب شفاف، ظرف مایکروویوی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,193,10,'fa|193|10'),(3815,NULL,NULL,'SP-MICROWAVE-BOX',NULL,NULL,NULL,NULL,NULL,NULL,193,1,'193|1'),(3816,'fa',NULL,'ظرف مشکی مایکروویوی درب شفاف',NULL,NULL,NULL,NULL,NULL,NULL,193,2,'fa|193|2'),(3817,'fa',NULL,'black-microwave-container-clear-lid',NULL,NULL,NULL,NULL,NULL,NULL,193,3,'fa|193|3'),(3818,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,193,23,'193|23'),(3819,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,193,24,'193|24'),(3820,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,193,28,'default|193|28'),(3821,'fa',NULL,'ظرف مشکی مایکروویوی درب شفاف | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,193,16,'fa|193|16'),(3822,'fa',NULL,'ظرف مشکی مایکروویوی درب شفاف, ظرف مایکروویوی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,193,17,'fa|193|17'),(3823,'fa',NULL,'خرید عمده ظرف مشکی مایکروویوی درب شفاف. پلی‌پروپیلن Food Grade با ابعاد تک‌خانه و چندخانه. مناسب غذای گرم، برنج، خوراک و سفارش بیرون‌بر. مشاهده مشخصات و استعل',NULL,NULL,NULL,NULL,NULL,NULL,193,18,'fa|193|18'),(3824,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,193,11,'193|11'),(3825,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,193,12,'193|12'),(3826,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,193,29,'default|193|29'),(3827,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,193,5,'193|5'),(3828,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,193,6,'193|6'),(3829,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,193,7,'193|7'),(3830,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,193,8,'default|193|8'),(3831,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,193,26,'193|26'),(3832,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,193,22,'193|22'),(3833,'fa',NULL,'سینی کرافت سرو غذای یک‌بارمصرف، مقوای کرافت Food Grade، ابعاد سایزبندی متنوع. مناسب سیب‌زمینی، سوخاری، ساندویچ و فینگرفود. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,194,9,'fa|194|9'),(3834,'fa',NULL,'<p>سینی کرافت با لبه‌های مقاوم برای سرو تمیز و حرفه‌ای انواع غذا و میان‌وعده.</p>\n<h2>مشخصات سینی کرافت سرو غذای یک‌بارمصرف</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> سیب‌زمینی، سوخاری، ساندویچ و فینگرفود</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینی کرافت سرو غذای یک‌بارمصرف، سینی سرو غذا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,194,10,'fa|194|10'),(3835,NULL,NULL,'SP-FOOD-TRAY',NULL,NULL,NULL,NULL,NULL,NULL,194,1,'194|1'),(3836,'fa',NULL,'سینی کرافت سرو غذای یک‌بارمصرف',NULL,NULL,NULL,NULL,NULL,NULL,194,2,'fa|194|2'),(3837,'fa',NULL,'kraft-disposable-food-serving-tray',NULL,NULL,NULL,NULL,NULL,NULL,194,3,'fa|194|3'),(3838,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,194,23,'194|23'),(3839,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,194,24,'194|24'),(3840,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,194,28,'default|194|28'),(3841,'fa',NULL,'سینی کرافت سرو غذای یک‌بارمصرف | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,194,16,'fa|194|16'),(3842,'fa',NULL,'سینی کرافت سرو غذای یک‌بارمصرف, سینی سرو غذا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,194,17,'fa|194|17'),(3843,'fa',NULL,'خرید عمده سینی کرافت سرو غذای یک‌بارمصرف. مقوای کرافت Food Grade با ابعاد سایزبندی متنوع. مناسب سیب‌زمینی، سوخاری، ساندویچ و فینگرفود. مشاهده مشخصات و استعلام',NULL,NULL,NULL,NULL,NULL,NULL,194,18,'fa|194|18'),(3844,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,194,11,'194|11'),(3845,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,194,12,'194|12'),(3846,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,194,29,'default|194|29'),(3847,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,194,5,'194|5'),(3848,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,194,6,'194|6'),(3849,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,194,7,'194|7'),(3850,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,194,8,'default|194|8'),(3851,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,194,26,'194|26'),(3852,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,194,22,'194|22'),(3853,'fa',NULL,'جا دستمالی کرافت رومیزی، مقوای کرافت مقاوم، ابعاد رومیزی استاندارد. مناسب رستوران، کافه، فست‌فود و کانتر پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,195,9,'fa|195|9'),(3854,'fa',NULL,'<p>جا دستمالی رومیزی کرافت با ظاهر مینیمال برای نظم میز و هماهنگی با بسته‌بندی‌های دوستدار محیط زیست.</p>\n<h2>مشخصات جا دستمالی کرافت رومیزی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت مقاوم</li>\n    <li><strong>ابعاد:</strong> رومیزی استاندارد</li>\n    <li><strong>کاربرد:</strong> رستوران، کافه، فست‌فود و کانتر پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جا دستمالی کرافت رومیزی، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,195,10,'fa|195|10'),(3855,NULL,NULL,'SP-NAPKIN-HOLDER',NULL,NULL,NULL,NULL,NULL,NULL,195,1,'195|1'),(3856,'fa',NULL,'جا دستمالی کرافت رومیزی',NULL,NULL,NULL,NULL,NULL,NULL,195,2,'fa|195|2'),(3857,'fa',NULL,'kraft-tabletop-napkin-holder',NULL,NULL,NULL,NULL,NULL,NULL,195,3,'fa|195|3'),(3858,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,195,23,'195|23'),(3859,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,195,24,'195|24'),(3860,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,195,28,'default|195|28'),(3861,'fa',NULL,'جا دستمالی کرافت رومیزی | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,195,16,'fa|195|16'),(3862,'fa',NULL,'جا دستمالی کرافت رومیزی, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,195,17,'fa|195|17'),(3863,'fa',NULL,'خرید عمده جا دستمالی کرافت رومیزی. مقوای کرافت مقاوم با ابعاد رومیزی استاندارد. مناسب رستوران، کافه، فست‌فود و کانتر پذیرایی. مشاهده مشخصات و استعلام قیمت از ',NULL,NULL,NULL,NULL,NULL,NULL,195,18,'fa|195|18'),(3864,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,195,11,'195|11'),(3865,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,195,12,'195|12'),(3866,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,195,29,'default|195|29'),(3867,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,195,5,'195|5'),(3868,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,195,6,'195|6'),(3869,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,195,7,'195|7'),(3870,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,195,8,'default|195|8'),(3871,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,195,26,'195|26'),(3872,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,195,22,'195|22'),(3873,'fa',NULL,'جعبه برگر صدفی کرافت، مقوای کرافت Food Grade، ابعاد ۱۲ × ۱۲ × ۸ سانتی‌متر. مناسب همبرگر، چیزبرگر و سفارش بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,196,9,'fa|196|9'),(3874,'fa',NULL,'<p>جعبه برگر صدفی با درب یکپارچه و فضای استاندارد برای جلوگیری از فشرده‌شدن برگر.</p>\n<h2>مشخصات جعبه برگر صدفی کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> همبرگر، چیزبرگر و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه برگر صدفی کرافت، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,196,10,'fa|196|10'),(3875,NULL,NULL,'SP-BURGER-CLAMSHELL',NULL,NULL,NULL,NULL,NULL,NULL,196,1,'196|1'),(3876,'fa',NULL,'جعبه برگر صدفی کرافت',NULL,NULL,NULL,NULL,NULL,NULL,196,2,'fa|196|2'),(3877,'fa',NULL,'kraft-clamshell-burger-box',NULL,NULL,NULL,NULL,NULL,NULL,196,3,'fa|196|3'),(3878,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,196,23,'196|23'),(3879,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,196,24,'196|24'),(3880,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,196,28,'default|196|28'),(3881,'fa',NULL,'جعبه برگر صدفی کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,196,16,'fa|196|16'),(3882,'fa',NULL,'جعبه برگر صدفی کرافت, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,196,17,'fa|196|17'),(3883,'fa',NULL,'خرید عمده جعبه برگر صدفی کرافت. مقوای کرافت Food Grade با ابعاد ۱۲ × ۱۲ × ۸ سانتی‌متر. مناسب همبرگر، چیزبرگر و سفارش بیرون‌بر. مشاهده مشخصات و استعلام قیمت از',NULL,NULL,NULL,NULL,NULL,NULL,196,18,'fa|196|18'),(3884,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,196,11,'196|11'),(3885,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,196,12,'196|12'),(3886,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,196,29,'default|196|29'),(3887,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,196,5,'196|5'),(3888,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,196,6,'196|6'),(3889,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,196,7,'196|7'),(3890,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,196,8,'default|196|8'),(3891,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,196,26,'196|26'),(3892,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,196,22,'196|22'),(3893,'fa',NULL,'جعبه برگر لاک‌باتوم ایندربرد، مقوای ایندربرد Food Grade، ابعاد ۱۳ × ۱۳ × ۸ سانتی‌متر. مناسب برگر ویژه، دوبل و فست‌فود بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,197,9,'fa|197|9'),(3894,'fa',NULL,'<p>جعبه برگر لاک‌باتوم با کف قفل‌شونده و استحکام مناسب برای حمل سفارش.</p>\n<h2>مشخصات جعبه برگر لاک‌باتوم ایندربرد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> ۱۳ × ۱۳ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> برگر ویژه، دوبل و فست‌فود بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه برگر لاک‌باتوم ایندربرد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,197,10,'fa|197|10'),(3895,NULL,NULL,'SP-BURGER-LOCK',NULL,NULL,NULL,NULL,NULL,NULL,197,1,'197|1'),(3896,'fa',NULL,'جعبه برگر لاک‌باتوم ایندربرد',NULL,NULL,NULL,NULL,NULL,NULL,197,2,'fa|197|2'),(3897,'fa',NULL,'lock-bottom-burger-box',NULL,NULL,NULL,NULL,NULL,NULL,197,3,'fa|197|3'),(3898,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,197,23,'197|23'),(3899,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,197,24,'197|24'),(3900,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,197,28,'default|197|28'),(3901,'fa',NULL,'جعبه برگر لاک‌باتوم ایندربرد | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,197,16,'fa|197|16'),(3902,'fa',NULL,'جعبه برگر لاک‌باتوم ایندربرد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,197,17,'fa|197|17'),(3903,'fa',NULL,'خرید عمده جعبه برگر لاک‌باتوم ایندربرد. مقوای ایندربرد Food Grade با ابعاد ۱۳ × ۱۳ × ۸ سانتی‌متر. مناسب برگر ویژه، دوبل و فست‌فود بیرون‌بر. مشاهده مشخصات و اس',NULL,NULL,NULL,NULL,NULL,NULL,197,18,'fa|197|18'),(3904,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,197,11,'197|11'),(3905,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,197,12,'197|12'),(3906,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,197,29,'default|197|29'),(3907,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,197,5,'197|5'),(3908,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,197,6,'197|6'),(3909,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,197,7,'197|7'),(3910,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,197,8,'default|197|8'),(3911,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,197,26,'197|26'),(3912,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,197,22,'197|22'),(3913,'fa',NULL,'جعبه ساندویچ کرافت استاندارد، مقوای کرافت Food Grade، ابعاد ۲۴ × ۹ × ۷ سانتی‌متر. مناسب ساندویچ، هات‌داگ و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,198,9,'fa|198|9'),(3914,'fa',NULL,'<p>جعبه ساندویچ کرافت با طول استاندارد برای حفظ فرم نان و چیدمان منظم محتویات.</p>\n<h2>مشخصات جعبه ساندویچ کرافت استاندارد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۹ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> ساندویچ، هات‌داگ و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه ساندویچ کرافت استاندارد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,198,10,'fa|198|10'),(3915,NULL,NULL,'SP-SANDWICH-KRAFT',NULL,NULL,NULL,NULL,NULL,NULL,198,1,'198|1'),(3916,'fa',NULL,'جعبه ساندویچ کرافت استاندارد',NULL,NULL,NULL,NULL,NULL,NULL,198,2,'fa|198|2'),(3917,'fa',NULL,'standard-kraft-sandwich-box',NULL,NULL,NULL,NULL,NULL,NULL,198,3,'fa|198|3'),(3918,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,198,23,'198|23'),(3919,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,198,24,'198|24'),(3920,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,198,28,'default|198|28'),(3921,'fa',NULL,'جعبه ساندویچ کرافت استاندارد | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,198,16,'fa|198|16'),(3922,'fa',NULL,'جعبه ساندویچ کرافت استاندارد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,198,17,'fa|198|17'),(3923,'fa',NULL,'خرید عمده جعبه ساندویچ کرافت استاندارد. مقوای کرافت Food Grade با ابعاد ۲۴ × ۹ × ۷ سانتی‌متر. مناسب ساندویچ، هات‌داگ و غذای بیرون‌بر. مشاهده مشخصات و استعلام ',NULL,NULL,NULL,NULL,NULL,NULL,198,18,'fa|198|18'),(3924,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,198,11,'198|11'),(3925,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,198,12,'198|12'),(3926,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,198,29,'default|198|29'),(3927,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,198,5,'198|5'),(3928,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,198,6,'198|6'),(3929,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,198,7,'198|7'),(3930,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,198,8,'default|198|8'),(3931,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,198,26,'198|26'),(3932,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,198,22,'198|22'),(3933,'fa',NULL,'جعبه ساندویچ کشویی ایندربرد، مقوای ایندربرد Food Grade، ابعاد ۲۵ × ۱۰ × ۷ سانتی‌متر. مناسب ساندویچ ویژه و هات‌داگ بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,199,9,'fa|199|9'),(3934,'fa',NULL,'<p>جعبه کشویی ساندویچ با بازشدن آسان و ظاهر حرفه‌ای مناسب چاپ اختصاصی برند.</p>\n<h2>مشخصات جعبه ساندویچ کشویی ایندربرد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۰ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> ساندویچ ویژه و هات‌داگ بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه ساندویچ کشویی ایندربرد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,199,10,'fa|199|10'),(3935,NULL,NULL,'SP-SANDWICH-DRAWER',NULL,NULL,NULL,NULL,NULL,NULL,199,1,'199|1'),(3936,'fa',NULL,'جعبه ساندویچ کشویی ایندربرد',NULL,NULL,NULL,NULL,NULL,NULL,199,2,'fa|199|2'),(3937,'fa',NULL,'drawer-sandwich-box',NULL,NULL,NULL,NULL,NULL,NULL,199,3,'fa|199|3'),(3938,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,199,23,'199|23'),(3939,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,199,24,'199|24'),(3940,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,199,28,'default|199|28'),(3941,'fa',NULL,'جعبه ساندویچ کشویی ایندربرد | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,199,16,'fa|199|16'),(3942,'fa',NULL,'جعبه ساندویچ کشویی ایندربرد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,199,17,'fa|199|17'),(3943,'fa',NULL,'خرید عمده جعبه ساندویچ کشویی ایندربرد. مقوای ایندربرد Food Grade با ابعاد ۲۵ × ۱۰ × ۷ سانتی‌متر. مناسب ساندویچ ویژه و هات‌داگ بیرون‌بر. مشاهده مشخصات و استعلا',NULL,NULL,NULL,NULL,NULL,NULL,199,18,'fa|199|18'),(3944,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,199,11,'199|11'),(3945,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,199,12,'199|12'),(3946,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,199,29,'default|199|29'),(3947,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,199,5,'199|5'),(3948,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,199,6,'199|6'),(3949,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,199,7,'199|7'),(3950,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,199,8,'default|199|8'),(3951,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,199,26,'199|26'),(3952,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,199,22,'199|22'),(3953,'fa',NULL,'ساشه ادویه تک‌نفره، لفاف چندلایه بهداشتی، ابعاد پک تک‌نفره. مناسب نمک، فلفل، آویشن و ادویه مخصوص. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,200,9,'fa|200|9'),(3954,'fa',NULL,'<p>ساشه ادویه تک‌نفره بهداشتی برای تکمیل سفارش رستوران و امکان چاپ اختصاصی.</p>\n<h2>مشخصات ساشه ادویه تک‌نفره</h2>\n<ul>\n    <li><strong>جنس:</strong> لفاف چندلایه بهداشتی</li>\n    <li><strong>ابعاد:</strong> پک تک‌نفره</li>\n    <li><strong>کاربرد:</strong> نمک، فلفل، آویشن و ادویه مخصوص</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ساشه ادویه تک‌نفره، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,200,10,'fa|200|10'),(3955,NULL,NULL,'SP-SACHET-SPICE',NULL,NULL,NULL,NULL,NULL,NULL,200,1,'200|1'),(3956,'fa',NULL,'ساشه ادویه تک‌نفره',NULL,NULL,NULL,NULL,NULL,NULL,200,2,'fa|200|2'),(3957,'fa',NULL,'single-serve-spice-sachet',NULL,NULL,NULL,NULL,NULL,NULL,200,3,'fa|200|3'),(3958,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,200,23,'200|23'),(3959,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,200,24,'200|24'),(3960,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,200,28,'default|200|28'),(3961,'fa',NULL,'ساشه ادویه تک‌نفره | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,200,16,'fa|200|16'),(3962,'fa',NULL,'ساشه ادویه تک‌نفره, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,200,17,'fa|200|17'),(3963,'fa',NULL,'خرید عمده ساشه ادویه تک‌نفره. لفاف چندلایه بهداشتی با ابعاد پک تک‌نفره. مناسب نمک، فلفل، آویشن و ادویه مخصوص. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,NULL,NULL,200,18,'fa|200|18'),(3964,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,200,11,'200|11'),(3965,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,200,12,'200|12'),(3966,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,200,29,'default|200|29'),(3967,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,200,5,'200|5'),(3968,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,200,6,'200|6'),(3969,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,200,7,'200|7'),(3970,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,200,8,'default|200|8'),(3971,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,200,26,'200|26'),(3972,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,200,22,'200|22'),(3973,'fa',NULL,'جعبه غذای بیرون‌بر کرافت، مقوای کرافت Food Grade، ابعاد سایزبندی تک‌نفره و خانوادگی. مناسب برنج، خوراک، غذای گرم و کترینگ. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,201,9,'fa|201|9'),(3974,'fa',NULL,'<p>جعبه غذای کرافت مقاوم برای ارسال منظم غذای گرم و سفارش‌های رستورانی.</p>\n<h2>مشخصات جعبه غذای بیرون‌بر کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی تک‌نفره و خانوادگی</li>\n    <li><strong>کاربرد:</strong> برنج، خوراک، غذای گرم و کترینگ</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه غذای بیرون‌بر کرافت، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,201,10,'fa|201|10'),(3975,NULL,NULL,'SP-FOOD-TAKEAWAY',NULL,NULL,NULL,NULL,NULL,NULL,201,1,'201|1'),(3976,'fa',NULL,'جعبه غذای بیرون‌بر کرافت',NULL,NULL,NULL,NULL,NULL,NULL,201,2,'fa|201|2'),(3977,'fa',NULL,'kraft-takeaway-food-box',NULL,NULL,NULL,NULL,NULL,NULL,201,3,'fa|201|3'),(3978,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,201,23,'201|23'),(3979,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,201,24,'201|24'),(3980,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,201,28,'default|201|28'),(3981,'fa',NULL,'جعبه غذای بیرون‌بر کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,201,16,'fa|201|16'),(3982,'fa',NULL,'جعبه غذای بیرون‌بر کرافت, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,201,17,'fa|201|17'),(3983,'fa',NULL,'خرید عمده جعبه غذای بیرون‌بر کرافت. مقوای کرافت Food Grade با ابعاد سایزبندی تک‌نفره و خانوادگی. مناسب برنج، خوراک، غذای گرم و کترینگ. مشاهده مشخصات و استعلام',NULL,NULL,NULL,NULL,NULL,NULL,201,18,'fa|201|18'),(3984,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,201,11,'201|11'),(3985,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,201,12,'201|12'),(3986,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,201,29,'default|201|29'),(3987,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,201,5,'201|5'),(3988,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,201,6,'201|6'),(3989,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,201,7,'201|7'),(3990,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,201,8,'default|201|8'),(3991,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,201,26,'201|26'),(3992,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,201,22,'201|22'),(3993,'fa',NULL,'سطل سوخاری خانوادگی کرافت، مقوای Food Grade مقاوم به چربی، ابعاد ظرفیت خانوادگی. مناسب مرغ سوخاری، بال و فیله. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,202,9,'fa|202|9'),(3994,'fa',NULL,'<p>سطل مقوایی سوخاری با ظرفیت خانوادگی و فرم مناسب حمل و سرو سفارش‌های چندنفره.</p>\n<h2>مشخصات سطل سوخاری خانوادگی کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای Food Grade مقاوم به چربی</li>\n    <li><strong>ابعاد:</strong> ظرفیت خانوادگی</li>\n    <li><strong>کاربرد:</strong> مرغ سوخاری، بال و فیله</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سطل سوخاری خانوادگی کرافت، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,202,10,'fa|202|10'),(3995,NULL,NULL,'SP-FRIED-BUCKET',NULL,NULL,NULL,NULL,NULL,NULL,202,1,'202|1'),(3996,'fa',NULL,'سطل سوخاری خانوادگی کرافت',NULL,NULL,NULL,NULL,NULL,NULL,202,2,'fa|202|2'),(3997,'fa',NULL,'kraft-family-fried-chicken-bucket',NULL,NULL,NULL,NULL,NULL,NULL,202,3,'fa|202|3'),(3998,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,202,23,'202|23'),(3999,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,202,24,'202|24'),(4000,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,202,28,'default|202|28'),(4001,'fa',NULL,'سطل سوخاری خانوادگی کرافت | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,202,16,'fa|202|16'),(4002,'fa',NULL,'سطل سوخاری خانوادگی کرافت, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,202,17,'fa|202|17'),(4003,'fa',NULL,'خرید عمده سطل سوخاری خانوادگی کرافت. مقوای Food Grade مقاوم به چربی با ابعاد ظرفیت خانوادگی. مناسب مرغ سوخاری، بال و فیله. مشاهده مشخصات و استعلام قیمت از شمی',NULL,NULL,NULL,NULL,NULL,NULL,202,18,'fa|202|18'),(4004,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,202,11,'202|11'),(4005,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,202,12,'202|12'),(4006,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,202,29,'default|202|29'),(4007,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,202,5,'202|5'),(4008,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,202,6,'202|6'),(4009,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,202,7,'202|7'),(4010,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,202,8,'default|202|8'),(4011,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,202,26,'202|26'),(4012,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,202,22,'202|22'),(4013,'fa',NULL,'سفره یکبار مصرف رستورانی، پلی‌اتیلن بهداشتی، ابعاد رول استاندارد. مناسب رستوران، کترینگ، مراسم و سرو غذا. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,203,9,'fa|203|9'),(4014,'fa',NULL,'<p>سفره یکبار مصرف بهداشتی و مقاوم برای آماده‌سازی سریع میز و نظافت آسان‌تر.</p>\n<h2>مشخصات سفره یکبار مصرف رستورانی</h2>\n<ul>\n    <li><strong>جنس:</strong> پلی‌اتیلن بهداشتی</li>\n    <li><strong>ابعاد:</strong> رول استاندارد</li>\n    <li><strong>کاربرد:</strong> رستوران، کترینگ، مراسم و سرو غذا</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سفره یکبار مصرف رستورانی، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,203,10,'fa|203|10'),(4015,NULL,NULL,'SP-TABLECLOTH',NULL,NULL,NULL,NULL,NULL,NULL,203,1,'203|1'),(4016,'fa',NULL,'سفره یکبار مصرف رستورانی',NULL,NULL,NULL,NULL,NULL,NULL,203,2,'fa|203|2'),(4017,'fa',NULL,'restaurant-disposable-tablecloth',NULL,NULL,NULL,NULL,NULL,NULL,203,3,'fa|203|3'),(4018,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,203,23,'203|23'),(4019,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,203,24,'203|24'),(4020,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,203,28,'default|203|28'),(4021,'fa',NULL,'سفره یکبار مصرف رستورانی | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,203,16,'fa|203|16'),(4022,'fa',NULL,'سفره یکبار مصرف رستورانی, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,203,17,'fa|203|17'),(4023,'fa',NULL,'خرید عمده سفره یکبار مصرف رستورانی. پلی‌اتیلن بهداشتی با ابعاد رول استاندارد. مناسب رستوران، کترینگ، مراسم و سرو غذا. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,NULL,NULL,203,18,'fa|203|18'),(4024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,203,11,'203|11'),(4025,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,203,12,'203|12'),(4026,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,203,29,'default|203|29'),(4027,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,203,5,'203|5'),(4028,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,203,6,'203|6'),(4029,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,203,7,'203|7'),(4030,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,203,8,'default|203|8'),(4031,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,203,26,'203|26'),(4032,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,203,22,'203|22'),(4033,'fa',NULL,'سینگل زیر پیتزا مقوایی، مقوای فشرده Food Grade، ابعاد سایزهای ۲۴ تا ۳۲ سانتی‌متر. مناسب زیر پیتزا، سرو و تقویت کف جعبه. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,204,9,'fa|204|9'),(4034,'fa',NULL,'<p>سینگل زیر پیتزا برای سرو تمیزتر، جابه‌جایی آسان و جلوگیری از تغییر شکل کف جعبه.</p>\n<h2>مشخصات سینگل زیر پیتزا مقوایی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای فشرده Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای ۲۴ تا ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> زیر پیتزا، سرو و تقویت کف جعبه</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینگل زیر پیتزا مقوایی، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,204,10,'fa|204|10'),(4035,NULL,NULL,'SP-PIZZA-BOARD',NULL,NULL,NULL,NULL,NULL,NULL,204,1,'204|1'),(4036,'fa',NULL,'سینگل زیر پیتزا مقوایی',NULL,NULL,NULL,NULL,NULL,NULL,204,2,'fa|204|2'),(4037,'fa',NULL,'cardboard-pizza-board',NULL,NULL,NULL,NULL,NULL,NULL,204,3,'fa|204|3'),(4038,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,204,23,'204|23'),(4039,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,204,24,'204|24'),(4040,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,204,28,'default|204|28'),(4041,'fa',NULL,'سینگل زیر پیتزا مقوایی | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,204,16,'fa|204|16'),(4042,'fa',NULL,'سینگل زیر پیتزا مقوایی, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,204,17,'fa|204|17'),(4043,'fa',NULL,'خرید عمده سینگل زیر پیتزا مقوایی. مقوای فشرده Food Grade با ابعاد سایزهای ۲۴ تا ۳۲ سانتی‌متر. مناسب زیر پیتزا، سرو و تقویت کف جعبه. مشاهده مشخصات و استعلام قی',NULL,NULL,NULL,NULL,NULL,NULL,204,18,'fa|204|18'),(4044,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,204,11,'204|11'),(4045,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,204,12,'204|12'),(4046,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,204,29,'default|204|29'),(4047,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,204,5,'204|5'),(4048,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,204,6,'204|6'),(4049,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,204,7,'204|7'),(4050,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,204,8,'default|204|8'),(4051,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,204,26,'204|26'),(4052,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,204,22,'204|22'),(4053,'fa',NULL,'جالیوانی مقوایی دوخانه، خمیر کاغذ بازیافتی مقاوم، ابعاد دوخانه. مناسب حمل دو لیوان نوشیدنی گرم یا سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,205,9,'fa|205|9'),(4054,'fa',NULL,'<p>جالیوانی دوخانه با جای‌گیری پایدار لیوان‌ها برای تحویل امن سفارش‌های کافه.</p>\n<h2>مشخصات جالیوانی مقوایی دوخانه</h2>\n<ul>\n    <li><strong>جنس:</strong> خمیر کاغذ بازیافتی مقاوم</li>\n    <li><strong>ابعاد:</strong> دوخانه</li>\n    <li><strong>کاربرد:</strong> حمل دو لیوان نوشیدنی گرم یا سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جالیوانی مقوایی دوخانه، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,205,10,'fa|205|10'),(4055,NULL,NULL,'SP-CUP-CARRIER-2',NULL,NULL,NULL,NULL,NULL,NULL,205,1,'205|1'),(4056,'fa',NULL,'جالیوانی مقوایی دوخانه',NULL,NULL,NULL,NULL,NULL,NULL,205,2,'fa|205|2'),(4057,'fa',NULL,'two-cup-cardboard-carrier',NULL,NULL,NULL,NULL,NULL,NULL,205,3,'fa|205|3'),(4058,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,205,23,'205|23'),(4059,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,205,24,'205|24'),(4060,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,205,28,'default|205|28'),(4061,'fa',NULL,'جالیوانی مقوایی دوخانه | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,205,16,'fa|205|16'),(4062,'fa',NULL,'جالیوانی مقوایی دوخانه, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,205,17,'fa|205|17'),(4063,'fa',NULL,'خرید عمده جالیوانی مقوایی دوخانه. خمیر کاغذ بازیافتی مقاوم با ابعاد دوخانه. مناسب حمل دو لیوان نوشیدنی گرم یا سرد. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,NULL,NULL,205,18,'fa|205|18'),(4064,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,205,11,'205|11'),(4065,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,205,12,'205|12'),(4066,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,205,29,'default|205|29'),(4067,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,205,5,'205|5'),(4068,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,205,6,'205|6'),(4069,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,205,7,'205|7'),(4070,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,205,8,'default|205|8'),(4071,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,205,26,'205|26'),(4072,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,205,22,'205|22'),(4073,'fa',NULL,'سینی مقوایی حمل بستنی، مقوای ایندربرد Food Grade، ابعاد دو و چهار کاپ. مناسب حمل کاپ بستنی، دسر و نوشیدنی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.',NULL,NULL,NULL,NULL,NULL,NULL,206,9,'fa|206|9'),(4074,'fa',NULL,'<p>سینی مقوایی مخصوص حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی مجموعه.</p>\n<h2>مشخصات سینی مقوایی حمل بستنی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> دو و چهار کاپ</li>\n    <li><strong>کاربرد:</strong> حمل کاپ بستنی، دسر و نوشیدنی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینی مقوایی حمل بستنی، بسته بندی بستنی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>',NULL,NULL,NULL,NULL,NULL,NULL,206,10,'fa|206|10'),(4075,NULL,NULL,'SP-ICECREAM-TRAY',NULL,NULL,NULL,NULL,NULL,NULL,206,1,'206|1'),(4076,'fa',NULL,'سینی مقوایی حمل بستنی',NULL,NULL,NULL,NULL,NULL,NULL,206,2,'fa|206|2'),(4077,'fa',NULL,'cardboard-ice-cream-cup-tray',NULL,NULL,NULL,NULL,NULL,NULL,206,3,'fa|206|3'),(4078,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,206,23,'206|23'),(4079,NULL,NULL,NULL,NULL,40,NULL,NULL,NULL,NULL,206,24,'206|24'),(4080,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,206,28,'default|206|28'),(4081,'fa',NULL,'سینی مقوایی حمل بستنی | شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,206,16,'fa|206|16'),(4082,'fa',NULL,'سینی مقوایی حمل بستنی, بسته بندی بستنی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,206,17,'fa|206|17'),(4083,'fa',NULL,'خرید عمده سینی مقوایی حمل بستنی. مقوای ایندربرد Food Grade با ابعاد دو و چهار کاپ. مناسب حمل کاپ بستنی، دسر و نوشیدنی. مشاهده مشخصات و استعلام قیمت از شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,206,18,'fa|206|18'),(4084,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,206,11,'206|11'),(4085,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,206,12,'206|12'),(4086,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,206,29,'default|206|29'),(4087,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,206,5,'206|5'),(4088,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,206,6,'206|6'),(4089,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,206,7,'206|7'),(4090,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,206,8,'default|206|8'),(4091,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,206,26,'206|26'),(4092,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,206,22,'206|22'),(4093,'fa',NULL,'<p>جعبه سوخاری دو تیکه (۱۰۰ عدد)</p>\n<p>(۱۰۰ عدد)</p>',NULL,NULL,NULL,NULL,NULL,NULL,207,9,'fa|207|9'),(4094,'fa',NULL,'<p>جعبه سوخاری دو تیکه</p>\n<div class=\"bt-notranslate\">\n<div class=\"bt-notranslate\">\n<div style=\"width:32px;height:32px;\"> </div>\n</div>\n</div>\n<p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,207,10,'fa|207|10'),(4095,NULL,NULL,'100-100',NULL,NULL,NULL,NULL,NULL,NULL,207,1,'207|1'),(4096,'fa',NULL,'جعبه سوخاری دو تکه کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,207,2,'fa|207|2'),(4097,'fa',NULL,'جعبه-سوخاری-دو-تکه-کرافت-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,207,3,'fa|207|3'),(4098,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,4,'default|207|4'),(4099,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,207,23,'207|23'),(4100,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,24,'207|24'),(4101,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,25,'207|25'),(4102,NULL,NULL,'کپی-از-جعبه سوخاری دو تکه کرافت',NULL,NULL,NULL,NULL,NULL,NULL,207,27,'207|27'),(4103,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,207,28,'default|207|28'),(4104,'fa',NULL,'جعبه سوخاری دو تیکه (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,207,16,'fa|207|16'),(4105,'fa',NULL,'جعبه سوخاری دو تیکه',NULL,NULL,NULL,NULL,NULL,NULL,207,17,'fa|207|17'),(4106,'fa',NULL,'جعبه سوخاری دو تیکه عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,207,18,'fa|207|18'),(4107,NULL,NULL,NULL,NULL,NULL,1010000.0000,NULL,NULL,NULL,207,11,'207|11'),(4108,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,12,'207|12'),(4109,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,13,'207|13'),(4110,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,14,'default|207|14'),(4111,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,15,'default|207|15'),(4112,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,207,29,'default|207|29'),(4113,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,207,30,'default|207|30'),(4114,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,207,5,'207|5'),(4115,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,207,6,'207|6'),(4116,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,207,7,'207|7'),(4117,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,207,8,'default|207|8'),(4118,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,207,26,'207|26'),(4119,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,207,19,'207|19'),(4120,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,207,20,'207|20'),(4121,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,207,21,'207|21'),(4122,NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,207,22,'207|22'),(4123,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,208,9,'fa|208|9'),(4124,'fa',NULL,'<p>جعبه سوخاری دو تکه سفید با ساختار مقاوم و فضای مناسب برای سرو مرغ سوخاری؛ مناسب رستوران و سفارش بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,208,10,'fa|208|10'),(4125,NULL,NULL,'SP-FC-002-W-100',NULL,NULL,NULL,NULL,NULL,NULL,208,1,'208|1'),(4126,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,208,2,'fa|208|2'),(4127,'fa',NULL,'fried-chicken-box-2-piece-white-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,208,3,'fa|208|3'),(4128,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,208,28,'default|208|28'),(4129,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,208,16,'fa|208|16'),(4130,'fa',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,208,17,'fa|208|17'),(4131,'fa',NULL,'خرید عمده جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,208,18,'fa|208|18'),(4132,NULL,NULL,NULL,NULL,NULL,1010000.0000,NULL,NULL,NULL,208,11,'208|11'),(4133,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,208,12,'208|12'),(4134,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,208,29,'default|208|29'),(4135,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,208,5,'208|5'),(4136,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,208,6,'208|6'),(4137,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,208,7,'208|7'),(4138,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,208,8,'default|208|8'),(4139,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,208,26,'208|26'),(4140,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,208,22,'208|22'),(4141,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,208,23,'208|23'),(4142,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,208,24,'208|24'),(4143,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,209,9,'fa|209|9'),(4144,'fa',NULL,'<p>جعبه سه تکه سوخاری سفید با ابعاد کاربردی برای چیدمان منظم مرغ و حفظ ظاهر سفارش هنگام تحویل.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,209,10,'fa|209|10'),(4145,NULL,NULL,'SP-FC-003-W-100',NULL,NULL,NULL,NULL,NULL,NULL,209,1,'209|1'),(4146,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,209,2,'fa|209|2'),(4147,'fa',NULL,'fried-chicken-box-3-piece-white-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,209,3,'fa|209|3'),(4148,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,209,28,'default|209|28'),(4149,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,209,16,'fa|209|16'),(4150,'fa',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,209,17,'fa|209|17'),(4151,'fa',NULL,'خرید عمده جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,209,18,'fa|209|18'),(4152,NULL,NULL,NULL,NULL,NULL,1310000.0000,NULL,NULL,NULL,209,11,'209|11'),(4153,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,209,12,'209|12'),(4154,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,209,29,'default|209|29'),(4155,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,209,5,'209|5'),(4156,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,209,6,'209|6'),(4157,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,209,7,'209|7'),(4158,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,209,8,'default|209|8'),(4159,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,209,26,'209|26'),(4160,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,209,22,'209|22'),(4161,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,209,23,'209|23'),(4162,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,209,24,'209|24'),(4163,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,210,9,'fa|210|9'),(4164,'fa',NULL,'<p>جعبه پنج تکه سوخاری سفید با ارتفاع بیشتر، مناسب سفارش‌های خانوادگی و پک‌های چندتکه فست‌فود.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,210,10,'fa|210|10'),(4165,NULL,NULL,'SP-FC-005-W-100',NULL,NULL,NULL,NULL,NULL,NULL,210,1,'210|1'),(4166,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,210,2,'fa|210|2'),(4167,'fa',NULL,'fried-chicken-box-5-piece-white-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,210,3,'fa|210|3'),(4168,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,210,28,'default|210|28'),(4169,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,210,16,'fa|210|16'),(4170,'fa',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,210,17,'fa|210|17'),(4171,'fa',NULL,'خرید عمده جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,210,18,'fa|210|18'),(4172,NULL,NULL,NULL,NULL,NULL,1390000.0000,NULL,NULL,NULL,210,11,'210|11'),(4173,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,210,12,'210|12'),(4174,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,210,29,'default|210|29'),(4175,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,210,5,'210|5'),(4176,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,210,6,'210|6'),(4177,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,210,7,'210|7'),(4178,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,210,8,'default|210|8'),(4179,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,210,26,'210|26'),(4180,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,210,22,'210|22'),(4181,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,210,23,'210|23'),(4182,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,210,24,'210|24'),(4183,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,211,9,'fa|211|9'),(4184,'fa',NULL,'<p>باکس سوخاری دو تکه مشکی با چاپ جذاب و مقوای ۲۵۰ گرم برای ارائه حرفه‌ای سفارش‌های بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,211,10,'fa|211|10'),(4185,NULL,NULL,'SP-FC-002-B-100',NULL,NULL,NULL,NULL,NULL,NULL,211,1,'211|1'),(4186,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,211,2,'fa|211|2'),(4187,'fa',NULL,'fried-chicken-box-2-piece-black-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,211,3,'fa|211|3'),(4188,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,211,28,'default|211|28'),(4189,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,211,16,'fa|211|16'),(4190,'fa',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,211,17,'fa|211|17'),(4191,'fa',NULL,'خرید عمده جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,211,18,'fa|211|18'),(4192,NULL,NULL,NULL,NULL,NULL,1160000.0000,NULL,NULL,NULL,211,11,'211|11'),(4193,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,211,12,'211|12'),(4194,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,211,29,'default|211|29'),(4195,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,211,5,'211|5'),(4196,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,211,6,'211|6'),(4197,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,211,7,'211|7'),(4198,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,211,8,'default|211|8'),(4199,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,211,26,'211|26'),(4200,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,211,22,'211|22'),(4201,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,211,23,'211|23'),(4202,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,211,24,'211|24'),(4203,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,212,9,'fa|212|9'),(4204,'fa',NULL,'<p>جعبه سه تکه سوخاری مشکی مناسب رستوران‌هایی که بسته‌بندی تیره، مقاوم و متمایز می‌خواهند.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,212,10,'fa|212|10'),(4205,NULL,NULL,'SP-FC-003-B-100',NULL,NULL,NULL,NULL,NULL,NULL,212,1,'212|1'),(4206,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,212,2,'fa|212|2'),(4207,'fa',NULL,'fried-chicken-box-3-piece-black-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,212,3,'fa|212|3'),(4208,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,212,28,'default|212|28'),(4209,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,212,16,'fa|212|16'),(4210,'fa',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,212,17,'fa|212|17'),(4211,'fa',NULL,'خرید عمده جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,212,18,'fa|212|18'),(4212,NULL,NULL,NULL,NULL,NULL,1420000.0000,NULL,NULL,NULL,212,11,'212|11'),(4213,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,212,12,'212|12'),(4214,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,212,29,'default|212|29'),(4215,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,212,5,'212|5'),(4216,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,212,6,'212|6'),(4217,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,212,7,'212|7'),(4218,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,212,8,'default|212|8'),(4219,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,212,26,'212|26'),(4220,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,212,22,'212|22'),(4221,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,212,23,'212|23'),(4222,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,212,24,'212|24'),(4223,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,213,9,'fa|213|9'),(4224,'fa',NULL,'<p>جعبه پنج تکه سوخاری مشکی با ظرفیت بیشتر برای سفارش‌های خانوادگی، پک مرغ و غذای بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,213,10,'fa|213|10'),(4225,NULL,NULL,'SP-FC-005-B-100',NULL,NULL,NULL,NULL,NULL,NULL,213,1,'213|1'),(4226,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,213,2,'fa|213|2'),(4227,'fa',NULL,'fried-chicken-box-5-piece-black-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,213,3,'fa|213|3'),(4228,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,213,28,'default|213|28'),(4229,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,213,16,'fa|213|16'),(4230,'fa',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,213,17,'fa|213|17'),(4231,'fa',NULL,'خرید عمده جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,213,18,'fa|213|18'),(4232,NULL,NULL,NULL,NULL,NULL,1530000.0000,NULL,NULL,NULL,213,11,'213|11'),(4233,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,213,12,'213|12'),(4234,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,213,29,'default|213|29'),(4235,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,213,5,'213|5'),(4236,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,213,6,'213|6'),(4237,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,213,7,'213|7'),(4238,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,213,8,'default|213|8'),(4239,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,213,26,'213|26'),(4240,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,213,22,'213|22'),(4241,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,213,23,'213|23'),(4242,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,213,24,'213|24'),(4243,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,214,9,'fa|214|9'),(4244,'fa',NULL,'<p>جعبه سوخاری دسته‌دار سفید برای حمل آسان‌تر سفارش و تحویل مرتب غذا به مشتری.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,214,10,'fa|214|10'),(4245,NULL,NULL,'SP-FC-HANDLE-W-100',NULL,NULL,NULL,NULL,NULL,NULL,214,1,'214|1'),(4246,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,214,2,'fa|214|2'),(4247,'fa',NULL,'handled-fried-chicken-box-white-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,214,3,'fa|214|3'),(4248,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,214,28,'default|214|28'),(4249,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,214,16,'fa|214|16'),(4250,'fa',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,214,17,'fa|214|17'),(4251,'fa',NULL,'خرید عمده جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,214,18,'fa|214|18'),(4252,NULL,NULL,NULL,NULL,NULL,1790000.0000,NULL,NULL,NULL,214,11,'214|11'),(4253,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,214,12,'214|12'),(4254,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,214,29,'default|214|29'),(4255,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,214,5,'214|5'),(4256,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,214,6,'214|6'),(4257,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,214,7,'214|7'),(4258,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,214,8,'default|214|8'),(4259,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,214,26,'214|26'),(4260,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,214,22,'214|22'),(4261,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,214,23,'214|23'),(4262,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,214,24,'214|24'),(4263,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,215,9,'fa|215|9'),(4264,'fa',NULL,'<p>جعبه سوخاری دسته‌دار مشکی با ظاهر حرفه‌ای و ساختار مناسب حمل سفارش‌های فست‌فودی.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,215,10,'fa|215|10'),(4265,NULL,NULL,'SP-FC-HANDLE-B-100',NULL,NULL,NULL,NULL,NULL,NULL,215,1,'215|1'),(4266,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,215,2,'fa|215|2'),(4267,'fa',NULL,'handled-fried-chicken-box-black-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,215,3,'fa|215|3'),(4268,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,215,28,'default|215|28'),(4269,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,215,16,'fa|215|16'),(4270,'fa',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,215,17,'fa|215|17'),(4271,'fa',NULL,'خرید عمده جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,215,18,'fa|215|18'),(4272,NULL,NULL,NULL,NULL,NULL,2010000.0000,NULL,NULL,NULL,215,11,'215|11'),(4273,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,215,12,'215|12'),(4274,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,215,29,'default|215|29'),(4275,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,215,5,'215|5'),(4276,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,215,6,'215|6'),(4277,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,215,7,'215|7'),(4278,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,215,8,'default|215|8'),(4279,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,215,26,'215|26'),(4280,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,215,22,'215|22'),(4281,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,215,23,'215|23'),(4282,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,215,24,'215|24'),(4283,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,216,9,'fa|216|9'),(4284,'fa',NULL,'<p>جعبه سوخاری سفره‌ای کوچک که پس از بازشدن سطح مناسبی برای سرو مستقیم غذا فراهم می‌کند.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۹.۵ × ۱۵ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,216,10,'fa|216|10'),(4285,NULL,NULL,'SP-FC-TABLE-S-100',NULL,NULL,NULL,NULL,NULL,NULL,216,1,'216|1'),(4286,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,216,2,'fa|216|2'),(4287,'fa',NULL,'small-tabletop-fried-chicken-box-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,216,3,'fa|216|3'),(4288,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,216,28,'default|216|28'),(4289,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,216,16,'fa|216|16'),(4290,'fa',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,216,17,'fa|216|17'),(4291,'fa',NULL,'خرید عمده جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,216,18,'fa|216|18'),(4292,NULL,NULL,NULL,NULL,NULL,2340000.0000,NULL,NULL,NULL,216,11,'216|11'),(4293,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,216,12,'216|12'),(4294,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,216,29,'default|216|29'),(4295,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,216,5,'216|5'),(4296,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,216,6,'216|6'),(4297,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,216,7,'216|7'),(4298,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,216,8,'default|216|8'),(4299,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,216,26,'216|26'),(4300,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,216,22,'216|22'),(4301,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,216,23,'216|23'),(4302,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,216,24,'216|24'),(4303,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,217,9,'fa|217|9'),(4304,'fa',NULL,'<p>جعبه سوخاری سفره‌ای بزرگ برای پک‌های حجیم و سفارش‌های خانوادگی با امکان سرو آسان.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,217,10,'fa|217|10'),(4305,NULL,NULL,'SP-FC-TABLE-L-100',NULL,NULL,NULL,NULL,NULL,NULL,217,1,'217|1'),(4306,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,217,2,'fa|217|2'),(4307,'fa',NULL,'large-tabletop-fried-chicken-box-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,217,3,'fa|217|3'),(4308,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,217,28,'default|217|28'),(4309,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,217,16,'fa|217|16'),(4310,'fa',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,217,17,'fa|217|17'),(4311,'fa',NULL,'خرید عمده جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سف عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,217,18,'fa|217|18'),(4312,NULL,NULL,NULL,NULL,NULL,2950000.0000,NULL,NULL,NULL,217,11,'217|11'),(4313,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,217,12,'217|12'),(4314,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,217,29,'default|217|29'),(4315,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,217,5,'217|5'),(4316,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,217,6,'217|6'),(4317,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,217,7,'217|7'),(4318,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,217,8,'default|217|8'),(4319,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,217,26,'217|26'),(4320,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,217,22,'217|22'),(4321,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,217,23,'217|23'),(4322,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,217,24,'217|24'),(4323,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,218,9,'fa|218|9'),(4324,'fa',NULL,'<p>بشقاب مقوایی سوخاری قفل‌دار با لبه‌های بلند برای سرو مرتب و دسترسی آسان به غذا در سالن یا بیرون‌بر.</p>\n<h2>مشخصات بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۵ × ۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,218,10,'fa|218|10'),(4325,NULL,NULL,'SP-FC-PLATE-100',NULL,NULL,NULL,NULL,NULL,NULL,218,1,'218|1'),(4326,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,218,2,'fa|218|2'),(4327,'fa',NULL,'fried-chicken-locking-serving-plate-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,218,3,'fa|218|3'),(4328,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,218,28,'default|218|28'),(4329,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,218,16,'fa|218|16'),(4330,'fa',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,218,17,'fa|218|17'),(4331,'fa',NULL,'خرید عمده بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. مشاهده مشخ عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,218,18,'fa|218|18'),(4332,NULL,NULL,NULL,NULL,NULL,570000.0000,NULL,NULL,NULL,218,11,'218|11'),(4333,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,218,12,'218|12'),(4334,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,218,29,'default|218|29'),(4335,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,218,5,'218|5'),(4336,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,218,6,'218|6'),(4337,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,218,7,'218|7'),(4338,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,218,8,'default|218|8'),(4339,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,218,26,'218|26'),(4340,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,218,22,'218|22'),(4341,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,218,23,'218|23'),(4342,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,218,24,'218|24'),(4343,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,219,9,'fa|219|9'),(4344,'fa',NULL,'<p>جعبه سیب‌زمینی صندوقی کوچک با درب یکپارچه برای حمل تمیز، حفظ فرم و جلوگیری از پراکندگی محتویات.</p>\n<h2>مشخصات جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۸ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,219,10,'fa|219|10'),(4345,NULL,NULL,'SP-FF-BOX-100',NULL,NULL,NULL,NULL,NULL,NULL,219,1,'219|1'),(4346,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,219,2,'fa|219|2'),(4347,'fa',NULL,'small-carton-french-fries-box-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,219,3,'fa|219|3'),(4348,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,219,28,'default|219|28'),(4349,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,219,16,'fa|219|16'),(4350,'fa',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,219,17,'fa|219|17'),(4351,'fa',NULL,'خرید عمده جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود،  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,219,18,'fa|219|18'),(4352,NULL,NULL,NULL,NULL,NULL,690000.0000,NULL,NULL,NULL,219,11,'219|11'),(4353,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,219,12,'219|12'),(4354,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,219,29,'default|219|29'),(4355,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,219,5,'219|5'),(4356,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,219,6,'219|6'),(4357,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,219,7,'219|7'),(4358,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,219,8,'default|219|8'),(4359,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,219,26,'219|26'),(4360,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,219,22,'219|22'),(4361,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,219,23,'219|23'),(4362,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,219,24,'219|24'),(4363,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,220,9,'fa|220|9'),(4364,'fa',NULL,'<p>ظرف قایقی کوچک سیب‌زمینی برای سرو تک‌نفره، دسترسی سریع و نمایش بهتر محصول.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۵ × ۱۱.۵ × ۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,220,10,'fa|220|10'),(4365,NULL,NULL,'SP-FF-BOAT-S-100',NULL,NULL,NULL,NULL,NULL,NULL,220,1,'220|1'),(4366,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,220,2,'fa|220|2'),(4367,'fa',NULL,'small-boat-french-fries-tray-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,220,3,'fa|220|3'),(4368,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,220,28,'default|220|28'),(4369,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,220,16,'fa|220|16'),(4370,'fa',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,220,17,'fa|220|17'),(4371,'fa',NULL,'خرید عمده جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,220,18,'fa|220|18'),(4372,NULL,NULL,NULL,NULL,NULL,360000.0000,NULL,NULL,NULL,220,11,'220|11'),(4373,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,220,12,'220|12'),(4374,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,220,29,'default|220|29'),(4375,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,220,5,'220|5'),(4376,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,220,6,'220|6'),(4377,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,220,7,'220|7'),(4378,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,220,8,'default|220|8'),(4379,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,220,26,'220|26'),(4380,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,220,22,'220|22'),(4381,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,220,23,'220|23'),(4382,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,220,24,'220|24'),(4383,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,221,9,'fa|221|9'),(4384,'fa',NULL,'<p>ظرف قایقی بزرگ سیب‌زمینی برای پرس‌های حجیم‌تر، سیب‌زمینی ویژه و سرو اشتراکی.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۱.۵ × ۱۰ × ۶ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,221,10,'fa|221|10'),(4385,NULL,NULL,'SP-FF-BOAT-L-100',NULL,NULL,NULL,NULL,NULL,NULL,221,1,'221|1'),(4386,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,221,2,'fa|221|2'),(4387,'fa',NULL,'large-boat-french-fries-tray-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,221,3,'fa|221|3'),(4388,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,221,28,'default|221|28'),(4389,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,221,16,'fa|221|16'),(4390,'fa',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,221,17,'fa|221|17'),(4391,'fa',NULL,'خرید عمده جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,221,18,'fa|221|18'),(4392,NULL,NULL,NULL,NULL,NULL,510000.0000,NULL,NULL,NULL,221,11,'221|11'),(4393,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,221,12,'221|12'),(4394,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,221,29,'default|221|29'),(4395,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,221,5,'221|5'),(4396,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,221,6,'221|6'),(4397,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,221,7,'221|7'),(4398,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,221,8,'default|221|8'),(4399,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,221,26,'221|26'),(4400,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,221,22,'221|22'),(4401,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,221,23,'221|23'),(4402,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,221,24,'221|24'),(4403,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,222,9,'fa|222|9'),(4404,'fa',NULL,'<p>جعبه قیفی بلند سیب‌زمینی با فرم متمایز برای سرو ایستاده و ارائه جذاب در فست‌فود و رویداد.</p>\n<h2>مشخصات جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,222,10,'fa|222|10'),(4405,NULL,NULL,'SP-FF-CONE-100',NULL,NULL,NULL,NULL,NULL,NULL,222,1,'222|1'),(4406,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,222,2,'fa|222|2'),(4407,'fa',NULL,'cone-french-fries-box-250g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,222,3,'fa|222|3'),(4408,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,222,28,'default|222|28'),(4409,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,222,16,'fa|222|16'),(4410,'fa',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,222,17,'fa|222|17'),(4411,'fa',NULL,'خرید عمده جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فو عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,222,18,'fa|222|18'),(4412,NULL,NULL,NULL,NULL,NULL,830000.0000,NULL,NULL,NULL,222,11,'222|11'),(4413,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,222,12,'222|12'),(4414,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,222,29,'default|222|29'),(4415,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,222,5,'222|5'),(4416,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,222,6,'222|6'),(4417,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,222,7,'222|7'),(4418,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,222,8,'default|222|8'),(4419,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,222,26,'222|26'),(4420,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,222,22,'222|22'),(4421,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,222,23,'222|23'),(4422,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,222,24,'222|24'),(4423,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,223,9,'fa|223|9'),(4424,'fa',NULL,'<p>باکس سیب‌زمینی نیوکلاسیک با دهانه باز و فرم مدرن برای سرو حرفه‌ای و برندینگ فست‌فود.</p>\n<h2>مشخصات جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۴ × ۱۱ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,223,10,'fa|223|10'),(4425,NULL,NULL,'SP-FF-NEO-100',NULL,NULL,NULL,NULL,NULL,NULL,223,1,'223|1'),(4426,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,223,2,'fa|223|2'),(4427,'fa',NULL,'neo-classic-french-fries-box-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,223,3,'fa|223|3'),(4428,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,223,28,'default|223|28'),(4429,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,223,16,'fa|223|16'),(4430,'fa',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,223,17,'fa|223|17'),(4431,'fa',NULL,'خرید عمده جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ک عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,223,18,'fa|223|18'),(4432,NULL,NULL,NULL,NULL,NULL,930000.0000,NULL,NULL,NULL,223,11,'223|11'),(4433,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,223,12,'223|12'),(4434,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,223,29,'default|223|29'),(4435,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,223,5,'223|5'),(4436,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,223,6,'223|6'),(4437,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,223,7,'223|7'),(4438,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,223,8,'default|223|8'),(4439,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,223,26,'223|26'),(4440,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,223,22,'223|22'),(4441,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,223,23,'223|23'),(4442,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,223,24,'223|24'),(4443,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,224,9,'fa|224|9'),(4444,'fa',NULL,'<p>جعبه هرمی کوچک سیب‌زمینی برای پرس تک‌نفره با ظاهر خاص و اشغال فضای کم روی میز.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,224,10,'fa|224|10'),(4445,NULL,NULL,'SP-FF-PYRAMID-S-100',NULL,NULL,NULL,NULL,NULL,NULL,224,1,'224|1'),(4446,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,224,2,'fa|224|2'),(4447,'fa',NULL,'small-pyramid-french-fries-box-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,224,3,'fa|224|3'),(4448,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,224,28,'default|224|28'),(4449,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,224,16,'fa|224|16'),(4450,'fa',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,224,17,'fa|224|17'),(4451,'fa',NULL,'خرید عمده جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی  عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,224,18,'fa|224|18'),(4452,NULL,NULL,NULL,NULL,NULL,690000.0000,NULL,NULL,NULL,224,11,'224|11'),(4453,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,224,12,'224|12'),(4454,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,224,29,'default|224|29'),(4455,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,224,5,'224|5'),(4456,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,224,6,'224|6'),(4457,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,224,7,'224|7'),(4458,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,224,8,'default|224|8'),(4459,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,224,26,'224|26'),(4460,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,224,22,'224|22'),(4461,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,224,23,'224|23'),(4462,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,224,24,'224|24'),(4463,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,225,9,'fa|225|9'),(4464,'fa',NULL,'<p>جعبه هرمی بزرگ سیب‌زمینی با ظرفیت بیشتر برای پرس ویژه و ارائه متفاوت محصول.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,225,10,'fa|225|10'),(4465,NULL,NULL,'SP-FF-PYRAMID-L-100',NULL,NULL,NULL,NULL,NULL,NULL,225,1,'225|1'),(4466,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,225,2,'fa|225|2'),(4467,'fa',NULL,'large-pyramid-french-fries-box-230g-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,225,3,'fa|225|3'),(4468,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,225,28,'default|225|28'),(4469,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,225,16,'fa|225|16'),(4470,'fa',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,225,17,'fa|225|17'),(4471,'fa',NULL,'خرید عمده جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌ز عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,225,18,'fa|225|18'),(4472,NULL,NULL,NULL,NULL,NULL,940000.0000,NULL,NULL,NULL,225,11,'225|11'),(4473,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,225,12,'225|12'),(4474,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,225,29,'default|225|29'),(4475,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,225,5,'225|5'),(4476,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,225,6,'225|6'),(4477,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,225,7,'225|7'),(4478,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,225,8,'default|225|8'),(4479,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,225,26,'225|26'),(4480,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,225,22,'225|22'),(4481,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,225,23,'225|23'),(4482,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,225,24,'225|24'),(4483,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,226,9,'fa|226|9'),(4484,'fa',NULL,'<p>جعبه پیتزا نیم متری پارس با ساختار مقاوم دو رو کرافت و فضای مناسب برای پیتزاهای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری پارس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری پارس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,226,10,'fa|226|10'),(4485,NULL,NULL,'SP-PIZZA-50-PARS-100',NULL,NULL,NULL,NULL,NULL,NULL,226,1,'226|1'),(4486,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,226,2,'fa|226|2'),(4487,'fa',NULL,'pars-half-meter-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,226,3,'fa|226|3'),(4488,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,226,28,'default|226|28'),(4489,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,226,16,'fa|226|16'),(4490,'fa',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,226,17,'fa|226|17'),(4491,'fa',NULL,'خرید عمده جعبه پیتزا نیم متری پارس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌ب عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,226,18,'fa|226|18'),(4492,NULL,NULL,NULL,NULL,NULL,1920000.0000,NULL,NULL,NULL,226,11,'226|11'),(4493,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,226,12,'226|12'),(4494,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,226,29,'default|226|29'),(4495,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,226,5,'226|5'),(4496,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,226,6,'226|6'),(4497,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,226,7,'226|7'),(4498,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,226,8,'default|226|8'),(4499,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,226,26,'226|26'),(4500,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,226,22,'226|22'),(4501,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,226,23,'226|23'),(4502,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,226,24,'226|24'),(4503,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,227,9,'fa|227|9'),(4504,'fa',NULL,'<p>جعبه پیتزا نیم متری طاقدیس با مقوای ایفلوت مقاوم برای حمل مطمئن پیتزای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,227,10,'fa|227|10'),(4505,NULL,NULL,'SP-PIZZA-50-TAGHDIS-100',NULL,NULL,NULL,NULL,NULL,NULL,227,1,'227|1'),(4506,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,227,2,'fa|227|2'),(4507,'fa',NULL,'taghdis-half-meter-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,227,3,'fa|227|3'),(4508,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,227,28,'default|227|28'),(4509,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,227,16,'fa|227|16'),(4510,'fa',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,227,17,'fa|227|17'),(4511,'fa',NULL,'خرید عمده جعبه پیتزا نیم متری طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,227,18,'fa|227|18'),(4512,NULL,NULL,NULL,NULL,NULL,2060000.0000,NULL,NULL,NULL,227,11,'227|11'),(4513,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,227,12,'227|12'),(4514,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,227,29,'default|227|29'),(4515,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,227,5,'227|5'),(4516,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,227,6,'227|6'),(4517,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,227,7,'227|7'),(4518,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,227,8,'default|227|8'),(4519,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,227,26,'227|26'),(4520,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,227,22,'227|22'),(4521,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,227,23,'227|23'),(4522,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,227,24,'227|24'),(4523,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,228,9,'fa|228|9'),(4524,'fa',NULL,'<p>جعبه پیتزا ۳۲ سانتی طاقدیس با استحکام مناسب، ظاهر کرافت حرفه‌ای و فضای استاندارد پیتزا.</p>\n<h2>مشخصات جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۲ × ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,228,10,'fa|228|10'),(4525,NULL,NULL,'SP-PIZZA-32-TAGHDIS-100',NULL,NULL,NULL,NULL,NULL,NULL,228,1,'228|1'),(4526,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,228,2,'fa|228|2'),(4527,'fa',NULL,'taghdis-32cm-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,228,3,'fa|228|3'),(4528,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,228,28,'default|228|28'),(4529,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,228,16,'fa|228|16'),(4530,'fa',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,228,17,'fa|228|17'),(4531,'fa',NULL,'خرید عمده جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,228,18,'fa|228|18'),(4532,NULL,NULL,NULL,NULL,NULL,2510000.0000,NULL,NULL,NULL,228,11,'228|11'),(4533,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,228,12,'228|12'),(4534,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,228,29,'default|228|29'),(4535,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,228,5,'228|5'),(4536,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,228,6,'228|6'),(4537,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,228,7,'228|7'),(4538,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,228,8,'default|228|8'),(4539,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,228,26,'228|26'),(4540,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,228,22,'228|22'),(4541,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,228,23,'228|23'),(4542,NULL,NULL,NULL,NULL,9,NULL,NULL,NULL,NULL,228,24,'228|24'),(4543,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,229,9,'fa|229|9'),(4544,'fa',NULL,'<p>جعبه پیتزا ۳۰ سانتی طاقدیس، مناسب پیتزای استاندارد با ساختار ایفلوت و مقاومت مناسب حمل.</p>\n<h2>مشخصات جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۰ × ۳۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,229,10,'fa|229|10'),(4545,NULL,NULL,'SP-PIZZA-30-TAGHDIS-100',NULL,NULL,NULL,NULL,NULL,NULL,229,1,'229|1'),(4546,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,229,2,'fa|229|2'),(4547,'fa',NULL,'taghdis-30cm-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,229,3,'fa|229|3'),(4548,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,229,28,'default|229|28'),(4549,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,229,16,'fa|229|16'),(4550,'fa',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,229,17,'fa|229|17'),(4551,'fa',NULL,'خرید عمده جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,229,18,'fa|229|18'),(4552,NULL,NULL,NULL,NULL,NULL,2270000.0000,NULL,NULL,NULL,229,11,'229|11'),(4553,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,229,12,'229|12'),(4554,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,229,29,'default|229|29'),(4555,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,229,5,'229|5'),(4556,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,229,6,'229|6'),(4557,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,229,7,'229|7'),(4558,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,229,8,'default|229|8'),(4559,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,229,26,'229|26'),(4560,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,229,22,'229|22'),(4561,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,229,23,'229|23'),(4562,NULL,NULL,NULL,NULL,8,NULL,NULL,NULL,NULL,229,24,'229|24'),(4563,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,230,9,'fa|230|9'),(4564,'fa',NULL,'<p>جعبه پیتزا ۲۸ سانتی طاقدیس با ابعاد جمع‌وجور و مقوای کرافت ایفلوت مناسب ارسال.</p>\n<h2>مشخصات جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۸ × ۲۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,230,10,'fa|230|10'),(4565,NULL,NULL,'SP-PIZZA-28-TAGHDIS-100',NULL,NULL,NULL,NULL,NULL,NULL,230,1,'230|1'),(4566,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,230,2,'fa|230|2'),(4567,'fa',NULL,'taghdis-28cm-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,230,3,'fa|230|3'),(4568,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,230,28,'default|230|28'),(4569,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,230,16,'fa|230|16'),(4570,'fa',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,230,17,'fa|230|17'),(4571,'fa',NULL,'خرید عمده جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,230,18,'fa|230|18'),(4572,NULL,NULL,NULL,NULL,NULL,1870000.0000,NULL,NULL,NULL,230,11,'230|11'),(4573,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,230,12,'230|12'),(4574,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,230,29,'default|230|29'),(4575,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,230,5,'230|5'),(4576,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,230,6,'230|6'),(4577,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,230,7,'230|7'),(4578,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,230,8,'default|230|8'),(4579,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,230,26,'230|26'),(4580,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,230,22,'230|22'),(4581,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,230,23,'230|23'),(4582,NULL,NULL,NULL,NULL,7,NULL,NULL,NULL,NULL,230,24,'230|24'),(4583,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,231,9,'fa|231|9'),(4584,'fa',NULL,'<p>جعبه پیتزا ۲۴ سانتی طاقدیس برای پیتزای کوچک و تک‌نفره با حمل آسان و ظاهر کرافت.</p>\n<h2>مشخصات جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۲۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>',NULL,NULL,NULL,NULL,NULL,NULL,231,10,'fa|231|10'),(4585,NULL,NULL,'SP-PIZZA-24-TAGHDIS-100',NULL,NULL,NULL,NULL,NULL,NULL,231,1,'231|1'),(4586,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,231,2,'fa|231|2'),(4587,'fa',NULL,'taghdis-24cm-kraft-pizza-box-pack-100',NULL,NULL,NULL,NULL,NULL,NULL,231,3,'fa|231|3'),(4588,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,231,28,'default|231|28'),(4589,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)',NULL,NULL,NULL,NULL,NULL,NULL,231,16,'fa|231|16'),(4590,'fa',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک',NULL,NULL,NULL,NULL,NULL,NULL,231,17,'fa|231|17'),(4591,'fa',NULL,'خرید عمده جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. م عرضه در بسته ۱۰۰ عددی.',NULL,NULL,NULL,NULL,NULL,NULL,231,18,'fa|231|18'),(4592,NULL,NULL,NULL,NULL,NULL,1410000.0000,NULL,NULL,NULL,231,11,'231|11'),(4593,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,231,12,'231|12'),(4594,NULL,'default',NULL,0,NULL,NULL,NULL,NULL,NULL,231,29,'default|231|29'),(4595,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,231,5,'231|5'),(4596,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,231,6,'231|6'),(4597,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,231,7,'231|7'),(4598,NULL,'default',NULL,1,NULL,NULL,NULL,NULL,NULL,231,8,'default|231|8'),(4599,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,231,26,'231|26'),(4600,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,231,22,'231|22'),(4601,NULL,NULL,NULL,NULL,54,NULL,NULL,NULL,NULL,231,23,'231|23'),(4602,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,231,24,'231|24');
/*!40000 ALTER TABLE `product_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_option_products`
--

DROP TABLE IF EXISTS `product_bundle_option_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_option_products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `product_bundle_option_id` int unsigned NOT NULL,
  `qty` int NOT NULL DEFAULT '0',
  `is_user_defined` tinyint(1) NOT NULL DEFAULT '1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bundle_option_products_product_id_bundle_option_id_unique` (`product_id`,`product_bundle_option_id`),
  KEY `pbop_option_id_idx` (`product_bundle_option_id`),
  CONSTRAINT `product_bundle_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_bundle_option_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_option_products`
--

LOCK TABLES `product_bundle_option_products` WRITE;
/*!40000 ALTER TABLE `product_bundle_option_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_option_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_option_translations`
--

DROP TABLE IF EXISTS `product_bundle_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_option_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_bundle_option_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_bundle_option_translations_option_id_locale_unique` (`product_bundle_option_id`,`locale`),
  UNIQUE KEY `bundle_option_translations_locale_label_bundle_option_id_unique` (`locale`,`label`,`product_bundle_option_id`),
  CONSTRAINT `product_bundle_option_translations_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_option_translations`
--

LOCK TABLES `product_bundle_option_translations` WRITE;
/*!40000 ALTER TABLE `product_bundle_option_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_bundle_options`
--

DROP TABLE IF EXISTS `product_bundle_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_bundle_options` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_bundle_options_product_id_foreign` (`product_id`),
  CONSTRAINT `product_bundle_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_bundle_options`
--

LOCK TABLES `product_bundle_options` WRITE;
/*!40000 ALTER TABLE `product_bundle_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bundle_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_categories` (
  `product_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  UNIQUE KEY `product_categories_product_id_category_id_unique` (`product_id`,`category_id`),
  KEY `product_categories_category_id_foreign` (`category_id`),
  CONSTRAINT `product_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_categories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
INSERT INTO `product_categories` VALUES (152,43),(207,43),(158,49),(159,49),(160,49),(161,49),(162,49),(163,49),(164,49),(165,49),(166,49),(167,49),(168,49),(202,49),(208,49),(209,49),(210,49),(211,49),(212,49),(213,49),(214,49),(215,49),(216,49),(217,49),(218,49),(158,50),(159,50),(160,50),(161,50),(162,50),(163,50),(208,50),(209,50),(210,50),(211,50),(212,50),(213,50),(164,51),(165,51),(214,51),(215,51),(166,52),(167,52),(168,52),(216,52),(217,52),(218,52),(169,53),(170,53),(171,53),(172,53),(173,53),(174,53),(175,53),(219,53),(220,53),(221,53),(222,53),(223,53),(224,53),(225,53),(169,54),(219,54),(170,55),(171,55),(220,55),(221,55),(172,56),(173,56),(174,56),(175,56),(222,56),(223,56),(224,56),(225,56),(176,57),(177,57),(178,58),(179,58),(180,58),(181,58),(182,58),(183,58),(204,58),(226,58),(227,58),(228,58),(229,58),(230,58),(231,58),(180,59),(181,59),(182,59),(183,59),(228,59),(229,59),(230,59),(231,59),(178,60),(179,60),(226,60),(227,60),(184,61),(185,62),(186,63),(187,64),(188,65),(206,65),(189,66),(190,67),(191,68),(192,69),(193,70),(194,71),(195,72),(186,73),(187,73),(205,73),(196,74),(197,74),(198,75),(199,75),(200,76),(201,77),(202,78),(203,79),(204,80),(189,81),(190,81),(193,81),(205,82),(206,83);
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_channels`
--

DROP TABLE IF EXISTS `product_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_channels` (
  `product_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  UNIQUE KEY `product_channels_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_channels_channel_id_foreign` (`channel_id`),
  KEY `pc_product_id_channel_id_idx` (`product_id`,`channel_id`),
  CONSTRAINT `product_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_channels_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_channels`
--

LOCK TABLES `product_channels` WRITE;
/*!40000 ALTER TABLE `product_channels` DISABLE KEYS */;
INSERT INTO `product_channels` VALUES (152,1),(158,1),(159,1),(160,1),(161,1),(162,1),(163,1),(164,1),(165,1),(166,1),(167,1),(168,1),(169,1),(170,1),(171,1),(172,1),(173,1),(174,1),(175,1),(176,1),(177,1),(178,1),(179,1),(180,1),(181,1),(182,1),(183,1),(184,1),(185,1),(186,1),(187,1),(188,1),(189,1),(190,1),(191,1),(192,1),(193,1),(194,1),(195,1),(196,1),(197,1),(198,1),(199,1),(200,1),(201,1),(202,1),(203,1),(204,1),(205,1),(206,1),(207,1),(208,1),(209,1),(210,1),(211,1),(212,1),(213,1),(214,1),(215,1),(216,1),(217,1),(218,1),(219,1),(220,1),(221,1),(222,1),(223,1),(224,1),(225,1),(226,1),(227,1),(228,1),(229,1),(230,1),(231,1);
/*!40000 ALTER TABLE `product_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_cross_sells`
--

DROP TABLE IF EXISTS `product_cross_sells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_cross_sells` (
  `parent_id` int unsigned NOT NULL,
  `child_id` int unsigned NOT NULL,
  UNIQUE KEY `product_cross_sells_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_cross_sells_child_id_foreign` (`child_id`),
  CONSTRAINT `product_cross_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_cross_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_cross_sells`
--

LOCK TABLES `product_cross_sells` WRITE;
/*!40000 ALTER TABLE `product_cross_sells` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_cross_sells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customer_group_prices`
--

DROP TABLE IF EXISTS `product_customer_group_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customer_group_prices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `qty` int NOT NULL DEFAULT '0',
  `value_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `unique_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_customer_group_prices_unique_id_unique` (`unique_id`),
  KEY `product_customer_group_prices_product_id_foreign` (`product_id`),
  KEY `product_customer_group_prices_customer_group_id_foreign` (`customer_group_id`),
  CONSTRAINT `product_customer_group_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_customer_group_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customer_group_prices`
--

LOCK TABLES `product_customer_group_prices` WRITE;
/*!40000 ALTER TABLE `product_customer_group_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customer_group_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_option_prices`
--

DROP TABLE IF EXISTS `product_customizable_option_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_option_prices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `label` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_customizable_option_id` int unsigned NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pcop_product_customizable_option_id_foreign` (`product_customizable_option_id`),
  CONSTRAINT `pcop_product_customizable_option_id_foreign` FOREIGN KEY (`product_customizable_option_id`) REFERENCES `product_customizable_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_option_prices`
--

LOCK TABLES `product_customizable_option_prices` WRITE;
/*!40000 ALTER TABLE `product_customizable_option_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_option_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_option_translations`
--

DROP TABLE IF EXISTS `product_customizable_option_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_option_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci,
  `product_customizable_option_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_customizable_option_id_locale_unique` (`product_customizable_option_id`,`locale`),
  CONSTRAINT `pcot_product_customizable_option_id_foreign` FOREIGN KEY (`product_customizable_option_id`) REFERENCES `product_customizable_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_option_translations`
--

LOCK TABLES `product_customizable_option_translations` WRITE;
/*!40000 ALTER TABLE `product_customizable_option_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_option_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_customizable_options`
--

DROP TABLE IF EXISTS `product_customizable_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_customizable_options` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `max_characters` text COLLATE utf8mb4_unicode_ci,
  `supported_file_extensions` text COLLATE utf8mb4_unicode_ci,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_customizable_options_product_id_foreign` (`product_id`),
  CONSTRAINT `product_customizable_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_customizable_options`
--

LOCK TABLES `product_customizable_options` WRITE;
/*!40000 ALTER TABLE `product_customizable_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_customizable_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_link_translations`
--

DROP TABLE IF EXISTS `product_downloadable_link_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_link_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_downloadable_link_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `link_translations_link_id_foreign` (`product_downloadable_link_id`),
  CONSTRAINT `link_translations_link_id_foreign` FOREIGN KEY (`product_downloadable_link_id`) REFERENCES `product_downloadable_links` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_link_translations`
--

LOCK TABLES `product_downloadable_link_translations` WRITE;
/*!40000 ALTER TABLE `product_downloadable_link_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_link_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_links`
--

DROP TABLE IF EXISTS `product_downloadable_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_links` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sample_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `downloads` int NOT NULL DEFAULT '0',
  `sort_order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_downloadable_links_product_id_foreign` (`product_id`),
  CONSTRAINT `product_downloadable_links_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_links`
--

LOCK TABLES `product_downloadable_links` WRITE;
/*!40000 ALTER TABLE `product_downloadable_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_sample_translations`
--

DROP TABLE IF EXISTS `product_downloadable_sample_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_sample_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_downloadable_sample_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `sample_translations_sample_id_foreign` (`product_downloadable_sample_id`),
  CONSTRAINT `sample_translations_sample_id_foreign` FOREIGN KEY (`product_downloadable_sample_id`) REFERENCES `product_downloadable_samples` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_sample_translations`
--

LOCK TABLES `product_downloadable_sample_translations` WRITE;
/*!40000 ALTER TABLE `product_downloadable_sample_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_sample_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_downloadable_samples`
--

DROP TABLE IF EXISTS `product_downloadable_samples`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_downloadable_samples` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_downloadable_samples_product_id_foreign` (`product_id`),
  CONSTRAINT `product_downloadable_samples_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_downloadable_samples`
--

LOCK TABLES `product_downloadable_samples` WRITE;
/*!40000 ALTER TABLE `product_downloadable_samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_downloadable_samples` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_flat`
--

DROP TABLE IF EXISTS `product_flat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_flat` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_description` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `url_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new` tinyint(1) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `meta_title` text COLLATE utf8mb4_unicode_ci,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,4) DEFAULT NULL,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` date DEFAULT NULL,
  `special_price_to` date DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attribute_family_id` int unsigned DEFAULT NULL,
  `product_id` int unsigned NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `visible_individually` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_flat_unique_index` (`product_id`,`channel`,`locale`),
  KEY `product_flat_attribute_family_id_foreign` (`attribute_family_id`),
  KEY `product_flat_parent_id_foreign` (`parent_id`),
  CONSTRAINT `product_flat_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `product_flat_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_flat_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_flat`
--

LOCK TABLES `product_flat` WRITE;
/*!40000 ALTER TABLE `product_flat` DISABLE KEYS */;
INSERT INTO `product_flat` VALUES (152,'100','simple','سوخاری دو تیکه',NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,101000.0000,NULL,NULL,NULL,1.0000,'2026-08-15 18:28:04','en','default',1,152,'2026-08-16 15:42:11',NULL,1),(153,'100','simple','جعبه سوخاری دو تکه کرافت','جعبه سوخاری دو تکه کرافت','<p>جعبه سوخاری دو تیکه (۱۰۰ عدد)</p>','<p>جعبه سوخاری دو تیکه</p>\n<div class=\"bt-notranslate\">\n<div class=\"bt-notranslate\">\n<div style=\"width:32px;height:32px;\"> </div>\n</div>\n</div>','جعبه-سوخاری-دو-تکه-کرافت',1,1,1,'جعبه سوخاری دو تیکه','جعبه سوخاری دو تیکه','جعبه سوخاری دو تیکه',10100.0000,NULL,NULL,NULL,1.0000,'2026-08-15 18:43:12','fa','default',1,152,'2026-08-21 15:49:51',NULL,1),(160,'SP-FC-002-W','simple',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم','جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سوخاری دو تکه سفید با ساختار مقاوم و فضای مناسب برای سرو مرغ سوخاری؛ مناسب رستوران و سفارش بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-2-piece-white-230g',1,1,1,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',10100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:53:18','fa','default',1,158,'2026-08-21 13:18:12',NULL,1),(161,'SP-FC-003-W','simple',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم','جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سه تکه سوخاری سفید با ابعاد کاربردی برای چیدمان منظم مرغ و حفظ ظاهر سفارش هنگام تحویل.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-3-piece-white-230g',1,0,1,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو',13100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:23','fa','default',1,159,'2026-08-21 13:18:12',NULL,1),(162,'SP-FC-005-W','simple',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم','جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پنج تکه سوخاری سفید با ارتفاع بیشتر، مناسب سفارش‌های خانوادگی و پک‌های چندتکه فست‌فود.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-5-piece-white-230g',1,0,1,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب',13900.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:24','fa','default',1,160,'2026-08-21 13:18:12',NULL,1),(163,'SP-FC-002-B','simple',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم','جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>باکس سوخاری دو تکه مشکی با چاپ جذاب و مقوای ۲۵۰ گرم برای ارائه حرفه‌ای سفارش‌های بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-2-piece-black-250g',1,0,1,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',11600.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:25','fa','default',1,161,'2026-08-21 13:18:12',NULL,1),(164,'SP-FC-003-B','simple',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم','جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سه تکه سوخاری مشکی مناسب رستوران‌هایی که بسته‌بندی تیره، مقاوم و متمایز می‌خواهند.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-3-piece-black-250g',1,0,1,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو',14200.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:27','fa','default',1,162,'2026-08-21 13:18:12',NULL,1),(165,'SP-FC-005-B','simple',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم','جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پنج تکه سوخاری مشکی با ظرفیت بیشتر برای سفارش‌های خانوادگی، پک مرغ و غذای بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-box-5-piece-black-250g',1,0,1,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب',15300.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:28','fa','default',1,163,'2026-08-21 13:18:12',NULL,1),(166,'SP-FC-HANDLE-W','simple',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم','جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سوخاری دسته‌دار سفید برای حمل آسان‌تر سفارش و تحویل مرتب غذا به مشتری.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','handled-fried-chicken-box-white-230g',1,0,1,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',17900.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:29','fa','default',1,164,'2026-08-21 13:18:12',NULL,1),(167,'SP-FC-HANDLE-B','simple',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم','جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سوخاری دسته‌دار مشکی با ظاهر حرفه‌ای و ساختار مناسب حمل سفارش‌های فست‌فودی.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','handled-fried-chicken-box-black-250g',1,1,1,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',20100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:30','fa','default',1,165,'2026-08-21 13:18:12',NULL,1),(168,'SP-FC-TABLE-S','simple',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم','جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سوخاری سفره‌ای کوچک که پس از بازشدن سطح مناسبی برای سرو مستقیم غذا فراهم می‌کند.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۹.۵ × ۱۵ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','small-tabletop-fried-chicken-box-250g',1,0,1,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ',23400.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:30','fa','default',1,166,'2026-08-21 13:18:12',NULL,1),(169,'SP-FC-TABLE-L','simple',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم','جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سوخاری سفره‌ای بزرگ برای پک‌های حجیم و سفارش‌های خانوادگی با امکان سرو آسان.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','large-tabletop-fried-chicken-box-250g',1,0,1,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سف',29500.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:32','fa','default',1,167,'2026-08-21 13:18:12',NULL,1),(170,'SP-FC-PLATE','simple',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم','بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>بشقاب مقوایی سوخاری قفل‌دار با لبه‌های بلند برای سرو مرتب و دسترسی آسان به غذا در سالن یا بیرون‌بر.</p>\n<h2>مشخصات بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۵ × ۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','fried-chicken-locking-serving-plate-250g',1,0,1,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم | شمیم پک','بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. مشاهده مشخ',5700.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:33','fa','default',1,168,'2026-08-21 13:18:12',NULL,1),(171,'SP-FF-BOX','simple',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم','جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه سیب‌زمینی صندوقی کوچک با درب یکپارچه برای حمل تمیز، حفظ فرم و جلوگیری از پراکندگی محتویات.</p>\n<h2>مشخصات جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۸ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','small-carton-french-fries-box-230g',1,0,1,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ',6900.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:34','fa','default',1,169,'2026-08-21 13:18:12',NULL,1),(172,'SP-FF-BOAT-S','simple',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم','جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>ظرف قایقی کوچک سیب‌زمینی برای سرو تک‌نفره، دسترسی سریع و نمایش بهتر محصول.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۵ × ۱۱.۵ × ۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','small-boat-french-fries-tray-230g',1,0,1,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود',3600.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:34','fa','default',1,170,'2026-08-21 13:18:12',NULL,1),(173,'SP-FF-BOAT-L','simple',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم','جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>ظرف قایقی بزرگ سیب‌زمینی برای پرس‌های حجیم‌تر، سیب‌زمینی ویژه و سرو اشتراکی.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۱.۵ × ۱۰ × ۶ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','large-boat-french-fries-tray-230g',1,1,1,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود',5100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:35','fa','default',1,171,'2026-08-21 13:18:12',NULL,1),(174,'SP-FF-CONE','simple',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم','جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه قیفی بلند سیب‌زمینی با فرم متمایز برای سرو ایستاده و ارائه جذاب در فست‌فود و رویداد.</p>\n<h2>مشخصات جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','cone-french-fries-box-250g',1,0,1,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم | شمیم پک','جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فو',8300.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:36','fa','default',1,172,'2026-08-21 13:18:12',NULL,1),(175,'SP-FF-NEO','simple',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم','جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>باکس سیب‌زمینی نیوکلاسیک با دهانه باز و فرم مدرن برای سرو حرفه‌ای و برندینگ فست‌فود.</p>\n<h2>مشخصات جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۴ × ۱۱ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','neo-classic-french-fries-box-230g',1,0,1,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ک',9300.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:37','fa','default',1,173,'2026-08-21 13:18:12',NULL,1),(176,'SP-FF-PYRAMID-S','simple',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم','جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه هرمی کوچک سیب‌زمینی برای پرس تک‌نفره با ظاهر خاص و اشغال فضای کم روی میز.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','small-pyramid-french-fries-box-230g',1,0,1,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی ',6900.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:38','fa','default',1,174,'2026-08-21 13:18:12',NULL,1),(177,'SP-FF-PYRAMID-L','simple',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم','جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه هرمی بزرگ سیب‌زمینی با ظرفیت بیشتر برای پرس ویژه و ارائه متفاوت محصول.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','large-pyramid-french-fries-box-230g',1,0,1,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک','جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌ز',9400.0000,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:38','fa','default',1,175,'2026-08-21 13:18:12',NULL,1),(178,'SP-PAPER-2535','simple',NULL,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر','کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر، کاغذ کرافت، ابعاد ۲۵ × ۳۵ سانتی‌متر. مناسب پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>کاغذ کرافت ساندویچ سایز ۲۵ در ۳۵ برای بسته‌بندی جمع‌وجور برگر، ساندویچ و میان‌وعده.</p>\n<h2>مشخصات کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۳۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-sandwich-paper-25x35',1,0,1,'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر | شمیم پک','کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر. کاغذ کرافت با ابعاد ۲۵ × ۳۵ سانتی‌متر. مناسب پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر. مشاهده مشخصات و ا',NULL,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:39','fa','default',1,176,'2026-08-21 13:18:12',NULL,1),(179,'SP-PAPER-3550','simple',NULL,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر','کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر، کاغذ کرافت، ابعاد ۳۵ × ۵۰ سانتی‌متر. مناسب پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>کاغذ کرافت ساندویچ سایز ۳۵ در ۵۰ برای بسته‌بندی محصولات بزرگ‌تر و پوشش کامل‌تر غذا.</p>\n<h2>مشخصات کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت</li>\n    <li><strong>ابعاد:</strong> ۳۵ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-sandwich-paper-35x50',1,1,1,'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر | شمیم پک','کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر. کاغذ کرافت با ابعاد ۳۵ × ۵۰ سانتی‌متر. مناسب پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر. مشاهده مشخصا',NULL,NULL,NULL,NULL,0.0000,'2026-08-19 18:55:40','fa','default',1,177,'2026-08-21 13:18:12',NULL,1),(180,'SP-PIZZA-50-PARS','simple',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت','جعبه پیتزا نیم متری پارس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا نیم متری پارس با ساختار مقاوم دو رو کرافت و فضای مناسب برای پیتزاهای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری پارس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری پارس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','pars-half-meter-kraft-pizza-box',1,0,1,'جعبه پیتزا نیم متری پارس دو رو کرافت | شمیم پک','جعبه پیتزا نیم متری پارس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا نیم متری پارس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌ب',19200.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:18','fa','default',1,178,'2026-08-21 13:18:12',NULL,1),(181,'SP-PIZZA-50-TAGHDIS','simple',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت','جعبه پیتزا نیم متری طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا نیم متری طاقدیس با مقوای ایفلوت مقاوم برای حمل مطمئن پیتزای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','taghdis-half-meter-kraft-pizza-box',1,0,1,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت | شمیم پک','جعبه پیتزا نیم متری طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا نیم متری طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون',20600.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:18','fa','default',1,179,'2026-08-21 13:18:12',NULL,1),(182,'SP-PIZZA-32-TAGHDIS','simple',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت','جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا ۳۲ سانتی طاقدیس با استحکام مناسب، ظاهر کرافت حرفه‌ای و فضای استاندارد پیتزا.</p>\n<h2>مشخصات جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۲ × ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','taghdis-32cm-kraft-pizza-box',1,0,1,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت | شمیم پک','جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. مشاهده',25100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:19','fa','default',1,180,'2026-08-21 13:18:12',NULL,1),(183,'SP-PIZZA-30-TAGHDIS','simple',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت','جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا ۳۰ سانتی طاقدیس، مناسب پیتزای استاندارد با ساختار ایفلوت و مقاومت مناسب حمل.</p>\n<h2>مشخصات جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۰ × ۳۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','taghdis-30cm-kraft-pizza-box',1,0,1,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت | شمیم پک','جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. مشاهده',22700.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:19','fa','default',1,181,'2026-08-21 13:18:12',NULL,1),(184,'SP-PIZZA-28-TAGHDIS','simple',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت','جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا ۲۸ سانتی طاقدیس با ابعاد جمع‌وجور و مقوای کرافت ایفلوت مناسب ارسال.</p>\n<h2>مشخصات جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۸ × ۲۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','taghdis-28cm-kraft-pizza-box',1,0,1,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت | شمیم پک','جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. مشاهده',18700.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:20','fa','default',1,182,'2026-08-21 13:18:12',NULL,1),(185,'SP-PIZZA-24-TAGHDIS','simple',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت','جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.','<p>جعبه پیتزا ۲۴ سانتی طاقدیس برای پیتزای کوچک و تک‌نفره با حمل آسان و ظاهر کرافت.</p>\n<h2>مشخصات جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۲۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','taghdis-24cm-kraft-pizza-box',1,0,1,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت | شمیم پک','جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. م',14100.0000,NULL,NULL,NULL,0.0000,'2026-08-19 19:26:20','fa','default',1,183,'2026-08-21 13:18:12',NULL,1),(186,'SP-BAG-KRAFT','simple',NULL,'پاکت کرافت بیرون‌بر دسته‌دار','پاکت کرافت بیرون‌بر دسته‌دار، کاغذ کرافت Food Grade، ابعاد سایزبندی متنوع. مناسب حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>پاکت کرافت مقاوم با دسته یکپارچه برای تحویل مرتب سفارش و امکان چاپ اختصاصی لوگوی مجموعه.</p>\n<h2>مشخصات پاکت کرافت بیرون‌بر دسته‌دار</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پاکت کرافت بیرون‌بر دسته‌دار، پاکت بیرون بر، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-takeaway-carry-bag',1,0,1,'پاکت کرافت بیرون‌بر دسته‌دار | شمیم پک','پاکت کرافت بیرون‌بر دسته‌دار, پاکت بیرون بر, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده پاکت کرافت بیرون‌بر دسته‌دار. کاغذ کرافت Food Grade با ابعاد سایزبندی متنوع. مناسب حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه. مشاهده مشخصات و استعل',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:46','fa','default',1,184,'2026-08-21 13:18:12',NULL,1),(187,'SP-CUTLERY-WOOD','simple',NULL,'پک چوبی قاشق چنگال کارد و دستمال','پک چوبی قاشق چنگال کارد و دستمال، چوب بهداشتی و لفاف شفاف، ابعاد پک تک‌نفره. مناسب سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>پک کامل و بهداشتی قاشق، چنگال، کارد و دستمال برای تکمیل سفارش‌های بیرون‌بر و پذیرایی حرفه‌ای.</p>\n<h2>مشخصات پک چوبی قاشق چنگال کارد و دستمال</h2>\n<ul>\n    <li><strong>جنس:</strong> چوب بهداشتی و لفاف شفاف</li>\n    <li><strong>ابعاد:</strong> پک تک‌نفره</li>\n    <li><strong>کاربرد:</strong> سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پک چوبی قاشق چنگال کارد و دستمال، پک قاشق و چنگال، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','wooden-cutlery-pack',1,0,1,'پک چوبی قاشق چنگال کارد و دستمال | شمیم پک','پک چوبی قاشق چنگال کارد و دستمال, پک قاشق و چنگال, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده پک چوبی قاشق چنگال کارد و دستمال. چوب بهداشتی و لفاف شفاف با ابعاد پک تک‌نفره. مناسب سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی. مشاهده مشخصات و استع',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:46','fa','default',1,185,'2026-08-21 13:18:12',NULL,1),(188,'SP-CUP-PAPER','simple',NULL,'لیوان کاغذی یک‌بارمصرف درب‌دار','لیوان کاغذی یک‌بارمصرف درب‌دار، کاغذ مخصوص نوشیدنی Food Grade، ابعاد سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر. مناسب قهوه، چای، دمنوش و نوشیدنی گرم. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>لیوان کاغذی مقاوم با امکان انتخاب درب و چاپ اختصاصی، مناسب کافه، رستوران و رویداد.</p>\n<h2>مشخصات لیوان کاغذی یک‌بارمصرف درب‌دار</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ مخصوص نوشیدنی Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر</li>\n    <li><strong>کاربرد:</strong> قهوه، چای، دمنوش و نوشیدنی گرم</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> لیوان کاغذی یک‌بارمصرف درب‌دار، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','disposable-paper-cup-with-lid',1,0,1,'لیوان کاغذی یک‌بارمصرف درب‌دار | شمیم پک','لیوان کاغذی یک‌بارمصرف درب‌دار, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده لیوان کاغذی یک‌بارمصرف درب‌دار. کاغذ مخصوص نوشیدنی Food Grade با ابعاد سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر. مناسب قهوه، چای، دمنوش و نوشیدنی گرم. مشاهده مش',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:47','fa','default',1,186,'2026-08-21 13:18:12',NULL,1),(189,'SP-CUP-PLASTIC','simple',NULL,'لیوان شفاف یک‌بارمصرف درب گنبدی','لیوان شفاف یک‌بارمصرف درب گنبدی، پلاستیک شفاف Food Grade، ابعاد سایزبندی متنوع. مناسب آبمیوه، شیک، اسموتی و نوشیدنی سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>لیوان شفاف با درب گنبدی برای نمایش بهتر نوشیدنی و حمل مطمئن سفارش‌های سرد.</p>\n<h2>مشخصات لیوان شفاف یک‌بارمصرف درب گنبدی</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> آبمیوه، شیک، اسموتی و نوشیدنی سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> لیوان شفاف یک‌بارمصرف درب گنبدی، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','clear-plastic-cup-dome-lid',1,0,1,'لیوان شفاف یک‌بارمصرف درب گنبدی | شمیم پک','لیوان شفاف یک‌بارمصرف درب گنبدی, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده لیوان شفاف یک‌بارمصرف درب گنبدی. پلاستیک شفاف Food Grade با ابعاد سایزبندی متنوع. مناسب آبمیوه، شیک، اسموتی و نوشیدنی سرد. مشاهده مشخصات و استعلام ق',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:47','fa','default',1,187,'2026-08-21 13:18:12',NULL,1),(190,'SP-ICECREAM-CUP','simple',NULL,'کاپ کاغذی بستنی و دسر','کاپ کاغذی بستنی و دسر، کاغذ روکش‌دار Food Grade، ابعاد سایزهای تک‌نفره و خانوادگی. مناسب بستنی، دسر، ژله و خوراکی سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>کاپ کاغذی مستحکم برای سرو بستنی و دسر با قابلیت سفارش درب و چاپ اختصاصی برند.</p>\n<h2>مشخصات کاپ کاغذی بستنی و دسر</h2>\n<ul>\n    <li><strong>جنس:</strong> کاغذ روکش‌دار Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای تک‌نفره و خانوادگی</li>\n    <li><strong>کاربرد:</strong> بستنی، دسر، ژله و خوراکی سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاپ کاغذی بستنی و دسر، بسته بندی بستنی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','paper-ice-cream-dessert-cup',1,0,1,'کاپ کاغذی بستنی و دسر | شمیم پک','کاپ کاغذی بستنی و دسر, بسته بندی بستنی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده کاپ کاغذی بستنی و دسر. کاغذ روکش‌دار Food Grade با ابعاد سایزهای تک‌نفره و خانوادگی. مناسب بستنی، دسر، ژله و خوراکی سرد. مشاهده مشخصات و استعلام قیم',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:47','fa','default',1,188,'2026-08-21 13:18:13',NULL,1),(191,'SP-SALAD-CLEAR','simple',NULL,'ظرف شفاف درب‌دار سالاد','ظرف شفاف درب‌دار سالاد، پلاستیک شفاف Food Grade، ابعاد سایزبندی متنوع. مناسب سالاد، میوه، سبزیجات و غذای سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>ظرف شفاف درب‌دار با نمایش کامل محتویات و بسته‌شدن مطمئن برای سفارش‌های سرد و بیرون‌بر.</p>\n<h2>مشخصات ظرف شفاف درب‌دار سالاد</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> سالاد، میوه، سبزیجات و غذای سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ظرف شفاف درب‌دار سالاد، ظرف سالاد یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','clear-salad-container-with-lid',1,0,1,'ظرف شفاف درب‌دار سالاد | شمیم پک','ظرف شفاف درب‌دار سالاد, ظرف سالاد یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده ظرف شفاف درب‌دار سالاد. پلاستیک شفاف Food Grade با ابعاد سایزبندی متنوع. مناسب سالاد، میوه، سبزیجات و غذای سرد. مشاهده مشخصات و استعلام قیمت از شمیم',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:47','fa','default',1,189,'2026-08-21 13:18:13',NULL,1),(192,'SP-SAUCE-CUP','simple',NULL,'کاپ شفاف درب‌دار سس','کاپ شفاف درب‌دار سس، پلاستیک شفاف Food Grade، ابعاد سایزهای کوچک. مناسب سس، چاشنی، ترشی و دورچین. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>کاپ کوچک درب‌دار برای بسته‌بندی بهداشتی سس و چاشنی در سفارش‌های رستورانی و فست‌فودی.</p>\n<h2>مشخصات کاپ شفاف درب‌دار سس</h2>\n<ul>\n    <li><strong>جنس:</strong> پلاستیک شفاف Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای کوچک</li>\n    <li><strong>کاربرد:</strong> سس، چاشنی، ترشی و دورچین</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> کاپ شفاف درب‌دار سس، ظرف سس یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','clear-sauce-cup-with-lid',1,0,1,'کاپ شفاف درب‌دار سس | شمیم پک','کاپ شفاف درب‌دار سس, ظرف سس یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده کاپ شفاف درب‌دار سس. پلاستیک شفاف Food Grade با ابعاد سایزهای کوچک. مناسب سس، چاشنی، ترشی و دورچین. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:48','fa','default',1,190,'2026-08-21 13:18:13',NULL,1),(193,'SP-STRAW-SKEWER','simple',NULL,'پک نی و سیخ چوبی یک‌بارمصرف','پک نی و سیخ چوبی یک‌بارمصرف، چوب و کاغذ بهداشتی، ابعاد سایزبندی متنوع. مناسب نوشیدنی، فینگرفود، کباب و پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>مجموعه نی و سیخ چوبی سازگار با سرو حرفه‌ای کافه، رستوران، فست‌فود و مراسم.</p>\n<h2>مشخصات پک نی و سیخ چوبی یک‌بارمصرف</h2>\n<ul>\n    <li><strong>جنس:</strong> چوب و کاغذ بهداشتی</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> نوشیدنی، فینگرفود، کباب و پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پک نی و سیخ چوبی یک‌بارمصرف، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','disposable-straws-wooden-skewers',1,0,1,'پک نی و سیخ چوبی یک‌بارمصرف | شمیم پک','پک نی و سیخ چوبی یک‌بارمصرف, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده پک نی و سیخ چوبی یک‌بارمصرف. چوب و کاغذ بهداشتی با ابعاد سایزبندی متنوع. مناسب نوشیدنی، فینگرفود، کباب و پذیرایی. مشاهده مشخصات و استعلام قیمت از شم',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:48','fa','default',1,191,'2026-08-21 13:18:13',NULL,1),(194,'SP-NUTS-POUCH','simple',NULL,'پاکت کرافت پنجره‌دار آجیل و خشکبار','پاکت کرافت پنجره‌دار آجیل و خشکبار، کرافت چندلایه Food Grade، ابعاد سایزبندی متنوع. مناسب آجیل، خشکبار، قهوه، ادویه و تنقلات. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>پاکت کرافت ایستاده با پنجره شفاف برای نمایش محصول، نگهداری بهتر و امکان چاپ اختصاصی برند.</p>\n<h2>مشخصات پاکت کرافت پنجره‌دار آجیل و خشکبار</h2>\n<ul>\n    <li><strong>جنس:</strong> کرافت چندلایه Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> آجیل، خشکبار، قهوه، ادویه و تنقلات</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> پاکت کرافت پنجره‌دار آجیل و خشکبار، بسته بندی آجیل و خشکبار، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-window-nuts-pouch',1,0,1,'پاکت کرافت پنجره‌دار آجیل و خشکبار | شمیم پک','پاکت کرافت پنجره‌دار آجیل و خشکبار, بسته بندی آجیل و خشکبار, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده پاکت کرافت پنجره‌دار آجیل و خشکبار. کرافت چندلایه Food Grade با ابعاد سایزبندی متنوع. مناسب آجیل، خشکبار، قهوه، ادویه و تنقلات. مشاهده مشخصات و استع',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:48','fa','default',1,192,'2026-08-21 13:18:13',NULL,1),(195,'SP-MICROWAVE-BOX','simple',NULL,'ظرف مشکی مایکروویوی درب شفاف','ظرف مشکی مایکروویوی درب شفاف، پلی‌پروپیلن Food Grade، ابعاد تک‌خانه و چندخانه. مناسب غذای گرم، برنج، خوراک و سفارش بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>ظرف مقاوم در برابر حرارت با درب شفاف و بسته‌شدن مطمئن، مناسب ارسال و گرم‌کردن غذا.</p>\n<h2>مشخصات ظرف مشکی مایکروویوی درب شفاف</h2>\n<ul>\n    <li><strong>جنس:</strong> پلی‌پروپیلن Food Grade</li>\n    <li><strong>ابعاد:</strong> تک‌خانه و چندخانه</li>\n    <li><strong>کاربرد:</strong> غذای گرم، برنج، خوراک و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ظرف مشکی مایکروویوی درب شفاف، ظرف مایکروویوی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','black-microwave-container-clear-lid',1,0,1,'ظرف مشکی مایکروویوی درب شفاف | شمیم پک','ظرف مشکی مایکروویوی درب شفاف, ظرف مایکروویوی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده ظرف مشکی مایکروویوی درب شفاف. پلی‌پروپیلن Food Grade با ابعاد تک‌خانه و چندخانه. مناسب غذای گرم، برنج، خوراک و سفارش بیرون‌بر. مشاهده مشخصات و استعل',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:49','fa','default',1,193,'2026-08-21 13:18:13',NULL,1),(196,'SP-FOOD-TRAY','simple',NULL,'سینی کرافت سرو غذای یک‌بارمصرف','سینی کرافت سرو غذای یک‌بارمصرف، مقوای کرافت Food Grade، ابعاد سایزبندی متنوع. مناسب سیب‌زمینی، سوخاری، ساندویچ و فینگرفود. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>سینی کرافت با لبه‌های مقاوم برای سرو تمیز و حرفه‌ای انواع غذا و میان‌وعده.</p>\n<h2>مشخصات سینی کرافت سرو غذای یک‌بارمصرف</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی متنوع</li>\n    <li><strong>کاربرد:</strong> سیب‌زمینی، سوخاری، ساندویچ و فینگرفود</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینی کرافت سرو غذای یک‌بارمصرف، سینی سرو غذا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-disposable-food-serving-tray',1,0,1,'سینی کرافت سرو غذای یک‌بارمصرف | شمیم پک','سینی کرافت سرو غذای یک‌بارمصرف, سینی سرو غذا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده سینی کرافت سرو غذای یک‌بارمصرف. مقوای کرافت Food Grade با ابعاد سایزبندی متنوع. مناسب سیب‌زمینی، سوخاری، ساندویچ و فینگرفود. مشاهده مشخصات و استعلام',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:49','fa','default',1,194,'2026-08-21 13:18:13',NULL,1),(197,'SP-NAPKIN-HOLDER','simple',NULL,'جا دستمالی کرافت رومیزی','جا دستمالی کرافت رومیزی، مقوای کرافت مقاوم، ابعاد رومیزی استاندارد. مناسب رستوران، کافه، فست‌فود و کانتر پذیرایی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جا دستمالی رومیزی کرافت با ظاهر مینیمال برای نظم میز و هماهنگی با بسته‌بندی‌های دوستدار محیط زیست.</p>\n<h2>مشخصات جا دستمالی کرافت رومیزی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت مقاوم</li>\n    <li><strong>ابعاد:</strong> رومیزی استاندارد</li>\n    <li><strong>کاربرد:</strong> رستوران، کافه، فست‌فود و کانتر پذیرایی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جا دستمالی کرافت رومیزی، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-tabletop-napkin-holder',1,0,1,'جا دستمالی کرافت رومیزی | شمیم پک','جا دستمالی کرافت رومیزی, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جا دستمالی کرافت رومیزی. مقوای کرافت مقاوم با ابعاد رومیزی استاندارد. مناسب رستوران، کافه، فست‌فود و کانتر پذیرایی. مشاهده مشخصات و استعلام قیمت از ',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 00:01:49','fa','default',1,195,'2026-08-21 13:18:13',NULL,1),(198,'SP-BURGER-CLAMSHELL','simple',NULL,'جعبه برگر صدفی کرافت','جعبه برگر صدفی کرافت، مقوای کرافت Food Grade، ابعاد ۱۲ × ۱۲ × ۸ سانتی‌متر. مناسب همبرگر، چیزبرگر و سفارش بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جعبه برگر صدفی با درب یکپارچه و فضای استاندارد برای جلوگیری از فشرده‌شدن برگر.</p>\n<h2>مشخصات جعبه برگر صدفی کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> همبرگر، چیزبرگر و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه برگر صدفی کرافت، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-clamshell-burger-box',1,0,1,'جعبه برگر صدفی کرافت | شمیم پک','جعبه برگر صدفی کرافت, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه برگر صدفی کرافت. مقوای کرافت Food Grade با ابعاد ۱۲ × ۱۲ × ۸ سانتی‌متر. مناسب همبرگر، چیزبرگر و سفارش بیرون‌بر. مشاهده مشخصات و استعلام قیمت از',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:09','fa','default',1,196,'2026-08-21 13:18:13',NULL,1),(199,'SP-BURGER-LOCK','simple',NULL,'جعبه برگر لاک‌باتوم ایندربرد','جعبه برگر لاک‌باتوم ایندربرد، مقوای ایندربرد Food Grade، ابعاد ۱۳ × ۱۳ × ۸ سانتی‌متر. مناسب برگر ویژه، دوبل و فست‌فود بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جعبه برگر لاک‌باتوم با کف قفل‌شونده و استحکام مناسب برای حمل سفارش.</p>\n<h2>مشخصات جعبه برگر لاک‌باتوم ایندربرد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> ۱۳ × ۱۳ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> برگر ویژه، دوبل و فست‌فود بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه برگر لاک‌باتوم ایندربرد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','lock-bottom-burger-box',1,0,1,'جعبه برگر لاک‌باتوم ایندربرد | شمیم پک','جعبه برگر لاک‌باتوم ایندربرد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه برگر لاک‌باتوم ایندربرد. مقوای ایندربرد Food Grade با ابعاد ۱۳ × ۱۳ × ۸ سانتی‌متر. مناسب برگر ویژه، دوبل و فست‌فود بیرون‌بر. مشاهده مشخصات و اس',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:09','fa','default',1,197,'2026-08-21 13:18:13',NULL,1),(200,'SP-SANDWICH-KRAFT','simple',NULL,'جعبه ساندویچ کرافت استاندارد','جعبه ساندویچ کرافت استاندارد، مقوای کرافت Food Grade، ابعاد ۲۴ × ۹ × ۷ سانتی‌متر. مناسب ساندویچ، هات‌داگ و غذای بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جعبه ساندویچ کرافت با طول استاندارد برای حفظ فرم نان و چیدمان منظم محتویات.</p>\n<h2>مشخصات جعبه ساندویچ کرافت استاندارد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۹ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> ساندویچ، هات‌داگ و غذای بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه ساندویچ کرافت استاندارد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','standard-kraft-sandwich-box',1,0,1,'جعبه ساندویچ کرافت استاندارد | شمیم پک','جعبه ساندویچ کرافت استاندارد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه ساندویچ کرافت استاندارد. مقوای کرافت Food Grade با ابعاد ۲۴ × ۹ × ۷ سانتی‌متر. مناسب ساندویچ، هات‌داگ و غذای بیرون‌بر. مشاهده مشخصات و استعلام ',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:10','fa','default',1,198,'2026-08-21 13:18:13',NULL,1),(201,'SP-SANDWICH-DRAWER','simple',NULL,'جعبه ساندویچ کشویی ایندربرد','جعبه ساندویچ کشویی ایندربرد، مقوای ایندربرد Food Grade، ابعاد ۲۵ × ۱۰ × ۷ سانتی‌متر. مناسب ساندویچ ویژه و هات‌داگ بیرون‌بر. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جعبه کشویی ساندویچ با بازشدن آسان و ظاهر حرفه‌ای مناسب چاپ اختصاصی برند.</p>\n<h2>مشخصات جعبه ساندویچ کشویی ایندربرد</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۰ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> ساندویچ ویژه و هات‌داگ بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه ساندویچ کشویی ایندربرد، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','drawer-sandwich-box',1,0,1,'جعبه ساندویچ کشویی ایندربرد | شمیم پک','جعبه ساندویچ کشویی ایندربرد, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه ساندویچ کشویی ایندربرد. مقوای ایندربرد Food Grade با ابعاد ۲۵ × ۱۰ × ۷ سانتی‌متر. مناسب ساندویچ ویژه و هات‌داگ بیرون‌بر. مشاهده مشخصات و استعلا',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:10','fa','default',1,199,'2026-08-21 13:18:13',NULL,1),(202,'SP-SACHET-SPICE','simple',NULL,'ساشه ادویه تک‌نفره','ساشه ادویه تک‌نفره، لفاف چندلایه بهداشتی، ابعاد پک تک‌نفره. مناسب نمک، فلفل، آویشن و ادویه مخصوص. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>ساشه ادویه تک‌نفره بهداشتی برای تکمیل سفارش رستوران و امکان چاپ اختصاصی.</p>\n<h2>مشخصات ساشه ادویه تک‌نفره</h2>\n<ul>\n    <li><strong>جنس:</strong> لفاف چندلایه بهداشتی</li>\n    <li><strong>ابعاد:</strong> پک تک‌نفره</li>\n    <li><strong>کاربرد:</strong> نمک، فلفل، آویشن و ادویه مخصوص</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> ساشه ادویه تک‌نفره، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','single-serve-spice-sachet',1,0,1,'ساشه ادویه تک‌نفره | شمیم پک','ساشه ادویه تک‌نفره, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده ساشه ادویه تک‌نفره. لفاف چندلایه بهداشتی با ابعاد پک تک‌نفره. مناسب نمک، فلفل، آویشن و ادویه مخصوص. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:10','fa','default',1,200,'2026-08-21 13:18:13',NULL,1),(203,'SP-FOOD-TAKEAWAY','simple',NULL,'جعبه غذای بیرون‌بر کرافت','جعبه غذای بیرون‌بر کرافت، مقوای کرافت Food Grade، ابعاد سایزبندی تک‌نفره و خانوادگی. مناسب برنج، خوراک، غذای گرم و کترینگ. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جعبه غذای کرافت مقاوم برای ارسال منظم غذای گرم و سفارش‌های رستورانی.</p>\n<h2>مشخصات جعبه غذای بیرون‌بر کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای کرافت Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزبندی تک‌نفره و خانوادگی</li>\n    <li><strong>کاربرد:</strong> برنج، خوراک، غذای گرم و کترینگ</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه غذای بیرون‌بر کرافت، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-takeaway-food-box',1,0,1,'جعبه غذای بیرون‌بر کرافت | شمیم پک','جعبه غذای بیرون‌بر کرافت, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه غذای بیرون‌بر کرافت. مقوای کرافت Food Grade با ابعاد سایزبندی تک‌نفره و خانوادگی. مناسب برنج، خوراک، غذای گرم و کترینگ. مشاهده مشخصات و استعلام',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:11','fa','default',1,201,'2026-08-21 13:18:13',NULL,1),(204,'SP-FRIED-BUCKET','simple',NULL,'سطل سوخاری خانوادگی کرافت','سطل سوخاری خانوادگی کرافت، مقوای Food Grade مقاوم به چربی، ابعاد ظرفیت خانوادگی. مناسب مرغ سوخاری، بال و فیله. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>سطل مقوایی سوخاری با ظرفیت خانوادگی و فرم مناسب حمل و سرو سفارش‌های چندنفره.</p>\n<h2>مشخصات سطل سوخاری خانوادگی کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای Food Grade مقاوم به چربی</li>\n    <li><strong>ابعاد:</strong> ظرفیت خانوادگی</li>\n    <li><strong>کاربرد:</strong> مرغ سوخاری، بال و فیله</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سطل سوخاری خانوادگی کرافت، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','kraft-family-fried-chicken-bucket',1,0,1,'سطل سوخاری خانوادگی کرافت | شمیم پک','سطل سوخاری خانوادگی کرافت, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده سطل سوخاری خانوادگی کرافت. مقوای Food Grade مقاوم به چربی با ابعاد ظرفیت خانوادگی. مناسب مرغ سوخاری، بال و فیله. مشاهده مشخصات و استعلام قیمت از شمی',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:11','fa','default',1,202,'2026-08-21 13:18:13',NULL,1),(205,'SP-TABLECLOTH','simple',NULL,'سفره یکبار مصرف رستورانی','سفره یکبار مصرف رستورانی، پلی‌اتیلن بهداشتی، ابعاد رول استاندارد. مناسب رستوران، کترینگ، مراسم و سرو غذا. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>سفره یکبار مصرف بهداشتی و مقاوم برای آماده‌سازی سریع میز و نظافت آسان‌تر.</p>\n<h2>مشخصات سفره یکبار مصرف رستورانی</h2>\n<ul>\n    <li><strong>جنس:</strong> پلی‌اتیلن بهداشتی</li>\n    <li><strong>ابعاد:</strong> رول استاندارد</li>\n    <li><strong>کاربرد:</strong> رستوران، کترینگ، مراسم و سرو غذا</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سفره یکبار مصرف رستورانی، کاغذ ساندویچ، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','restaurant-disposable-tablecloth',1,0,1,'سفره یکبار مصرف رستورانی | شمیم پک','سفره یکبار مصرف رستورانی, کاغذ ساندویچ, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده سفره یکبار مصرف رستورانی. پلی‌اتیلن بهداشتی با ابعاد رول استاندارد. مناسب رستوران، کترینگ، مراسم و سرو غذا. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:12','fa','default',1,203,'2026-08-21 13:18:13',NULL,1),(206,'SP-PIZZA-BOARD','simple',NULL,'سینگل زیر پیتزا مقوایی','سینگل زیر پیتزا مقوایی، مقوای فشرده Food Grade، ابعاد سایزهای ۲۴ تا ۳۲ سانتی‌متر. مناسب زیر پیتزا، سرو و تقویت کف جعبه. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>سینگل زیر پیتزا برای سرو تمیزتر، جابه‌جایی آسان و جلوگیری از تغییر شکل کف جعبه.</p>\n<h2>مشخصات سینگل زیر پیتزا مقوایی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای فشرده Food Grade</li>\n    <li><strong>ابعاد:</strong> سایزهای ۲۴ تا ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> زیر پیتزا، سرو و تقویت کف جعبه</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینگل زیر پیتزا مقوایی، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','cardboard-pizza-board',1,0,1,'سینگل زیر پیتزا مقوایی | شمیم پک','سینگل زیر پیتزا مقوایی, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده سینگل زیر پیتزا مقوایی. مقوای فشرده Food Grade با ابعاد سایزهای ۲۴ تا ۳۲ سانتی‌متر. مناسب زیر پیتزا، سرو و تقویت کف جعبه. مشاهده مشخصات و استعلام قی',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:12','fa','default',1,204,'2026-08-21 13:18:13',NULL,1),(207,'SP-CUP-CARRIER-2','simple',NULL,'جالیوانی مقوایی دوخانه','جالیوانی مقوایی دوخانه، خمیر کاغذ بازیافتی مقاوم، ابعاد دوخانه. مناسب حمل دو لیوان نوشیدنی گرم یا سرد. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>جالیوانی دوخانه با جای‌گیری پایدار لیوان‌ها برای تحویل امن سفارش‌های کافه.</p>\n<h2>مشخصات جالیوانی مقوایی دوخانه</h2>\n<ul>\n    <li><strong>جنس:</strong> خمیر کاغذ بازیافتی مقاوم</li>\n    <li><strong>ابعاد:</strong> دوخانه</li>\n    <li><strong>کاربرد:</strong> حمل دو لیوان نوشیدنی گرم یا سرد</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جالیوانی مقوایی دوخانه، لیوان یک بار مصرف، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','two-cup-cardboard-carrier',1,0,1,'جالیوانی مقوایی دوخانه | شمیم پک','جالیوانی مقوایی دوخانه, لیوان یک بار مصرف, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جالیوانی مقوایی دوخانه. خمیر کاغذ بازیافتی مقاوم با ابعاد دوخانه. مناسب حمل دو لیوان نوشیدنی گرم یا سرد. مشاهده مشخصات و استعلام قیمت از شمیم پک.',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:12','fa','default',1,205,'2026-08-21 13:18:13',NULL,1),(208,'SP-ICECREAM-TRAY','simple',NULL,'سینی مقوایی حمل بستنی','سینی مقوایی حمل بستنی، مقوای ایندربرد Food Grade، ابعاد دو و چهار کاپ. مناسب حمل کاپ بستنی، دسر و نوشیدنی. برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.','<p>سینی مقوایی مخصوص حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی مجموعه.</p>\n<h2>مشخصات سینی مقوایی حمل بستنی</h2>\n<ul>\n    <li><strong>جنس:</strong> مقوای ایندربرد Food Grade</li>\n    <li><strong>ابعاد:</strong> دو و چهار کاپ</li>\n    <li><strong>کاربرد:</strong> حمل کاپ بستنی، دسر و نوشیدنی</li>\n    <li><strong>نوع فروش:</strong> عمده و استعلام قیمت</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> سینی مقوایی حمل بستنی، بسته بندی بستنی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p>','cardboard-ice-cream-cup-tray',1,0,1,'سینی مقوایی حمل بستنی | شمیم پک','سینی مقوایی حمل بستنی, بسته بندی بستنی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده سینی مقوایی حمل بستنی. مقوای ایندربرد Food Grade با ابعاد دو و چهار کاپ. مناسب حمل کاپ بستنی، دسر و نوشیدنی. مشاهده مشخصات و استعلام قیمت از شمیم پک',NULL,NULL,NULL,NULL,0.0000,'2026-08-20 21:03:13','fa','default',1,206,'2026-08-21 13:18:13',NULL,1),(209,'100','simple','سوخاری دو تیکه',NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,101000.0000,NULL,NULL,NULL,1.0000,'2026-08-21 13:16:58','en','default',1,207,'2026-08-21 13:16:58',NULL,1),(210,'100-100','simple','کپی-از-جعبه سوخاری دو تکه کرافت','جعبه سوخاری دو تکه کرافت (۱۰۰ عدد)','<p>جعبه سوخاری دو تیکه (۱۰۰ عدد)</p>\n<p>(۱۰۰ عدد)</p>','<p>جعبه سوخاری دو تیکه</p>\n<div class=\"bt-notranslate\">\n<div class=\"bt-notranslate\">\n<div style=\"width:32px;height:32px;\"> </div>\n</div>\n</div>\n<p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','جعبه-سوخاری-دو-تکه-کرافت-pack-100',1,1,1,'جعبه سوخاری دو تیکه (۱۰۰ عدد)','جعبه سوخاری دو تیکه','جعبه سوخاری دو تیکه عرضه در بسته ۱۰۰ عددی.',1010000.0000,NULL,NULL,NULL,1.0000,'2026-08-21 13:16:58','fa','default',1,207,'2026-08-21 15:49:30',NULL,1),(211,'SP-FC-002-W-100','simple',NULL,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سوخاری دو تکه سفید با ساختار مقاوم و فضای مناسب برای سرو مرغ سوخاری؛ مناسب رستوران و سفارش بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-2-piece-white-230g-pack-100',1,1,1,'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',1010000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:16:59','fa','default',1,208,'2026-08-21 13:18:13',NULL,1),(212,'SP-FC-003-W-100','simple',NULL,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سه تکه سوخاری سفید با ابعاد کاربردی برای چیدمان منظم مرغ و حفظ ظاهر سفارش هنگام تحویل.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-3-piece-white-230g-pack-100',1,0,1,'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو عرضه در بسته ۱۰۰ عددی.',1310000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:16:59','fa','default',1,209,'2026-08-21 13:18:13',NULL,1),(213,'SP-FC-005-W-100','simple',NULL,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پنج تکه سوخاری سفید با ارتفاع بیشتر، مناسب سفارش‌های خانوادگی و پک‌های چندتکه فست‌فود.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-5-piece-white-230g-pack-100',1,0,1,'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب عرضه در بسته ۱۰۰ عددی.',1390000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:00','fa','default',1,210,'2026-08-21 13:18:13',NULL,1),(214,'SP-FC-002-B-100','simple',NULL,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>باکس سوخاری دو تکه مشکی با چاپ جذاب و مقوای ۲۵۰ گرم برای ارائه حرفه‌ای سفارش‌های بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-2-piece-black-250g-pack-100',1,0,1,'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',1160000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:01','fa','default',1,211,'2026-08-21 13:18:13',NULL,1),(215,'SP-FC-003-B-100','simple',NULL,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سه تکه سوخاری مشکی مناسب رستوران‌هایی که بسته‌بندی تیره، مقاوم و متمایز می‌خواهند.</p>\n<h2>مشخصات جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-3-piece-black-250g-pack-100',1,0,1,'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۸ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرو عرضه در بسته ۱۰۰ عددی.',1420000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:01','fa','default',1,212,'2026-08-21 13:18:13',NULL,1),(216,'SP-FC-005-B-100','simple',NULL,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پنج تکه سوخاری مشکی با ظرفیت بیشتر برای سفارش‌های خانوادگی، پک مرغ و غذای بیرون‌بر.</p>\n<h2>مشخصات جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-box-5-piece-black-250g-pack-100',1,0,1,'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش ب عرضه در بسته ۱۰۰ عددی.',1530000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:01','fa','default',1,213,'2026-08-21 13:18:13',NULL,1),(217,'SP-FC-HANDLE-W-100','simple',NULL,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سوخاری دسته‌دار سفید برای حمل آسان‌تر سفارش و تحویل مرتب غذا به مشتری.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','handled-fried-chicken-box-white-230g-pack-100',1,0,1,'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',1790000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:02','fa','default',1,214,'2026-08-21 13:18:13',NULL,1),(218,'SP-FC-HANDLE-B-100','simple',NULL,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سوخاری دسته‌دار مشکی با ظاهر حرفه‌ای و ساختار مناسب حمل سفارش‌های فست‌فودی.</p>\n<h2>مشخصات جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۲ × ۱۲ × ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','handled-fried-chicken-box-black-250g-pack-100',1,1,1,'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۲ × ۱۲ × ۱۱ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',2010000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:03','fa','default',1,215,'2026-08-21 13:18:13',NULL,1),(219,'SP-FC-TABLE-S-100','simple',NULL,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سوخاری سفره‌ای کوچک که پس از بازشدن سطح مناسبی برای سرو مستقیم غذا فراهم می‌کند.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۹.۵ × ۱۵ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','small-tabletop-fried-chicken-box-250g-pack-100',1,0,1,'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۱۹.۵ × ۱۵ × ۷ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش  عرضه در بسته ۱۰۰ عددی.',2340000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:03','fa','default',1,216,'2026-08-21 13:18:13',NULL,1),(220,'SP-FC-TABLE-L-100','simple',NULL,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سوخاری سفره‌ای بزرگ برای پک‌های حجیم و سفارش‌های خانوادگی با امکان سرو آسان.</p>\n<h2>مشخصات جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','large-tabletop-fried-chicken-box-250g-pack-100',1,0,1,'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر. مناسب بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سف عرضه در بسته ۱۰۰ عددی.',2950000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:04','fa','default',1,217,'2026-08-21 13:18:13',NULL,1),(221,'SP-FC-PLATE-100','simple',NULL,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>بشقاب مقوایی سوخاری قفل‌دار با لبه‌های بلند برای سرو مرتب و دسترسی آسان به غذا در سالن یا بیرون‌بر.</p>\n<h2>مشخصات بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۵ × ۱۵ × ۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم، جعبه سوخاری، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','fried-chicken-locking-serving-plate-250g-pack-100',1,0,1,'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم, جعبه سوخاری, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد ۲۵ × ۱۵ × ۵ سانتی‌متر. مناسب سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی. مشاهده مشخ عرضه در بسته ۱۰۰ عددی.',570000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:04','fa','default',1,218,'2026-08-21 13:18:13',NULL,1),(222,'SP-FF-BOX-100','simple',NULL,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه سیب‌زمینی صندوقی کوچک با درب یکپارچه برای حمل تمیز، حفظ فرم و جلوگیری از پراکندگی محتویات.</p>\n<h2>مشخصات جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۲ × ۸ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','small-carton-french-fries-box-230g-pack-100',1,0,1,'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۲ × ۸ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود،  عرضه در بسته ۱۰۰ عددی.',690000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:05','fa','default',1,219,'2026-08-21 13:18:13',NULL,1),(223,'SP-FF-BOAT-S-100','simple',NULL,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>ظرف قایقی کوچک سیب‌زمینی برای سرو تک‌نفره، دسترسی سریع و نمایش بهتر محصول.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۵ × ۱۱.۵ × ۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','small-boat-french-fries-tray-230g-pack-100',1,0,1,'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۵ × ۱۱.۵ × ۴ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود عرضه در بسته ۱۰۰ عددی.',360000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:05','fa','default',1,220,'2026-08-21 13:18:13',NULL,1),(224,'SP-FF-BOAT-L-100','simple',NULL,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>ظرف قایقی بزرگ سیب‌زمینی برای پرس‌های حجیم‌تر، سیب‌زمینی ویژه و سرو اشتراکی.</p>\n<h2>مشخصات جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۲۱.۵ × ۱۰ × ۶ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','large-boat-french-fries-tray-230g-pack-100',1,1,1,'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۲۱.۵ × ۱۰ × ۶ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود عرضه در بسته ۱۰۰ عددی.',510000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:06','fa','default',1,221,'2026-08-21 13:18:13',NULL,1),(225,'SP-FF-CONE-100','simple',NULL,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، ایندربرد ۲۵۰ گرم، ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه قیفی بلند سیب‌زمینی با فرم متمایز برای سرو ایستاده و ارائه جذاب در فست‌فود و رویداد.</p>\n<h2>مشخصات جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۵۰ گرم</li>\n    <li><strong>ابعاد:</strong> عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','cone-french-fries-box-250g-pack-100',1,0,1,'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم. ایندربرد ۲۵۰ گرم با ابعاد عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فو عرضه در بسته ۱۰۰ عددی.',830000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:07','fa','default',1,222,'2026-08-21 13:18:13',NULL,1),(226,'SP-FF-NEO-100','simple',NULL,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>باکس سیب‌زمینی نیوکلاسیک با دهانه باز و فرم مدرن برای سرو حرفه‌ای و برندینگ فست‌فود.</p>\n<h2>مشخصات جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ۱۴ × ۱۱ × ۷ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','neo-classic-french-fries-box-230g-pack-100',1,0,1,'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ۱۴ × ۱۱ × ۷ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، ک عرضه در بسته ۱۰۰ عددی.',930000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:07','fa','default',1,223,'2026-08-21 13:18:14',NULL,1),(227,'SP-FF-PYRAMID-S-100','simple',NULL,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه هرمی کوچک سیب‌زمینی برای پرس تک‌نفره با ظاهر خاص و اشغال فضای کم روی میز.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','small-pyramid-french-fries-box-230g-pack-100',1,0,1,'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی  عرضه در بسته ۱۰۰ عددی.',690000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:08','fa','default',1,224,'2026-08-21 13:18:14',NULL,1),(228,'SP-FF-PYRAMID-L-100','simple',NULL,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم (۱۰۰ عدد)','جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، ایندربرد ۲۳۰ گرم، ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه هرمی بزرگ سیب‌زمینی با ظرفیت بیشتر برای پرس ویژه و ارائه متفاوت محصول.</p>\n<h2>مشخصات جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم</h2>\n<ul>\n    <li><strong>جنس:</strong> ایندربرد ۲۳۰ گرم</li>\n    <li><strong>ابعاد:</strong> ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم، جعبه سیب زمینی، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','large-pyramid-french-fries-box-230g-pack-100',1,0,1,'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم | شمیم پک (۱۰۰ عدد)','جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم, جعبه سیب زمینی, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم. ایندربرد ۲۳۰ گرم با ابعاد ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر. مناسب سرو و بسته‌بندی سیب‌ز عرضه در بسته ۱۰۰ عددی.',940000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:08','fa','default',1,225,'2026-08-21 13:18:14',NULL,1),(229,'SP-PIZZA-50-PARS-100','simple',NULL,'جعبه پیتزا نیم متری پارس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا نیم متری پارس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا نیم متری پارس با ساختار مقاوم دو رو کرافت و فضای مناسب برای پیتزاهای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری پارس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری پارس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','pars-half-meter-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا نیم متری پارس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا نیم متری پارس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا نیم متری پارس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌ب عرضه در بسته ۱۰۰ عددی.',1920000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:09','fa','default',1,226,'2026-08-21 13:18:14',NULL,1),(230,'SP-PIZZA-50-TAGHDIS-100','simple',NULL,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا نیم متری طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا نیم متری طاقدیس با مقوای ایفلوت مقاوم برای حمل مطمئن پیتزای بزرگ.</p>\n<h2>مشخصات جعبه پیتزا نیم متری طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۵۰ × ۵۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا نیم متری طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','taghdis-half-meter-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا نیم متری طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا نیم متری طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا نیم متری طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۵۰ × ۵۰ سانتی‌متر. مناسب بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون عرضه در بسته ۱۰۰ عددی.',2060000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:09','fa','default',1,227,'2026-08-21 13:18:14',NULL,1),(231,'SP-PIZZA-32-TAGHDIS-100','simple',NULL,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا ۳۲ سانتی طاقدیس با استحکام مناسب، ظاهر کرافت حرفه‌ای و فضای استاندارد پیتزا.</p>\n<h2>مشخصات جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۲ × ۳۲ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','taghdis-32cm-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۲ × ۳۲ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',2510000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:10','fa','default',1,228,'2026-08-21 13:18:14',NULL,1),(232,'SP-PIZZA-30-TAGHDIS-100','simple',NULL,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا ۳۰ سانتی طاقدیس، مناسب پیتزای استاندارد با ساختار ایفلوت و مقاومت مناسب حمل.</p>\n<h2>مشخصات جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۳۰ × ۳۰ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','taghdis-30cm-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۳۰ × ۳۰ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',2270000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:10','fa','default',1,229,'2026-08-21 13:18:14',NULL,1),(233,'SP-PIZZA-28-TAGHDIS-100','simple',NULL,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا ۲۸ سانتی طاقدیس با ابعاد جمع‌وجور و مقوای کرافت ایفلوت مناسب ارسال.</p>\n<h2>مشخصات جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۸ × ۲۸ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','taghdis-28cm-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۸ × ۲۸ سانتی‌متر. مناسب بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر. مشاهده عرضه در بسته ۱۰۰ عددی.',1870000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:11','fa','default',1,230,'2026-08-21 13:18:14',NULL,1),(234,'SP-PIZZA-24-TAGHDIS-100','simple',NULL,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت (۱۰۰ عدد)','جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، کارتن دو رو کرافت ایفلوت، ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است. (۱۰۰ عدد)','<p>جعبه پیتزا ۲۴ سانتی طاقدیس برای پیتزای کوچک و تک‌نفره با حمل آسان و ظاهر کرافت.</p>\n<h2>مشخصات جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت</h2>\n<ul>\n    <li><strong>جنس:</strong> کارتن دو رو کرافت ایفلوت</li>\n    <li><strong>ابعاد:</strong> ۲۴ × ۲۴ سانتی‌متر</li>\n    <li><strong>کاربرد:</strong> بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر</li>\n    <li><strong>نوع فروش:</strong> فروش آنلاین و سفارش عمده</li>\n</ul>\n<h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>\n<p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با شمیم پک تماس بگیرید.</p>\n<p><strong>عبارت‌های مرتبط:</strong> جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت، جعبه پیتزا، بسته بندی فست فود، بسته بندی غذای بیرون بر، خرید عمده بسته بندی</p><p><strong>تعداد در بسته: ۱۰۰ عدد</strong></p>','taghdis-24cm-kraft-pizza-box-pack-100',1,0,1,'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت | شمیم پک (۱۰۰ عدد)','جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت, جعبه پیتزا, بسته بندی فست فود, بسته بندی غذای بیرون بر, خرید عمده بسته بندی, چاپ اختصاصی جعبه غذا, شمیم پک','خرید عمده جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت. کارتن دو رو کرافت ایفلوت با ابعاد ۲۴ × ۲۴ سانتی‌متر. مناسب بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر. م عرضه در بسته ۱۰۰ عددی.',1410000.0000,NULL,NULL,NULL,0.0000,'2026-08-21 13:17:11','fa','default',1,231,'2026-08-21 13:18:14',NULL,1);
/*!40000 ALTER TABLE `product_flat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_grouped_products`
--

DROP TABLE IF EXISTS `product_grouped_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_grouped_products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `associated_product_id` int unsigned NOT NULL,
  `qty` int NOT NULL DEFAULT '0',
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `grouped_products_product_id_associated_product_id_unique` (`product_id`,`associated_product_id`),
  KEY `product_grouped_products_associated_product_id_foreign` (`associated_product_id`),
  KEY `pgp_product_id_idx` (`product_id`),
  CONSTRAINT `product_grouped_products_associated_product_id_foreign` FOREIGN KEY (`associated_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_grouped_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_grouped_products`
--

LOCK TABLES `product_grouped_products` WRITE;
/*!40000 ALTER TABLE `product_grouped_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_grouped_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int unsigned NOT NULL,
  `position` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `prod_img_product_id_idx` (`product_id`),
  CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=843 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (310,'images','product/152/shamim-two-piece-kraft.webp',152,1),(769,'images','product/158/K2EoqP0jluIOjIVOkXTVDtFWMGgmWuUMJnFnItHS.webp',158,1),(770,'images','product/159/7ZAIugbiVK0n2Pk31w3fY8kvi43kAjPrbQYVEsnF.webp',159,1),(771,'images','product/160/TeggiGV3xA5vnnJTbeJaWcBEfv4QZ5Ta6gyYgtVO.webp',160,1),(772,'images','product/161/5bV89NSS8wH5HDTCaZhRFlQtm836jDSHQJuXcziE.webp',161,1),(773,'images','product/162/X2lU9O9TI7mOYKulY2TfCilBfBSctjko4q8J20wW.webp',162,1),(774,'images','product/163/aGIM7EzuDYIsMuXDJx3E8ZoHjXb4NpGmvm5wxYoW.webp',163,1),(775,'images','product/164/elftfEIGiqrQ1CpAVGlhQVm58iY3Hc9gJJL4MA5Z.webp',164,1),(776,'images','product/165/gsK9Wa0MObKVFWtzsybnIUGSaKqwrbhhc9bsHQ1w.webp',165,1),(777,'images','product/166/xAAoxo8AVkItDXVoTQz1mi0whILwRpszHteFWUKp.webp',166,1),(778,'images','product/167/jvcoKKBMh3aKimzwiEYj6ezcnKFmTAPUl5fLfXeh.webp',167,1),(779,'images','product/168/vHDIFJAIFK8TvHADeTq3mdP7s62XS0fg8CXHIx6x.webp',168,1),(780,'images','product/169/6A3mlTyUUp38slIpDE4payhyys1qtTYteJ6d0Wed.webp',169,1),(781,'images','product/170/ra5UFbV2BIB1xldHIRbfK5Ow5hBTjFKpq1zgEOuo.webp',170,1),(782,'images','product/171/2E1F55byRJkYpVvl6ocFgMNBvQWtqnCju8x7V8yA.webp',171,1),(783,'images','product/172/UtE5mThKLK16wp6k1ijL9SLW9ZEGYWfTLKrFMTcR.webp',172,1),(784,'images','product/173/82fDeSsyXp2gRsjb9qSxmICChDKMPM57q7Kat6P8.webp',173,1),(785,'images','product/174/M1i2gnN2DuPqrPtnttO163p7VztcyIB3JsAdKiWO.webp',174,1),(786,'images','product/175/kJJ9BHkYwVdjiugcclb49JKorx9YWoLejPLfqU4y.webp',175,1),(787,'images','product/176/oBlGarpxGjLowMqmAUV5tf2AZeh6EiBfwFFWUL4W.webp',176,1),(788,'images','product/177/ZiI8GTn1ynH7JK24h3CQDt9DBn5wUsO63WEkad9Y.webp',177,1),(789,'images','product/178/4ocVMEwyyRwNpaHKaQpzfFMpRTH56ZEJfYCuwBy7.webp',178,1),(790,'images','product/179/RW99VgoLxzzmiDddWF13vskLY6n9afWqoyKBRMf7.webp',179,1),(791,'images','product/180/we9xTeE3FvZDd6H0ss7LOeGKoH0C4qc6ZjALrCwQ.webp',180,1),(792,'images','product/181/rnWmq6YDsWTLLrd98uLYqcRYdFgj7TEO8iBochCo.webp',181,1),(793,'images','product/182/84UNxCOVhPCSpqb4zWYtyZ5AP8riwSlfge0fKrkx.webp',182,1),(794,'images','product/183/U7xjbh2ZOOc1r0noXmU681l2Xj2kKHohaiiJUxkQ.webp',183,1),(795,'images','product/184/g3aGZtCC3Fx1TqKMyPWKqR6JXWIjhgQ2IoHzS2pM.webp',184,1),(796,'images','product/185/3dTMY9oZBEAXZUbVRBxRdHcE2UXFCrY2iICVy3uS.webp',185,1),(797,'images','product/186/uddk6Ua1odzfWEcDNy1tZwJLo0grPuKKlxgggfJ3.webp',186,1),(798,'images','product/187/c8lBcfNdnnxX8449EogyOGs8BvycmRpotauZjTq9.webp',187,1),(799,'images','product/188/W8jBi1LSZvzgTVrufG0Jur0B5P2UMLD33nMHSYRJ.webp',188,1),(800,'images','product/189/i1wPvSsZ929Izb5PaEeU9rzxnJXExE0rPrAfkh9o.webp',189,1),(801,'images','product/190/1AVNqwI4dCekPEMM4l7lhzNh00hlbNxKOk666sdN.webp',190,1),(802,'images','product/191/ICK5YGON7uvMzXHB5huImlFwrZrsRqFMmjWBmJf8.webp',191,1),(803,'images','product/192/NJCm4mWLAqYMPE6wrK4GEJaEWcVZ5yH4S6ZBirzf.webp',192,1),(804,'images','product/193/BTDvqIIAFTW2tKXPqjys2XnW1JKzrjcvgtCkJxF7.webp',193,1),(805,'images','product/194/aeFUZjK2F6M7F9zjsqH1FaGxQacmOqtYQ0eoz9sv.webp',194,1),(806,'images','product/195/XHI9TSZavpOITbalBkNGGtflh8kBhlun6clZkJQk.webp',195,1),(807,'images','product/196/ApDzDjRWWCsZ1ADLjusfzTVcR7Kit6UWl7t48KlN.webp',196,1),(808,'images','product/197/xPF63RZTRd13XsgetCYiFeHHaDU6HNddkdWCYWNd.webp',197,1),(809,'images','product/198/GwVVJpLX6LMqJKvxWnbwRvwd7HYi1j2ZvvHb8Hly.webp',198,1),(810,'images','product/199/dlhDgck722ayYbvFiyLDRDh3DvidtDMb7KD7uGnJ.webp',199,1),(811,'images','product/200/xH17Rjqnd9YV6EFTNgXCk4NAE50KlgeJ98A8EjqZ.webp',200,1),(812,'images','product/201/pdrifh7HKDw1Uk18JGyeHKKaCBTe0jwlv0MQrEX9.webp',201,1),(813,'images','product/202/Yl8CoJYCOwPOjHOgRAzmvZ9BRJawFJpU9jr3xTsB.webp',202,1),(814,'images','product/203/IDhBT92LS6SVty8dBiRzgwhiQBnROOAOjQhQ8Vnv.webp',203,1),(815,'images','product/204/XumUbwxjHBsgX77pwFCHOM6Nkv0r3gLlK6wcY41E.webp',204,1),(816,'images','product/205/ye8vZEAV8ryf7uIwOaDIuWUSSHyNbNhSdF5S5dd8.webp',205,1),(817,'images','product/206/gyzYR7uxhBamTTIm6JSyhMkFHJql84xX73wJ2h4d.webp',206,1),(818,'images','product/207/shamim-two-piece-kraft.webp',207,1),(819,'images','product/208/K2EoqP0jluIOjIVOkXTVDtFWMGgmWuUMJnFnItHS.webp',208,1),(820,'images','product/209/7ZAIugbiVK0n2Pk31w3fY8kvi43kAjPrbQYVEsnF.webp',209,1),(821,'images','product/210/TeggiGV3xA5vnnJTbeJaWcBEfv4QZ5Ta6gyYgtVO.webp',210,1),(822,'images','product/211/5bV89NSS8wH5HDTCaZhRFlQtm836jDSHQJuXcziE.webp',211,1),(823,'images','product/212/X2lU9O9TI7mOYKulY2TfCilBfBSctjko4q8J20wW.webp',212,1),(824,'images','product/213/aGIM7EzuDYIsMuXDJx3E8ZoHjXb4NpGmvm5wxYoW.webp',213,1),(825,'images','product/214/elftfEIGiqrQ1CpAVGlhQVm58iY3Hc9gJJL4MA5Z.webp',214,1),(826,'images','product/215/gsK9Wa0MObKVFWtzsybnIUGSaKqwrbhhc9bsHQ1w.webp',215,1),(827,'images','product/216/xAAoxo8AVkItDXVoTQz1mi0whILwRpszHteFWUKp.webp',216,1),(828,'images','product/217/jvcoKKBMh3aKimzwiEYj6ezcnKFmTAPUl5fLfXeh.webp',217,1),(829,'images','product/218/vHDIFJAIFK8TvHADeTq3mdP7s62XS0fg8CXHIx6x.webp',218,1),(830,'images','product/219/6A3mlTyUUp38slIpDE4payhyys1qtTYteJ6d0Wed.webp',219,1),(831,'images','product/220/ra5UFbV2BIB1xldHIRbfK5Ow5hBTjFKpq1zgEOuo.webp',220,1),(832,'images','product/221/2E1F55byRJkYpVvl6ocFgMNBvQWtqnCju8x7V8yA.webp',221,1),(833,'images','product/222/UtE5mThKLK16wp6k1ijL9SLW9ZEGYWfTLKrFMTcR.webp',222,1),(834,'images','product/223/82fDeSsyXp2gRsjb9qSxmICChDKMPM57q7Kat6P8.webp',223,1),(835,'images','product/224/M1i2gnN2DuPqrPtnttO163p7VztcyIB3JsAdKiWO.webp',224,1),(836,'images','product/225/kJJ9BHkYwVdjiugcclb49JKorx9YWoLejPLfqU4y.webp',225,1),(837,'images','product/226/4ocVMEwyyRwNpaHKaQpzfFMpRTH56ZEJfYCuwBy7.webp',226,1),(838,'images','product/227/RW99VgoLxzzmiDddWF13vskLY6n9afWqoyKBRMf7.webp',227,1),(839,'images','product/228/we9xTeE3FvZDd6H0ss7LOeGKoH0C4qc6ZjALrCwQ.webp',228,1),(840,'images','product/229/rnWmq6YDsWTLLrd98uLYqcRYdFgj7TEO8iBochCo.webp',229,1),(841,'images','product/230/84UNxCOVhPCSpqb4zWYtyZ5AP8riwSlfge0fKrkx.webp',230,1),(842,'images','product/231/U7xjbh2ZOOc1r0noXmU681l2Xj2kKHohaiiJUxkQ.webp',231,1);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_inventories`
--

DROP TABLE IF EXISTS `product_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_inventories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qty` int NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL,
  `vendor_id` int NOT NULL DEFAULT '0',
  `inventory_source_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_source_vendor_index_unique` (`product_id`,`inventory_source_id`,`vendor_id`),
  KEY `product_inventories_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `product_inventories_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_inventories`
--

LOCK TABLES `product_inventories` WRITE;
/*!40000 ALTER TABLE `product_inventories` DISABLE KEYS */;
INSERT INTO `product_inventories` VALUES (129,2147483647,152,0,1),(135,100000,158,0,1),(136,100000,159,0,1),(137,100000,160,0,1),(138,100000,161,0,1),(139,100000,162,0,1),(140,100000,163,0,1),(141,100000,164,0,1),(142,100000,165,0,1),(143,100000,166,0,1),(144,100000,167,0,1),(145,100000,168,0,1),(146,100000,169,0,1),(147,100000,170,0,1),(148,100000,171,0,1),(149,100000,172,0,1),(150,100000,173,0,1),(151,100000,174,0,1),(152,100000,175,0,1),(153,100000,176,0,1),(154,100000,177,0,1),(155,100000,178,0,1),(156,100000,179,0,1),(157,100000,180,0,1),(158,100000,181,0,1),(159,100000,182,0,1),(160,100000,183,0,1),(161,100000,184,0,1),(162,100000,185,0,1),(163,100000,186,0,1),(164,100000,187,0,1),(165,100000,188,0,1),(166,100000,189,0,1),(167,100000,190,0,1),(168,100000,191,0,1),(169,100000,192,0,1),(170,100000,193,0,1),(171,100000,194,0,1),(172,100000,195,0,1),(173,100000,196,0,1),(174,100000,197,0,1),(175,100000,198,0,1),(176,100000,199,0,1),(177,100000,200,0,1),(178,100000,201,0,1),(179,100000,202,0,1),(180,100000,203,0,1),(181,100000,204,0,1),(182,100000,205,0,1),(183,100000,206,0,1),(184,2147483647,207,0,1),(185,100000,208,0,1),(186,100000,209,0,1),(187,100000,210,0,1),(188,100000,211,0,1),(189,100000,212,0,1),(190,100000,213,0,1),(191,100000,214,0,1),(192,100000,215,0,1),(193,100000,216,0,1),(194,100000,217,0,1),(195,100000,218,0,1),(196,100000,219,0,1),(197,100000,220,0,1),(198,100000,221,0,1),(199,100000,222,0,1),(200,100000,223,0,1),(201,100000,224,0,1),(202,100000,225,0,1),(203,100000,226,0,1),(204,100000,227,0,1),(205,100000,228,0,1),(206,100000,229,0,1),(207,100000,230,0,1),(208,100000,231,0,1);
/*!40000 ALTER TABLE `product_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_inventory_indices`
--

DROP TABLE IF EXISTS `product_inventory_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_inventory_indices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qty` int NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_inventory_indices_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_inventory_indices_channel_id_foreign` (`channel_id`),
  KEY `prod_inv_product_id_idx` (`product_id`),
  CONSTRAINT `product_inventory_indices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_inventory_indices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_inventory_indices`
--

LOCK TABLES `product_inventory_indices` WRITE;
/*!40000 ALTER TABLE `product_inventory_indices` DISABLE KEYS */;
INSERT INTO `product_inventory_indices` VALUES (126,2147483646,152,1,NULL,'2026-08-16 17:00:08'),(131,100000,158,1,NULL,'2026-08-19 19:26:03'),(132,100000,159,1,NULL,'2026-08-19 19:26:04'),(133,100000,160,1,NULL,'2026-08-19 19:26:05'),(134,100000,161,1,NULL,'2026-08-19 19:26:05'),(135,100000,162,1,NULL,'2026-08-19 19:26:06'),(136,100000,163,1,NULL,'2026-08-19 19:26:07'),(137,100000,164,1,NULL,'2026-08-19 19:26:08'),(138,100000,165,1,NULL,'2026-08-19 19:26:09'),(139,100000,166,1,NULL,'2026-08-19 19:26:09'),(140,100000,167,1,NULL,'2026-08-19 19:26:10'),(141,100000,168,1,NULL,'2026-08-19 19:26:11'),(142,100000,169,1,NULL,'2026-08-19 19:26:12'),(143,100000,170,1,NULL,'2026-08-19 19:26:13'),(144,100000,171,1,NULL,'2026-08-19 19:26:13'),(145,100000,172,1,NULL,'2026-08-19 19:26:14'),(146,100000,173,1,NULL,'2026-08-19 19:26:15'),(147,100000,174,1,NULL,'2026-08-19 19:26:16'),(148,100000,175,1,NULL,'2026-08-19 19:26:16'),(149,100000,176,1,NULL,'2026-08-20 21:03:02'),(150,100000,177,1,NULL,'2026-08-20 21:03:03'),(151,100000,178,1,NULL,NULL),(152,100000,179,1,NULL,NULL),(153,100000,180,1,NULL,NULL),(154,100000,181,1,NULL,NULL),(155,100000,182,1,NULL,NULL),(156,100000,183,1,NULL,NULL),(157,100000,184,1,NULL,'2026-08-20 21:03:05'),(158,100000,185,1,NULL,'2026-08-20 21:03:06'),(159,100000,186,1,NULL,'2026-08-20 21:03:06'),(160,100000,187,1,NULL,'2026-08-20 21:03:06'),(161,100000,188,1,NULL,'2026-08-20 21:03:07'),(162,100000,189,1,NULL,'2026-08-20 21:03:07'),(163,100000,190,1,NULL,'2026-08-20 21:03:07'),(164,100000,191,1,NULL,'2026-08-20 21:03:07'),(165,100000,192,1,NULL,'2026-08-20 21:03:08'),(166,100000,193,1,NULL,'2026-08-20 21:03:08'),(167,100000,194,1,NULL,'2026-08-20 21:03:08'),(168,100000,195,1,NULL,'2026-08-20 21:03:09'),(169,100000,196,1,NULL,NULL),(170,100000,197,1,NULL,NULL),(171,100000,198,1,NULL,NULL),(172,100000,199,1,NULL,NULL),(173,100000,200,1,NULL,NULL),(174,100000,201,1,NULL,NULL),(175,100000,202,1,NULL,NULL),(176,100000,203,1,NULL,NULL),(177,100000,204,1,NULL,NULL),(178,100000,205,1,NULL,NULL),(179,100000,206,1,NULL,NULL),(180,2147483647,207,1,NULL,NULL),(181,100000,208,1,NULL,NULL),(182,100000,209,1,NULL,NULL),(183,100000,210,1,NULL,NULL),(184,100000,211,1,NULL,NULL),(185,100000,212,1,NULL,NULL),(186,100000,213,1,NULL,NULL),(187,100000,214,1,NULL,NULL),(188,100000,215,1,NULL,NULL),(189,100000,216,1,NULL,NULL),(190,100000,217,1,NULL,NULL),(191,100000,218,1,NULL,NULL),(192,100000,219,1,NULL,NULL),(193,100000,220,1,NULL,NULL),(194,100000,221,1,NULL,NULL),(195,100000,222,1,NULL,NULL),(196,100000,223,1,NULL,NULL),(197,100000,224,1,NULL,NULL),(198,100000,225,1,NULL,NULL),(199,100000,226,1,NULL,NULL),(200,100000,227,1,NULL,NULL),(201,100000,228,1,NULL,NULL),(202,100000,229,1,NULL,NULL),(203,100000,230,1,NULL,NULL),(204,100000,231,1,NULL,NULL);
/*!40000 ALTER TABLE `product_inventory_indices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_ordered_inventories`
--

DROP TABLE IF EXISTS `product_ordered_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_ordered_inventories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qty` int NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_ordered_inventories_product_id_channel_id_unique` (`product_id`,`channel_id`),
  KEY `product_ordered_inventories_channel_id_foreign` (`channel_id`),
  CONSTRAINT `product_ordered_inventories_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_ordered_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_ordered_inventories`
--

LOCK TABLES `product_ordered_inventories` WRITE;
/*!40000 ALTER TABLE `product_ordered_inventories` DISABLE KEYS */;
INSERT INTO `product_ordered_inventories` VALUES (1,1,152,1);
/*!40000 ALTER TABLE `product_ordered_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_price_indices`
--

DROP TABLE IF EXISTS `product_price_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_price_indices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `customer_group_id` int unsigned DEFAULT NULL,
  `channel_id` int unsigned NOT NULL DEFAULT '1',
  `min_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `regular_min_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `max_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `regular_max_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `price_indices_product_id_customer_group_id_channel_id_unique` (`product_id`,`customer_group_id`,`channel_id`),
  KEY `product_price_indices_customer_group_id_foreign` (`customer_group_id`),
  KEY `product_price_indices_channel_id_foreign` (`channel_id`),
  KEY `ppi_product_id_customer_group_id_idx` (`product_id`,`customer_group_id`),
  CONSTRAINT `product_price_indices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_price_indices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_price_indices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=691 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_price_indices`
--

LOCK TABLES `product_price_indices` WRITE;
/*!40000 ALTER TABLE `product_price_indices` DISABLE KEYS */;
INSERT INTO `product_price_indices` VALUES (454,152,1,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(455,152,2,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(456,152,3,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(469,158,1,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(470,158,2,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(471,158,3,1,10100.0000,10100.0000,10100.0000,10100.0000,NULL,'2026-08-22 16:59:08'),(472,159,1,1,13100.0000,13100.0000,13100.0000,13100.0000,NULL,'2026-08-22 16:59:08'),(473,159,2,1,13100.0000,13100.0000,13100.0000,13100.0000,NULL,'2026-08-22 16:59:08'),(474,159,3,1,13100.0000,13100.0000,13100.0000,13100.0000,NULL,'2026-08-22 16:59:08'),(475,160,1,1,13900.0000,13900.0000,13900.0000,13900.0000,NULL,'2026-08-22 16:59:08'),(476,160,2,1,13900.0000,13900.0000,13900.0000,13900.0000,NULL,'2026-08-22 16:59:08'),(477,160,3,1,13900.0000,13900.0000,13900.0000,13900.0000,NULL,'2026-08-22 16:59:08'),(478,161,1,1,11600.0000,11600.0000,11600.0000,11600.0000,NULL,'2026-08-22 16:59:08'),(479,161,2,1,11600.0000,11600.0000,11600.0000,11600.0000,NULL,'2026-08-22 16:59:08'),(480,161,3,1,11600.0000,11600.0000,11600.0000,11600.0000,NULL,'2026-08-22 16:59:08'),(481,162,1,1,14200.0000,14200.0000,14200.0000,14200.0000,NULL,'2026-08-22 16:59:08'),(482,162,2,1,14200.0000,14200.0000,14200.0000,14200.0000,NULL,'2026-08-22 16:59:08'),(483,162,3,1,14200.0000,14200.0000,14200.0000,14200.0000,NULL,'2026-08-22 16:59:08'),(484,163,1,1,15300.0000,15300.0000,15300.0000,15300.0000,NULL,'2026-08-22 16:59:08'),(485,163,2,1,15300.0000,15300.0000,15300.0000,15300.0000,NULL,'2026-08-22 16:59:08'),(486,163,3,1,15300.0000,15300.0000,15300.0000,15300.0000,NULL,'2026-08-22 16:59:08'),(487,164,1,1,17900.0000,17900.0000,17900.0000,17900.0000,NULL,'2026-08-22 16:59:08'),(488,164,2,1,17900.0000,17900.0000,17900.0000,17900.0000,NULL,'2026-08-22 16:59:08'),(489,164,3,1,17900.0000,17900.0000,17900.0000,17900.0000,NULL,'2026-08-22 16:59:08'),(490,165,1,1,20100.0000,20100.0000,20100.0000,20100.0000,NULL,'2026-08-22 16:59:08'),(491,165,2,1,20100.0000,20100.0000,20100.0000,20100.0000,NULL,'2026-08-22 16:59:08'),(492,165,3,1,20100.0000,20100.0000,20100.0000,20100.0000,NULL,'2026-08-22 16:59:08'),(493,166,1,1,23400.0000,23400.0000,23400.0000,23400.0000,NULL,'2026-08-22 16:59:08'),(494,166,2,1,23400.0000,23400.0000,23400.0000,23400.0000,NULL,'2026-08-22 16:59:08'),(495,166,3,1,23400.0000,23400.0000,23400.0000,23400.0000,NULL,'2026-08-22 16:59:08'),(496,167,1,1,29500.0000,29500.0000,29500.0000,29500.0000,NULL,'2026-08-22 16:59:08'),(497,167,2,1,29500.0000,29500.0000,29500.0000,29500.0000,NULL,'2026-08-22 16:59:08'),(498,167,3,1,29500.0000,29500.0000,29500.0000,29500.0000,NULL,'2026-08-22 16:59:08'),(499,168,1,1,5700.0000,5700.0000,5700.0000,5700.0000,NULL,'2026-08-22 16:59:08'),(500,168,2,1,5700.0000,5700.0000,5700.0000,5700.0000,NULL,'2026-08-22 16:59:08'),(501,168,3,1,5700.0000,5700.0000,5700.0000,5700.0000,NULL,'2026-08-22 16:59:08'),(502,169,1,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(503,169,2,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(504,169,3,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(505,170,1,1,3600.0000,3600.0000,3600.0000,3600.0000,NULL,'2026-08-22 16:59:08'),(506,170,2,1,3600.0000,3600.0000,3600.0000,3600.0000,NULL,'2026-08-22 16:59:08'),(507,170,3,1,3600.0000,3600.0000,3600.0000,3600.0000,NULL,'2026-08-22 16:59:08'),(508,171,1,1,5100.0000,5100.0000,5100.0000,5100.0000,NULL,'2026-08-22 16:59:08'),(509,171,2,1,5100.0000,5100.0000,5100.0000,5100.0000,NULL,'2026-08-22 16:59:08'),(510,171,3,1,5100.0000,5100.0000,5100.0000,5100.0000,NULL,'2026-08-22 16:59:08'),(511,172,1,1,8300.0000,8300.0000,8300.0000,8300.0000,NULL,'2026-08-22 16:59:08'),(512,172,2,1,8300.0000,8300.0000,8300.0000,8300.0000,NULL,'2026-08-22 16:59:08'),(513,172,3,1,8300.0000,8300.0000,8300.0000,8300.0000,NULL,'2026-08-22 16:59:08'),(514,173,1,1,9300.0000,9300.0000,9300.0000,9300.0000,NULL,'2026-08-22 16:59:08'),(515,173,2,1,9300.0000,9300.0000,9300.0000,9300.0000,NULL,'2026-08-22 16:59:08'),(516,173,3,1,9300.0000,9300.0000,9300.0000,9300.0000,NULL,'2026-08-22 16:59:08'),(517,174,1,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(518,174,2,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(519,174,3,1,6900.0000,6900.0000,6900.0000,6900.0000,NULL,'2026-08-22 16:59:08'),(520,175,1,1,9400.0000,9400.0000,9400.0000,9400.0000,NULL,'2026-08-22 16:59:08'),(521,175,2,1,9400.0000,9400.0000,9400.0000,9400.0000,NULL,'2026-08-22 16:59:08'),(522,175,3,1,9400.0000,9400.0000,9400.0000,9400.0000,NULL,'2026-08-22 16:59:08'),(523,176,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(524,176,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(525,176,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(526,177,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(527,177,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(528,177,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(529,178,1,1,19200.0000,19200.0000,19200.0000,19200.0000,NULL,'2026-08-22 16:59:08'),(530,178,2,1,19200.0000,19200.0000,19200.0000,19200.0000,NULL,'2026-08-22 16:59:08'),(531,178,3,1,19200.0000,19200.0000,19200.0000,19200.0000,NULL,'2026-08-22 16:59:08'),(532,179,1,1,20600.0000,20600.0000,20600.0000,20600.0000,NULL,'2026-08-22 16:59:08'),(533,179,2,1,20600.0000,20600.0000,20600.0000,20600.0000,NULL,'2026-08-22 16:59:08'),(534,179,3,1,20600.0000,20600.0000,20600.0000,20600.0000,NULL,'2026-08-22 16:59:08'),(535,180,1,1,25100.0000,25100.0000,25100.0000,25100.0000,NULL,'2026-08-22 16:59:08'),(536,180,2,1,25100.0000,25100.0000,25100.0000,25100.0000,NULL,'2026-08-22 16:59:08'),(537,180,3,1,25100.0000,25100.0000,25100.0000,25100.0000,NULL,'2026-08-22 16:59:08'),(538,181,1,1,22700.0000,22700.0000,22700.0000,22700.0000,NULL,'2026-08-22 16:59:08'),(539,181,2,1,22700.0000,22700.0000,22700.0000,22700.0000,NULL,'2026-08-22 16:59:08'),(540,181,3,1,22700.0000,22700.0000,22700.0000,22700.0000,NULL,'2026-08-22 16:59:08'),(541,182,1,1,18700.0000,18700.0000,18700.0000,18700.0000,NULL,'2026-08-22 16:59:08'),(542,182,2,1,18700.0000,18700.0000,18700.0000,18700.0000,NULL,'2026-08-22 16:59:08'),(543,182,3,1,18700.0000,18700.0000,18700.0000,18700.0000,NULL,'2026-08-22 16:59:08'),(544,183,1,1,14100.0000,14100.0000,14100.0000,14100.0000,NULL,'2026-08-22 16:59:08'),(545,183,2,1,14100.0000,14100.0000,14100.0000,14100.0000,NULL,'2026-08-22 16:59:08'),(546,183,3,1,14100.0000,14100.0000,14100.0000,14100.0000,NULL,'2026-08-22 16:59:08'),(547,184,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(548,184,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(549,184,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(550,185,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(551,185,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(552,185,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(553,186,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(554,186,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(555,186,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(556,187,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(557,187,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(558,187,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(559,188,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(560,188,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(561,188,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(562,189,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(563,189,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(564,189,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(565,190,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(566,190,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(567,190,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(568,191,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(569,191,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(570,191,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(571,192,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(572,192,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(573,192,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(574,193,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(575,193,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(576,193,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(577,194,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(578,194,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(579,194,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(580,195,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(581,195,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(582,195,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:42'),(583,196,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(584,196,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(585,196,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(586,197,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(587,197,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(588,197,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(589,198,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(590,198,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(591,198,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(592,199,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(593,199,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(594,199,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(595,200,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(596,200,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(597,200,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(598,201,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(599,201,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(600,201,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(601,202,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(602,202,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(603,202,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(604,203,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(605,203,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(606,203,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(607,204,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(608,204,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(609,204,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(610,205,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(611,205,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(612,205,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(613,206,1,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(614,206,2,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(615,206,3,1,0.0000,0.0000,0.0000,0.0000,NULL,'2026-08-21 15:27:43'),(616,207,1,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(617,207,2,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(618,207,3,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(619,208,1,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(620,208,2,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(621,208,3,1,1010000.0000,1010000.0000,1010000.0000,1010000.0000,NULL,'2026-08-22 16:59:08'),(622,209,1,1,1310000.0000,1310000.0000,1310000.0000,1310000.0000,NULL,'2026-08-22 16:59:08'),(623,209,2,1,1310000.0000,1310000.0000,1310000.0000,1310000.0000,NULL,'2026-08-22 16:59:08'),(624,209,3,1,1310000.0000,1310000.0000,1310000.0000,1310000.0000,NULL,'2026-08-22 16:59:08'),(625,210,1,1,1390000.0000,1390000.0000,1390000.0000,1390000.0000,NULL,'2026-08-22 16:59:08'),(626,210,2,1,1390000.0000,1390000.0000,1390000.0000,1390000.0000,NULL,'2026-08-22 16:59:08'),(627,210,3,1,1390000.0000,1390000.0000,1390000.0000,1390000.0000,NULL,'2026-08-22 16:59:08'),(628,211,1,1,1160000.0000,1160000.0000,1160000.0000,1160000.0000,NULL,'2026-08-22 16:59:08'),(629,211,2,1,1160000.0000,1160000.0000,1160000.0000,1160000.0000,NULL,'2026-08-22 16:59:08'),(630,211,3,1,1160000.0000,1160000.0000,1160000.0000,1160000.0000,NULL,'2026-08-22 16:59:08'),(631,212,1,1,1420000.0000,1420000.0000,1420000.0000,1420000.0000,NULL,'2026-08-22 16:59:08'),(632,212,2,1,1420000.0000,1420000.0000,1420000.0000,1420000.0000,NULL,'2026-08-22 16:59:08'),(633,212,3,1,1420000.0000,1420000.0000,1420000.0000,1420000.0000,NULL,'2026-08-22 16:59:08'),(634,213,1,1,1530000.0000,1530000.0000,1530000.0000,1530000.0000,NULL,'2026-08-22 16:59:09'),(635,213,2,1,1530000.0000,1530000.0000,1530000.0000,1530000.0000,NULL,'2026-08-22 16:59:09'),(636,213,3,1,1530000.0000,1530000.0000,1530000.0000,1530000.0000,NULL,'2026-08-22 16:59:09'),(637,214,1,1,1790000.0000,1790000.0000,1790000.0000,1790000.0000,NULL,'2026-08-22 16:59:09'),(638,214,2,1,1790000.0000,1790000.0000,1790000.0000,1790000.0000,NULL,'2026-08-22 16:59:09'),(639,214,3,1,1790000.0000,1790000.0000,1790000.0000,1790000.0000,NULL,'2026-08-22 16:59:09'),(640,215,1,1,2010000.0000,2010000.0000,2010000.0000,2010000.0000,NULL,'2026-08-22 16:59:09'),(641,215,2,1,2010000.0000,2010000.0000,2010000.0000,2010000.0000,NULL,'2026-08-22 16:59:09'),(642,215,3,1,2010000.0000,2010000.0000,2010000.0000,2010000.0000,NULL,'2026-08-22 16:59:09'),(643,216,1,1,2340000.0000,2340000.0000,2340000.0000,2340000.0000,NULL,'2026-08-22 16:59:09'),(644,216,2,1,2340000.0000,2340000.0000,2340000.0000,2340000.0000,NULL,'2026-08-22 16:59:09'),(645,216,3,1,2340000.0000,2340000.0000,2340000.0000,2340000.0000,NULL,'2026-08-22 16:59:09'),(646,217,1,1,2950000.0000,2950000.0000,2950000.0000,2950000.0000,NULL,'2026-08-22 16:59:09'),(647,217,2,1,2950000.0000,2950000.0000,2950000.0000,2950000.0000,NULL,'2026-08-22 16:59:09'),(648,217,3,1,2950000.0000,2950000.0000,2950000.0000,2950000.0000,NULL,'2026-08-22 16:59:09'),(649,218,1,1,570000.0000,570000.0000,570000.0000,570000.0000,NULL,'2026-08-22 16:59:09'),(650,218,2,1,570000.0000,570000.0000,570000.0000,570000.0000,NULL,'2026-08-22 16:59:09'),(651,218,3,1,570000.0000,570000.0000,570000.0000,570000.0000,NULL,'2026-08-22 16:59:09'),(652,219,1,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(653,219,2,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(654,219,3,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(655,220,1,1,360000.0000,360000.0000,360000.0000,360000.0000,NULL,'2026-08-22 16:59:09'),(656,220,2,1,360000.0000,360000.0000,360000.0000,360000.0000,NULL,'2026-08-22 16:59:09'),(657,220,3,1,360000.0000,360000.0000,360000.0000,360000.0000,NULL,'2026-08-22 16:59:09'),(658,221,1,1,510000.0000,510000.0000,510000.0000,510000.0000,NULL,'2026-08-22 16:59:09'),(659,221,2,1,510000.0000,510000.0000,510000.0000,510000.0000,NULL,'2026-08-22 16:59:09'),(660,221,3,1,510000.0000,510000.0000,510000.0000,510000.0000,NULL,'2026-08-22 16:59:09'),(661,222,1,1,830000.0000,830000.0000,830000.0000,830000.0000,NULL,'2026-08-22 16:59:09'),(662,222,2,1,830000.0000,830000.0000,830000.0000,830000.0000,NULL,'2026-08-22 16:59:09'),(663,222,3,1,830000.0000,830000.0000,830000.0000,830000.0000,NULL,'2026-08-22 16:59:09'),(664,223,1,1,930000.0000,930000.0000,930000.0000,930000.0000,NULL,'2026-08-22 16:59:09'),(665,223,2,1,930000.0000,930000.0000,930000.0000,930000.0000,NULL,'2026-08-22 16:59:09'),(666,223,3,1,930000.0000,930000.0000,930000.0000,930000.0000,NULL,'2026-08-22 16:59:09'),(667,224,1,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(668,224,2,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(669,224,3,1,690000.0000,690000.0000,690000.0000,690000.0000,NULL,'2026-08-22 16:59:09'),(670,225,1,1,940000.0000,940000.0000,940000.0000,940000.0000,NULL,'2026-08-22 16:59:09'),(671,225,2,1,940000.0000,940000.0000,940000.0000,940000.0000,NULL,'2026-08-22 16:59:09'),(672,225,3,1,940000.0000,940000.0000,940000.0000,940000.0000,NULL,'2026-08-22 16:59:09'),(673,226,1,1,1920000.0000,1920000.0000,1920000.0000,1920000.0000,NULL,'2026-08-22 16:59:09'),(674,226,2,1,1920000.0000,1920000.0000,1920000.0000,1920000.0000,NULL,'2026-08-22 16:59:09'),(675,226,3,1,1920000.0000,1920000.0000,1920000.0000,1920000.0000,NULL,'2026-08-22 16:59:09'),(676,227,1,1,2060000.0000,2060000.0000,2060000.0000,2060000.0000,NULL,'2026-08-22 16:59:09'),(677,227,2,1,2060000.0000,2060000.0000,2060000.0000,2060000.0000,NULL,'2026-08-22 16:59:09'),(678,227,3,1,2060000.0000,2060000.0000,2060000.0000,2060000.0000,NULL,'2026-08-22 16:59:09'),(679,228,1,1,2510000.0000,2510000.0000,2510000.0000,2510000.0000,NULL,'2026-08-22 16:59:09'),(680,228,2,1,2510000.0000,2510000.0000,2510000.0000,2510000.0000,NULL,'2026-08-22 16:59:09'),(681,228,3,1,2510000.0000,2510000.0000,2510000.0000,2510000.0000,NULL,'2026-08-22 16:59:09'),(682,229,1,1,2270000.0000,2270000.0000,2270000.0000,2270000.0000,NULL,'2026-08-22 16:59:09'),(683,229,2,1,2270000.0000,2270000.0000,2270000.0000,2270000.0000,NULL,'2026-08-22 16:59:09'),(684,229,3,1,2270000.0000,2270000.0000,2270000.0000,2270000.0000,NULL,'2026-08-22 16:59:09'),(685,230,1,1,1870000.0000,1870000.0000,1870000.0000,1870000.0000,NULL,'2026-08-22 16:59:09'),(686,230,2,1,1870000.0000,1870000.0000,1870000.0000,1870000.0000,NULL,'2026-08-22 16:59:09'),(687,230,3,1,1870000.0000,1870000.0000,1870000.0000,1870000.0000,NULL,'2026-08-22 16:59:09'),(688,231,1,1,1410000.0000,1410000.0000,1410000.0000,1410000.0000,NULL,'2026-08-22 16:59:09'),(689,231,2,1,1410000.0000,1410000.0000,1410000.0000,1410000.0000,NULL,'2026-08-22 16:59:09'),(690,231,3,1,1410000.0000,1410000.0000,1410000.0000,1410000.0000,NULL,'2026-08-22 16:59:09');
/*!40000 ALTER TABLE `product_price_indices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_relations`
--

DROP TABLE IF EXISTS `product_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_relations` (
  `parent_id` int unsigned NOT NULL,
  `child_id` int unsigned NOT NULL,
  UNIQUE KEY `product_relations_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_relations_child_id_foreign` (`child_id`),
  CONSTRAINT `product_relations_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_relations_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_relations`
--

LOCK TABLES `product_relations` WRITE;
/*!40000 ALTER TABLE `product_relations` DISABLE KEYS */;
INSERT INTO `product_relations` VALUES (152,207),(158,208),(159,209),(160,210),(161,211),(162,212),(163,213),(164,214),(165,215),(166,216),(167,217),(168,218),(169,219),(170,220),(171,221),(172,222),(173,223),(174,224),(175,225),(178,226),(179,227),(180,228),(181,229),(182,230),(183,231);
/*!40000 ALTER TABLE `product_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_review_attachments`
--

DROP TABLE IF EXISTS `product_review_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_review_attachments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `review_id` int unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `mime_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_review_images_review_id_foreign` (`review_id`),
  CONSTRAINT `product_review_images_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `product_reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_review_attachments`
--

LOCK TABLES `product_review_attachments` WRITE;
/*!40000 ALTER TABLE `product_review_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_review_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_reviews` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int unsigned NOT NULL,
  `customer_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prod_rev_product_id_idx` (`product_id`),
  CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_reviews`
--

LOCK TABLES `product_reviews` WRITE;
/*!40000 ALTER TABLE `product_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_super_attributes`
--

DROP TABLE IF EXISTS `product_super_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_super_attributes` (
  `product_id` int unsigned NOT NULL,
  `attribute_id` int unsigned NOT NULL,
  UNIQUE KEY `product_super_attributes_product_id_attribute_id_unique` (`product_id`,`attribute_id`),
  KEY `product_super_attributes_attribute_id_foreign` (`attribute_id`),
  CONSTRAINT `product_super_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `product_super_attributes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_super_attributes`
--

LOCK TABLES `product_super_attributes` WRITE;
/*!40000 ALTER TABLE `product_super_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_super_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_up_sells`
--

DROP TABLE IF EXISTS `product_up_sells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_up_sells` (
  `parent_id` int unsigned NOT NULL,
  `child_id` int unsigned NOT NULL,
  UNIQUE KEY `product_up_sells_parent_id_child_id_unique` (`parent_id`,`child_id`),
  KEY `product_up_sells_child_id_foreign` (`child_id`),
  CONSTRAINT `product_up_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_up_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_up_sells`
--

LOCK TABLES `product_up_sells` WRITE;
/*!40000 ALTER TABLE `product_up_sells` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_up_sells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_videos`
--

DROP TABLE IF EXISTS `product_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_videos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `prod_vid_product_id_idx` (`product_id`),
  CONSTRAINT `product_videos_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_videos`
--

LOCK TABLES `product_videos` WRITE;
/*!40000 ALTER TABLE `product_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `attribute_family_id` int unsigned DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_sku_unique` (`sku`),
  KEY `products_attribute_family_id_foreign` (`attribute_family_id`),
  KEY `products_parent_id_foreign` (`parent_id`),
  CONSTRAINT `products_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `products_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=232 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (152,'100','simple',NULL,1,NULL,'2026-08-15 18:28:04','2026-08-15 18:40:07'),(158,'SP-FC-002-W','simple',NULL,1,NULL,'2026-08-19 18:53:18','2026-08-19 18:53:18'),(159,'SP-FC-003-W','simple',NULL,1,NULL,'2026-08-19 18:55:23','2026-08-19 18:55:23'),(160,'SP-FC-005-W','simple',NULL,1,NULL,'2026-08-19 18:55:24','2026-08-19 18:55:24'),(161,'SP-FC-002-B','simple',NULL,1,NULL,'2026-08-19 18:55:25','2026-08-19 18:55:25'),(162,'SP-FC-003-B','simple',NULL,1,NULL,'2026-08-19 18:55:26','2026-08-19 18:55:26'),(163,'SP-FC-005-B','simple',NULL,1,NULL,'2026-08-19 18:55:28','2026-08-19 18:55:28'),(164,'SP-FC-HANDLE-W','simple',NULL,1,NULL,'2026-08-19 18:55:29','2026-08-19 18:55:29'),(165,'SP-FC-HANDLE-B','simple',NULL,1,NULL,'2026-08-19 18:55:30','2026-08-19 18:55:30'),(166,'SP-FC-TABLE-S','simple',NULL,1,NULL,'2026-08-19 18:55:30','2026-08-19 18:55:30'),(167,'SP-FC-TABLE-L','simple',NULL,1,NULL,'2026-08-19 18:55:32','2026-08-19 18:55:32'),(168,'SP-FC-PLATE','simple',NULL,1,NULL,'2026-08-19 18:55:33','2026-08-19 18:55:33'),(169,'SP-FF-BOX','simple',NULL,1,NULL,'2026-08-19 18:55:33','2026-08-19 18:55:33'),(170,'SP-FF-BOAT-S','simple',NULL,1,NULL,'2026-08-19 18:55:34','2026-08-19 18:55:34'),(171,'SP-FF-BOAT-L','simple',NULL,1,NULL,'2026-08-19 18:55:35','2026-08-19 18:55:35'),(172,'SP-FF-CONE','simple',NULL,1,NULL,'2026-08-19 18:55:36','2026-08-19 18:55:36'),(173,'SP-FF-NEO','simple',NULL,1,NULL,'2026-08-19 18:55:37','2026-08-19 18:55:37'),(174,'SP-FF-PYRAMID-S','simple',NULL,1,NULL,'2026-08-19 18:55:38','2026-08-19 18:55:38'),(175,'SP-FF-PYRAMID-L','simple',NULL,1,NULL,'2026-08-19 18:55:38','2026-08-19 18:55:38'),(176,'SP-PAPER-2535','simple',NULL,1,NULL,'2026-08-19 18:55:39','2026-08-19 18:55:39'),(177,'SP-PAPER-3550','simple',NULL,1,NULL,'2026-08-19 18:55:40','2026-08-19 18:55:40'),(178,'SP-PIZZA-50-PARS','simple',NULL,1,NULL,'2026-08-19 19:26:18','2026-08-19 19:26:18'),(179,'SP-PIZZA-50-TAGHDIS','simple',NULL,1,NULL,'2026-08-19 19:26:18','2026-08-19 19:26:18'),(180,'SP-PIZZA-32-TAGHDIS','simple',NULL,1,NULL,'2026-08-19 19:26:19','2026-08-19 19:26:19'),(181,'SP-PIZZA-30-TAGHDIS','simple',NULL,1,NULL,'2026-08-19 19:26:19','2026-08-19 19:26:19'),(182,'SP-PIZZA-28-TAGHDIS','simple',NULL,1,NULL,'2026-08-19 19:26:19','2026-08-19 19:26:19'),(183,'SP-PIZZA-24-TAGHDIS','simple',NULL,1,NULL,'2026-08-19 19:26:20','2026-08-19 19:26:20'),(184,'SP-BAG-KRAFT','simple',NULL,1,NULL,'2026-08-20 00:01:46','2026-08-20 00:01:46'),(185,'SP-CUTLERY-WOOD','simple',NULL,1,NULL,'2026-08-20 00:01:46','2026-08-20 00:01:46'),(186,'SP-CUP-PAPER','simple',NULL,1,NULL,'2026-08-20 00:01:47','2026-08-20 00:01:47'),(187,'SP-CUP-PLASTIC','simple',NULL,1,NULL,'2026-08-20 00:01:47','2026-08-20 00:01:47'),(188,'SP-ICECREAM-CUP','simple',NULL,1,NULL,'2026-08-20 00:01:47','2026-08-20 00:01:47'),(189,'SP-SALAD-CLEAR','simple',NULL,1,NULL,'2026-08-20 00:01:47','2026-08-20 00:01:47'),(190,'SP-SAUCE-CUP','simple',NULL,1,NULL,'2026-08-20 00:01:48','2026-08-20 00:01:48'),(191,'SP-STRAW-SKEWER','simple',NULL,1,NULL,'2026-08-20 00:01:48','2026-08-20 00:01:48'),(192,'SP-NUTS-POUCH','simple',NULL,1,NULL,'2026-08-20 00:01:48','2026-08-20 00:01:48'),(193,'SP-MICROWAVE-BOX','simple',NULL,1,NULL,'2026-08-20 00:01:48','2026-08-20 00:01:48'),(194,'SP-FOOD-TRAY','simple',NULL,1,NULL,'2026-08-20 00:01:49','2026-08-20 00:01:49'),(195,'SP-NAPKIN-HOLDER','simple',NULL,1,NULL,'2026-08-20 00:01:49','2026-08-20 00:01:49'),(196,'SP-BURGER-CLAMSHELL','simple',NULL,1,NULL,'2026-08-20 21:03:09','2026-08-20 21:03:09'),(197,'SP-BURGER-LOCK','simple',NULL,1,NULL,'2026-08-20 21:03:09','2026-08-20 21:03:09'),(198,'SP-SANDWICH-KRAFT','simple',NULL,1,NULL,'2026-08-20 21:03:10','2026-08-20 21:03:10'),(199,'SP-SANDWICH-DRAWER','simple',NULL,1,NULL,'2026-08-20 21:03:10','2026-08-20 21:03:10'),(200,'SP-SACHET-SPICE','simple',NULL,1,NULL,'2026-08-20 21:03:10','2026-08-20 21:03:10'),(201,'SP-FOOD-TAKEAWAY','simple',NULL,1,NULL,'2026-08-20 21:03:11','2026-08-20 21:03:11'),(202,'SP-FRIED-BUCKET','simple',NULL,1,NULL,'2026-08-20 21:03:11','2026-08-20 21:03:11'),(203,'SP-TABLECLOTH','simple',NULL,1,NULL,'2026-08-20 21:03:12','2026-08-20 21:03:12'),(204,'SP-PIZZA-BOARD','simple',NULL,1,NULL,'2026-08-20 21:03:12','2026-08-20 21:03:12'),(205,'SP-CUP-CARRIER-2','simple',NULL,1,NULL,'2026-08-20 21:03:12','2026-08-20 21:03:12'),(206,'SP-ICECREAM-TRAY','simple',NULL,1,NULL,'2026-08-20 21:03:13','2026-08-20 21:03:13'),(207,'100-100','simple',NULL,1,NULL,'2026-08-21 13:16:58','2026-08-21 13:16:58'),(208,'SP-FC-002-W-100','simple',NULL,1,NULL,'2026-08-21 13:16:58','2026-08-21 13:16:59'),(209,'SP-FC-003-W-100','simple',NULL,1,NULL,'2026-08-21 13:16:59','2026-08-21 13:16:59'),(210,'SP-FC-005-W-100','simple',NULL,1,NULL,'2026-08-21 13:17:00','2026-08-21 13:17:00'),(211,'SP-FC-002-B-100','simple',NULL,1,NULL,'2026-08-21 13:17:00','2026-08-21 13:17:01'),(212,'SP-FC-003-B-100','simple',NULL,1,NULL,'2026-08-21 13:17:01','2026-08-21 13:17:01'),(213,'SP-FC-005-B-100','simple',NULL,1,NULL,'2026-08-21 13:17:01','2026-08-21 13:17:01'),(214,'SP-FC-HANDLE-W-100','simple',NULL,1,NULL,'2026-08-21 13:17:02','2026-08-21 13:17:02'),(215,'SP-FC-HANDLE-B-100','simple',NULL,1,NULL,'2026-08-21 13:17:02','2026-08-21 13:17:03'),(216,'SP-FC-TABLE-S-100','simple',NULL,1,NULL,'2026-08-21 13:17:03','2026-08-21 13:17:03'),(217,'SP-FC-TABLE-L-100','simple',NULL,1,NULL,'2026-08-21 13:17:04','2026-08-21 13:17:04'),(218,'SP-FC-PLATE-100','simple',NULL,1,NULL,'2026-08-21 13:17:04','2026-08-21 13:17:04'),(219,'SP-FF-BOX-100','simple',NULL,1,NULL,'2026-08-21 13:17:05','2026-08-21 13:17:05'),(220,'SP-FF-BOAT-S-100','simple',NULL,1,NULL,'2026-08-21 13:17:05','2026-08-21 13:17:05'),(221,'SP-FF-BOAT-L-100','simple',NULL,1,NULL,'2026-08-21 13:17:06','2026-08-21 13:17:06'),(222,'SP-FF-CONE-100','simple',NULL,1,NULL,'2026-08-21 13:17:06','2026-08-21 13:17:07'),(223,'SP-FF-NEO-100','simple',NULL,1,NULL,'2026-08-21 13:17:07','2026-08-21 13:17:07'),(224,'SP-FF-PYRAMID-S-100','simple',NULL,1,NULL,'2026-08-21 13:17:07','2026-08-21 13:17:08'),(225,'SP-FF-PYRAMID-L-100','simple',NULL,1,NULL,'2026-08-21 13:17:08','2026-08-21 13:17:08'),(226,'SP-PIZZA-50-PARS-100','simple',NULL,1,NULL,'2026-08-21 13:17:09','2026-08-21 13:17:09'),(227,'SP-PIZZA-50-TAGHDIS-100','simple',NULL,1,NULL,'2026-08-21 13:17:09','2026-08-21 13:17:09'),(228,'SP-PIZZA-32-TAGHDIS-100','simple',NULL,1,NULL,'2026-08-21 13:17:10','2026-08-21 13:17:10'),(229,'SP-PIZZA-30-TAGHDIS-100','simple',NULL,1,NULL,'2026-08-21 13:17:10','2026-08-21 13:17:10'),(230,'SP-PIZZA-28-TAGHDIS-100','simple',NULL,1,NULL,'2026-08-21 13:17:11','2026-08-21 13:17:11'),(231,'SP-PIZZA-24-TAGHDIS-100','simple',NULL,1,NULL,'2026-08-21 13:17:11','2026-08-21 13:17:11');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_items`
--

DROP TABLE IF EXISTS `refund_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refund_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_id` int unsigned DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  `refund_id` int unsigned DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `refund_items_parent_id_foreign` (`parent_id`),
  KEY `refund_items_order_item_id_foreign` (`order_item_id`),
  KEY `refund_items_refund_id_foreign` (`refund_id`),
  CONSTRAINT `refund_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refund_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `refund_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refund_items_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_items`
--

LOCK TABLES `refund_items` WRITE;
/*!40000 ALTER TABLE `refund_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refunds`
--

DROP TABLE IF EXISTS `refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refunds` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `increment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT '0',
  `total_qty` int DEFAULT NULL,
  `base_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_refund` decimal(12,4) DEFAULT '0.0000',
  `base_adjustment_refund` decimal(12,4) DEFAULT '0.0000',
  `adjustment_fee` decimal(12,4) DEFAULT '0.0000',
  `base_adjustment_fee` decimal(12,4) DEFAULT '0.0000',
  `sub_total` decimal(12,4) DEFAULT '0.0000',
  `base_sub_total` decimal(12,4) DEFAULT '0.0000',
  `grand_total` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_sub_total_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `order_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `refunds_order_id_foreign` (`order_id`),
  CONSTRAINT `refunds_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refunds`
--

LOCK TABLES `refunds` WRITE;
/*!40000 ALTER TABLE `refunds` DISABLE KEYS */;
/*!40000 ALTER TABLE `refunds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma`
--

DROP TABLE IF EXISTS `rma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned NOT NULL,
  `rma_status_id` int unsigned DEFAULT NULL,
  `package_condition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `information` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_order_id_foreign` (`order_id`),
  KEY `rma_rma_status_id_foreign` (`rma_status_id`),
  CONSTRAINT `rma_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_rma_status_id_foreign` FOREIGN KEY (`rma_status_id`) REFERENCES `rma_statuses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma`
--

LOCK TABLES `rma` WRITE;
/*!40000 ALTER TABLE `rma` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_additional_fields`
--

DROP TABLE IF EXISTS `rma_additional_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_additional_fields` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int unsigned DEFAULT NULL,
  `rma_custom_field_id` int unsigned DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_additional_fields_rma_id_foreign` (`rma_id`),
  KEY `rma_additional_fields_rma_custom_field_id_foreign` (`rma_custom_field_id`),
  CONSTRAINT `rma_additional_fields_rma_custom_field_id_foreign` FOREIGN KEY (`rma_custom_field_id`) REFERENCES `rma_custom_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_additional_fields_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_additional_fields`
--

LOCK TABLES `rma_additional_fields` WRITE;
/*!40000 ALTER TABLE `rma_additional_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_additional_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_custom_field_options`
--

DROP TABLE IF EXISTS `rma_custom_field_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_custom_field_options` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_custom_field_id` int unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_custom_field_options_rma_custom_field_id_foreign` (`rma_custom_field_id`),
  CONSTRAINT `rma_custom_field_options_rma_custom_field_id_foreign` FOREIGN KEY (`rma_custom_field_id`) REFERENCES `rma_custom_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_custom_field_options`
--

LOCK TABLES `rma_custom_field_options` WRITE;
/*!40000 ALTER TABLE `rma_custom_field_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_custom_field_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_custom_fields`
--

DROP TABLE IF EXISTS `rma_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_custom_fields` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) DEFAULT '0',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT '0',
  `position` int DEFAULT '0',
  `input_validation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rma_custom_fields_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_custom_fields`
--

LOCK TABLES `rma_custom_fields` WRITE;
/*!40000 ALTER TABLE `rma_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_images`
--

DROP TABLE IF EXISTS `rma_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_images` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int unsigned NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_images_rma_id_foreign` (`rma_id`),
  CONSTRAINT `rma_images_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_images`
--

LOCK TABLES `rma_images` WRITE;
/*!40000 ALTER TABLE `rma_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_items`
--

DROP TABLE IF EXISTS `rma_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int unsigned DEFAULT NULL,
  `rma_reason_id` int unsigned DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  `variant_id` int unsigned DEFAULT NULL,
  `quantity` int unsigned NOT NULL,
  `resolution` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_items_rma_id_foreign` (`rma_id`),
  KEY `rma_items_rma_reason_id_foreign` (`rma_reason_id`),
  KEY `rma_items_order_item_id_foreign` (`order_item_id`),
  KEY `rma_items_variant_id_foreign` (`variant_id`),
  CONSTRAINT `rma_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_items_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rma_items_rma_reason_id_foreign` FOREIGN KEY (`rma_reason_id`) REFERENCES `rma_reasons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `rma_items_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_items`
--

LOCK TABLES `rma_items` WRITE;
/*!40000 ALTER TABLE `rma_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_messages`
--

DROP TABLE IF EXISTS `rma_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_messages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_id` int unsigned NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment_path` longtext COLLATE utf8mb4_unicode_ci,
  `attachment` longtext COLLATE utf8mb4_unicode_ci,
  `is_admin` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_messages_rma_id_foreign` (`rma_id`),
  CONSTRAINT `rma_messages_rma_id_foreign` FOREIGN KEY (`rma_id`) REFERENCES `rma` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_messages`
--

LOCK TABLES `rma_messages` WRITE;
/*!40000 ALTER TABLE `rma_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `rma_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_reason_resolutions`
--

DROP TABLE IF EXISTS `rma_reason_resolutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_reason_resolutions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rma_reason_id` int unsigned NOT NULL,
  `resolution_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rma_reason_resolutions_rma_reason_id_foreign` (`rma_reason_id`),
  CONSTRAINT `rma_reason_resolutions_rma_reason_id_foreign` FOREIGN KEY (`rma_reason_id`) REFERENCES `rma_reasons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_reason_resolutions`
--

LOCK TABLES `rma_reason_resolutions` WRITE;
/*!40000 ALTER TABLE `rma_reason_resolutions` DISABLE KEYS */;
INSERT INTO `rma_reason_resolutions` VALUES (1,1,'return','2026-08-05 22:11:38','2026-08-05 22:11:38'),(2,1,'cancel_items','2026-08-05 22:11:38','2026-08-05 22:11:38'),(3,2,'return','2026-08-05 22:11:38','2026-08-05 22:11:38'),(4,2,'cancel_items','2026-08-05 22:11:38','2026-08-05 22:11:38'),(5,3,'return','2026-08-05 22:11:38','2026-08-05 22:11:38'),(6,3,'cancel_items','2026-08-05 22:11:38','2026-08-05 22:11:38'),(7,4,'return','2026-08-05 22:11:38','2026-08-05 22:11:38'),(8,4,'cancel_items','2026-08-05 22:11:38','2026-08-05 22:11:38'),(9,5,'return','2026-08-05 22:11:38','2026-08-05 22:11:38'),(10,5,'cancel_items','2026-08-05 22:11:38','2026-08-05 22:11:38');
/*!40000 ALTER TABLE `rma_reason_resolutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_reasons`
--

DROP TABLE IF EXISTS `rma_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_reasons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `position` int NOT NULL DEFAULT '0',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_reasons`
--

LOCK TABLES `rma_reasons` WRITE;
/*!40000 ALTER TABLE `rma_reasons` DISABLE KEYS */;
INSERT INTO `rma_reasons` VALUES (1,'Manufacturer Defect',1,1,0,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(2,'Damaged During Shipping',1,2,0,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(3,'Wrong Description Online',1,3,0,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(4,'Dead On Arrival',1,4,0,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(5,'Product Not Received Yet',1,5,0,'2026-08-05 22:11:38','2026-08-05 22:11:38');
/*!40000 ALTER TABLE `rma_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_rules`
--

DROP TABLE IF EXISTS `rma_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_rules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `return_period` int DEFAULT NULL,
  `default` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_rules`
--

LOCK TABLES `rma_rules` WRITE;
/*!40000 ALTER TABLE `rma_rules` DISABLE KEYS */;
INSERT INTO `rma_rules` VALUES (1,'Basic','1',1,10,NULL,'2026-08-05 22:11:39','2026-08-05 22:11:39');
/*!40000 ALTER TABLE `rma_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rma_statuses`
--

DROP TABLE IF EXISTS `rma_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rma_statuses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rma_statuses`
--

LOCK TABLES `rma_statuses` WRITE;
/*!40000 ALTER TABLE `rma_statuses` DISABLE KEYS */;
INSERT INTO `rma_statuses` VALUES (1,'Pending Review',1,'#efb308',1,NULL,NULL),(2,'Approved',1,'#12af56',1,NULL,NULL),(3,'Awaiting Return',1,'#f59e0b',1,NULL,NULL),(4,'Return In Transit',1,'#3b82f6',1,NULL,NULL),(5,'Refunded',1,'#10b981',1,NULL,NULL),(6,'Solved',1,'#47b84f',1,NULL,NULL),(7,'Request Declined',1,'#e11d48',1,NULL,NULL),(8,'Item Canceled',1,'#dc2626',1,NULL,NULL),(9,'Request Canceled',1,'#991b1b',1,NULL,NULL);
/*!40000 ALTER TABLE `rma_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permission_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrator','This role users will have all the access','all',NULL,NULL,NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_synonyms`
--

DROP TABLE IF EXISTS `search_synonyms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_synonyms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `terms` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_synonyms`
--

LOCK TABLES `search_synonyms` WRITE;
/*!40000 ALTER TABLE `search_synonyms` DISABLE KEYS */;
INSERT INTO `search_synonyms` VALUES (1,'جعبه سوخاری','جعبه سوخاری,باکس سوخاری,جعبه مرغ سوخاری,ظرف سوخاری,بسته بندی سوخاری','2026-08-19 18:55:40','2026-08-19 18:55:40'),(2,'جعبه سیب زمینی','جعبه سیب زمینی,پاکت سیب زمینی,ظرف سیب زمینی,باکس سیب زمینی,جعبه سیب زمینی سرخ کرده','2026-08-19 18:55:40','2026-08-19 18:55:40'),(3,'کاغذ ساندویچ','کاغذ ساندویچ,کاغذ دور ساندویچ,کاغذ کرافت غذا,کاغذ فست فود,کاغذ بسته بندی غذا','2026-08-19 18:55:40','2026-08-19 18:55:40'),(4,'دسته دار','دسته دار,دسته‌دار,جعبه دسته دار,باکس دسته دار','2026-08-19 18:55:40','2026-08-19 18:55:40'),(5,'جعبه پیتزا','جعبه پیتزا,باکس پیتزا,کارتن پیتزا,جعبه پیتزا کرافت,جعبه پیتزا ایفلوت','2026-08-19 19:26:20','2026-08-19 19:26:20');
/*!40000 ALTER TABLE `search_synonyms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_terms`
--

DROP TABLE IF EXISTS `search_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_terms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `term` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `results` int NOT NULL DEFAULT '0',
  `uses` int NOT NULL DEFAULT '0',
  `redirect_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_in_suggested_terms` tinyint(1) NOT NULL DEFAULT '0',
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `search_terms_channel_id_foreign` (`channel_id`),
  CONSTRAINT `search_terms_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_terms`
--

LOCK TABLES `search_terms` WRITE;
/*!40000 ALTER TABLE `search_terms` DISABLE KEYS */;
INSERT INTO `search_terms` VALUES (1,'جعبه برگر',0,1,NULL,0,'en',1,'2026-08-06 17:46:25','2026-08-06 17:46:25'),(2,'کاغذ کرافت',0,1,NULL,0,'en',1,'2026-08-06 18:07:12','2026-08-06 18:07:12'),(3,'جعبه ساندویچ',0,1,NULL,0,'en',1,'2026-08-07 11:30:25','2026-08-07 11:30:25'),(4,'جعبه سوخاری',0,2,NULL,0,'en',1,'2026-08-15 18:37:58','2026-08-15 18:40:36'),(5,'جعبه سوخاری',11,17,NULL,0,'fa',1,'2026-08-15 18:45:16','2026-08-19 20:24:45'),(6,'سوخاری',1,1,NULL,0,'fa',1,'2026-08-16 15:44:09','2026-08-16 15:44:09'),(7,'باکس سوخاری',11,2,NULL,0,'fa',1,'2026-08-19 18:57:55','2026-08-19 19:02:19'),(8,'پاکت سیب زمینی',7,1,NULL,0,'fa',1,'2026-08-19 19:02:45','2026-08-19 19:02:45'),(9,'کاغذ دور ساندویچ',2,2,NULL,0,'fa',1,'2026-08-19 19:02:56','2026-08-19 19:29:05'),(10,'جعبه پیتزا',6,2,NULL,0,'fa',1,'2026-08-19 19:27:36','2026-08-19 19:30:45'),(11,'جعبه برگر',0,1,NULL,0,'fa',1,'2026-08-19 22:53:12','2026-08-19 22:53:12'),(12,'جعبه ساندویچ',0,1,NULL,0,'fa',1,'2026-08-19 22:53:23','2026-08-19 22:53:23'),(13,'جعبه سیب زمینی',7,1,NULL,0,'fa',1,'2026-08-19 22:53:29','2026-08-19 22:53:29'),(14,'پک قاشق و چنگال',0,1,NULL,0,'fa',1,'2026-08-20 15:16:31','2026-08-20 15:16:31'),(15,'لیوان یکبار مصرف',0,1,NULL,0,'fa',1,'2026-08-20 15:16:44','2026-08-20 15:16:44'),(16,'بسته بندی آجیل',0,1,NULL,0,'fa',1,'2026-08-20 15:16:56','2026-08-20 15:16:56'),(17,'بسته بندی ساشه',0,1,NULL,0,'fa',1,'2026-08-20 15:18:01','2026-08-20 15:18:01');
/*!40000 ALTER TABLE `search_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_items`
--

DROP TABLE IF EXISTS `shipment_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `price` decimal(12,4) DEFAULT '0.0000',
  `base_price` decimal(12,4) DEFAULT '0.0000',
  `total` decimal(12,4) DEFAULT '0.0000',
  `base_total` decimal(12,4) DEFAULT '0.0000',
  `price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price_incl_tax` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `product_id` int unsigned DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  `shipment_id` int unsigned NOT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_items_shipment_id_foreign` (`shipment_id`),
  CONSTRAINT `shipment_items_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_items`
--

LOCK TABLES `shipment_items` WRITE;
/*!40000 ALTER TABLE `shipment_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_qty` int DEFAULT NULL,
  `total_weight` decimal(12,4) DEFAULT NULL,
  `carrier_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrier_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `track_number` text COLLATE utf8mb4_unicode_ci,
  `email_sent` tinyint(1) NOT NULL DEFAULT '0',
  `customer_id` int unsigned DEFAULT NULL,
  `customer_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int unsigned NOT NULL,
  `order_address_id` int unsigned DEFAULT NULL,
  `inventory_source_id` int unsigned DEFAULT NULL,
  `inventory_source_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipments_order_id_foreign` (`order_id`),
  KEY `shipments_inventory_source_id_foreign` (`inventory_source_id`),
  CONSTRAINT `shipments_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipments`
--

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitemap_channels`
--

DROP TABLE IF EXISTS `sitemap_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitemap_channels` (
  `sitemap_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  UNIQUE KEY `sitemap_channels_sitemap_id_channel_id_unique` (`sitemap_id`,`channel_id`),
  KEY `sitemap_channels_channel_id_foreign` (`channel_id`),
  CONSTRAINT `sitemap_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sitemap_channels_sitemap_id_foreign` FOREIGN KEY (`sitemap_id`) REFERENCES `sitemaps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitemap_channels`
--

LOCK TABLES `sitemap_channels` WRITE;
/*!40000 ALTER TABLE `sitemap_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitemap_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitemaps`
--

DROP TABLE IF EXISTS `sitemaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitemaps` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `additional` json DEFAULT NULL,
  `generated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitemaps`
--

LOCK TABLES `sitemaps` WRITE;
/*!40000 ALTER TABLE `sitemaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitemaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribers_list`
--

DROP TABLE IF EXISTS `subscribers_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscribers_list` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_subscribed` tinyint(1) NOT NULL DEFAULT '0',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int unsigned DEFAULT NULL,
  `channel_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscribers_list_customer_id_foreign` (`customer_id`),
  KEY `subscribers_list_channel_id_foreign` (`channel_id`),
  CONSTRAINT `subscribers_list_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subscribers_list_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribers_list`
--

LOCK TABLES `subscribers_list` WRITE;
/*!40000 ALTER TABLE `subscribers_list` DISABLE KEYS */;
INSERT INTO `subscribers_list` VALUES (4,'ehvbpc@gmail.com',1,'6a92b43bda9b6',10,1,'2026-08-29 13:58:11','2026-08-29 13:58:11');
/*!40000 ALTER TABLE `subscribers_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_categories`
--

DROP TABLE IF EXISTS `tax_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_categories_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_categories`
--

LOCK TABLES `tax_categories` WRITE;
/*!40000 ALTER TABLE `tax_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_categories_tax_rates`
--

DROP TABLE IF EXISTS `tax_categories_tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_categories_tax_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tax_category_id` int unsigned NOT NULL,
  `tax_rate_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_map_index_unique` (`tax_category_id`,`tax_rate_id`),
  KEY `tax_categories_tax_rates_tax_rate_id_foreign` (`tax_rate_id`),
  CONSTRAINT `tax_categories_tax_rates_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tax_categories_tax_rates_tax_rate_id_foreign` FOREIGN KEY (`tax_rate_id`) REFERENCES `tax_rates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_categories_tax_rates`
--

LOCK TABLES `tax_categories_tax_rates` WRITE;
/*!40000 ALTER TABLE `tax_categories_tax_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax_categories_tax_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_rates`
--

DROP TABLE IF EXISTS `tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_zip` tinyint(1) NOT NULL DEFAULT '0',
  `zip_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_from` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tax_rate` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tax_rates_identifier_unique` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_rates`
--

LOCK TABLES `tax_rates` WRITE;
/*!40000 ALTER TABLE `tax_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theme_customization_translations`
--

DROP TABLE IF EXISTS `theme_customization_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_customization_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `theme_customization_id` int unsigned NOT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `theme_customization_id_foreign` (`theme_customization_id`),
  CONSTRAINT `theme_customization_id_foreign` FOREIGN KEY (`theme_customization_id`) REFERENCES `theme_customizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme_customization_translations`
--

LOCK TABLES `theme_customization_translations` WRITE;
/*!40000 ALTER TABLE `theme_customization_translations` DISABLE KEYS */;
INSERT INTO `theme_customization_translations` VALUES (1,1,'en','{\"images\": [{\"link\": \"formal-wear-female\", \"image\": \"storage/theme/1/l4S7PMtCjF86cYxDx0F7LDD8LiLqsnvkmdDABEyZ.webp\", \"title\": \"Get Ready For New Collection\"}, {\"link\": \"formal-wear-men\", \"image\": \"storage/theme/1/1AELYELNCeXw4aumniMjSPlbSbjTtisDiIlXqBBi.webp\", \"title\": \"Get Ready For New Collection\"}, {\"link\": \"active-wear-female\", \"image\": \"storage/theme/1/20Os8TOvKS7w5E3izy9qZBoc4XQZ9nAlCNWryLNk.webp\", \"title\": \"Get Ready For New Collection\"}, {\"link\": \"smart-home-automation\", \"image\": \"storage/theme/1/5YmckyxN30JWr0gUytjM6z8eyZIDsOrHvg6S113P.webp\", \"title\": \"Get Ready For New Collection\"}, {\"link\": \"mobile-phones-accessories\", \"image\": \"storage/theme/1/RrzC022stKcdjImv61jaLmDcjaawOYB61Eui03la.webp\", \"title\": \"Get Ready For New Collection\"}, {\"link\": \"laptops-tablets\", \"image\": \"storage/theme/1/rApdSsozazXRAdCYTx1hY6PDgSLRiTY8rMFrSyHe.webp\", \"title\": \"Get Ready For New Collection\"}]}'),(2,2,'en','{\"css\": \".home-offer h1 {display: block;font-weight: 500;text-align: center;font-size: 22px;font-family: DM Serif Display;background-color: #E8EDFE;padding-top: 20px;padding-bottom: 20px;}@media (max-width:768px){.home-offer h1 {font-size:18px;padding-top: 10px;padding-bottom: 10px;}@media (max-width:525px) {.home-offer h1 {font-size:14px;padding-top: 6px;padding-bottom: 6px;}}\", \"html\": \"<div class=\\\"home-offer\\\"><h1>Get UPTO 40% OFF on your 1st order SHOP NOW</h1></div>\"}'),(3,3,'en','{\"css\": \".top-collection-container {overflow: hidden;}.top-collection-header {padding-left: 15px;padding-right: 15px;text-align: center;font-size: 70px;line-height: 90px;color: #060C3B;margin-top: 80px;}.top-collection-header h2 {max-width: 595px;margin-left: auto;margin-right: auto;font-family: DM Serif Display;}.top-collection-grid {display: flex;flex-wrap: wrap;gap: 32px;justify-content: center;margin-top: 60px;width: 100%;margin-right: auto;margin-left: auto;padding-right: 90px;padding-left: 90px;}.top-collection-card {position: relative;background: #f9fafb;overflow:hidden;border-radius:20px;}.top-collection-card img {border-radius: 16px;max-width: 100%;text-indent:-9999px;transition: transform 300ms ease;transform: scale(1);}.top-collection-card:hover img {transform: scale(1.05);transition: all 300ms ease;}.top-collection-card h3 {color: #060C3B;font-size: 30px;font-family: DM Serif Display;transform: translateX(-50%);width: max-content;left: 50%;bottom: 30px;position: absolute;margin: 0;font-weight: inherit;}@media not all and (min-width: 525px) {.top-collection-header {margin-top: 28px;font-size: 20px;line-height: 1.5;}.top-collection-grid {gap: 10px}}@media not all and (min-width: 768px) {.top-collection-header {margin-top: 30px;font-size: 28px;line-height: 3;}.top-collection-header h2 {line-height:2; margin-bottom:20px;} .top-collection-grid {gap: 14px}} @media not all and (min-width: 1024px) {.top-collection-grid {padding-left: 30px;padding-right: 30px;}}@media (max-width: 768px) {.top-collection-grid { row-gap:15px; column-gap:0px;justify-content: space-between;margin-top: 0px;} .top-collection-card{width:48%} .top-collection-card img {width:100%;} .top-collection-card h3 {font-size:24px; bottom: 16px;}}@media (max-width:520px) { .top-collection-grid{padding-left: 15px;padding-right: 15px;} .top-collection-card h3 {font-size:18px; bottom: 10px;}}\", \"html\": \"<div class=\\\"top-collection-container\\\">\\n                                <div class=\\\"top-collection-header\\\">\\n                                    <h2>The game with our new additions!</h2>\\n                                </div>\\n\\n                                <div class=\\\"top-collection-grid container\\\">\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"electronics\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/SslcDsUUBiVu8sIcrwyjKnEnUA1YsCnmTPrxlQf5.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"mens\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/9QiafpBymGEeBT43YXGYazQpY0P0IRA9rpuyzhrK.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"womens\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/uFC8ZTARh1ve1vwO5UgxCT7ivs6XEdfoUSmGtmpH.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"formal-wear-men\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/cME5v7CnzyMAb9A1s5TD7ByTUOChEBZodnVhHXOY.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"formal-wear-female\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/aSgk81P4sojvHt958p3OcAFJyw0TcDU5MPfgz2w2.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n\\n                                    <div class=\\\"top-collection-card\\\">\\n                                        <a href=\\\"wellness\\\" aria-label=\\\"The game with our new additions!\\\">\\n                                            <img src=\\\"\\\" data-src=\\\"storage/theme/5/XDjk8rKjmSEhfynPkLfND9at9aAhWtXKUF8QXHz5.webp\\\" class=\\\"lazy\\\" width=\\\"396\\\" height=\\\"396\\\" alt=\\\"The game with our new additions!\\\">\\n                                        </a>\\n                                    </div>\\n                                </div>\\n                            </div>\"}'),(4,4,'en','{\"css\": \".section-gap{margin-top:80px}.direction-ltr{direction:ltr}.direction-rtl{direction:rtl}.inline-col-wrapper{display:grid;grid-template-columns:auto 1fr;grid-gap:60px;align-items:center}.inline-col-wrapper .inline-col-image-wrapper{overflow:hidden}.inline-col-wrapper .inline-col-image-wrapper img{max-width:100%;height:auto;border-radius:16px;text-indent:-9999px}.inline-col-wrapper .inline-col-content-wrapper{display:flex;flex-wrap:wrap;gap:20px;max-width:464px}.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{max-width:442px;font-size:60px;font-weight:400;color:#060c3b;line-height:70px;font-family:DM Serif Display;margin:0}.inline-col-wrapper .inline-col-content-wrapper .inline-col-description{margin:0;font-size:18px;color:#6e6e6e;font-family:Poppins}@media (max-width:991px){.inline-col-wrapper{grid-template-columns:1fr;grid-gap:16px}.inline-col-wrapper .inline-col-content-wrapper{gap:10px}} @media (max-width:768px){.inline-col-wrapper .inline-col-image-wrapper img {width:100%;} .inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:28px !important;line-height:normal !important}} @media (max-width:525px){.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:20px !important;} .inline-col-description{font-size:16px} .inline-col-wrapper{grid-gap:10px}}\", \"html\": \"<div class=\\\"section-gap bold-collections container\\\">\\n                                <div class=\\\"inline-col-wrapper\\\">\\n                                    <div class=\\\"inline-col-image-wrapper\\\">\\n                                        <img src=\\\"\\\" data-src=\\\"storage/theme/6/vamgnxS7WewQm1knSrYpa2b96zUyyE7BSXkdrQ6f.webp\\\" class=\\\"lazy\\\" width=\\\"632\\\" height=\\\"510\\\" alt=\\\"Get Ready for our new Bold Collections!\\\">\\n                                    </div>\\n\\n                                    <div class=\\\"inline-col-content-wrapper\\\">\\n                                        <h2 class=\\\"inline-col-title\\\"> Get Ready for our new Bold Collections! </h2> \\n                                        \\n                                        <p class=\\\"inline-col-description\\\">Introducing Our New Bold Collections! Elevate your style with daring designs and vibrant statements. Explore striking patterns and bold colors that redefine your wardrobe. Get ready to embrace the extraordinary!</p>\\n                                        \\n                                        <a href=\\\"wellness\\\">\\n                                            <button class=\\\"primary-button max-md:rounded-lg max-md:px-4 max-md:py-2.5 max-md:text-sm\\\">View Collections</button>\\n                                        </a>\\n                                    </div>\\n                                </div>\\n                            </div>\"}'),(5,5,'en','{\"css\": \".section-game {overflow: hidden;}.section-title,.section-title h2{font-weight:400;font-family:DM Serif Display}.section-title{margin-top:80px;padding-left:15px;padding-right:15px;text-align:center;line-height:90px}.section-title h2{font-size:70px;color:#060c3b;max-width:595px;margin:auto}.collection-card-wrapper{display:flex;flex-wrap:wrap;justify-content:center;gap:30px}.collection-card-wrapper .single-collection-card{position:relative}.collection-card-wrapper .single-collection-card img{border-radius:16px;background-color:#f5f5f5;max-width:100%;height:auto;text-indent:-9999px}.collection-card-wrapper .single-collection-card .overlay-text{font-size:50px;font-weight:400;max-width:234px;font-style:italic;color:#060c3b;font-family:DM Serif Display;position:absolute;bottom:30px;left:30px;margin:0}@media (max-width:1024px){.section-title{padding:0 30px}}@media (max-width:991px){.collection-card-wrapper{flex-wrap:wrap}}@media (max-width:768px) {.collection-card-wrapper .single-collection-card .overlay-text{font-size:32px; bottom:20px}.section-title{margin-top:32px}.section-title h2{font-size:28px;line-height:normal}} @media (max-width:525px){.collection-card-wrapper .single-collection-card .overlay-text{font-size:18px; bottom:10px} .section-title{margin-top:28px}.section-title h2{font-size:20px;} .collection-card-wrapper{gap:10px; 15px; row-gap:15px; column-gap:0px;justify-content: space-between;margin-top: 15px;} .collection-card-wrapper .single-collection-card {width:48%;}}\", \"html\": \"<div class=\\\"section-game\\\">\\n                                <div class=\\\"section-title\\\">\\n                                    <h2>The game with our new additions!</h2> \\n                                </div>\\n\\n                                <div class=\\\"section-gap container\\\">\\n                                    <div class=\\\"collection-card-wrapper\\\">\\n                                        <div class=\\\"single-collection-card\\\">\\n                                            <a href=\\\"active-wear\\\">\\n                                                <img src=\\\"\\\" data-src=\\\"storage/theme/8/I45rcVn4QKbijVTzhLtWDfpgQjRK5GE0Bd5l0KJt.webp\\\" class=\\\"lazy\\\" width=\\\"615\\\" height=\\\"600\\\" alt=\\\"The game with our new additions!\\\">\\n                                                \\n                                                <h3 class=\\\"overlay-text\\\">Our Collections</h3> \\n                                            </a>\\n                                        </div>\\n\\n                                        <div class=\\\"single-collection-card\\\">\\n                                            <a href=\\\"active-wear-female\\\">\\n                                                <img src=\\\"\\\" data-src=\\\"storage/theme/8/XRKbg8D9KLCuOTlZF8BcMjX3aVOghXHnfn0nfE96.webp\\\" class=\\\"lazy\\\" width=\\\"615\\\" height=\\\"600\\\" alt=\\\"The game with our new additions!\\\">\\n                                                \\n                                                <h3 class=\\\"overlay-text\\\"> Our Collections </h3> \\n                                            </a>\\n                                        </div>\\n                                    </div>\\n                                </div>\\n                            </div>\"}'),(6,6,'en','{\"css\": \".section-gap{margin-top:80px}.direction-ltr{direction:ltr}.direction-rtl{direction:rtl}.inline-col-wrapper{display:grid;grid-template-columns:auto 1fr;grid-gap:60px;align-items:center}.inline-col-wrapper .inline-col-image-wrapper{overflow:hidden}.inline-col-wrapper .inline-col-image-wrapper img{max-width:100%;height:auto;border-radius:16px;text-indent:-9999px}.inline-col-wrapper .inline-col-content-wrapper{display:flex;flex-wrap:wrap;gap:20px;max-width:464px}.inline-col-wrapper .inline-col-content-wrapper .inline-col-title{max-width:442px;font-size:60px;font-weight:400;color:#060c3b;line-height:70px;font-family:DM Serif Display;margin:0}.inline-col-wrapper .inline-col-content-wrapper .inline-col-description{margin:0;font-size:18px;color:#6e6e6e;font-family:Poppins}@media (max-width:991px){.inline-col-wrapper{grid-template-columns:1fr;grid-gap:16px}.inline-col-wrapper .inline-col-content-wrapper{gap:10px}}@media (max-width:768px) {.inline-col-wrapper .inline-col-image-wrapper img {max-width:100%;}.inline-col-wrapper .inline-col-content-wrapper{max-width:100%;justify-content:center; text-align:center} .section-gap{padding:0 30px; gap:20px;margin-top:24px} .bold-collections{margin-top:32px;}} @media (max-width:525px){.inline-col-wrapper .inline-col-content-wrapper{gap:10px} .inline-col-wrapper .inline-col-content-wrapper .inline-col-title{font-size:20px;line-height:normal} .section-gap{padding:0 15px; gap:15px;margin-top:10px} .bold-collections{margin-top:28px;}  .inline-col-description{font-size:16px !important} .inline-col-wrapper{grid-gap:15px}\", \"html\": \"<div class=\\\"section-gap bold-collections container\\\">\\n                                <div class=\\\"inline-col-wrapper direction-rtl\\\">\\n                                    <div class=\\\"inline-col-image-wrapper\\\">\\n                                        <img src=\\\"\\\" data-src=\\\"storage/theme/10/2cFsW7BtPZx2uHgG4kY7mHunoOO7AXvJ7Wl04dy8.webp\\\" class=\\\"lazy\\\" width=\\\"632\\\" height=\\\"510\\\" alt=\\\"Unleash Your Boldness with Our New Collection!\\\">\\n                                    </div>\\n\\n                                    <div class=\\\"inline-col-content-wrapper direction-ltr\\\">\\n                                        <h2 class=\\\"inline-col-title\\\">Unleash Your Boldness with Our New Collection!</h2> \\n                                        \\n                                        <p class=\\\"inline-col-description\\\">Our Bold Collections are here to redefine your wardrobe with fearless designs and striking, vibrant colors. From daring patterns to powerful hues, this is your chance to break away from the ordinary and step into the extraordinary.</p>\\n                                        \\n                                        <a href=\\\"electronics\\\">\\n                                            <button class=\\\"primary-button max-md:rounded-lg max-md:px-4 max-md:py-2.5 max-md:text-sm\\\">View Collections</button>\\n                                        </a>\\n                                    </div>\\n                                </div>\\n                            </div>\"}'),(7,7,'en','{\"column_1\": [{\"url\": \"http://127.0.0.1:8000/page/about-us\", \"title\": \"About Us\", \"sort_order\": 1}, {\"url\": \"http://127.0.0.1:8000/contact-us\", \"title\": \"Contact Us\", \"sort_order\": 2}, {\"url\": \"http://127.0.0.1:8000/page/customer-service\", \"title\": \"Customer Service\", \"sort_order\": 3}, {\"url\": \"http://127.0.0.1:8000/page/whats-new\", \"title\": \"What\'s New\", \"sort_order\": 4}, {\"url\": \"http://127.0.0.1:8000/page/terms-of-use\", \"title\": \"Terms of Use\", \"sort_order\": 5}, {\"url\": \"http://127.0.0.1:8000/page/terms-conditions\", \"title\": \"Terms & Conditions\", \"sort_order\": 6}], \"column_2\": [{\"url\": \"http://127.0.0.1:8000/page/privacy-policy\", \"title\": \"Privacy Policy\", \"sort_order\": 1}, {\"url\": \"http://127.0.0.1:8000/page/payment-policy\", \"title\": \"Payment Policy\", \"sort_order\": 2}, {\"url\": \"http://127.0.0.1:8000/page/shipping-policy\", \"title\": \"Shipping Policy\", \"sort_order\": 3}, {\"url\": \"http://127.0.0.1:8000/page/refund-policy\", \"title\": \"Refund Policy\", \"sort_order\": 4}, {\"url\": \"http://127.0.0.1:8000/page/return-policy\", \"title\": \"Return Policy\", \"sort_order\": 5}]}'),(8,8,'en','{\"services\": [{\"title\": \"Free Shipping\", \"description\": \"Enjoy free shipping on all orders\", \"service_icon\": \"icon-truck\"}, {\"title\": \"Product Replace\", \"description\": \"Easy Product Replacement Available!\", \"service_icon\": \"icon-product\"}, {\"title\": \"Emi Available\", \"description\": \"No cost EMI available on all major credit cards\", \"service_icon\": \"icon-dollar-sign\"}, {\"title\": \"24/7 Support\", \"description\": \"Dedicated 24/7 support via chat and email\", \"service_icon\": \"icon-support\"}]}'),(9,9,'en','{\"filters\": {\"sort\": \"asc\", \"limit\": 10, \"parent_id\": 1}}'),(10,10,'en','{\"title\": \"Mens Collection\", \"filters\": {\"sort\": \"created_at-desc\", \"limit\": 10, \"category_id\": 2}}'),(11,11,'en','{\"title\": \"Womens Collection\", \"filters\": {\"sort\": \"created_at-desc\", \"limit\": 10, \"category_id\": 4}}'),(12,12,'en','{\"title\": \"Kids Collection\", \"filters\": {\"sort\": \"price-desc\", \"limit\": 10, \"category_id\": 3}}'),(13,13,'en','{\"title\": \"Book Tickets\", \"filters\": {\"sort\": \"name-asc\", \"limit\": 10, \"category_id\": 26}}');
/*!40000 ALTER TABLE `theme_customization_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theme_customizations`
--

DROP TABLE IF EXISTS `theme_customizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_customizations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `theme_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'default',
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `channel_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `theme_customizations_channel_id_foreign` (`channel_id`),
  CONSTRAINT `theme_customizations_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme_customizations`
--

LOCK TABLES `theme_customizations` WRITE;
/*!40000 ALTER TABLE `theme_customizations` DISABLE KEYS */;
INSERT INTO `theme_customizations` VALUES (1,'default','image_carousel','Image Carousel',1,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(2,'default','static_content','Offer Information',2,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(3,'default','static_content','Top Collections',5,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(4,'default','static_content','Bold Collections',6,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(5,'default','static_content','Game Container',8,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(6,'default','static_content','Bold Collections',10,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(7,'default','footer_links','Footer Links',11,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(8,'default','services_content','Services Content',12,1,1,'2026-08-05 22:11:38','2026-08-05 22:11:38'),(9,'default','category_carousel','Categories Collections',3,1,1,'2026-08-05 22:11:43','2026-08-05 22:11:43'),(10,'default','product_carousel','Mens Collection',4,1,1,'2026-08-05 22:11:43','2026-08-05 22:11:43'),(11,'default','product_carousel','Womens Collection',7,1,1,'2026-08-05 22:11:43','2026-08-05 22:11:43'),(12,'default','product_carousel','Kids Collection',9,1,1,'2026-08-05 22:11:43','2026-08-05 22:11:43'),(13,'default','product_carousel','Book Tickets',13,1,1,'2026-08-05 22:11:43','2026-08-05 22:11:43');
/*!40000 ALTER TABLE `theme_customizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `url_rewrites`
--

DROP TABLE IF EXISTS `url_rewrites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `url_rewrites` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `url_rewrites_et_rp_lc_idx` (`entity_type`,`request_path`,`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `url_rewrites`
--

LOCK TABLES `url_rewrites` WRITE;
/*!40000 ALTER TABLE `url_rewrites` DISABLE KEYS */;
INSERT INTO `url_rewrites` VALUES (2,'product','سوخاری-دو-تیکه','جعبه-سوخاری-دو-تکه-کرافت','301','fa','2026-08-18 18:58:05','2026-08-18 18:58:05');
/*!40000 ALTER TABLE `url_rewrites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `item_options` json DEFAULT NULL,
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `time_of_moving` date DEFAULT NULL,
  `additional` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wishlist_channel_id_foreign` (`channel_id`),
  KEY `wishlist_product_id_foreign` (`product_id`),
  KEY `wishlist_customer_id_foreign` (`customer_id`),
  CONSTRAINT `wishlist_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist_items`
--

DROP TABLE IF EXISTS `wishlist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `additional` json DEFAULT NULL,
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wishlist_items_channel_id_foreign` (`channel_id`),
  KEY `wishlist_items_product_id_foreign` (`product_id`),
  KEY `wishlist_items_customer_id_foreign` (`customer_id`),
  CONSTRAINT `wishlist_items_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_items_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist_items`
--

LOCK TABLES `wishlist_items` WRITE;
/*!40000 ALTER TABLE `wishlist_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zarinpal_transactions`
--

DROP TABLE IF EXISTS `zarinpal_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zarinpal_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` int NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `card_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `card_pan` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fee_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Merchant',
  `fee` int NOT NULL,
  `order_id` bigint unsigned DEFAULT NULL,
  `amount` bigint unsigned NOT NULL,
  `status` enum('success','failed','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zarinpal_transactions`
--

LOCK TABLES `zarinpal_transactions` WRITE;
/*!40000 ALTER TABLE `zarinpal_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `zarinpal_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'shamim'
--

--
-- Dumping routines for database 'shamim'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-30 12:23:50
