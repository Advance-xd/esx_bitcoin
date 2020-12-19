-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                5.7.29-log - MySQL Community Server (GPL)
-- Server-OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumpar databasstruktur för fivem
CREATE DATABASE IF NOT EXISTS `fivem` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fivem`;

-- Dumpar struktur för tabell fivem.bitcoin
CREATE TABLE IF NOT EXISTS `bitcoin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `bitcoins` float NOT NULL DEFAULT '0',
  `graphics` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumpar data för tabell fivem.bitcoin: ~1 rows (ungefär)
/*!40000 ALTER TABLE `bitcoin` DISABLE KEYS */;
INSERT INTO `bitcoin` (`id`, `identifier`, `bitcoins`, `graphics`) VALUES
	(1, '1998-01-01-3011', 8.93695, 1);
/*!40000 ALTER TABLE `bitcoin` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
