DROP DATABASE IF EXISTS my_library;
CREATE DATABASE my_library;
USE my_library;

DROP TABLE IF EXISTS catalog;
CREATE TABLE catalog (
	id SERIAL PRIMARY KEY,
    type_of_content VARCHAR(50) UNIQUE);

DROP TABLE IF EXISTS content;
CREATE TABLE content (
id SERIAL PRIMARY KEY,
type_id INT UNSIGNED,
name VARCHAR(255) UNIQUE,
description BLOB,
owner_id INT UNSIGNED,
path VARCHAR(255),
added_at DATETIME DEFAULT CURRENT_TIMESTAMP);

DROP TABLE IF EXISTS owner;
CREATE TABLE owner (
	id SERIAL PRIMARY KEY,
    nickname VARCHAR(50));
    
DROP TABLE IF EXISTS key_words_base;
CREATE TABLE key_words_base (
	id SERIAL PRIMARY KEY,
    key_word VARCHAR(50) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
    
DROP TABLE IF EXISTS content_key_words;
CREATE TABLE content_key_words (
	content_id INT UNSIGNED,
    key_words_id INT UNSIGNED);

