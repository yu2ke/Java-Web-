-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: restaurant_order
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `restaurant_order`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `restaurant_order` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `restaurant_order`;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `dept_id` int unsigned NOT NULL AUTO_INCREMENT,
  `dept_name` varchar(50) NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `dept_name` (`dept_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门/工作单位';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'研发部','2026-09-10 21:26:54'),(2,'市场部','2026-09-10 21:26:54'),(3,'行政部','2026-09-10 21:26:54'),(4,'财务部','2026-09-10 21:26:54');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `menu_id` int unsigned NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名字',
  `is_current` tinyint(1) NOT NULL DEFAULT '0' COMMENT '当前启用菜单(0/1)',
  `current_key` int GENERATED ALWAYS AS (if((`is_current` = 1),1,NULL)) STORED COMMENT '配合唯一索引保证只有一个当前菜单',
  `create_by` int unsigned DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`menu_id`),
  UNIQUE KEY `uq_menu_current` (`current_key`),
  KEY `fk_menu_create_by` (`create_by`),
  CONSTRAINT `fk_menu_create_by` FOREIGN KEY (`create_by`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` (`menu_id`, `menu_name`, `is_current`, `create_by`, `create_time`) VALUES (1,'本周标准菜单',1,1,'2026-09-10 21:26:54'),(2,'上周菜单',0,1,'2026-09-10 21:26:54');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_item`
--

DROP TABLE IF EXISTS `menu_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_item` (
  `item_id` int unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` int unsigned NOT NULL,
  `recipe_id` int unsigned DEFAULT NULL COMMENT '来源食谱(仅追溯,可置空)',
  `dish_name` varchar(50) NOT NULL COMMENT '菜名(快照)',
  `classify` varchar(20) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `unit` varchar(10) NOT NULL COMMENT '单位(快照)',
  `price` decimal(8,2) NOT NULL COMMENT '价格(快照,可改)',
  PRIMARY KEY (`item_id`),
  KEY `fk_mi_recipe` (`recipe_id`),
  KEY `idx_mi_menu` (`menu_id`),
  CONSTRAINT `fk_mi_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mi_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`) ON DELETE SET NULL,
  CONSTRAINT `menu_item_chk_1` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单菜品(快照)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_item`
--

LOCK TABLES `menu_item` WRITE;
/*!40000 ALTER TABLE `menu_item` DISABLE KEYS */;
INSERT INTO `menu_item` VALUES (1,1,1,'炒白菜','菜肴',NULL,'份',3.00),(2,1,2,'西红柿蛋汤','汤',NULL,'份',3.00),(3,1,3,'小炒肉','菜肴',NULL,'份',5.00),(4,1,4,'米饭','主食',NULL,'两',0.30),(5,1,6,'银耳汤','甜点',NULL,'碗',4.00),(6,1,5,'馒头','主食',NULL,'个',1.00),(7,1,7,'西红柿炒鸡蛋','菜肴',NULL,'份',6.00),(8,1,8,'莲藕汤','汤',NULL,'份',4.00),(9,2,3,'小炒肉','菜肴',NULL,'份',5.50),(10,2,4,'米饭','主食',NULL,'两',0.30);
/*!40000 ALTER TABLE `menu_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `oitem_id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned NOT NULL,
  `dish_name` varchar(50) NOT NULL COMMENT '菜名(快照)',
  `unit` varchar(10) NOT NULL COMMENT '单位(快照)',
  `classify` varchar(20) DEFAULT NULL,
  `quantity` decimal(8,2) NOT NULL COMMENT '分量',
  `price` decimal(8,2) NOT NULL COMMENT '单价(快照)',
  `amount` decimal(10,2) NOT NULL COMMENT '合计价格=分量*单价(触发器计算)',
  PRIMARY KEY (`oitem_id`),
  KEY `idx_oitem_order` (`order_id`),
  KEY `idx_oitem_dish` (`dish_name`),
  CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_oi_amount` CHECK ((`amount` = (`quantity` * `price`))),
  CONSTRAINT `order_item_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,'米饭','两','主食',2.00,0.30,0.60),(2,1,'小炒肉','份','菜肴',1.00,5.00,5.00),(3,2,'米饭','两','主食',3.00,0.30,0.90),(4,2,'馒头','个','主食',2.00,1.00,2.00),(5,3,'米饭','两','主食',4.00,0.30,1.20),(6,3,'小炒肉','份','菜肴',1.00,5.00,5.00),(7,3,'西红柿蛋汤','份','汤',1.00,3.00,3.00),(8,4,'米饭','两','主食',2.00,0.30,0.60),(9,4,'银耳汤','碗','甜点',1.00,4.00,4.00),(10,5,'小炒肉','份','菜肴',1.00,5.00,5.00),(11,5,'米饭','两','主食',2.00,0.30,0.60),(12,6,'米饭','两','主食',2.00,0.30,0.60),(13,6,'西红柿炒鸡蛋','份','菜肴',1.00,6.00,6.00),(14,6,'莲藕汤','份','汤',1.00,4.00,4.00),(15,7,'炒白菜','份','菜肴',1.00,3.00,3.00),(16,7,'米饭','两','主食',2.00,0.30,0.60),(17,8,'小炒肉','份','菜肴',1.00,5.00,5.00),(18,8,'米饭','两','主食',2.00,0.30,0.60),(19,9,'馒头','个','主食',2.00,1.00,2.00),(20,9,'银耳汤','碗','甜点',1.00,4.00,4.00);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_oitem_before_insert` BEFORE INSERT ON `order_item` FOR EACH ROW BEGIN
  SET NEW.amount = NEW.quantity * NEW.price;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_order_total_ai` AFTER INSERT ON `order_item` FOR EACH ROW BEGIN
  UPDATE orders o
     SET o.total_price = (SELECT IFNULL(SUM(amount),0) FROM order_item WHERE order_id=NEW.order_id)
   WHERE o.order_id = NEW.order_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_oitem_before_update` BEFORE UPDATE ON `order_item` FOR EACH ROW BEGIN
  SET NEW.amount = NEW.quantity * NEW.price;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_order_total_au` AFTER UPDATE ON `order_item` FOR EACH ROW BEGIN
  UPDATE orders o
     SET o.total_price = (SELECT IFNULL(SUM(amount),0) FROM order_item WHERE order_id=NEW.order_id)
   WHERE o.order_id = NEW.order_id;
  IF NEW.order_id <> OLD.order_id THEN
    UPDATE orders o
       SET o.total_price = (SELECT IFNULL(SUM(amount),0) FROM order_item WHERE order_id=OLD.order_id)
     WHERE o.order_id = OLD.order_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_order_total_ad` AFTER DELETE ON `order_item` FOR EACH ROW BEGIN
  UPDATE orders o
     SET o.total_price = (SELECT IFNULL(SUM(amount),0) FROM order_item WHERE order_id=OLD.order_id)
   WHERE o.order_id = OLD.order_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `order_date` date NOT NULL COMMENT '就餐日期',
  `order_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总计价格',
  `status` varchar(10) NOT NULL DEFAULT '已下单' COMMENT '已下单/已配餐',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uq_order_user_date` (`user_id`,`order_date`),
  KEY `idx_order_date` (`order_date`),
  KEY `idx_order_user` (`user_id`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,5,'2026-08-03','2026-08-03 07:50:00',5.60,'已配餐'),(2,5,'2026-08-05','2026-08-05 08:10:00',2.90,'已配餐'),(3,5,'2026-09-01','2026-09-01 08:20:00',9.20,'已配餐'),(4,5,'2026-09-02','2026-09-02 08:30:00',4.60,'已配餐'),(5,6,'2026-08-03','2026-08-03 08:05:00',5.60,'已配餐'),(6,6,'2026-09-01','2026-09-01 08:40:00',10.60,'已配餐'),(7,6,'2026-09-03','2026-09-03 08:05:00',3.60,'已下单'),(8,7,'2026-09-01','2026-09-01 08:15:00',5.60,'已下单'),(9,7,'2026-09-02','2026-09-02 08:45:00',6.00,'已下单');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_order_before_insert` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
  DECLARE v_deadline TIME;
  DECLARE v_serve    TIME;
  SELECT CAST(cfg_value AS TIME) INTO v_deadline FROM sys_config WHERE cfg_key='order_deadline';
  SELECT CAST(cfg_value AS TIME) INTO v_serve    FROM sys_config WHERE cfg_key='serve_start';

  IF NEW.order_date > DATE_ADD(CURDATE(), INTERVAL 1 DAY) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只能预订当天或次日的餐';
  END IF;
  IF NEW.order_date = CURDATE() AND TIME(NOW()) > v_deadline THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '订餐截止时间已过，不能为今天下单';
  END IF;
  IF NEW.order_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND TIME(NOW()) < v_serve THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '次日订餐尚未开放(配餐开始时间后)';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe` (
  `recipe_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '菜名',
  `classify` varchar(20) NOT NULL COMMENT '分类:主食/菜肴/糕点/甜点/汤',
  `photo` varchar(255) DEFAULT NULL COMMENT '菜品图片(上传后保存的路径/URL)',
  `unit` varchar(10) NOT NULL COMMENT '计量单位:份/两/个/例/杯/碗',
  `price` decimal(8,2) NOT NULL COMMENT '单位价格',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在售(1在售/0下架)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`recipe_id`),
  UNIQUE KEY `uq_recipe_name_unit` (`name`,`unit`),
  KEY `idx_recipe_classify` (`classify`),
  CONSTRAINT `recipe_chk_1` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='食谱';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe`
--

LOCK TABLES `recipe` WRITE;
/*!40000 ALTER TABLE `recipe` DISABLE KEYS */;
INSERT INTO `recipe` VALUES (1,'炒白菜','菜肴',NULL,'份',3.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(2,'西红柿蛋汤','汤',NULL,'份',3.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(3,'小炒肉','菜肴',NULL,'份',5.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(4,'米饭','主食',NULL,'两',0.30,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(5,'馒头','主食',NULL,'个',1.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(6,'银耳汤','甜点',NULL,'碗',4.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(7,'西红柿炒鸡蛋','菜肴',NULL,'份',6.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(8,'莲藕汤','汤',NULL,'份',4.00,1,'2026-09-10 21:26:54','2026-09-10 21:26:54'),(9,'111','主食','92706bed205d4c9f9a9d4d45cfddb009.png','份',3.00,1,'2026-09-10 21:41:20','2026-09-10 21:41:20');
/*!40000 ALTER TABLE `recipe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) NOT NULL,
  `role_desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'餐厅经理','系统管理员,拥有最高权限'),(2,'厨房主管','管理食谱,打印总括订单'),(3,'配餐员','批量打印员工订单配餐'),(4,'财务管理','月度销售/员工统计'),(5,'企业员工','订餐,查看自己订单与统计');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `cfg_key` varchar(30) NOT NULL,
  `cfg_value` varchar(50) NOT NULL,
  PRIMARY KEY (`cfg_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统参数';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES ('order_deadline','09:00'),('serve_start','11:30');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL COMMENT '登录名',
  `password` varchar(64) NOT NULL COMMENT '密码(存SHA2散列)',
  `real_name` varchar(30) NOT NULL COMMENT '姓名',
  `phone` varchar(20) NOT NULL COMMENT '联系电话(送餐)',
  `dept_id` int unsigned NOT NULL,
  `workstation` varchar(50) DEFAULT NULL COMMENT '工位信息(送餐)',
  `role_id` tinyint unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在职(1在职/0离职)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_user_dept` (`dept_id`),
  KEY `idx_user_role` (`role_id`),
  CONSTRAINT `fk_user_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `chk_user_phone` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9+\\-]{5,20}$'))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'manager','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','王经理','13800000001',2,'3F-301',1,1,'2026-09-10 21:26:54'),(2,'kitchen','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','陈主厨','13800000002',1,'厨房A区',2,1,'2026-09-10 21:26:54'),(3,'server','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','配餐员小赵','13800000003',3,'2F-205',3,1,'2026-09-10 21:26:54'),(4,'finance','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','财务小李','13800000004',4,'4F-401',4,1,'2026-09-10 21:26:54'),(5,'liu','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','刘XX','12200993311',1,'XX楼301室',5,1,'2026-09-10 21:26:54'),(6,'zhang','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','张XX','12200993312',1,'XX楼302室',5,1,'2026-09-10 21:26:54'),(7,'wang','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','王XX','12200993313',2,'XX楼401室',5,1,'2026-09-10 21:26:54'),(8,'li','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','李XX','12200993314',3,'XX楼501室',5,1,'2026-09-10 21:26:54');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_blanket_order`
--

DROP TABLE IF EXISTS `v_blanket_order`;
/*!50001 DROP VIEW IF EXISTS `v_blanket_order`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_blanket_order` AS SELECT 
 1 AS `order_date`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `classify`,
 1 AS `total_qty`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_emp_own_monthly`
--

DROP TABLE IF EXISTS `v_emp_own_monthly`;
/*!50001 DROP VIEW IF EXISTS `v_emp_own_monthly`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_emp_own_monthly` AS SELECT 
 1 AS `real_name`,
 1 AS `stat_month`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `total_qty`,
 1 AS `unit_price`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_emp_own_orders`
--

DROP TABLE IF EXISTS `v_emp_own_orders`;
/*!50001 DROP VIEW IF EXISTS `v_emp_own_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_emp_own_orders` AS SELECT 
 1 AS `order_id`,
 1 AS `order_date`,
 1 AS `order_time`,
 1 AS `total_price`,
 1 AS `status`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `quantity`,
 1 AS `price`,
 1 AS `amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_employee_monthly`
--

DROP TABLE IF EXISTS `v_employee_monthly`;
/*!50001 DROP VIEW IF EXISTS `v_employee_monthly`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_employee_monthly` AS SELECT 
 1 AS `user_id`,
 1 AS `real_name`,
 1 AS `stat_month`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `total_qty`,
 1 AS `unit_price`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_employee_monthly_orders`
--

DROP TABLE IF EXISTS `v_employee_monthly_orders`;
/*!50001 DROP VIEW IF EXISTS `v_employee_monthly_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_employee_monthly_orders` AS SELECT 
 1 AS `user_id`,
 1 AS `real_name`,
 1 AS `stat_month`,
 1 AS `order_id`,
 1 AS `order_date`,
 1 AS `order_time`,
 1 AS `total_price`,
 1 AS `status`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `quantity`,
 1 AS `price`,
 1 AS `amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_menu_current`
--

DROP TABLE IF EXISTS `v_menu_current`;
/*!50001 DROP VIEW IF EXISTS `v_menu_current`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_menu_current` AS SELECT 
 1 AS `menu_id`,
 1 AS `menu_name`,
 1 AS `item_id`,
 1 AS `dish_name`,
 1 AS `classify`,
 1 AS `photo`,
 1 AS `unit`,
 1 AS `price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_monthly_sales`
--

DROP TABLE IF EXISTS `v_monthly_sales`;
/*!50001 DROP VIEW IF EXISTS `v_monthly_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_monthly_sales` AS SELECT 
 1 AS `stat_month`,
 1 AS `dish_name`,
 1 AS `unit`,
 1 AS `total_qty`,
 1 AS `unit_price`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_recipe_mgr`
--

DROP TABLE IF EXISTS `v_recipe_mgr`;
/*!50001 DROP VIEW IF EXISTS `v_recipe_mgr`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_recipe_mgr` AS SELECT 
 1 AS `recipe_id`,
 1 AS `name`,
 1 AS `classify`,
 1 AS `photo`,
 1 AS `unit`,
 1 AS `price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_user_mgr`
--

DROP TABLE IF EXISTS `v_user_mgr`;
/*!50001 DROP VIEW IF EXISTS `v_user_mgr`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_user_mgr` AS SELECT 
 1 AS `user_id`,
 1 AS `username`,
 1 AS `real_name`,
 1 AS `phone`,
 1 AS `dept_id`,
 1 AS `workstation`,
 1 AS `role_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `restaurant_order`
--

USE `restaurant_order`;

--
-- Final view structure for view `v_blanket_order`
--

/*!50001 DROP VIEW IF EXISTS `v_blanket_order`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_blanket_order` AS select `o`.`order_date` AS `order_date`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,`oi`.`classify` AS `classify`,sum(`oi`.`quantity`) AS `total_qty` from (`order_item` `oi` join `orders` `o` on((`oi`.`order_id` = `o`.`order_id`))) group by `o`.`order_date`,`oi`.`dish_name`,`oi`.`unit`,`oi`.`classify` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_emp_own_monthly`
--

/*!50001 DROP VIEW IF EXISTS `v_emp_own_monthly`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_emp_own_monthly` AS select `u`.`real_name` AS `real_name`,date_format(`o`.`order_date`,'%Y-%m') AS `stat_month`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,sum(`oi`.`quantity`) AS `total_qty`,round(avg(`oi`.`price`),2) AS `unit_price`,sum(`oi`.`amount`) AS `total_amount` from ((`orders` `o` join `user` `u` on((`o`.`user_id` = `u`.`user_id`))) join `order_item` `oi` on((`oi`.`order_id` = `o`.`order_id`))) where (`u`.`user_id` = `fn_emp_uid`()) group by `u`.`real_name`,`stat_month`,`oi`.`dish_name`,`oi`.`unit` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_emp_own_orders`
--

/*!50001 DROP VIEW IF EXISTS `v_emp_own_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_emp_own_orders` AS select `o`.`order_id` AS `order_id`,`o`.`order_date` AS `order_date`,`o`.`order_time` AS `order_time`,`o`.`total_price` AS `total_price`,`o`.`status` AS `status`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,`oi`.`quantity` AS `quantity`,`oi`.`price` AS `price`,`oi`.`amount` AS `amount` from (`orders` `o` join `order_item` `oi` on((`oi`.`order_id` = `o`.`order_id`))) where (`o`.`user_id` = `fn_emp_uid`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_employee_monthly`
--

/*!50001 DROP VIEW IF EXISTS `v_employee_monthly`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_employee_monthly` AS select `u`.`user_id` AS `user_id`,`u`.`real_name` AS `real_name`,date_format(`o`.`order_date`,'%Y-%m') AS `stat_month`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,sum(`oi`.`quantity`) AS `total_qty`,round(avg(`oi`.`price`),2) AS `unit_price`,sum(`oi`.`amount`) AS `total_amount` from ((`orders` `o` join `user` `u` on((`o`.`user_id` = `u`.`user_id`))) join `order_item` `oi` on((`oi`.`order_id` = `o`.`order_id`))) group by `u`.`user_id`,`u`.`real_name`,`stat_month`,`oi`.`dish_name`,`oi`.`unit` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_employee_monthly_orders`
--

/*!50001 DROP VIEW IF EXISTS `v_employee_monthly_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_employee_monthly_orders` AS select `u`.`user_id` AS `user_id`,`u`.`real_name` AS `real_name`,date_format(`o`.`order_date`,'%Y-%m') AS `stat_month`,`o`.`order_id` AS `order_id`,`o`.`order_date` AS `order_date`,`o`.`order_time` AS `order_time`,`o`.`total_price` AS `total_price`,`o`.`status` AS `status`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,`oi`.`quantity` AS `quantity`,`oi`.`price` AS `price`,`oi`.`amount` AS `amount` from ((`orders` `o` join `user` `u` on((`o`.`user_id` = `u`.`user_id`))) join `order_item` `oi` on((`oi`.`order_id` = `o`.`order_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_menu_current`
--

/*!50001 DROP VIEW IF EXISTS `v_menu_current`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_menu_current` AS select `m`.`menu_id` AS `menu_id`,`m`.`menu_name` AS `menu_name`,`mi`.`item_id` AS `item_id`,`mi`.`dish_name` AS `dish_name`,`mi`.`classify` AS `classify`,`mi`.`photo` AS `photo`,`mi`.`unit` AS `unit`,`mi`.`price` AS `price` from (`menu` `m` join `menu_item` `mi` on((`m`.`menu_id` = `mi`.`menu_id`))) where (`m`.`is_current` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_monthly_sales`
--

/*!50001 DROP VIEW IF EXISTS `v_monthly_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_monthly_sales` AS select date_format(`o`.`order_date`,'%Y-%m') AS `stat_month`,`oi`.`dish_name` AS `dish_name`,`oi`.`unit` AS `unit`,sum(`oi`.`quantity`) AS `total_qty`,round(avg(`oi`.`price`),2) AS `unit_price`,sum(`oi`.`amount`) AS `total_amount` from (`order_item` `oi` join `orders` `o` on((`oi`.`order_id` = `o`.`order_id`))) group by `stat_month`,`oi`.`dish_name`,`oi`.`unit` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_recipe_mgr`
--

/*!50001 DROP VIEW IF EXISTS `v_recipe_mgr`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_recipe_mgr` AS select `recipe`.`recipe_id` AS `recipe_id`,`recipe`.`name` AS `name`,`recipe`.`classify` AS `classify`,`recipe`.`photo` AS `photo`,`recipe`.`unit` AS `unit`,`recipe`.`price` AS `price` from `recipe` where (`recipe`.`is_active` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_user_mgr`
--

/*!50001 DROP VIEW IF EXISTS `v_user_mgr`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_user_mgr` AS select `user`.`user_id` AS `user_id`,`user`.`username` AS `username`,`user`.`real_name` AS `real_name`,`user`.`phone` AS `phone`,`user`.`dept_id` AS `dept_id`,`user`.`workstation` AS `workstation`,`user`.`role_id` AS `role_id` from `user` where (`user`.`is_active` = 1) */;
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

-- Dump completed on 2026-09-20  8:35:56
