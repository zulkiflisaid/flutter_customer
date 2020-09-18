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

-- Dumping structure for table fullstack_api.banks
CREATE TABLE IF NOT EXISTS `banks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `no_rek` varchar(50) DEFAULT '',
  `nm_pendek` varchar(50) DEFAULT '',
  `nm_panjang` varchar(50) DEFAULT '',
  `pemilik` varchar(50) DEFAULT '',
  `url_logo` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Nomor Rekening` (`no_rek`),
  UNIQUE KEY `Logo` (`url_logo`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.banks: ~5 rows (approximately)
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
INSERT INTO `banks` (`id`, `no_rek`, `nm_pendek`, `nm_panjang`, `pemilik`, `url_logo`, `created_at`, `updated_at`) VALUES
	(1, 'reee3', 'eee3', 'eee3', 'f', 'http://localhost:8080/img/bank/600881587.jpeg', '2020-07-11 09:17:29', '2020-07-12 07:43:11'),
	(21, 'reeee3', 'eeee3', 'eeee3', 'f', 'http://localhost:8080/img/bank/314067471.jpeg', '2020-07-12 07:43:23', '2020-07-12 07:43:23'),
	(22, 'e', 'eeee3', 'eeee3', 'b', 'http://localhost:8080/img/bank/288061399.jpeg', '2020-07-12 07:43:24', '2020-07-12 07:43:24'),
	(23, 'ee', 'eeee3', 'eeee3', 'b', 'http://localhost:8080/img/bank/931180891.jpeg', '2020-07-12 07:43:27', '2020-07-12 07:43:27'),
	(24, 'eeee3e', 'eeee3', 'eeee3', '', 'http://localhost:8080/img/bank/041735827.jpeg', '2020-07-12 07:43:31', '2020-07-12 07:43:31');
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;

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
  `category_cook` varchar(50) DEFAULT NULL,
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
  `category_food` varchar(50) DEFAULT NULL,
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

-- Dumping structure for table fullstack_api.category_shops
CREATE TABLE IF NOT EXISTS `category_shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_shop` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `category` (`category_shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.category_shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `category_shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_shops` ENABLE KEYS */;

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
  `alamat_cook` varchar(255) NOT NULL DEFAULT '',
  `ket_cook` varchar(255) NOT NULL DEFAULT '',
  `min_hrg` int(11) NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `kat_onkir` tinyint(4) NOT NULL DEFAULT 0,
  `posisi_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `posisi_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `buka_senin` time NOT NULL DEFAULT curtime(),
  `tutup_senin` time NOT NULL DEFAULT curtime(),
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
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
  `name` varchar(50) NOT NULL DEFAULT '0',
  `email` varchar(100) NOT NULL DEFAULT '0',
  `phone_number` varchar(15) NOT NULL DEFAULT '0',
  `phone_id` varchar(5) NOT NULL DEFAULT '0',
  `password` varchar(100) NOT NULL DEFAULT '0',
  `saldo` decimal(7,0) unsigned NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `trip` int(11) NOT NULL DEFAULT 0,
  `point` int(11) NOT NULL DEFAULT 0,
  `pin_register` int(11) NOT NULL DEFAULT 0,
  `pin_reset` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `gcm` varchar(255) NOT NULL DEFAULT '0',
  `url_avatar` varchar(255) NOT NULL DEFAULT '',
  `radius_pickup` smallint(6) NOT NULL DEFAULT 10000 COMMENT 'radius jemputan yg sesuai harapan masing masing pelanggan pakai meter ',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `last_order` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`email`),
  UNIQUE KEY `Phone Number` (`phone_id`,`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.customers: ~3 rows (approximately)
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `saldo`, `counter_reputation`, `divide_reputation`, `trip`, `point`, `pin_register`, `pin_reset`, `latitude`, `longitude`, `gcm`, `url_avatar`, `radius_pickup`, `status`, `last_order`, `created_at`, `updated_at`) VALUES
	(1, 'rrrrrrrrrr', 'a@customer.com', '82256330208', '+62', '$2a$04$J/tfNRMb5ixYPlB8NLbzGu77sMhoJTKqSBp/iaulmNIizTr3s0.s6', 0, 0.0, 0, 0, 0, 799523, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '2020-07-09 10:32:05', '2020-07-09 10:32:05', '2020-07-15 23:26:34'),
	(2, 'rrrrrrrrrr', 'ee@aa.com', '82256330206', '+62', '$2a$04$Y5U5o2s9orbB1G33NNzGgOL4vX3/ojBZ5uC5btYjJl9.5DRaYIzpe', 0, 0.0, 0, 0, 0, 230131, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '2020-07-09 10:32:45', '2020-07-09 10:32:45', '2020-07-14 13:46:59'),
	(3, 'rrrrrrrrrr', 'ee@aaa.com', '82256330205', '+62', '$2a$04$mmphNiQhuXfj5o5lYdpWNuW/E1mODW.ICVH33cBrakFAVT.pABUvC', 0, 0.0, 0, 0, 0, 733432, 0, 0.000000, 0.000000, 'gcm', '', 10000, 1, '2020-07-09 10:32:50', '2020-07-09 10:32:50', '2020-07-14 13:47:03');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;

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
  `name` varchar(50) NOT NULL DEFAULT '0',
  `email` varchar(100) NOT NULL DEFAULT '0',
  `phone_number` varchar(15) NOT NULL DEFAULT '0',
  `phone_id` varchar(3) NOT NULL DEFAULT '0',
  `password` varchar(100) NOT NULL DEFAULT '0',
  `category_driver` varchar(100) NOT NULL DEFAULT '0',
  `saldo` decimal(7,0) unsigned NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `trip` int(11) NOT NULL DEFAULT 0,
  `point` int(11) NOT NULL DEFAULT 0,
  `pin_register` int(11) NOT NULL DEFAULT 0,
  `pin_reset` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `longitude` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `gcm` varchar(255) NOT NULL DEFAULT '0',
  `url_avatar` varchar(255) NOT NULL DEFAULT '',
  `radius_pickup` smallint(6) NOT NULL DEFAULT 10000 COMMENT 'radius jemputan yg sesuai harapan masing masing pelanggan pakai meter ',
  `active_driving` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `last_order` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`email`),
  UNIQUE KEY `Phone Number` (`phone_id`,`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.drivers: ~3 rows (approximately)
/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
INSERT INTO `drivers` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `category_driver`, `saldo`, `counter_reputation`, `divide_reputation`, `trip`, `point`, `pin_register`, `pin_reset`, `latitude`, `longitude`, `gcm`, `url_avatar`, `radius_pickup`, `active_driving`, `status`, `last_order`, `created_at`, `updated_at`) VALUES
	(1, 'name', 'a@driver.com', '12', '+62', '$2a$04$Mc1b4rDy3IE/dYj/HAkuHOG4OLmqzPTid6s9qBZQgMRiDAqE0RKBi', '0', 0, 0.0, 0, 0, 0, 230131, 0, 0.000000, 0.000000, 'driver', '', 10000, 0, 1, '2020-07-16 10:59:23', '2020-07-16 10:59:23', '2020-07-16 11:00:07'),
	(5, 'name', 'aa@driver.com', '5555555555555', '+62', '$2a$04$xHI/bBv3F529HllCLUEiI.6AvIh/X6jbPaksGfj.H0TdrJxN0jy0S', '0', 0, 0.0, 0, 0, 0, 799523, 0, 0.000000, 0.000000, 'driver', '', 10000, 0, 0, '2020-07-16 11:04:38', '2020-07-16 11:04:38', '2020-07-16 11:04:38'),
	(8, 'name', 'aaa@driver.com', '555555555555', '+62', '$2a$04$jk1zg6yNlPzy57Tt6OaGQeQdkrg03nIRINUJj2RH.MRT2nrJ7bSgG', 'motor', 0, 0.0, 0, 0, 0, 303094, 0, 0.000000, 0.000000, 'driver', '', 10000, 0, 0, '2020-07-16 11:20:45', '2020-07-16 11:20:45', '2020-07-16 11:20:45'),
	(11, 'name', 'adaa@driver.com', '55555555555', '+62', '$2a$04$B6GUTx4Ye26VK4ExlJYLvePtLa1wEOE5rakzT1CqiMgY4w9ir9vei', 'motor', 0, 0.0, 0, 0, 0, 522913, 0, 0.000000, 0.000000, 'driver', '', 10000, 0, 0, '2020-07-16 11:26:20', '2020-07-16 11:26:20', '2020-07-16 11:26:20');
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.driver_prices
CREATE TABLE IF NOT EXISTS `driver_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_driver` varchar(50) DEFAULT '0',
  `pos_provinsi` varchar(50) DEFAULT '0',
  `pos_kab` varchar(50) DEFAULT '0',
  `pos_kec` varchar(50) DEFAULT '0',
  `pos_lurah_desa` varchar(50) DEFAULT '0',
  `radius_zona_special` varchar(50) DEFAULT '0' COMMENT 'didalam jangkauan  zona khusus radius dari lat long khusus',
  `radius_zona_common` varchar(50) DEFAULT '0' COMMENT 'diluar jangkauan  zona khusus atau radius dari lat long umum',
  `max_zona_order` varchar(50) DEFAULT '0',
  `min_meter` int(11) DEFAULT 0,
  `charge` decimal(7,0) DEFAULT 0 COMMENT 'biaya admin normal',
  `price_cash` decimal(7,0) DEFAULT 0 COMMENT 'harga dasar cash jarak dibawah km looping yg tidak memotong biaya damin',
  `price_deposit` decimal(7,0) DEFAULT 0 COMMENT 'harga dasar payment jarak dibawah km looping yg  memotong biaya adamin',
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
  `gcm` varchar(255) NOT NULL DEFAULT '0',
  `key_server` varchar(255) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.gcms: ~0 rows (approximately)
/*!40000 ALTER TABLE `gcms` DISABLE KEYS */;
INSERT INTO `gcms` (`id`, `gcm`, `key_server`, `created_at`, `updated_at`) VALUES
	(1, 'fL_z8bmBTIs:APA91bFkJR7mI0WkKCnVljDbd3VVLNMyoCG6A0IXYnGF_pRAfJus5hcWakzJcwsno2BgZNI8XJN7tIxYlYGeuBvwf-Qsujk5Mvm7XznDqKR0Z-hctKltIo1iQjGql5CbEVGp1Ao_0m-z', 'AAAAqb3QmLo:APA91bGYHDpiqCE__s7kOJud_mScdRynRzZEGj_usgg6N4yZ1nDY3RNwBWVbxzYSzTxhbixR3zT3h84CbVOO1ISV3RUwMAls42K5iDmS9cyFaTrA1QpNgKKuM2SfRSbzG_R-y8iN4ksk', '2020-07-09 07:42:02', '2020-07-09 07:42:33');
/*!40000 ALTER TABLE `gcms` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.inboxs
CREATE TABLE IF NOT EXISTS `inboxs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `message` text DEFAULT '',
  `tag` text DEFAULT NULL,
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
  `kategory_id` int(11) NOT NULL DEFAULT 0,
  `nm_cook` varchar(255) NOT NULL DEFAULT '',
  `ket_cook` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `hrg` int(10) unsigned NOT NULL DEFAULT 0,
  `laku` bigint(20) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.itemcooks: ~0 rows (approximately)
/*!40000 ALTER TABLE `itemcooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemcooks` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.itemfoods
CREATE TABLE IF NOT EXISTS `itemfoods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resto_id` int(10) unsigned NOT NULL DEFAULT 0,
  `kategory_id` int(11) NOT NULL DEFAULT 0,
  `nm_menu` varchar(255) NOT NULL DEFAULT '',
  `ket_menu` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `hrg` int(10) unsigned NOT NULL DEFAULT 0,
  `laku` bigint(20) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.itemfoods: ~2 rows (approximately)
/*!40000 ALTER TABLE `itemfoods` DISABLE KEYS */;
INSERT INTO `itemfoods` (`id`, `resto_id`, `kategory_id`, `nm_menu`, `ket_menu`, `url_img`, `hrg`, `laku`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, '0', '0', 'http://localhost:8080/img/food/069630103.jpeg', 0, 0, '2020-07-13 14:35:34', '2020-07-13 14:35:34'),
	(2, 1, 1, '0', '0', 'http://localhost:8080/img/food/519743899.jpeg', 0, 0, '2020-07-13 14:36:00', '2020-07-13 14:36:00'),
	(3, 1, 1, '0', '0', 'http://localhost:8080/img/food/937370099.jpeg', 0, 0, '2020-07-13 14:36:57', '2020-07-13 14:36:57');
/*!40000 ALTER TABLE `itemfoods` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.itemshops
CREATE TABLE IF NOT EXISTS `itemshops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(10) unsigned NOT NULL DEFAULT 0,
  `kategory_id` int(11) NOT NULL DEFAULT 0,
  `nm_shop` varchar(255) NOT NULL DEFAULT '',
  `ket_shop` varchar(255) NOT NULL DEFAULT '',
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `hrg` int(10) unsigned NOT NULL DEFAULT 0,
  `laku` bigint(20) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
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
  `title` text DEFAULT NULL,
  `message` text DEFAULT '',
  `tag` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.promotions: ~0 rows (approximately)
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;

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
  `alamat_resto` varchar(255) NOT NULL DEFAULT '',
  `ket_resto` varchar(255) NOT NULL DEFAULT '',
  `min_hrg` int(11) NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `kat_onkir` tinyint(4) NOT NULL DEFAULT 0,
  `posisi_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `posisi_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `buka_senin` time NOT NULL DEFAULT curtime(),
  `tutup_senin` time NOT NULL DEFAULT curtime(),
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.restaurants: ~7 rows (approximately)
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` (`id`, `name`, `email`, `phone_number`, `phone_id`, `password`, `pin_register`, `gcm`, `nm_resto`, `alamat_resto`, `ket_resto`, `min_hrg`, `counter_reputation`, `divide_reputation`, `kat_onkir`, `posisi_lat`, `posisi_long`, `buka_senin`, `tutup_senin`, `url_img`, `status`, `created_at`, `updated_at`) VALUES
	(1, '', '', '', '', '', '', '', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'eeeaaaaaaaaaaaaaaaaaae3', 'eeeaaaaaaaaaaaaaaaaae3', 0, 0.0, 0, 0, 0.000000, 0.000000, '04:00:12', '04:00:12', 'http://localhost:8080/img/resto/903401427.jpeg', 0, '2020-07-13 04:00:12', '2020-07-13 06:53:09'),
	(2, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0, 0.0, 0, 0, 0.000000, 0.000000, '04:10:12', '04:10:12', 'http://localhost:8080/img/resto/467971847.jpeg', 0, '2020-07-13 04:10:12', '2020-07-13 04:10:12'),
	(3, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0, 0.0, 0, 0, 0.000000, 0.000000, '04:10:14', '04:10:14', 'http://localhost:8080/img/resto/195626883.jpeg', 0, '2020-07-13 04:10:14', '2020-07-13 04:10:14'),
	(4, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0, 0.0, 0, 0, 0.000000, 9999.999999, '04:10:33', '04:10:33', 'http://localhost:8080/img/resto/962943031.jpeg', 0, '2020-07-13 04:10:33', '2020-07-13 04:10:33'),
	(5, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0, 0.0, 0, 0, 0.000000, 9999.999999, '04:10:34', '04:10:34', 'http://localhost:8080/img/resto/330350491.jpeg', 0, '2020-07-13 04:10:34', '2020-07-13 04:10:34'),
	(6, '', '', '', '', '', '', '', 'eeee3e', 'eeee3', 'eeee3', 0, 0.0, 0, 0, 0.000000, 9999.999999, '04:17:06', '04:17:06', 'http://localhost:8080/img/resto/907748883.jpeg', 0, '2020-07-13 04:17:06', '2020-07-13 04:17:06'),
	(7, '', '', '', '', '', '', '', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'eeeaaaaaaaaaaaaaaaaaae3', 'eeeaaaaaaaaaaaaaaaaae3', 0, 0.0, 0, 0, 0.000000, 0.000000, '07:29:25', '07:29:25', 'http://localhost:8080/img/resto/120073083.jpeg', 0, '2020-07-13 07:29:25', '2020-07-13 07:29:25');
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
  `alamat_shop` varchar(255) NOT NULL DEFAULT '',
  `ket_shop` varchar(255) NOT NULL DEFAULT '',
  `min_hrg` int(11) NOT NULL DEFAULT 0,
  `counter_reputation` decimal(10,1) NOT NULL DEFAULT 0.0,
  `divide_reputation` int(11) NOT NULL DEFAULT 0,
  `kat_onkir` tinyint(4) NOT NULL DEFAULT 0,
  `posisi_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `posisi_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `buka_senin` time NOT NULL DEFAULT curtime(),
  `tutup_senin` time NOT NULL DEFAULT curtime(),
  `url_img` varchar(255) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.shops: ~0 rows (approximately)
/*!40000 ALTER TABLE `shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `shops` ENABLE KEYS */;

-- Dumping structure for table fullstack_api.topups
CREATE TABLE IF NOT EXISTS `topups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kd_transfer` varchar(50) NOT NULL DEFAULT '',
  `user_kat` varchar(50) NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `bank_id` int(10) unsigned NOT NULL DEFAULT 0,
  `jumlah` int(11) NOT NULL DEFAULT 0,
  `is_bukti` enum('true','false') NOT NULL DEFAULT 'false',
  `verifikasi` enum('true','false') NOT NULL DEFAULT 'false',
  `img_bukti` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Kode Transfer` (`kd_transfer`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.topups: ~3 rows (approximately)
/*!40000 ALTER TABLE `topups` DISABLE KEYS */;
INSERT INTO `topups` (`id`, `kd_transfer`, `user_kat`, `user_id`, `bank_id`, `jumlah`, `is_bukti`, `verifikasi`, `img_bukti`, `created_at`, `updated_at`) VALUES
	(1, 'FE78143508975', 'customers', 1, 1, 21000, 'true', 'false', 'upload/topup/018FA3105479A9A8-772483107.jpeg', '2020-07-14 10:05:01', '2020-07-14 10:29:25'),
	(2, '865E670697123', '0', 1, 1, 21000, 'true', 'false', 'upload/topup/3D0BDFBA8268D9FF-135223287.jpeg', '2020-07-14 10:07:24', '2020-07-14 10:50:30'),
	(3, 'BDE6543434247', 'customers', 1, 1, 21000, 'true', 'false', 'upload/topup/257E53089DC504EF-677695007.jpeg', '2020-07-14 14:41:05', '2020-07-14 14:48:56');
/*!40000 ALTER TABLE `topups` ENABLE KEYS */;

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

-- Dumping structure for table fullstack_api.tran_foods
CREATE TABLE IF NOT EXISTS `tran_foods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `kd_transaksi` varchar(50) NOT NULL DEFAULT '',
  `category_driver` varchar(50) NOT NULL DEFAULT '',
  `pay_category` varchar(50) NOT NULL DEFAULT '',
  `charge` int(11) NOT NULL DEFAULT 0,
  `point_transaction` int(11) NOT NULL DEFAULT 0,
  `status_driver` tinyint(4) NOT NULL DEFAULT 0,
  `total_prices` int(11) NOT NULL DEFAULT 0,
  `driver_id` int(11) NOT NULL DEFAULT 0,
  `duration_value` int(11) NOT NULL DEFAULT 0,
  `distance_value` int(11) NOT NULL DEFAULT 0,
  `status_order` int(11) NOT NULL DEFAULT 0,
  `jemput_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `jemput_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `tujuan_lat` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `tujuan_long` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `tujuan_alamat` varchar(50) NOT NULL DEFAULT '',
  `tujuan_judul` varchar(50) NOT NULL DEFAULT '',
  `distance_text` varchar(50) NOT NULL DEFAULT '',
  `duration_text` varchar(50) NOT NULL DEFAULT '',
  `jemput_alamat` varchar(50) NOT NULL DEFAULT '',
  `jemput_judul` varchar(50) NOT NULL DEFAULT '',
  `jemput_ket` varchar(50) NOT NULL DEFAULT '',
  `polyline` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT current_timestamp(),
  `accept_at` datetime DEFAULT current_timestamp(),
  `finish_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 2` (`kd_transaksi`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table fullstack_api.tran_ojeks: ~2 rows (approximately)
/*!40000 ALTER TABLE `tran_ojeks` DISABLE KEYS */;
INSERT INTO `tran_ojeks` (`id`, `user_id`, `kd_transaksi`, `category_driver`, `pay_category`, `charge`, `point_transaction`, `status_driver`, `total_prices`, `driver_id`, `duration_value`, `distance_value`, `status_order`, `jemput_lat`, `jemput_long`, `tujuan_lat`, `tujuan_long`, `tujuan_alamat`, `tujuan_judul`, `distance_text`, `duration_text`, `jemput_alamat`, `jemput_judul`, `jemput_ket`, `polyline`, `created_at`, `accept_at`, `finish_at`, `updated_at`) VALUES
	(1, 1, '0F82198548847', 'motor', 'tunai', 1, 1, 0, 4000, 1, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 00:40:16', '2020-07-16 00:40:16', '2020-07-16 00:40:16', '2020-07-16 00:40:16'),
	(2, 1, '2D11203530015', 'motor', 'tunai', 1, 1, 0, 4000, 0, 1, 1, 0, -3.464214, 119.140585, -3.481263, 119.141014, '1', '1', '1', '1', '1', '1', '1', '1', '2020-07-16 00:45:07', '2020-07-16 00:45:07', '2020-07-16 00:45:07', '2020-07-16 00:45:07');
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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
