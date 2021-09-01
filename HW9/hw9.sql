-- Практическое задание по теме “Транзакции, переменные, представления”
-- ЗАДАНИЕ 1
-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

-- SELECT * FROM shop.users;
-- SELECT * FROM sample.users;
START TRANSACTION;
-- SELECT id, name FROM shop.users WHERE id = 1;
INSERT INTO sample.users SELECT id, name FROM shop.users WHERE id = 1;
COMMIT;

-- ЗАДАНИЕ 2
-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

-- SELECT * FROM products;
-- SELECT * FROM catalogs;
-- SELECT p.name AS product_name, c.name AS catalog_name FROM products p JOIN catalogs c ON p.catalog_id = c.id;
CREATE VIEW np AS SELECT  p.id, p.name AS product_name, c.id AS catalog_id, c.name AS catalog_name FROM products p JOIN catalogs c ON p.catalog_id = c.id;
SELECT product_name,catalog_name FROM np;


-- ЗАДАНИЕ 3
-- (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS test_cal;
CREATE TABLE test_cal (
	`created_at` DATE);
    
INSERT INTO test_cal VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

SELECT * FROM test_cal;

-- SHOW TABLES;
-- SELECT * FROM orders;

CREATE VIEW aug AS SELECT '2018-08-01' + INTERVAL (id - 1) DAY AS days FROM orders WHERE id BETWEEN 1 AND 31;
SELECT * FROM aug;

SELECT a.days, IF(a.days = t.created_at, 1,0) AS flag FROM aug a LEFT JOIN test_cal t ON a.days = t.created_at;

-- DROP VIEW aug;

-- ЗАДАНИЕ 4
-- (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS test_logs;
CREATE TABLE test_logs (
	id SERIAL,
    created_at DATE);
    
INSERT INTO test_logs (created_at)
	SELECT * FROM aug;

-- SELECT * FROM test_logs;

-- SELECT id FROM test_logs ORDER BY created_at DESC LIMIT 5;
-- DELETE FROM test_logs WHERE id IN (SELECT * FROM (SELECT id FROM test_logs ORDER BY created_at DESC LIMIT 5)sub);

PREPARE fresh FROM 'DELETE FROM test_logs WHERE id IN (SELECT * FROM (SELECT id FROM test_logs ORDER BY created_at DESC LIMIT 5)sub)';

EXECUTE fresh;

-- Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)
-- ЗАДАНИЕ 1
-- Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

SELECT Host, User FROM mysql.user;
SHOW GRANTS FOR shop_read;

CREATE USER 'shop_read'@'%' IDENTIFIED BY 'pass';
GRANT SELECT ON shop.* TO shop_read;
SHOW GRANTS FOR shop_read;

CREATE USER 'shop'@'%' IDENTIFIED BY 'pass';
GRANT ALL ON shop.* TO shop;
SHOW GRANTS FOR shop;

-- ЗАДАНИЕ 2
-- (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

USE shop;
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
	id SERIAL,
    name VARCHAR (55),
    password VARCHAR(32)
    );

INSERT INTO accounts (name, password) VALUES ('Sddkj','ddskdjs'),('Okds','fvjfvs'),('Mdds','jccwee'),('Qvs','KDJKDJ');

CREATE VIEW username (id, name) AS SELECT id, name FROM accounts;

CREATE USER 'user_read'@'%' IDENTIFIED BY 'pass';
GRANT SELECT (id,name) ON shop.username TO user_read;


-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- ЗАДАНИЕ 1
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE hi TEXT;
    
    IF CURTIME() BETWEEN '6:00:00' AND '11:59:99' THEN 
		SET hi = 'Доброе утро';
	elseif
		CURTIME() BETWEEN '12:00:00' AND '17:59:99' THEN
		SET hi = 'Добрый день';
	elseif
		CURTIME() BETWEEN '18:00:00' AND '23:59:99' THEN
		SET hi = 'Добрый вечер';
	ELSE
		SET hi = 'Доброй ночи';
	END IF;
    RETURN hi;
END//

SELECT hello()//
	

-- ЗАДАНИЕ 2
-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

SELECT * FROM products//

SHOW TRIGGERS//

DROP TRIGGER IF EXISTS check_fields_insert//
CREATE TRIGGER check_fields_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
	IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN
    SIGNAL SQLSTATE '88888' SET MESSAGE_TEXT = 'INSERT - canseled - FILL FIELDS NAME, DESCRIPTION';
    END IF;
END//

DROP TRIGGER IF EXISTS check_fields_update//
CREATE TRIGGER check_fields_update BEFORE UPDATE ON products
FOR EACH ROW 
BEGIN
	IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN
    SIGNAL SQLSTATE '88888' SET MESSAGE_TEXT = 'INSERT - canseled - FILL FIELDS NAME, DESCRIPTION';
    END IF;
END//

INSERT INTO products (description,price,catalog_id) VALUES ('Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 11111,1)//

UPDATE products SET description = NULL, name = NULL WHERE id = 7//
UPDATE products SET name = NULL WHERE id = 8//

SELECT * FROM products//


-- ЗАДАНИЕ 3
-- (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION IF EXISTs fibonacci//
CREATE FUNCTION fibonacci(n INT)
RETURNS BIGINT DETERMINISTIC
BEGIN
	DECLARE fib, fibm, a DOUBLE;
    SET fib = (1+SQRT(5))/2;
    SET fibm = (1-SQRT(5))/2;
    SET a = (POW(fib, n) + POW(fibm, n))/SQRT(5);
	RETURN a;
END//

SELECT fibonacci(10)//