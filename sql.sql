-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.10-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for fullstack_api
CREATE DATABASE IF NOT EXISTS `fullstack_api` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fullstack_api`;

-- Dumping structure for table fullstack_api.admins
CREATE TABLE IF NOT EXISTS `admins` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `phone_number` varchar(15) NOT NULL DEFAULT '',
  `phone_id` varchar(5) NOT NULL DEFAULT '',
  `password` varchar(250) NOT NULL DEFAULT '',
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `url_avatar` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`email`),
  UNIQUE KEY `Phone Number` (`phone_id`,`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.admins: ~1 rows (approximately)
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `gcm`, `url_avatar`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'zulkifli', 'a@admin.com', '82256330205', '+62', '$2a$04$J/tfNRMb5ixYPlB8NLbzGu77sMhoJTKqSBp/iaulmNIizTr3s0.s6', '0', '', 1, '2020-07-13 02:31:50', '2020-07-15 23:26:38');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.api_vendors
CREATE TABLE IF NOT EXISTS `api_vendors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `api_key` varchar(255) DEFAULT '',
  `status_provider` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.api_vendors: ~0 rows (approximately)
/*!40000 ALTER TABLE `api_vendors` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_vendors` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.banks
CREATE TABLE IF NOT EXISTS `banks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `no_rek` varchar(50) DEFAULT '',
  `nm_short` varchar(50) DEFAULT '',
  `nm_long` varchar(50) DEFAULT '',
  `owner` varchar(50) DEFAULT '',
  `url_logo` varchar(255) DEFAULT '',
  `status` tinyint(4) DEFAULT 0 COMMENT '1=aktive and 0=non active',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Nomor Rekening` (`no_rek`),
  UNIQUE KEY `Logo` (`url_logo`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.banks: ~5 rows (approximately)
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
INSERT INTO `banks` (`id`, `no_rek`, `nm_short`, `nm_long`, `owner`, `url_logo`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'reee3', 'eee3', 'eee3', 'f', 'http://localhost:8080/img/bank/600881587.jpeg', 0, '2020-07-11 09:17:29', '2020-07-12 07:43:11'),
	(21, 'reeee3', 'eeee3', 'eeee3', 'f', 'http://localhost:8080/img/bank/314067471.jpeg', 0, '2020-07-12 07:43:23', '2020-07-12 07:43:23'),
	(22, 'e', 'eeee3', 'eeee3', 'b', 'http://localhost:8080/img/bank/288061399.jpeg', 0, '2020-07-12 07:43:24', '2020-07-12 07:43:24'),
	(23, 'ee', 'eeee3', 'eeee3', 'b', 'http://localhost:8080/img/bank/931180891.jpeg', 0, '2020-07-12 07:43:27', '2020-07-12 07:43:27'),
	(24, 'eeee3e', 'eeee3', 'eeee3', '', 'http://localhost:8080/img/bank/041735827.jpeg', 0, '2020-07-12 07:43:31', '2020-07-12 07:43:31');
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cancels
CREATE TABLE IF NOT EXISTS `cancels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(50) DEFAULT '',
  `value` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cancels: ~0 rows (approximately)
/*!40000 ALTER TABLE `cancels` DISABLE KEYS */;
/*!40000 ALTER TABLE `cancels` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cart_cooks
CREATE TABLE IF NOT EXISTS `cart_cooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cart_cooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `cart_cooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_cooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cart_foods
CREATE TABLE IF NOT EXISTS `cart_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT 0,
  `restaurant_id` int(10) unsigned NOT NULL DEFAULT 0,
  `method_pay` int(10) unsigned NOT NULL DEFAULT 0,
  `total_price` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cart_foods: ~0 rows (approximately)
/*!40000 ALTER TABLE `cart_foods` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_foods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cart_ojeks
CREATE TABLE IF NOT EXISTS `cart_ojeks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cart_ojeks: ~0 rows (approximately)
/*!40000 ALTER TABLE `cart_ojeks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_ojeks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cart_shops
CREATE TABLE IF NOT EXISTS `cart_shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cart_shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `cart_shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.category_cooks
CREATE TABLE IF NOT EXISTS `category_cooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_cook` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category cook` (`category_cook`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.category_cooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `category_cooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_cooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.category_foods
CREATE TABLE IF NOT EXISTS `category_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_food` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category food` (`category_food`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.category_foods: ~4 rows (approximately)
/*!40000 ALTER TABLE `category_foods` DISABLE KEYS */;
INSERT INTO `category_foods` (`id`, `category_food`, `created_at`, `updated_at`) VALUES
	(11, 'rrr', '2019-07-09 17:22:29', '2020-07-09 17:54:45'),
	(13, 'ffff', '2020-07-09 20:55:41', '2020-07-09 20:55:41'),
	(23, 'rr', '2020-07-09 21:11:58', '2020-07-09 21:11:58'),
	(53, 'rre', '2020-07-09 21:27:12', '2020-07-09 21:27:12');
/*!40000 ALTER TABLE `category_foods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.category_pays
CREATE TABLE IF NOT EXISTS `category_pays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_pay` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category pay` (`category_pay`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.category_pays: ~0 rows (approximately)
/*!40000 ALTER TABLE `category_pays` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_pays` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.category_shops
CREATE TABLE IF NOT EXISTS `category_shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_shop` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category` (`category_shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.category_shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `category_shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.charge_admins
CREATE TABLE IF NOT EXISTS `charge_admins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_code` varchar(50) DEFAULT '',
  `charge` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.charge_admins: ~0 rows (approximately)
/*!40000 ALTER TABLE `charge_admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `charge_admins` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.cooks
CREATE TABLE IF NOT EXISTS `cooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone_number` varchar(255) NOT NULL DEFAULT '',
  `phone_id` varchar(5) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `pin_register` varchar(255) NOT NULL DEFAULT '',
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `nm_cook` varchar(255) NOT NULL DEFAULT '',
  `address_cook` varchar(255) NOT NULL DEFAULT '',
  `desc_cook` varchar(255) NOT NULL DEFAULT '',
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `kat_onkir` tinyint(4) NOT NULL DEFAULT 0,
  `latitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `scadule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'jadwal buka dan tutup dalm seminggu format json contoh {a:{a:08:00,b:22:00}} penjelasan a pertama adalah senin',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `os` char(15) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.cooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `cooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.customers
CREATE TABLE IF NOT EXISTS `customers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `phone_number` varchar(15) NOT NULL DEFAULT '',
  `phone_id` varchar(5) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `balance` decimal(7,0) unsigned NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `trip` int(11) NOT NULL DEFAULT 0,
  `point` int(11) NOT NULL DEFAULT 0,
  `pin_register` int(11) NOT NULL DEFAULT 0,
  `pin_reset` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `url_avatar` varchar(255) NOT NULL DEFAULT '',
  `radius_pickup` smallint(6) NOT NULL DEFAULT 10000 COMMENT 'radius jemputan yg sesuai harapan masing masing pelanggan pakai meter ',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0=new , 1 = active user, 2=blok user',
  `os` char(15) NOT NULL DEFAULT '',
  `last_order` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`email`),
  UNIQUE KEY `Phone Number` (`phone_id`,`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.customers: ~20 rows (approximately)
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `balance`, `counter_reputation`, `divide_reputation`, `trip`, `point`, `pin_register`, `pin_reset`, `latitude`, `longitude`, `gcm`, `url_avatar`, `radius_pickup`, `status`, `os`, `last_order`, `created_at`, `updated_at`) VALUES
	(1, 'rrrrrrrrrr', 'a@customer.com', '82256330208', '+62', '$2a$04$J/tfNRMb5ixYPlB8NLbzGu77sMhoJTKqSBp/iaulmNIizTr3s0.s6', 0, 0.0, 0, 0, 0, 799523, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '0', '2020-07-09 10:32:05', '2020-07-09 10:32:05', '2020-09-02 17:05:36'),
	(2, 'rrrrrrrrrr', 'ee@aa.com', '82256330206', '+62', '$2a$04$Y5U5o2s9orbB1G33NNzGgOL4vX3/ojBZ5uC5btYjJl9.5DRaYIzpe', 0, 0.0, 0, 0, 0, 230131, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '0', '2020-07-09 10:32:45', '2020-07-09 10:32:45', '2020-07-14 13:46:59'),
	(3, 'rrrrrrrrrr', 'ee@aaa.com', '82256330205', '+62', '$2a$04$mmphNiQhuXfj5o5lYdpWNuW/E1mODW.ICVH33cBrakFAVT.pABUvC', 0, 0.0, 0, 0, 0, 733432, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '0', '2020-07-09 10:32:50', '2020-07-09 10:32:50', '2020-07-14 13:47:03'),
	(24, 'rrrrrrrrrr', 'ee@ererf333fgffer.com', '82253330233', '+62', '$2a$04$0ObzXPlIi4GlzBXQ.KTri.LSgrRsFPWIP1wYWCkA03uH4ANzJs3tO', 0, 0.0, 0, 0, 0, 303094, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-08-30 12:56:55', '2020-08-30 12:56:55', '2020-08-30 12:56:55'),
	(25, 'rrrrrrrrrr', 'ee@ere333f3fgffer.com', '82236330211', '+62', '$2y$10$00osQuutw/WeNP1bU83w/uBHuqRpa5.g9zE3W6VzzlR64sqDeZpRK', 0, 0.0, 0, 0, 0, 0, 0, 0.000000, 0.000000, '0', '', 10000, 0, '0', '2020-08-30 12:57:08', '2020-08-30 12:57:08', '2020-08-30 12:57:08'),
	(63, 'rrrrrrrrrr', 'ee@ererf333fgffedr.com', '82253333333', '+62', '$2a$04$4ozPjJeUP8d6Ccz4D4z18OcyGVV7eL/fNN1.lYd/qq2wqslwh7ec2', 0, 0.0, 0, 0, 0, 842956, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-01 23:07:43', '2020-09-01 23:07:43', '2020-09-01 23:07:43'),
	(65, 'rrrrrrrrrr', 'ee@ererf333fgffredr.com', '82253333113', '+62', '$2a$04$fs1XvSUizf3DH.c/906Nq.E7z9dOjIm2ZG4ZxXyi8AoaEGtbHIjFq', 0, 0.0, 0, 0, 0, 654581, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-01 23:08:17', '2020-09-01 23:08:17', '2020-09-01 23:08:17'),
	(67, 'rrrrrrrrrr', 'ee@ererf33efgffredr.com', '82213333113', '+62', '$2a$04$DJkJFzDxLUZpsIkAASbkIeKRVt5mSWJwBnmTrakyHmE522Tfp6BhC', 0, 0.0, 0, 0, 0, 522913, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-01 23:09:16', '2020-09-01 23:09:16', '2020-09-01 23:09:16'),
	(68, 'rrrrrrrrrr', 'ee@ererf33efg6r.com', '82213993113', '+62', '$2a$04$SW83Cptzbr5vh5AzWt1ci.h8XkpW2rgjS1hNKGgYaGmz7O2BfYT8q', 0, 0.0, 0, 0, 0, 440687, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-01 23:09:30', '2020-09-01 23:09:30', '2020-09-01 23:09:30'),
	(150, 'zul', 'H_HAAA@dd.vvt', '825478111', '+62', '$2y$10$pNh9SQ0tFsZ5s5r6Fclh6.I4FB1gnqSNqREPuQqw7ruB4CnYS4fOG', 0, 0.0, 0, 0, 0, 0, 0, 0.000000, 0.000000, '0', '', 10000, 0, '0', '2020-09-02 02:24:50', '2020-09-02 02:24:50', '2020-09-02 02:24:50'),
	(180, 'rrrrrrrrrr', 'ee@ererf33efg6rcom.yy', '822139931133', '+62', '$2a$04$X7x8p99RxfjXMAntLLUCYuyuKLibOIcS.4oDyJ5JzZFNwDX0vKz/C', 0, 0.0, 0, 0, 0, 539627, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:35:39', '2020-09-02 03:35:39', '2020-09-02 03:35:39'),
	(181, 'rrrrrrrrrr', 'ee@ererf33efg6rcom.yhy', '82213993133', '+62', '$2a$04$a3k4AArvb8X2MokpwoUJ6emVpvU5LMQCElWL4yl0RKywbaiXRKl2W', 0, 0.0, 0, 0, 0, 840979, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:35:54', '2020-09-02 03:35:54', '2020-09-02 03:35:54'),
	(189, 'rrrrrrrrrr', 'ee@ererf33efg6rcom.yh6y', '822139931333', '+62', '$2a$04$C05JeJEwgPBKMtlzy04o1ep4qnAJpeBAEmiQU40jljSqlswzPa6E2', 0, 0.0, 0, 0, 0, 718040, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:37:30', '2020-09-02 03:37:30', '2020-09-02 03:37:30'),
	(193, 'rrrrrrrrrr', 'ee@a.yhy', '822139924', '+62', '$2a$04$3utTyZYnoE30I24TAbNc2uznU6OMiqaW6KD1tg4EyRxZ34fFxa2R2', 0, 0.0, 0, 0, 0, 129323, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:37:50', '2020-09-02 03:37:50', '2020-09-02 03:37:50'),
	(194, 'rrrrrrrrrr', 'ee@ba.yhy', '8221399242', '+62', '$2a$04$.WkOE2qCETstxq5ucC6ndO27pNpG5LzcYvrEzI2jWTvnYtqRdrIfO', 0, 0.0, 0, 0, 0, 582431, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:38:06', '2020-09-02 03:38:06', '2020-09-02 03:38:06'),
	(196, 'rrrrrrrrrr&#39;', 'ee@ba.yhyk', '82213992427', '+62', '$2a$04$/Kw2C1K9ZXazfXYDVhBSJe6yF0f2IJpGcqxEUn1f/yNDN3YOnRJwC', 0, 0.0, 0, 0, 0, 338882, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 03:40:40', '2020-09-02 03:40:40', '2020-09-02 03:40:40'),
	(197, 'zul ghgh', 'H_HAAA@jggggg.vvt', '8254781116', '+62', '$2y$10$QKgI0Ztuu2gJZtlZZKBAZeF9k1y.vjiw4WbmO0CMerHMy6KywP7Ai', 0, 0.0, 0, 0, 0, 0, 0, 0.000000, 0.000000, '0', '', 10000, 0, '0', '2020-09-02 03:42:57', '2020-09-02 03:42:57', '2020-09-02 03:42:57'),
	(214, 'rrrrrrrrrr&#39;', 'ee@bea.yhyk', '822139924427', '+62', '$2a$04$HgaeOvzyHpWZ5xmpFD1wIeWbUyE2kxZYRHGzTFeoIzDKAuO8yNcoe', 0, 0.0, 0, 0, 0, 733432, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 15:22:25', '2020-09-02 15:22:25', '2020-09-02 15:22:25'),
	(215, 'rrrrrrrrrr&#39;', 'ee@b4ea.yhyk', '8221399244427', '+62', '$2a$04$le64O6hvsdgQobo8SZFli.10W1mjDdh3UOUWPmkvHf5GcUWwGA4oe', 0, 0.0, 0, 0, 0, 485103, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 15:22:32', '2020-09-02 15:22:32', '2020-09-02 15:22:32'),
	(216, 'rrrrrrrrrr&#39;', 'ee@erer.yhyk', '822139244427', '+62', '$2a$04$X36U5TNWC/coSu6rV6SoZ.xxZHJSN7jsVx0cJwSe705HZEzuWURrO', 0, 0.0, 0, 0, 0, 303094, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 15:22:47', '2020-09-02 15:22:47', '2020-09-02 15:22:47'),
	(220, 'rrrrrrrrrr&#39;', 'ee@3erer.yhyk', '82213924427', '+62', '$2a$04$LcUYNMSOVSA7qEfhV4roLOvwaPGXLI1uKr3k3mzXELKChc5Ng18Y2', 0, 0.0, 0, 0, 0, 303094, 0, 0.000000, 0.000000, 'gcm', '', 10000, 0, '0', '2020-09-02 17:09:35', '2020-09-02 17:09:35', '2020-09-02 17:09:35');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.customer_promos
CREATE TABLE IF NOT EXISTS `customer_promos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `promo_id` varchar(50) DEFAULT '',
  `customer_id` varchar(50) DEFAULT '',
  `is_use` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.customer_promos: ~0 rows (approximately)
/*!40000 ALTER TABLE `customer_promos` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_promos` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.customer_vouchers
CREATE TABLE IF NOT EXISTS `customer_vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` varchar(50) DEFAULT '',
  `customer_id` varchar(50) DEFAULT '',
  `is_use` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.customer_vouchers: ~0 rows (approximately)
/*!40000 ALTER TABLE `customer_vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_vouchers` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.detail_cart_foods
CREATE TABLE IF NOT EXISTS `detail_cart_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cart_food_id` int(10) unsigned NOT NULL DEFAULT 0,
  `category_food_id` int(10) unsigned NOT NULL DEFAULT 0,
  `nm_menu` varchar(255) NOT NULL DEFAULT '',
  `desc_menu` varchar(255) NOT NULL DEFAULT '',
  `order_desc` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `price` int(10) unsigned NOT NULL DEFAULT 0,
  `qity` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.detail_cart_foods: ~0 rows (approximately)
/*!40000 ALTER TABLE `detail_cart_foods` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_cart_foods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.detail_tran_cooks
CREATE TABLE IF NOT EXISTS `detail_tran_cooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.detail_tran_cooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `detail_tran_cooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_tran_cooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.detail_tran_foods
CREATE TABLE IF NOT EXISTS `detail_tran_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.detail_tran_foods: ~0 rows (approximately)
/*!40000 ALTER TABLE `detail_tran_foods` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_tran_foods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.detail_tran_shops
CREATE TABLE IF NOT EXISTS `detail_tran_shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.detail_tran_shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `detail_tran_shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_tran_shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.drivers
CREATE TABLE IF NOT EXISTS `drivers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `phone_number` varchar(15) NOT NULL DEFAULT '',
  `phone_id` varchar(3) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `category_driver` varchar(100) NOT NULL DEFAULT '',
  `balance` decimal(7,0) unsigned NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `trip` int(11) NOT NULL DEFAULT 0,
  `point` int(11) NOT NULL DEFAULT 0,
  `pin_register` int(11) NOT NULL DEFAULT 0,
  `pin_reset` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `url_avatar` varchar(255) NOT NULL DEFAULT '',
  `radius_pickup` smallint(6) NOT NULL DEFAULT 10000 COMMENT 'radius jemputan yg sesuai harapan masing masing pelanggan pakai meter ',
  `active_driving` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0=stan bay , 1 =sibuk',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0=new , 1 = active user, 2=blok user',
  `os` char(15) NOT NULL DEFAULT '',
  `last_order` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`email`),
  UNIQUE KEY `Phone Number` (`phone_id`,`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.drivers: ~6 rows (approximately)
/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
INSERT INTO `drivers` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `category_driver`, `balance`, `counter_reputation`, `divide_reputation`, `trip`, `point`, `pin_register`, `pin_reset`, `latitude`, `longitude`, `gcm`, `url_avatar`, `radius_pickup`, `active_driving`, `status`, `os`, `last_order`, `created_at`, `updated_at`) VALUES
	(1, 'name', 'a@driver.com', '12', '+62', '$2a$04$Mc1b4rDy3IE/dYj/HAkuHOG4OLmqzPTid6s9qBZQgMRiDAqE0RKBi', '0', 0, 0.0, 0, 0, 0, 230131, 0, -3.479320, 119.143743, '6', '', 10000, 0, 1, '0', '2020-07-16 10:59:23', '2020-07-16 10:59:23', '2020-07-16 15:52:28'),
	(5, 'name', 'aa@driver.com', '5555555555555', '+62', '$2a$04$xHI/bBv3F529HllCLUEiI.6AvIh/X6jbPaksGfj.H0TdrJxN0jy0S', '0', 0, 0.0, 0, 0, 0, 799523, 0, -3.479320, 119.143743, '1', '', 10000, 0, 0, '0', '2020-07-16 11:04:38', '2020-07-16 11:04:38', '2020-07-16 15:52:23'),
	(8, 'name', 'aaa@driver.com', '555555555555', '+62', '$2a$04$jk1zg6yNlPzy57Tt6OaGQeQdkrg03nIRINUJj2RH.MRT2nrJ7bSgG', 'motor', 0, 0.0, 0, 0, 0, 303094, 0, -3.479320, 119.143743, 'fL_z8bmBTIs:APA91bFkJR7mI0WkKCnVljDbd3VVLNMyoCG6A0IXYnGF_pRAfJus5hcWakzJcwsno2BgZNI8XJN7tIxYlYGeuBvwf-Qsujk5Mvm7XznDqKR0Z-hctKltIo1iQjGql5CbEVGp1Ao_0m-z', '', 10000, 0, 0, '0', '2020-07-16 11:20:45', '2020-07-16 11:20:45', '2020-07-16 16:43:27'),
	(11, 'name', 'adaa@driver.com', '55555555555', '+62', '$2a$04$B6GUTx4Ye26VK4ExlJYLvePtLa1wEOE5rakzT1CqiMgY4w9ir9vei', 'motor', 0, 0.0, 0, 0, 0, 522913, 0, -3.479320, 119.143743, '3', '', 10000, 0, 0, '0', '2020-07-16 11:26:20', '2020-07-16 11:26:20', '2020-07-16 15:52:25'),
	(15, 'name', 'b@driver.com', '12334455677', '+62', '$2a$04$nW4fpEv1DYMfEdlgEywZ6uHlVvtPnZcY1NiEAd0kMIoldgzrZLifi', 'motor', 0, 0.0, 0, 0, 0, 485103, 0, -3.479320, 119.143743, '4', '', 10000, 0, 0, '0', '2020-07-16 13:52:18', '2020-07-16 13:52:18', '2020-07-16 15:52:26'),
	(16, 'name', 'bd@driver.com', '12334455678', '+62', '$2a$04$GBCZxdtx13r/9VLYbfX1XuyCb58eaa2FqjKflvb0Jd7U1ibLk2KyC', 'motor', 0, 0.0, 0, 0, 0, 303094, 0, -3.479320, 119.143743, '5', '', 10000, 0, 0, '0', '2020-07-16 13:52:26', '2020-07-16 13:52:26', '2020-07-16 15:52:27');
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.driver_prices
CREATE TABLE IF NOT EXISTS `driver_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_driver` varchar(50) DEFAULT '',
  `pos_provinsi` varchar(50) DEFAULT '',
  `pos_kab` varchar(50) DEFAULT '',
  `pos_kec` varchar(50) DEFAULT '',
  `pos_lurah_desa` varchar(50) DEFAULT '',
  `radius_zona_special` varchar(50) DEFAULT '' COMMENT 'didalam jangkauan  zona khusus radius dari lat long khusus',
  `radius_zona_common` varchar(50) DEFAULT '' COMMENT 'diluar jangkauan  zona khusus atau radius dari lat long umum',
  `max_zona_order` varchar(50) DEFAULT '',
  `min_meter` int(11) DEFAULT 0 COMMENT 'batas minimal jarak untuk bisa diorder',
  `charge` decimal(7,0) DEFAULT 0 COMMENT 'biaya admin normal',
  `price_cash` decimal(7,0) DEFAULT 0 COMMENT 'harga dasar cash jarak dibawah km looping yg tidak memotong biaya admin',
  `price_deposit` decimal(7,0) DEFAULT 0 COMMENT 'harga dasar payment jarak dibawah km looping yg  memotong biaya admin',
  `price_per_km` decimal(7,0) DEFAULT 0 COMMENT 'harga per kilo meter diatas atau dibawah jarak harga dasar',
  `price_looping_km` decimal(7,0) DEFAULT 0 COMMENT 'harga jarak tertentu 4 km , 5 km',
  `basic_km` int(11) DEFAULT 0 COMMENT 'berapa kilo meter untuk tarif harga dasar',
  `distance_looping_km` int(11) DEFAULT 0 COMMENT 'berapa kilo meter untuk tarif harga perulangan',
  `point_transaction` tinyint(4) DEFAULT 0 COMMENT 'poin transaksi biasanya 1 per kilo meter',
  `status` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`category_driver`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.driver_prices: ~3 rows (approximately)
/*!40000 ALTER TABLE `driver_prices` DISABLE KEYS */;
INSERT INTO `driver_prices` (`id`, `category_driver`, `pos_provinsi`, `pos_kab`, `pos_kec`, `pos_lurah_desa`, `radius_zona_special`, `radius_zona_common`, `max_zona_order`, `min_meter`, `charge`, `price_cash`, `price_deposit`, `price_per_km`, `price_looping_km`, `basic_km`, `distance_looping_km`, `point_transaction`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'motor', '', '', '', '', '', '', '', 500, 1000, 4000, 3000, 1000, 4000, 3, 4, 1, 1, '2020-07-13 01:28:47', '2020-07-13 01:28:48'),
	(2, 'car4', '', '', '', '', '', '', '', 500, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2020-07-13 01:22:38', '2020-07-13 01:28:49'),
	(4, 'rrr3333333', '', '', '', '', '', '', '', 100, 1000, 1000, 0, 0, 1000, 4000, 1, 1, 0, '2020-07-13 01:22:38', '2020-07-13 01:22:38');
/*!40000 ALTER TABLE `driver_prices` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.gcms
CREATE TABLE IF NOT EXISTS `gcms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `key_server` varchar(255) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.gcms: ~0 rows (approximately)
/*!40000 ALTER TABLE `gcms` DISABLE KEYS */;
INSERT INTO `gcms` (`id`, `gcm`, `key_server`, `created_at`, `updated_at`) VALUES
	(1, 'fL_z8bmBTIs:APA91bFkJR7mI0WkKCnVljDbd3VVLNMyoCG6A0IXYnGF_pRAfJus5hcWakzJcwsno2BgZNI8XJN7tIxYlYGeuBvwf-Qsujk5Mvm7XznDqKR0Z-hctKltIo1iQjGql5CbEVGp1Ao_0m-z', 'AAAAqb3QmLo:APA91bGYHDpiqCE__s7kOJud_mScdRynRzZEGj_usgg6N4yZ1nDY3RNwBWVbxzYSzTxhbixR3zT3h84CbVOO1ISV3RUwMAls42K5iDmS9cyFaTrA1QpNgKKuM2SfRSbzG_R-y8iN4ksk', '2020-07-09 07:42:02', '2020-07-09 07:42:33');
/*!40000 ALTER TABLE `gcms` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.holidays
CREATE TABLE IF NOT EXISTS `holidays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_name` varchar(50) DEFAULT '' COMMENT 'name services cooks,restaurants,shops',
  `service_id` varchar(50) DEFAULT '' COMMENT 'id cooks,restaurants,shops',
  `date` date DEFAULT curdate(),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.holidays: ~0 rows (approximately)
/*!40000 ALTER TABLE `holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `holidays` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.inboxs
CREATE TABLE IF NOT EXISTS `inboxs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT '',
  `message` text DEFAULT '',
  `tag` text DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.inboxs: ~0 rows (approximately)
/*!40000 ALTER TABLE `inboxs` DISABLE KEYS */;
/*!40000 ALTER TABLE `inboxs` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.itemcooks
CREATE TABLE IF NOT EXISTS `itemcooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cook_id` int(10) unsigned NOT NULL DEFAULT 0,
  `category_cook_id` int(11) NOT NULL DEFAULT 0,
  `nm_cook` varchar(255) NOT NULL DEFAULT '',
  `desc_cook` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `price` int(10) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`url_img`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.itemcooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `itemcooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemcooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.itemfoods
CREATE TABLE IF NOT EXISTS `itemfoods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(10) unsigned NOT NULL DEFAULT 0,
  `category_food_id` int(11) NOT NULL DEFAULT 0,
  `nm_menu` varchar(255) NOT NULL DEFAULT '',
  `desc_menu` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `price` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `stock` smallint(5) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '0=can order 1 =cannot oreder, 2=blok restaurant',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`url_img`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.itemfoods: ~3 rows (approximately)
/*!40000 ALTER TABLE `itemfoods` DISABLE KEYS */;
INSERT INTO `itemfoods` (`id`, `restaurant_id`, `category_food_id`, `nm_menu`, `desc_menu`, `url_img`, `price`, `stock`, `status`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, '0', '0', 'http://localhost:8080/img/food/069630103.jpeg', 0, 0, 0, '2020-07-13 14:35:34', '2020-07-13 14:35:34'),
	(2, 1, 1, '0', '0', 'http://localhost:8080/img/food/519743899.jpeg', 0, 0, 0, '2020-07-13 14:36:00', '2020-07-13 14:36:00'),
	(3, 1, 1, '0', '0', 'http://localhost:8080/img/food/937370099.jpeg', 0, 0, 0, '2020-07-13 14:36:57', '2020-07-13 14:36:57');
/*!40000 ALTER TABLE `itemfoods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.itemshops
CREATE TABLE IF NOT EXISTS `itemshops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(10) unsigned NOT NULL DEFAULT 0,
  `category_shop_id` int(11) NOT NULL DEFAULT 0,
  `nm_shop` varchar(255) NOT NULL DEFAULT '',
  `desc_shop` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `price` int(10) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`url_img`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.itemshops: ~1 rows (approximately)
/*!40000 ALTER TABLE `itemshops` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemshops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.promotions
CREATE TABLE IF NOT EXISTS `promotions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT '',
  `message` text DEFAULT '',
  `tag` text DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.promotions: ~0 rows (approximately)
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.pulses
CREATE TABLE IF NOT EXISTS `pulses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(50) DEFAULT '',
  `name` varchar(50) DEFAULT '',
  `price` decimal(10,0) DEFAULT 0,
  `status_provider` varchar(50) DEFAULT '',
  `status_stock` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.pulses: ~0 rows (approximately)
/*!40000 ALTER TABLE `pulses` DISABLE KEYS */;
/*!40000 ALTER TABLE `pulses` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.restaurants
CREATE TABLE IF NOT EXISTS `restaurants` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone_number` varchar(255) NOT NULL DEFAULT '',
  `phone_id` varchar(5) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `pin_register` varchar(255) NOT NULL DEFAULT '',
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `nm_resto` varchar(255) NOT NULL DEFAULT '',
  `address_resto` varchar(255) NOT NULL DEFAULT '',
  `desc_resto` varchar(255) NOT NULL DEFAULT '',
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `discount_delivery` int(11) NOT NULL DEFAULT 0,
  `min_distance_discount_delivery` tinyint(4) NOT NULL DEFAULT 0,
  `lattitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `scadule` varchar(255) NOT NULL DEFAULT '' COMMENT 'jadwal buka dan tutup dalm seminggu format json contoh {a:{a:08:00,b:22:00}} penjelasan a pertama adalah senin',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0=new , 1 = active user, 2=blok user',
  `os` char(15) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.restaurants: ~7 rows (approximately)
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `pin_register`, `gcm`, `nm_resto`, `address_resto`, `desc_resto`, `counter_reputation`, `divide_reputation`, `discount_delivery`, `min_distance_discount_delivery`, `lattitude`, `longitude`, `scadule`, `url_img`, `status`, `os`, `created_at`, `updated_at`) VALUES
	(1, '', '', '', '', '', '', '', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'eeeaaaaaaaaaaaaaaaaaae3', 'eeeaaaaaaaaaaaaaaaaae3', 0.0, 0, 0, 0, 0.000000, 0.000000, '04:00:12', 'http://localhost:8080/img/resto/903401427.jpeg', 0, '0', '2020-07-13 04:00:12', '2020-07-13 06:53:09'),
	(2, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0.0, 0, 0, 0, 0.000000, 0.000000, '04:10:12', 'http://localhost:8080/img/resto/467971847.jpeg', 0, '0', '2020-07-13 04:10:12', '2020-07-13 04:10:12'),
	(3, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0.0, 0, 0, 0, 0.000000, 0.000000, '04:10:14', 'http://localhost:8080/img/resto/195626883.jpeg', 0, '0', '2020-07-13 04:10:14', '2020-07-13 04:10:14'),
	(4, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0.0, 0, 0, 0, 0.000000, 9999.999999, '04:10:33', 'http://localhost:8080/img/resto/962943031.jpeg', 0, '0', '2020-07-13 04:10:33', '2020-07-13 04:10:33'),
	(5, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0.0, 0, 0, 0, 0.000000, 9999.999999, '04:10:34', 'http://localhost:8080/img/resto/330350491.jpeg', 0, '0', '2020-07-13 04:10:34', '2020-07-13 04:10:34'),
	(6, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0.0, 0, 0, 0, 0.000000, 9999.999999, '04:17:06', 'http://localhost:8080/img/resto/907748883.jpeg', 0, '0', '2020-07-13 04:17:06', '2020-07-13 04:17:06'),
	(7, '', '', '', '', '', '', '', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'eeeaaaaaaaaaaaaaaaaaae3', 'eeeaaaaaaaaaaaaaaaaae3', 0.0, 0, 0, 0, 0.000000, 0.000000, '07:29:25', 'http://localhost:8080/img/resto/120073083.jpeg', 0, '0', '2020-07-13 07:29:25', '2020-07-13 07:29:25');
/*!40000 ALTER TABLE `restaurants` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.shops
CREATE TABLE IF NOT EXISTS `shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone_number` varchar(255) NOT NULL DEFAULT '',
  `phone_id` varchar(5) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `pin_register` varchar(255) NOT NULL DEFAULT '',
  `gcm` varchar(255) NOT NULL DEFAULT '',
  `nm_shop` varchar(255) NOT NULL DEFAULT '',
  `address_shop` varchar(255) NOT NULL DEFAULT '',
  `desc_shop` varchar(255) NOT NULL DEFAULT '',
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `kat_onkir` tinyint(4) NOT NULL DEFAULT 0,
  `lattitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `scadule` varchar(255) NOT NULL DEFAULT '' COMMENT 'jadwal buka dan tutup dalm seminggu format json contoh {a:{a:08:00,b:22:00}} penjelasan a pertama adalah senin',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `os` char(15) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tokens_plns
CREATE TABLE IF NOT EXISTS `tokens_plns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '',
  `price` decimal(10,0) DEFAULT 0,
  `status_provider` varchar(50) DEFAULT '',
  `status_stock` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tokens_plns: ~0 rows (approximately)
/*!40000 ALTER TABLE `tokens_plns` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens_plns` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.topups
CREATE TABLE IF NOT EXISTS `topups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code_transfer` varchar(50) NOT NULL DEFAULT '',
  `user_category` varchar(50) NOT NULL DEFAULT '',
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `bank_id` int(10) unsigned NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `is_verification` enum('true','false') NOT NULL DEFAULT 'false',
  `img_struck` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Kode Transfer` (`code_transfer`),
  UNIQUE KEY `Index 3` (`img_struck`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.topups: ~3 rows (approximately)
/*!40000 ALTER TABLE `topups` DISABLE KEYS */;
INSERT INTO `topups` (`id`, `code_transfer`, `user_category`, `user_id`, `bank_id`, `amount`, `is_verification`, `img_struck`, `created_at`, `updated_at`) VALUES
	(1, 'FE78143508975', 'customers', 1, 1, 21000, 'false', 'upload/topup/018FA3105479A9A8-772483107.jpeg', '2020-07-14 10:05:01', '2020-07-14 10:29:25'),
	(2, '865E670697123', '0', 1, 1, 21000, 'false', 'upload/topup/3D0BDFBA8268D9FF-135223287.jpeg', '2020-07-14 10:07:24', '2020-07-14 10:50:30'),
	(3, 'BDE6543434247', 'customers', 1, 1, 21000, 'false', 'upload/topup/257E53089DC504EF-677695007.jpeg', '2020-07-14 14:41:05', '2020-07-14 14:48:56');
/*!40000 ALTER TABLE `topups` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_cars
CREATE TABLE IF NOT EXISTS `tran_cars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_cars: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_cars` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_cars` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_cooks
CREATE TABLE IF NOT EXISTS `tran_cooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_cooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_cooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_cooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_couriers
CREATE TABLE IF NOT EXISTS `tran_couriers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_couriers: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_couriers` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_couriers` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_exchange_points
CREATE TABLE IF NOT EXISTS `tran_exchange_points` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_category` int(10) unsigned NOT NULL DEFAULT 0,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `point` int(10) unsigned NOT NULL DEFAULT 0,
  `name_exchange` varchar(50) NOT NULL DEFAULT '',
  `desc_exchange` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_exchange_points: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_exchange_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_exchange_points` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_foods
CREATE TABLE IF NOT EXISTS `tran_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT 0,
  `restaurant_id` int(10) unsigned NOT NULL DEFAULT 0,
  `customer_voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `driver_id` int(10) unsigned NOT NULL DEFAULT 0,
  `cancel_id` int(10) unsigned NOT NULL DEFAULT 0,
  `code_trans` varchar(50) NOT NULL DEFAULT '',
  `point_transaction` tinyint(4) NOT NULL DEFAULT 0,
  `pay_category` varchar(50) NOT NULL DEFAULT '',
  `status_driver` tinyint(4) NOT NULL DEFAULT 0,
  `status_order` tinyint(4) NOT NULL DEFAULT 0,
  `duration_value` varchar(50) NOT NULL DEFAULT '',
  `distance_value` varchar(50) NOT NULL DEFAULT '',
  `desti_long` varchar(50) NOT NULL DEFAULT '',
  `desti_lat` varchar(50) NOT NULL DEFAULT '',
  `desti_address` varchar(50) NOT NULL DEFAULT '',
  `desti_place` varchar(50) NOT NULL DEFAULT '',
  `polyline` varchar(50) NOT NULL DEFAULT '',
  `charge` int(11) NOT NULL DEFAULT 0,
  `driver_price` int(11) NOT NULL DEFAULT 0,
  `food_price` int(11) NOT NULL DEFAULT 0,
  `discount` int(11) NOT NULL DEFAULT 0,
  `amount_voucher` int(11) NOT NULL DEFAULT 0,
  `total_prices` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_foods: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_foods` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_foods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_ojeks
CREATE TABLE IF NOT EXISTS `tran_ojeks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT 0,
  `customer_voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `driver_id` int(11) NOT NULL DEFAULT 0,
  `code_trans` varchar(50) NOT NULL DEFAULT '',
  `pay_category` varchar(50) NOT NULL DEFAULT '',
  `point_transaction` tinyint(4) NOT NULL DEFAULT 0,
  `status_driver` tinyint(4) NOT NULL DEFAULT 0,
  `status_order` tinyint(4) NOT NULL DEFAULT 0,
  `charge` int(11) NOT NULL DEFAULT 0,
  `driver_price` int(11) NOT NULL DEFAULT 0,
  `discount` int(11) NOT NULL DEFAULT 0,
  `amount_voucher` int(11) NOT NULL DEFAULT 0,
  `total_prices` int(11) NOT NULL DEFAULT 0,
  `duration_value` int(11) NOT NULL DEFAULT 0,
  `distance_value` int(11) NOT NULL DEFAULT 0,
  `cancel_id` tinyint(4) NOT NULL DEFAULT 0,
  `pickup_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `pickup_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `desti_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `desti_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `desti_address` varchar(50) NOT NULL DEFAULT '',
  `desti_place` varchar(50) NOT NULL DEFAULT '',
  `distance_text` varchar(50) NOT NULL DEFAULT '',
  `duration_text` varchar(50) NOT NULL DEFAULT '',
  `pickup_place` varchar(50) NOT NULL DEFAULT '',
  `pickup_address` varchar(50) NOT NULL DEFAULT '',
  `pickup_desc` varchar(50) NOT NULL DEFAULT '',
  `polyline` tinytext NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `accept_at` datetime DEFAULT current_timestamp(),
  `finish_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`code_trans`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_ojeks: ~199 rows (approximately)
/*!40000 ALTER TABLE `tran_ojeks` DISABLE KEYS */;
INSERT INTO `tran_ojeks` (`id`, `customer_id`, `customer_voucher_id`, `driver_id`, `code_trans`, `pay_category`, `point_transaction`, `status_driver`, `status_order`, `charge`, `driver_price`, `discount`, `amount_voucher`, `total_prices`, `duration_value`, `distance_value`, `cancel_id`, `pickup_lat`, `pickup_long`, `desti_lat`, `desti_long`, `desti_address`, `desti_place`, `distance_text`, `duration_text`, `pickup_place`, `pickup_address`, `pickup_desc`, `polyline`, `created_at`, `accept_at`, `finish_at`, `updated_at`) VALUES
	(1, 1, 0, 1, '0F82198548847', 'tunai', 1, 0, 88, 1, 0, 0, 0, 4000, 1, 1, 1, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 00:40:16', '2020-07-16 00:40:16', '2020-07-16 00:40:16', '2020-07-17 16:19:18'),
	(2, 1, 0, 0, '2D11203530015', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 00:45:07', '2020-07-16 00:45:07', '2020-07-16 00:45:07', '2020-07-16 00:45:07'),
	(3, 1, 0, 0, 'DF96924929011', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 14:27:32', '2020-07-16 14:27:32', '2020-07-16 14:27:32', '2020-07-16 14:27:32'),
	(4, 1, 0, 0, '9C38124933271', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 14:27:47', '2020-07-16 14:27:47', '2020-07-16 14:27:47', '2020-07-16 14:27:47'),
	(5, 1, 0, 0, '756E688241347', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 14:28:45', '2020-07-16 14:28:45', '2020-07-16 14:28:45', '2020-07-16 14:28:45'),
	(6, 1, 0, 0, 'AAA2924452967', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 14:30:55', '2020-07-16 14:30:55', '2020-07-16 14:30:55', '2020-07-16 14:30:55'),
	(7, 1, 0, 0, '2082287285363', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:04:01', '2020-07-16 15:04:01', '2020-07-16 15:04:01', '2020-07-16 15:04:01'),
	(8, 1, 0, 0, '793D410586835', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:06:37', '2020-07-16 15:06:37', '2020-07-16 15:06:37', '2020-07-16 15:06:37'),
	(9, 1, 0, 0, '0733812732423', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:19:20', '2020-07-16 15:19:20', '2020-07-16 15:19:20', '2020-07-16 15:19:20'),
	(10, 1, 0, 0, '09AC191431719', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:21:13', '2020-07-16 15:21:13', '2020-07-16 15:21:13', '2020-07-16 15:21:13'),
	(11, 1, 0, 0, '7ED6786576019', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:22:40', '2020-07-16 15:22:40', '2020-07-16 15:22:40', '2020-07-16 15:22:40'),
	(12, 1, 0, 0, 'B165822475083', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:31:07', '2020-07-16 15:31:07', '2020-07-16 15:31:07', '2020-07-16 15:31:07'),
	(13, 1, 0, 0, 'D292567874675', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:33:49', '2020-07-16 15:33:49', '2020-07-16 15:33:49', '2020-07-16 15:33:49'),
	(14, 1, 0, 0, 'A97B359760751', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:34:05', '2020-07-16 15:34:05', '2020-07-16 15:34:05', '2020-07-16 15:34:05'),
	(15, 1, 0, 0, '66AE731784523', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:49:51', '2020-07-16 15:49:51', '2020-07-16 15:49:51', '2020-07-16 15:49:51'),
	(16, 1, 0, 0, '0662144095387', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:50:28', '2020-07-16 15:50:28', '2020-07-16 15:50:28', '2020-07-16 15:50:28'),
	(17, 1, 0, 0, '8C39125315335', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:51:06', '2020-07-16 15:51:06', '2020-07-16 15:51:06', '2020-07-16 15:51:06'),
	(18, 1, 0, 0, 'D87D587611667', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:52:36', '2020-07-16 15:52:36', '2020-07-16 15:52:36', '2020-07-16 15:52:36'),
	(19, 1, 0, 0, '83B6308537703', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:53:08', '2020-07-16 15:53:08', '2020-07-16 15:53:08', '2020-07-16 15:53:08'),
	(20, 1, 0, 0, '70A0338096079', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 15:53:42', '2020-07-16 15:53:42', '2020-07-16 15:53:42', '2020-07-16 15:53:42'),
	(21, 1, 0, 0, '51F4072041259', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:08:58', '2020-07-16 16:08:58', '2020-07-16 16:08:58', '2020-07-16 16:08:58'),
	(22, 1, 0, 0, '8D97322530847', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:27:55', '2020-07-16 16:27:55', '2020-07-16 16:27:55', '2020-07-16 16:27:55'),
	(23, 1, 0, 0, '1AC8973068543', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:28:38', '2020-07-16 16:28:38', '2020-07-16 16:28:38', '2020-07-16 16:28:38'),
	(24, 1, 0, 0, 'A2BF942109919', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:41:31', '2020-07-16 16:41:31', '2020-07-16 16:41:31', '2020-07-16 16:41:31'),
	(25, 1, 0, 0, 'A988158116803', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:42:39', '2020-07-16 16:42:39', '2020-07-16 16:42:39', '2020-07-16 16:42:39'),
	(26, 1, 0, 0, '2844732934199', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:43:29', '2020-07-16 16:43:29', '2020-07-16 16:43:29', '2020-07-16 16:43:29'),
	(27, 1, 0, 0, 'E8E8321412463', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:45:06', '2020-07-16 16:45:06', '2020-07-16 16:45:06', '2020-07-16 16:45:06'),
	(28, 1, 0, 0, '8C8A046978811', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:47:37', '2020-07-16 16:47:37', '2020-07-16 16:47:37', '2020-07-16 16:47:37'),
	(29, 1, 0, 0, 'A0D6808890183', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:50:42', '2020-07-16 16:50:42', '2020-07-16 16:50:42', '2020-07-16 16:50:42'),
	(30, 1, 0, 0, 'FD6D374686363', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:53:40', '2020-07-16 16:53:40', '2020-07-16 16:53:40', '2020-07-16 16:53:40'),
	(31, 1, 0, 0, '511B261909839', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:55:48', '2020-07-16 16:55:48', '2020-07-16 16:55:48', '2020-07-16 16:55:48'),
	(32, 1, 0, 0, 'B85E035098795', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:12', '2020-07-16 16:56:12', '2020-07-16 16:56:12', '2020-07-16 16:56:12'),
	(33, 1, 0, 0, 'EBBD430613019', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:13', '2020-07-16 16:56:13', '2020-07-16 16:56:13', '2020-07-16 16:56:13'),
	(34, 1, 0, 0, '33EE019827971', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:14', '2020-07-16 16:56:14', '2020-07-16 16:56:14', '2020-07-16 16:56:14'),
	(35, 1, 0, 0, '6437276281947', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:15', '2020-07-16 16:56:15', '2020-07-16 16:56:15', '2020-07-16 16:56:15'),
	(36, 1, 0, 0, '3B14541759583', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:27', '2020-07-16 16:56:27', '2020-07-16 16:56:27', '2020-07-16 16:56:27'),
	(37, 1, 0, 0, '5713981798103', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:28', '2020-07-16 16:56:28', '2020-07-16 16:56:28', '2020-07-16 16:56:28'),
	(38, 1, 0, 0, '9F34498381995', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:29', '2020-07-16 16:56:29', '2020-07-16 16:56:29', '2020-07-16 16:56:29'),
	(39, 1, 0, 0, 'C6F2011480843', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:30', '2020-07-16 16:56:30', '2020-07-16 16:56:30', '2020-07-16 16:56:30'),
	(40, 1, 0, 0, '64DB000744495', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:31', '2020-07-16 16:56:31', '2020-07-16 16:56:31', '2020-07-16 16:56:31'),
	(41, 1, 0, 0, '32D6176978259', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:32', '2020-07-16 16:56:32', '2020-07-16 16:56:32', '2020-07-16 16:56:32'),
	(42, 1, 0, 0, 'AEEE882204787', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:33', '2020-07-16 16:56:33', '2020-07-16 16:56:33', '2020-07-16 16:56:33'),
	(43, 1, 0, 0, '7822452999891', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:33', '2020-07-16 16:56:33', '2020-07-16 16:56:33', '2020-07-16 16:56:33'),
	(44, 1, 0, 0, '40A8505207687', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:35', '2020-07-16 16:56:35', '2020-07-16 16:56:35', '2020-07-16 16:56:35'),
	(45, 1, 0, 0, 'B3EF936942543', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:56:36', '2020-07-16 16:56:36', '2020-07-16 16:56:36', '2020-07-16 16:56:36'),
	(46, 1, 0, 0, '36BD119725639', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:29', '2020-07-16 16:57:29', '2020-07-16 16:57:29', '2020-07-16 16:57:29'),
	(47, 1, 0, 0, '05C8385007995', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:30', '2020-07-16 16:57:30', '2020-07-16 16:57:30', '2020-07-16 16:57:30'),
	(48, 1, 0, 0, '4983742299271', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:31', '2020-07-16 16:57:31', '2020-07-16 16:57:31', '2020-07-16 16:57:31'),
	(49, 1, 0, 0, 'C5A1237836807', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:32', '2020-07-16 16:57:32', '2020-07-16 16:57:32', '2020-07-16 16:57:32'),
	(50, 1, 0, 0, 'A83F559861435', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:33', '2020-07-16 16:57:33', '2020-07-16 16:57:33', '2020-07-16 16:57:33'),
	(51, 1, 0, 0, '6BCA083076467', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:34', '2020-07-16 16:57:34', '2020-07-16 16:57:34', '2020-07-16 16:57:34'),
	(52, 1, 0, 0, '9E03242133639', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:35', '2020-07-16 16:57:35', '2020-07-16 16:57:35', '2020-07-16 16:57:35'),
	(53, 1, 0, 0, 'FD61881360247', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:36', '2020-07-16 16:57:36', '2020-07-16 16:57:36', '2020-07-16 16:57:36'),
	(54, 1, 0, 0, '27EF168976763', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:57:37', '2020-07-16 16:57:37', '2020-07-16 16:57:37', '2020-07-16 16:57:37'),
	(55, 1, 0, 0, '6806540134607', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:21', '2020-07-16 16:58:21', '2020-07-16 16:58:21', '2020-07-16 16:58:21'),
	(56, 1, 0, 0, '3DEE728586347', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:22', '2020-07-16 16:58:22', '2020-07-16 16:58:22', '2020-07-16 16:58:22'),
	(57, 1, 0, 0, '68EC856910247', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:23', '2020-07-16 16:58:23', '2020-07-16 16:58:23', '2020-07-16 16:58:23'),
	(58, 1, 0, 0, '18DD117563779', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:24', '2020-07-16 16:58:24', '2020-07-16 16:58:24', '2020-07-16 16:58:24'),
	(59, 1, 0, 0, 'A191737512003', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:24', '2020-07-16 16:58:24', '2020-07-16 16:58:24', '2020-07-16 16:58:24'),
	(60, 1, 0, 0, '7DF4254095895', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 16:58:25', '2020-07-16 16:58:25', '2020-07-16 16:58:25', '2020-07-16 16:58:25'),
	(61, 1, 0, 0, '65E3473372755', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:01:46', '2020-07-16 17:01:46', '2020-07-16 17:01:46', '2020-07-16 17:01:46'),
	(62, 1, 0, 0, 'EC46049356899', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:03:19', '2020-07-16 17:03:19', '2020-07-16 17:03:19', '2020-07-16 17:03:19'),
	(63, 1, 0, 0, 'EA00125709275', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:27', '2020-07-16 17:08:27', '2020-07-16 17:08:27', '2020-07-16 17:08:27'),
	(64, 1, 0, 0, '52D6593954391', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:39', '2020-07-16 17:08:39', '2020-07-16 17:08:39', '2020-07-16 17:08:39'),
	(65, 1, 0, 0, 'E1A2158641971', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:41', '2020-07-16 17:08:41', '2020-07-16 17:08:41', '2020-07-16 17:08:41'),
	(66, 1, 0, 0, 'DD06915453203', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:42', '2020-07-16 17:08:42', '2020-07-16 17:08:42', '2020-07-16 17:08:42'),
	(67, 1, 0, 0, 'BF8D894600671', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:43', '2020-07-16 17:08:43', '2020-07-16 17:08:43', '2020-07-16 17:08:43'),
	(68, 1, 0, 0, '15CB618676315', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:45', '2020-07-16 17:08:45', '2020-07-16 17:08:45', '2020-07-16 17:08:45'),
	(69, 1, 0, 0, '6BB5799014187', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:46', '2020-07-16 17:08:46', '2020-07-16 17:08:46', '2020-07-16 17:08:46'),
	(70, 1, 0, 0, '1E81066827603', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:47', '2020-07-16 17:08:47', '2020-07-16 17:08:47', '2020-07-16 17:08:47'),
	(71, 1, 0, 0, '5593885439199', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:08:48', '2020-07-16 17:08:48', '2020-07-16 17:08:48', '2020-07-16 17:08:48'),
	(72, 1, 0, 0, 'D2A5673548863', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:42:24', '2020-07-16 17:42:24', '2020-07-16 17:42:24', '2020-07-16 17:42:24'),
	(73, 1, 0, 0, 'E584617014775', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:43:19', '2020-07-16 17:43:19', '2020-07-16 17:43:19', '2020-07-16 17:43:19'),
	(74, 1, 0, 0, '21C6336461595', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:43:20', '2020-07-16 17:43:20', '2020-07-16 17:43:20', '2020-07-16 17:43:20'),
	(75, 1, 0, 0, '0293365619619', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 17:43:22', '2020-07-16 17:43:22', '2020-07-16 17:43:22', '2020-07-16 17:43:22'),
	(76, 1, 0, 0, 'D0C2629382855', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:30:00', '2020-07-17 16:30:00', '2020-07-17 16:30:00', '2020-07-17 16:30:00'),
	(77, 1, 0, 0, 'A349145965647', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:30:03', '2020-07-17 16:30:03', '2020-07-17 16:30:03', '2020-07-17 16:30:03'),
	(78, 1, 0, 0, '02A0347349875', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:30:04', '2020-07-17 16:30:04', '2020-07-17 16:30:04', '2020-07-17 16:30:04'),
	(79, 1, 0, 0, '44A4002994015', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:30:05', '2020-07-17 16:30:05', '2020-07-17 16:30:05', '2020-07-17 16:30:05'),
	(80, 1, 0, 0, '8286532939663', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:30:06', '2020-07-17 16:30:06', '2020-07-17 16:30:06', '2020-07-17 16:30:06'),
	(81, 1, 0, 0, 'FCE5357635819', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:42:03', '2020-07-17 16:42:03', '2020-07-17 16:42:03', '2020-07-17 16:42:03'),
	(82, 1, 0, 0, 'FAC4747996503', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:42:04', '2020-07-17 16:42:04', '2020-07-17 16:42:04', '2020-07-17 16:42:04'),
	(83, 1, 0, 0, 'CEC6387223111', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 16:42:05', '2020-07-17 16:42:05', '2020-07-17 16:42:05', '2020-07-17 16:42:05'),
	(84, 1, 0, 0, '282D358992807', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:25:35', '2020-07-17 17:25:35', '2020-07-17 17:25:35', '2020-07-17 17:25:35'),
	(85, 1, 0, 0, 'D284028857239', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:25:36', '2020-07-17 17:25:36', '2020-07-17 17:25:36', '2020-07-17 17:25:36'),
	(86, 1, 0, 0, 'FF65035682203', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:25:37', '2020-07-17 17:25:37', '2020-07-17 17:25:37', '2020-07-17 17:25:37'),
	(87, 1, 0, 0, '3689984621115', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:25:38', '2020-07-17 17:25:38', '2020-07-17 17:25:38', '2020-07-17 17:25:38'),
	(88, 1, 0, 0, '44C4077678367', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:25:39', '2020-07-17 17:25:39', '2020-07-17 17:25:39', '2020-07-17 17:25:39'),
	(89, 1, 0, 0, 'E00F496704095', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:26:25', '2020-07-17 17:26:25', '2020-07-17 17:26:25', '2020-07-17 17:26:25'),
	(90, 1, 0, 0, 'B91D151281811', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:27:18', '2020-07-17 17:27:18', '2020-07-17 17:27:18', '2020-07-17 17:27:18'),
	(91, 1, 0, 0, '99F6777753951', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:19', '2020-07-17 17:29:19', '2020-07-17 17:29:19', '2020-07-17 17:29:19'),
	(92, 1, 0, 0, '0CB1664797051', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:21', '2020-07-17 17:29:21', '2020-07-17 17:29:21', '2020-07-17 17:29:21'),
	(93, 1, 0, 0, 'A731645946835', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:22', '2020-07-17 17:29:22', '2020-07-17 17:29:22', '2020-07-17 17:29:22'),
	(94, 1, 0, 0, '22D8932180099', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:23', '2020-07-17 17:29:23', '2020-07-17 17:29:23', '2020-07-17 17:29:23'),
	(95, 1, 0, 0, '63A1065132823', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:24', '2020-07-17 17:29:24', '2020-07-17 17:29:24', '2020-07-17 17:29:24'),
	(96, 1, 0, 0, '9D29196842291', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:25', '2020-07-17 17:29:25', '2020-07-17 17:29:25', '2020-07-17 17:29:25'),
	(97, 1, 0, 0, '3F20270525711', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:26', '2020-07-17 17:29:26', '2020-07-17 17:29:26', '2020-07-17 17:29:26'),
	(98, 1, 0, 0, '456E581190899', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:27', '2020-07-17 17:29:27', '2020-07-17 17:29:27', '2020-07-17 17:29:27'),
	(99, 1, 0, 0, 'B60E499396539', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:28', '2020-07-17 17:29:28', '2020-07-17 17:29:28', '2020-07-17 17:29:28'),
	(100, 1, 0, 0, '1B0D772268047', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:29', '2020-07-17 17:29:29', '2020-07-17 17:29:29', '2020-07-17 17:29:29'),
	(101, 1, 0, 0, '75F8883745147', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:30', '2020-07-17 17:29:30', '2020-07-17 17:29:30', '2020-07-17 17:29:30'),
	(102, 1, 0, 0, '79A0772890039', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:32', '2020-07-17 17:29:32', '2020-07-17 17:29:32', '2020-07-17 17:29:32'),
	(103, 1, 0, 0, '41A8086705351', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:33', '2020-07-17 17:29:33', '2020-07-17 17:29:33', '2020-07-17 17:29:33'),
	(104, 1, 0, 0, '7A2F168403163', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:29:34', '2020-07-17 17:29:34', '2020-07-17 17:29:34', '2020-07-17 17:29:34'),
	(105, 1, 0, 0, '85E8989653551', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:33', '2020-07-17 17:30:33', '2020-07-17 17:30:33', '2020-07-17 17:30:33'),
	(106, 1, 0, 0, '85C5848160619', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:35', '2020-07-17 17:30:35', '2020-07-17 17:30:35', '2020-07-17 17:30:35'),
	(107, 1, 0, 0, 'A87C044486755', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:36', '2020-07-17 17:30:36', '2020-07-17 17:30:36', '2020-07-17 17:30:36'),
	(108, 1, 0, 0, '86E3665293515', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:37', '2020-07-17 17:30:37', '2020-07-17 17:30:37', '2020-07-17 17:30:37'),
	(109, 1, 0, 0, '453E363360159', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:38', '2020-07-17 17:30:38', '2020-07-17 17:30:38', '2020-07-17 17:30:38'),
	(110, 1, 0, 0, '9B4B894259791', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:38', '2020-07-17 17:30:38', '2020-07-17 17:30:38', '2020-07-17 17:30:38'),
	(111, 1, 0, 0, '2EC9076794903', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:39', '2020-07-17 17:30:39', '2020-07-17 17:30:39', '2020-07-17 17:30:39'),
	(112, 1, 0, 0, '275A347564619', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:40', '2020-07-17 17:30:40', '2020-07-17 17:30:40', '2020-07-17 17:30:40'),
	(113, 1, 0, 0, '56B9251454519', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:41', '2020-07-17 17:30:41', '2020-07-17 17:30:41', '2020-07-17 17:30:41'),
	(114, 1, 0, 0, '7839011321527', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:42', '2020-07-17 17:30:42', '2020-07-17 17:30:42', '2020-07-17 17:30:42'),
	(115, 1, 0, 0, 'A140028691943', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:30:43', '2020-07-17 17:30:43', '2020-07-17 17:30:43', '2020-07-17 17:30:43'),
	(116, 1, 0, 0, '7C6D073800239', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:03', '2020-07-17 17:34:03', '2020-07-17 17:34:03', '2020-07-17 17:34:03'),
	(117, 1, 0, 0, '8300478476663', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:05', '2020-07-17 17:34:05', '2020-07-17 17:34:05', '2020-07-17 17:34:05'),
	(118, 1, 0, 0, 'ECAD566046555', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:05', '2020-07-17 17:34:05', '2020-07-17 17:34:05', '2020-07-17 17:34:05'),
	(119, 1, 0, 0, 'AC17714173555', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:06', '2020-07-17 17:34:06', '2020-07-17 17:34:06', '2020-07-17 17:34:06'),
	(120, 1, 0, 0, 'E87E941136415', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:09', '2020-07-17 17:34:09', '2020-07-17 17:34:09', '2020-07-17 17:34:09'),
	(121, 1, 0, 0, '8E27677430035', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:10', '2020-07-17 17:34:10', '2020-07-17 17:34:10', '2020-07-17 17:34:10'),
	(122, 1, 0, 0, '2964933025475', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:11', '2020-07-17 17:34:11', '2020-07-17 17:34:11', '2020-07-17 17:34:11'),
	(123, 1, 0, 0, '48E6806706819', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 17:34:12', '2020-07-17 17:34:12', '2020-07-17 17:34:12', '2020-07-17 17:34:12'),
	(124, 1, 0, 0, '9F2C877074531', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:07:18', '2020-07-17 18:07:18', '2020-07-17 18:07:18', '2020-07-17 18:07:18'),
	(125, 1, 0, 0, '5085855746451', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:09:35', '2020-07-17 18:09:35', '2020-07-17 18:09:35', '2020-07-17 18:09:35'),
	(126, 1, 0, 0, '91BA037660299', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:09:38', '2020-07-17 18:09:38', '2020-07-17 18:09:38', '2020-07-17 18:09:38'),
	(127, 1, 0, 0, '3E19886805699', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:10:34', '2020-07-17 18:10:34', '2020-07-17 18:10:34', '2020-07-17 18:10:34'),
	(128, 1, 0, 0, '5168598527383', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:10:54', '2020-07-17 18:10:54', '2020-07-17 18:10:54', '2020-07-17 18:10:54'),
	(129, 1, 0, 0, 'C385030866651', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:14:50', '2020-07-17 18:14:50', '2020-07-17 18:14:50', '2020-07-17 18:14:50'),
	(130, 1, 0, 0, '6245728188867', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:15:49', '2020-07-17 18:15:49', '2020-07-17 18:15:49', '2020-07-17 18:15:49'),
	(131, 1, 0, 0, '5191583169883', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:18:44', '2020-07-17 18:18:44', '2020-07-17 18:18:44', '2020-07-17 18:18:44'),
	(132, 1, 0, 0, 'E745970800975', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:20:18', '2020-07-17 18:20:18', '2020-07-17 18:20:18', '2020-07-17 18:20:18'),
	(133, 1, 0, 0, 'F788667023503', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:22:46', '2020-07-17 18:22:46', '2020-07-17 18:22:46', '2020-07-17 18:22:46'),
	(134, 1, 0, 0, '8145113277315', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:23:11', '2020-07-17 18:23:11', '2020-07-17 18:23:11', '2020-07-17 18:23:11'),
	(135, 1, 0, 0, 'EEE0542006887', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:23:51', '2020-07-17 18:23:51', '2020-07-17 18:23:51', '2020-07-17 18:23:51'),
	(136, 1, 0, 0, 'DBCF488542999', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:25:22', '2020-07-17 18:25:22', '2020-07-17 18:25:22', '2020-07-17 18:25:22'),
	(137, 1, 0, 0, '2CCC602319663', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:42:10', '2020-07-17 18:42:10', '2020-07-17 18:42:10', '2020-07-17 18:42:10'),
	(138, 1, 0, 0, 'E9BF314275707', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-17 18:42:13', '2020-07-17 18:42:13', '2020-07-17 18:42:13', '2020-07-17 18:42:13'),
	(139, 1, 0, 0, '7CF2780881635', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-18 11:50:56', '2020-07-18 11:50:56', '2020-07-18 11:50:56', '2020-07-18 11:50:56'),
	(140, 1, 0, 0, '8677854408451', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:14:46', '2020-07-19 04:14:46', '2020-07-19 04:14:46', '2020-07-19 04:14:46'),
	(141, 1, 0, 0, 'C8D8957927155', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:15:21', '2020-07-19 04:15:21', '2020-07-19 04:15:21', '2020-07-19 04:15:21'),
	(142, 1, 0, 0, 'D815530627995', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:17:39', '2020-07-19 04:17:39', '2020-07-19 04:17:39', '2020-07-19 04:17:39'),
	(143, 1, 0, 0, 'A2B4153016911', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:18:05', '2020-07-19 04:18:05', '2020-07-19 04:18:05', '2020-07-19 04:18:05'),
	(144, 1, 0, 0, '3A92210136883', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:21:29', '2020-07-19 04:21:29', '2020-07-19 04:21:29', '2020-07-19 04:21:29'),
	(145, 1, 0, 0, 'A4BB287121507', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:23:05', '2020-07-19 04:23:05', '2020-07-19 04:23:05', '2020-07-19 04:23:05'),
	(146, 1, 0, 0, 'B5BC161547955', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:24:03', '2020-07-19 04:24:03', '2020-07-19 04:24:03', '2020-07-19 04:24:03'),
	(147, 1, 0, 0, '098C342507819', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:24:07', '2020-07-19 04:24:07', '2020-07-19 04:24:07', '2020-07-19 04:24:07'),
	(148, 1, 0, 0, '09DD632224187', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:28:09', '2020-07-19 04:28:09', '2020-07-19 04:28:09', '2020-07-19 04:28:09'),
	(149, 1, 0, 0, '6FC1993523023', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:28:12', '2020-07-19 04:28:12', '2020-07-19 04:28:12', '2020-07-19 04:28:12'),
	(150, 1, 0, 0, '6344567992967', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:28:13', '2020-07-19 04:28:13', '2020-07-19 04:28:13', '2020-07-19 04:28:13'),
	(151, 1, 0, 0, '1352593444275', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:31:23', '2020-07-19 04:31:23', '2020-07-19 04:31:23', '2020-07-19 04:31:23'),
	(152, 1, 0, 0, '4A5B301102387', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:31:24', '2020-07-19 04:31:24', '2020-07-19 04:31:24', '2020-07-19 04:31:24'),
	(153, 1, 0, 0, '2AFA753378347', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:37:59', '2020-07-19 04:37:59', '2020-07-19 04:37:59', '2020-07-19 04:37:59'),
	(154, 1, 0, 0, 'DB5C211836715', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:38:00', '2020-07-19 04:38:00', '2020-07-19 04:38:00', '2020-07-19 04:38:00'),
	(155, 1, 0, 0, '9CFF817898467', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 04:38:01', '2020-07-19 04:38:01', '2020-07-19 04:38:01', '2020-07-19 04:38:01'),
	(156, 1, 0, 0, '3301237549871', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:54:53', '2020-07-19 12:54:53', '2020-07-19 12:54:53', '2020-07-19 12:54:53'),
	(157, 1, 0, 0, '3901718299663', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:15', '2020-07-19 12:55:15', '2020-07-19 12:55:15', '2020-07-19 12:55:15'),
	(158, 1, 0, 0, 'C623397421743', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:16', '2020-07-19 12:55:16', '2020-07-19 12:55:16', '2020-07-19 12:55:16'),
	(159, 1, 0, 0, '6D1C953901107', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:18', '2020-07-19 12:55:18', '2020-07-19 12:55:18', '2020-07-19 12:55:18'),
	(160, 1, 0, 0, '7411503220587', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:18', '2020-07-19 12:55:18', '2020-07-19 12:55:18', '2020-07-19 12:55:18'),
	(161, 1, 0, 0, '88D4198760199', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:20', '2020-07-19 12:55:20', '2020-07-19 12:55:20', '2020-07-19 12:55:20'),
	(162, 1, 0, 0, 'E3E7914102911', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:20', '2020-07-19 12:55:20', '2020-07-19 12:55:20', '2020-07-19 12:55:20'),
	(163, 1, 0, 0, 'EB69413840003', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:21', '2020-07-19 12:55:21', '2020-07-19 12:55:21', '2020-07-19 12:55:21'),
	(164, 1, 0, 0, 'BAAE007683779', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 12:55:22', '2020-07-19 12:55:22', '2020-07-19 12:55:22', '2020-07-19 12:55:22'),
	(165, 1, 0, 0, '6325358902511', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:32:47', '2020-07-19 13:32:47', '2020-07-19 13:32:47', '2020-07-19 13:32:47'),
	(166, 1, 0, 0, '9B47916004595', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:32:55', '2020-07-19 13:32:55', '2020-07-19 13:32:55', '2020-07-19 13:32:55'),
	(167, 1, 0, 0, 'B570109704223', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:32:57', '2020-07-19 13:32:57', '2020-07-19 13:32:57', '2020-07-19 13:32:57'),
	(168, 1, 0, 0, 'C5C7889997423', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:32:59', '2020-07-19 13:32:59', '2020-07-19 13:32:59', '2020-07-19 13:32:59'),
	(169, 1, 0, 0, '3FB9614073067', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:00', '2020-07-19 13:33:00', '2020-07-19 13:33:00', '2020-07-19 13:33:00'),
	(170, 1, 0, 0, 'D907063273787', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:01', '2020-07-19 13:33:01', '2020-07-19 13:33:01', '2020-07-19 13:33:01'),
	(171, 1, 0, 0, '7156002953951', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:04', '2020-07-19 13:33:04', '2020-07-19 13:33:04', '2020-07-19 13:33:04'),
	(172, 1, 0, 0, '0C7A959671811', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:05', '2020-07-19 13:33:05', '2020-07-19 13:33:05', '2020-07-19 13:33:05'),
	(173, 1, 0, 0, '4DC8285705099', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:07', '2020-07-19 13:33:07', '2020-07-19 13:33:07', '2020-07-19 13:33:07'),
	(174, 1, 0, 0, 'A097087374447', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:09', '2020-07-19 13:33:09', '2020-07-19 13:33:09', '2020-07-19 13:33:09'),
	(175, 1, 0, 0, '79DE302024983', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:11', '2020-07-19 13:33:11', '2020-07-19 13:33:11', '2020-07-19 13:33:11'),
	(176, 1, 0, 0, '4731568359699', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:12', '2020-07-19 13:33:12', '2020-07-19 13:33:12', '2020-07-19 13:33:12'),
	(177, 1, 0, 0, '8074834500591', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:13', '2020-07-19 13:33:13', '2020-07-19 13:33:13', '2020-07-19 13:33:13'),
	(178, 1, 0, 0, '8922369075063', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:14', '2020-07-19 13:33:14', '2020-07-19 13:33:14', '2020-07-19 13:33:14'),
	(179, 1, 0, 0, 'F1E8467190407', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:15', '2020-07-19 13:33:15', '2020-07-19 13:33:15', '2020-07-19 13:33:15'),
	(180, 1, 0, 0, '311D709424091', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:16', '2020-07-19 13:33:16', '2020-07-19 13:33:16', '2020-07-19 13:33:16'),
	(181, 1, 0, 0, '4383936912767', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:17', '2020-07-19 13:33:17', '2020-07-19 13:33:17', '2020-07-19 13:33:17'),
	(182, 1, 0, 0, 'E62D720686983', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:33:18', '2020-07-19 13:33:18', '2020-07-19 13:33:18', '2020-07-19 13:33:18'),
	(183, 1, 0, 0, '63E1488665351', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:29', '2020-07-19 13:39:29', '2020-07-19 13:39:29', '2020-07-19 13:39:29'),
	(184, 1, 0, 0, 'CC8E879455303', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:30', '2020-07-19 13:39:30', '2020-07-19 13:39:30', '2020-07-19 13:39:30'),
	(185, 1, 0, 0, '122E712382639', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:31', '2020-07-19 13:39:31', '2020-07-19 13:39:31', '2020-07-19 13:39:31'),
	(186, 1, 0, 0, 'EF34218421079', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:32', '2020-07-19 13:39:32', '2020-07-19 13:39:32', '2020-07-19 13:39:32'),
	(187, 1, 0, 0, '64E9106847431', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:33', '2020-07-19 13:39:33', '2020-07-19 13:39:33', '2020-07-19 13:39:33'),
	(188, 1, 0, 0, '5A42835122631', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:34', '2020-07-19 13:39:34', '2020-07-19 13:39:34', '2020-07-19 13:39:34'),
	(189, 1, 0, 0, 'BDD5081460423', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:36', '2020-07-19 13:39:36', '2020-07-19 13:39:36', '2020-07-19 13:39:36'),
	(190, 1, 0, 0, '1A45309378367', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:37', '2020-07-19 13:39:37', '2020-07-19 13:39:37', '2020-07-19 13:39:37'),
	(191, 1, 0, 0, '6407546029243', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:38', '2020-07-19 13:39:38', '2020-07-19 13:39:38', '2020-07-19 13:39:38'),
	(192, 1, 0, 0, '3C33384014671', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:39', '2020-07-19 13:39:39', '2020-07-19 13:39:39', '2020-07-19 13:39:39'),
	(193, 1, 0, 0, '95D6679934851', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:40', '2020-07-19 13:39:40', '2020-07-19 13:39:40', '2020-07-19 13:39:40'),
	(194, 1, 0, 0, '696D430544211', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 13:39:41', '2020-07-19 13:39:41', '2020-07-19 13:39:41', '2020-07-19 13:39:41'),
	(195, 1, 0, 0, '701A503083903', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 15:41:17', '2020-07-19 15:41:17', '2020-07-19 15:41:17', '2020-07-19 15:41:17'),
	(196, 1, 0, 0, 'C619372382587', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 15:41:47', '2020-07-19 15:41:47', '2020-07-19 15:41:47', '2020-07-19 15:41:47'),
	(197, 1, 0, 0, '17BC053855179', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-19 15:42:24', '2020-07-19 15:42:24', '2020-07-19 15:42:24', '2020-07-19 15:42:24'),
	(198, 1, 0, 0, '6132247173179', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-08-12 09:27:04', '2020-08-12 09:27:04', '2020-08-12 09:27:04', '2020-08-12 09:27:04'),
	(199, 1, 0, 0, '742F460220655', 'tunai', 1, 0, 0, 1, 0, 0, 0, 4000, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-08-13 19:12:57', '2020-08-13 19:12:57', '2020-08-13 19:12:57', '2020-08-13 19:12:57');
/*!40000 ALTER TABLE `tran_ojeks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.tran_shops
CREATE TABLE IF NOT EXISTS `tran_shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `tran_shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `tran_shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.vouchers
CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_name` varchar(50) DEFAULT '',
  `voucher_desc` varchar(50) DEFAULT '',
  `voucher_code` varchar(50) DEFAULT '',
  `voucher_img` varchar(255) DEFAULT '',
  `amount` int(11) DEFAULT 0,
  `begin_at` varchar(50) DEFAULT '',
  `stop_at` varchar(50) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.vouchers: ~0 rows (approximately)
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
