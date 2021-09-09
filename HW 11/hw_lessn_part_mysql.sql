-- Практическое задание по теме “Оптимизация запросов”
-- Задание 1
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	`id` SERIAL,
    `table_name` VARCHAR(55),
    `id_identifier` VARCHAR(55),
    `name_content` VARCHAR(55),
    `created_at` DATETIME
    )ENGINE=Archive;
    
-- Error Code: 1069. Too many keys specified; max 1 keys allowed
    
    
DELIMITER //

DROP TRIGGER IF EXISTS logs_insert_users//
CREATE TRIGGER logs_insert_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_identifier, name_content, created_at) VALUES ('users', NEW.id, NEW.name, NOW()); 
END//

DROP TRIGGER IF EXISTS logs_insert_catalogs//
CREATE TRIGGER logs_insert_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_identifier, name_content, created_at) VALUES ('catalogs', NEW.id, NEW.name, NOW()); 
END//

DROP TRIGGER IF EXISTS logs_insert_products//
CREATE TRIGGER logs_insert_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_identifier, name_content, created_at) VALUES ('products', NEW.id, NEW.name, NOW()); 
END//

INSERT INTO users (`name`, `birthday_at`) VALUES ('Sedrgey', '1999-01-01')//
INSERT INTO catalogs (`name`) VALUES ('Интерфейс')//
INSERT INTO products (`name`) VALUES ('Мышь')//

-- SHOW TRIGGERS//
-- DROP TRIGGER logs_insert//

SELECT * FROM users//
SELECT * FROM catalogs//
SELECT * FROM products//
SELECT * FROM logs //

-- Задание 2
-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS spam//
CREATE PROCEDURE spam(n INT)
BEGIN
  DECLARE i INT DEFAULT 1;

  WHILE i <= n DO
    INSERT INTO users (`name`) VALUES (CONCAT('name', i, 'a')), (CONCAT('name', i,'b')),(CONCAT('name', i,'c')),(CONCAT('name', i,'d')),(CONCAT('name', i,'e')),(CONCAT('name', i,'f')),(CONCAT('name', i,'g')),(CONCAT('name', i,'h')),(CONCAT('name', i,'j')),(CONCAT('name', i,'k'));
    SET i = i + 1;
  END WHILE;
END//

CALL spam(1000)//
SELECT * FROM users//
-- DELETE FROM users WHERE id >100//