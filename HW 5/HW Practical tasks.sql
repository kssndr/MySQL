DROP DATABASE IF EXISTS hw5_1;
CREATE DATABASE hw5_1;
USE hw5_1;

-- ЗАДАНИЕ
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    birthday_at DATE,
    created_at DATETIME,
    updated_at DATETIME);
    
INSERT INTO users (firstname, lastname, birthday_at, updated_at) VALUES ('Eva', 'First', '2000-01-01', '2000-01-01');
INSERT INTO `users` (firstname, lastname, birthday_at,created_at,updated_at) VALUES ('Daphney','Maggio','1985-03-23',NULL,NULL),('Angelina','Conn','1973-11-19',NULL,NULL),('Allene','Baumbach','1994-03-13',NULL,NULL),('Janice','Wintheiser','1978-05-11',NULL,NULL),('Adrianna','Cruickshank','2001-06-06',NULL,NULL),('Donavon','Williamson','1970-11-25',NULL,NULL),('Elisabeth','Monahan','1984-02-27',NULL,NULL),('Kari','Smitham','1990-10-09',NULL,NULL),('Rory','Johns','2004-04-18',NULL,NULL),('Anabelle','Ruecker','2012-09-05',NULL,NULL),('Ayla','Olson','2000-05-16',NULL,NULL),('Madge','Fay','2018-02-26',NULL,NULL),('Jaleel','Heathcote','2002-12-19',NULL,NULL),('Bill','Stokes','2019-12-01',NULL,NULL),('Raven','Yundt','2010-12-10',NULL,NULL),('Billie','Ziemann','2005-12-20',NULL,NULL),('Tre','Waters','2016-11-20',NULL,NULL),('Aisha','Ratke','1989-02-02',NULL,NULL),('Monte','Swaniawski','1979-05-18',NULL,NULL),('Francesca','O\'Connell','2014-03-05',NULL,NULL),('Willa','Runolfsdottir','1986-07-01',NULL,NULL),('Theresa','Jacobi','2013-05-29',NULL,NULL),('Ryann','Greenholt','2008-08-31',NULL,NULL),('Maximilian','Treutel','1985-12-25',NULL,NULL),('Santiago','Klocko','2012-10-16',NULL,NULL),('Justyn','Ward','1997-03-15',NULL,NULL),('Winifred','Macejkovic','1984-12-30',NULL,NULL),('Mauricio','Kessler','2008-02-24',NULL,NULL),('Waino','Brown','1973-12-31',NULL,NULL),('Dawn','Stanton','2019-03-08',NULL,NULL),('Aletha','Klocko','2006-04-08',NULL,NULL),('Katelynn','Wolff','1986-04-21',NULL,NULL),('Alvina','Bins','1996-12-17',NULL,NULL),('Ava','Reinger','2020-03-14',NULL,NULL),('Audie','Medhurst','1970-11-18',NULL,NULL),('Kareem','Hayes','1970-01-14',NULL,NULL),('Mckayla','Leffler','1985-03-04',NULL,NULL),('Gonzalo','Schneider','1974-09-14',NULL,NULL),('Solon','Grimes','1980-09-13',NULL,NULL),('Leora','Crooks','1975-12-18',NULL,NULL),('Robbie','Bogan','1974-05-25',NULL,NULL),('Sven','Cummerata','2008-10-10',NULL,NULL),('Suzanne','Moore','1985-01-08',NULL,NULL),('Lempi','Corwin','2005-03-20',NULL,NULL),('Enos','Reinger','1982-09-18',NULL,NULL),('Skyla','VonRueden','1988-12-26',NULL,NULL),('Monte','Pfeffer','2016-07-07',NULL,NULL),('Jamal','Mitchell','2018-11-12',NULL,NULL),('Alexandra','Cassin','2002-12-11',NULL,NULL);
SELECT * FROM users;
SELECT id FROM users WHERE created_at IS NULL OR updated_at IS NULL;
-- пишем отдельно для каждого столба обновления потому что в одной строчке есть данные по update_at
UPDATE users SET created_at = CURRENT_TIMESTAMP() WHERE created_at IS NULL LIMIT 51;
UPDATE users SET updated_at = CURRENT_TIMESTAMP() WHERE updated_at IS NULL LIMIT 51; 

SELECT * FROM users;

-- ЗАДАНИЕ
-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

DESCRIBE users;
ALTER TABLE users CHANGE created_at created_at VARCHAR(19), CHANGE updated_at updated_at VARCHAR(19);
UPDATE users SET created_at = CONVERT(DATE_FORMAT(created_at,'%Y-%m-%d %H:%i'), CHAR) LIMIT 100;
UPDATE users SET updated_at = CONVERT(DATE_FORMAT(updated_at,'%Y-%m-%d %H:%i'), CHAR) LIMIT 100;
DESCRIBE users;
SELECT * FROM users;

ALTER TABLE users CHANGE created_at created_at DATETIME, CHANGE updated_at updated_at DATETIME;
DESCRIBE users;
SELECT * FROM users;

-- ЗАДАНИЕ 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT UNSIGNED DEFAULT NULL ,
    product_id INT UNSIGNED DEFAULT NULL,
    stock INT UNSIGNED DEFAULT NULL,
    created_at DATETIME,
    updated_at DATETIME);

INSERT INTO `storehouses_products` VALUES (1,2,17,0,'1997-11-10 12:44:36','2018-06-23 07:46:41'),(2,1,14,17,'2009-01-18 14:18:58','1988-09-14 06:42:21'),(3,1,17,11,'1981-08-07 11:28:01','1992-09-25 06:10:09'),(4,1,14,8,'2008-09-06 14:36:27','1990-08-02 11:37:56'),(5,2,2,15,'1980-02-29 00:40:25','1982-01-17 05:25:51'),(6,2,2,20,'2010-01-30 10:40:11','2000-11-15 19:34:33'),(7,1,8,18,'1998-01-05 14:05:42','1973-02-10 11:26:24'),(8,2,11,8,'2018-02-27 14:12:33','1981-08-24 07:48:59'),(9,2,2,8,'1972-06-05 05:35:01','1971-07-06 15:10:07'),(10,3,10,4,'1971-06-19 19:47:56','1982-04-08 18:34:40'),(11,3,2,2,'1980-12-17 16:58:05','1997-02-03 02:38:51'),(12,1,1,19,'1972-07-23 09:23:49','2009-09-26 16:31:58'),(13,1,8,11,'1975-01-29 13:49:29','1989-01-03 10:40:42'),(14,1,8,0,'1993-03-27 07:04:53','2021-07-05 02:32:35'),(15,3,14,0,'1989-05-13 22:48:56','2002-08-31 21:04:31'),(16,1,7,0,'2015-06-10 17:30:47','2005-05-25 15:19:11'),(17,1,16,8,'1980-06-20 08:58:11','2013-05-01 13:35:32'),(18,1,15,6,'1970-10-24 21:26:12','1993-06-06 19:40:13'),(19,3,19,17,'2018-11-23 06:42:14','2014-12-30 02:06:52'),(20,3,15,16,'2019-11-15 09:17:12','1990-02-09 14:17:00'),(21,3,3,1,'1982-05-12 11:51:51','1971-11-23 19:45:20'),(22,1,9,14,'1980-11-26 03:14:14','1984-06-26 07:05:09'),(23,3,3,20,'2014-05-02 15:58:23','1989-10-02 09:38:51'),(24,2,7,13,'1990-02-11 18:23:21','1977-03-09 19:27:16'),(25,3,1,20,'1987-07-22 19:02:14','1984-06-29 00:22:02'),(26,3,11,15,'1997-12-03 03:01:25','1994-05-05 05:50:25'),(27,1,13,10,'1973-09-08 12:53:23','2012-05-12 10:49:55'),(28,1,9,17,'1973-09-09 06:08:21','1978-05-27 11:40:42'),(29,1,12,17,'2007-02-22 18:06:06','1997-02-08 20:09:19'),(30,1,5,0,'2002-01-05 19:39:42','2018-06-14 10:52:45'),(31,1,10,1,'2008-01-24 22:10:06','1991-01-11 19:47:29'),(32,2,5,0,'1984-11-21 02:14:21','1986-07-12 17:52:10'),(33,3,3,13,'2016-07-21 04:51:46','2007-09-07 01:25:44'),(34,3,7,5,'1991-01-01 21:15:40','2015-12-19 20:20:48'),(35,3,7,15,'1983-10-12 08:49:31','2020-07-28 21:39:49'),(36,3,3,19,'2006-11-09 05:33:37','1986-12-06 17:24:25'),(37,3,20,11,'2009-02-18 03:17:21','2005-01-21 18:28:26'),(38,1,1,5,'1995-12-04 20:00:36','2015-03-08 08:33:12'),(39,1,14,4,'1975-05-01 18:36:29','2017-07-21 14:40:41'),(40,2,18,0,'2001-09-17 20:57:42','1997-01-03 07:56:41'),(41,1,15,3,'2012-12-25 07:43:26','1984-05-19 13:46:40'),(42,1,6,1,'2003-01-12 18:06:19','1972-06-10 18:42:43'),(43,3,1,12,'2010-12-08 21:23:18','2010-02-16 23:27:25'),(44,1,6,6,'1996-01-22 10:27:48','1982-04-27 07:02:20'),(45,1,15,2,'1980-09-18 19:55:04','1994-02-17 22:31:11'),(46,3,4,7,'2017-09-18 12:06:04','2004-05-13 02:01:14'),(47,2,15,5,'2015-12-10 03:18:41','1999-04-28 21:53:24'),(48,2,14,11,'1970-04-20 20:59:21','1973-02-25 03:15:28'),(49,1,6,3,'2011-02-20 03:59:39','2016-08-11 18:48:05'),(50,1,20,11,'2001-09-12 12:26:55','2010-04-30 06:44:11'),(51,1,15,7,'2013-03-10 00:08:42','1978-06-26 14:51:24'),(52,1,4,18,'1988-12-04 23:39:37','1991-12-12 03:07:11'),(53,3,19,9,'1994-02-12 22:05:54','1981-12-04 15:26:54'),(54,1,1,6,'1971-08-14 04:37:24','2020-08-10 07:29:53'),(55,2,15,11,'2019-06-07 20:23:37','1994-03-21 12:35:17'),(56,2,14,1,'2005-09-14 19:47:28','2001-03-07 21:20:27'),(57,1,17,7,'1970-08-16 19:57:56','2007-09-30 13:55:18'),(58,2,10,13,'1973-11-09 02:46:21','1990-12-07 19:30:05'),(59,1,7,1,'2010-04-12 08:24:07','2007-03-28 02:44:15'),(60,1,5,8,'1977-07-20 02:45:40','2020-04-15 03:31:01'),(61,3,10,16,'1984-01-26 00:56:37','1998-02-14 21:25:37'),(62,1,10,3,'1992-12-13 21:59:31','1971-04-28 08:39:12'),(63,2,5,14,'1977-12-18 06:04:06','1986-09-24 19:00:59'),(64,1,5,7,'2016-06-06 09:15:54','1978-07-28 04:29:33'),(65,3,15,10,'1973-09-16 16:08:05','1997-09-24 20:57:44'),(66,3,1,12,'1984-11-30 02:35:37','2007-10-29 06:16:13'),(67,1,17,20,'1971-09-10 21:45:57','1978-10-04 12:41:08'),(68,2,6,19,'1976-09-29 06:47:30','1971-09-07 14:11:24'),(69,2,12,0,'2008-12-14 01:10:08','2019-11-22 16:17:06'),(70,3,14,7,'1982-01-27 23:32:07','1996-09-11 14:28:27'),(71,3,14,20,'1995-04-10 07:05:28','1976-11-10 15:00:29'),(72,3,15,6,'2000-02-04 05:12:15','2006-12-14 06:24:13'),(73,2,11,15,'1974-10-19 22:50:57','1982-07-19 09:15:08'),(74,3,16,10,'2017-10-19 00:31:16','1982-08-07 13:30:32'),(75,1,11,16,'2005-02-14 04:51:08','2018-11-15 08:49:06'),(76,3,10,7,'2000-06-19 22:26:09','1985-11-06 17:04:51'),(77,2,20,20,'1980-07-23 06:39:17','2019-07-25 10:03:00'),(78,3,20,15,'1981-08-26 02:08:43','2001-04-13 08:43:01'),(79,2,20,11,'2019-04-06 12:51:10','1984-02-07 12:42:45'),(80,3,15,0,'1984-04-02 06:37:45','2006-12-29 15:47:16'),(81,1,15,1,'1982-02-03 08:55:41','1980-10-23 09:02:05'),(82,2,18,17,'1995-06-26 09:39:48','1994-05-03 22:58:09'),(83,1,10,19,'2008-07-10 20:07:07','1984-08-07 10:00:38'),(84,2,10,13,'2018-11-20 07:20:25','2020-08-23 19:59:11'),(85,1,9,5,'1993-03-12 11:31:51','2014-11-21 21:03:13'),(86,3,14,3,'2005-09-08 23:26:54','1975-04-02 14:22:09'),(87,1,16,0,'1979-06-13 03:33:08','1999-08-17 21:54:17'),(88,3,8,0,'1990-07-14 11:38:27','1985-08-17 12:54:39'),(89,2,7,3,'1977-03-10 20:06:19','1991-03-04 00:34:30'),(90,2,6,7,'1985-01-18 22:14:14','1973-09-12 13:27:59'),(91,2,16,6,'1991-03-29 08:22:36','2003-07-03 16:52:07'),(92,1,18,14,'1994-03-24 20:06:10','1984-02-22 17:21:30'),(93,3,16,8,'2016-08-08 18:09:32','1978-07-23 00:53:47'),(94,3,10,4,'2009-05-22 19:41:04','1992-01-03 03:36:18'),(95,2,12,8,'2004-12-27 13:23:58','2014-03-18 05:03:24'),(96,3,16,5,'2016-02-17 20:00:06','2005-03-11 22:41:22'),(97,1,2,1,'1972-06-27 11:57:48','2017-01-04 22:49:51'),(98,1,19,0,'1981-01-10 03:25:43','2019-02-07 19:58:46'),(99,2,4,4,'2006-12-06 22:32:25','2012-08-25 16:10:27'),(100,2,4,0,'1992-04-19 00:17:16','1996-08-05 12:51:55');

SELECT storehouse_id, stock, product_id FROM storehouses_products ORDER BY storehouse_id, IF(stock > 0,0,1), stock LIMIT 1000;


-- ЗАДАНИЕ 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)
    
ALTER TABLE users ADD month VARCHAR(20) AFTER birthday_at;
DESCRIBE users;
UPDATE users SET month = (
	SELECT 
		CASE 
			WHEN DATE_FORMAT(birthday_at, '%m')=01 THEN 'january'
            WHEN DATE_FORMAT(birthday_at, '%m')=02 THEN 'febrary'
            WHEN DATE_FORMAT(birthday_at, '%m')=03 THEN 'march'
            WHEN DATE_FORMAT(birthday_at, '%m')=04 THEN 'april'
            WHEN DATE_FORMAT(birthday_at, '%m')=05 THEN 'may'
            WHEN DATE_FORMAT(birthday_at, '%m')=06 THEN 'june'
            WHEN DATE_FORMAT(birthday_at, '%m')=07 THEN 'july'
            WHEN DATE_FORMAT(birthday_at, '%m')=08 THEN 'august'
            WHEN DATE_FORMAT(birthday_at, '%m')=09 THEN 'september'
            WHEN DATE_FORMAT(birthday_at, '%m')=10 THEN 'october'
            WHEN DATE_FORMAT(birthday_at, '%m')=11 THEN 'november'
            ELSE 'december'
		END
	) LIMIT 1000;


SELECT * FROM users WHERE month = 'may' OR month = 'august';

-- ЗАДАНИЕ 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL PRIMARY KEY,
    name VARCHAR (50) UNIQUE);

INSERT INTO `catalogs` VALUES (6,'a'),(29,'accusamus'),(68,'accusantium'),(49,'ad'),(65,'adipisci'),(58,'aliquam'),(69,'aliquid'),(4,'animi'),(33,'aperiam'),(55,'architecto'),(27,'aspernatur'),(92,'assumenda'),(74,'at'),(66,'atque'),(48,'aut'),(42,'autem'),(2,'commodi'),(53,'consectetur'),(15,'consequatur'),(23,'consequuntur'),(63,'delectus'),(44,'dicta'),(88,'dolor'),(11,'dolorem'),(21,'doloremque'),(82,'dolores'),(70,'doloribus'),(99,'dolorum'),(97,'ducimus'),(100,'ea'),(84,'enim'),(39,'eos'),(52,'error'),(13,'est'),(37,'et'),(76,'eveniet'),(54,'exercitationem'),(32,'fugiat'),(77,'fugit'),(81,'impedit'),(19,'inventore'),(47,'ipsa'),(51,'ipsam'),(62,'ipsum'),(1,'iste'),(46,'iure'),(34,'iusto'),(86,'laboriosam'),(89,'laborum'),(17,'laudantium'),(57,'libero'),(41,'maiores'),(60,'maxime'),(71,'modi'),(10,'molestiae'),(20,'molestias'),(72,'mollitia'),(14,'neque'),(83,'nesciunt'),(8,'non'),(95,'nostrum'),(87,'numquam'),(50,'odio'),(79,'odit'),(90,'officia'),(25,'omnis'),(36,'perspiciatis'),(56,'porro'),(3,'quas'),(26,'qui'),(18,'quia'),(73,'quidem'),(28,'quis'),(96,'quo'),(59,'quod'),(67,'quos'),(31,'reiciendis'),(75,'rem'),(98,'repellat'),(7,'reprehenderit'),(9,'repudiandae'),(64,'rerum'),(22,'saepe'),(12,'sed'),(35,'sint'),(16,'sit'),(43,'soluta'),(80,'sunt'),(61,'tempore'),(85,'temporibus'),(24,'tenetur'),(93,'unde'),(45,'ut'),(91,'vel'),(78,'veritatis'),(94,'vero'),(38,'voluptas'),(30,'voluptate'),(5,'voluptatem'),(40,'voluptates');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD (id, 5, 1, 2);


-- **********************************************
-- Практическое задание теме «Агрегация данных»
-- ЗАДАНИЕ 1
-- Подсчитайте средний возраст пользователей в таблице users.

SELECT (TO_DAYS(birthday_at)) FROM users;
SELECT TIMESTAMPDIFF(YEAR,birthday_at,NOW()) FROM users;
SELECT SUM(TIMESTAMPDIFF(YEAR,birthday_at,NOW()))/COUNT(id) AS average_age FROM users;

-- ЗАДАНИЕ 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DATE_FORMAT(CONCAT(YEAR(NOW()),DATE_FORMAT(birthday_at, '-%m-%d')), '%w') AS `weekday` , COUNT(*) AS Birthday_per_WeekDay_Current_Year FROM users GROUP BY `weekday` ORDER BY FIELD (`weekday`, 1,2,3,4,5,6,0);


-- ЗАДАНИЕ 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы.

SELECT EXP(SUM(LN(stock))) FROM storehouses_products;


