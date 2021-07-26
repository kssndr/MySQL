DROP DATABASE shop;
CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS catalogs;
CREATE TABLE IF NOT EXISTS catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)  UNIQUE COMMENT 'Название раздела')
COMMENT = 'Разделы интернет магазина';

DESCRIBE catalogs;
INSERT IGNORE INTO catalogs VALUES
	(DEFAULT, 'Процессоры'),
    (DEFAULT, 'Мат. платы'),
    (DEFAULT, 'Видеокарты');
    
SELECT * FROM catalogs;

INSERT IGNORE INTO catalogs VALUES
	(DEFAULT, NULL),
    (DEFAULT, NULL),
    (DEFAULT, NULL);
    
SELECT * FROM catalogs;

UPDATE catalogs SET name = 'empty'
WHERE name IS NULL LIMIT 1000;

SELECT * FROM catalogs;

/* Пусть в таблице catalogs базы данных shop в строке name могут находиться пустые строки и поля принимающие значение NULL. 
Напишите запрос, который заменяет все такие поля на строку ‘empty’. Помните, что на уроке мы установили уникальность на поле name. 
Возможно ли оставить это условие? Почему?
ОТВЕТ:
тип NULL - неизвестное значение и не противоречит требовнию уникальности, а 'empty' всегда 'empty' и поэтому будет возможно изменить 
только одно значение в этом столбце/поле, а запрос на переменование всех - не выполниться

 */


DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'День рождения',
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название',
    description TEXT COMMENT 'Описание',
    price DECIMAL(11,2) COMMENT 'Цена',
    catalog_id INT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_catalog_id(catalog_id)
) COMMENT = 'Таварные позиции';

DESCRIBE products;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DESCRIBE orders;

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
    id SERIAL PRIMARY KEY,
    order_id INT UNSIGNED,
    product_id INT UNSIGNED,
    total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных групп',
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
    id SERIAL PRIMARY KEY,
    user_id INT UNSIGNED,
    product_id INT UNSIGNED,
    descount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.1 до 1.0',
    finished_at DATETIME NULL,
    started_at DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_user_id(user_id),
    KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DESCRIBE discounts;

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
    id SERIAL PRIMARY KEY,
    storehouse_id INT UNSIGNED,
    product_id INT UNSIGNED,
    value INT UNSIGNED COMMENT 'Запас товарной позиции на склада',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

SELECT * FROM catalogs;
-- INSERT INTO catalogs VALUES (1,'sds');
TRUNCATE catalogs;
DESCRIBE catalogs;
INSERT INTO catalogs VALUES 
	(DEFAULT, 'Процессоры'),
	(DEFAULT, 'Мат. платы'),
	(DEFAULT, 'Видеокарты');
SELECT * FROM catalogs;


