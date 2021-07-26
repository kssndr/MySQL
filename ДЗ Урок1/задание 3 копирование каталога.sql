USE example;
DROP TABLE IF EXISTS cat;
CREATE TABLE cat (
	id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE);

SELECT * FROM cat;
INSERT INTO cat VALUES 
	(DEFAULT, 'dd'),
    (DEFAULT, 'fff');
SELECT * FROM cat;
UPDATE example.cat SET example.cat.name = (SELECT shop.catalogs.name FROM shop.catalogs WHERE shop.catalogs.id = example.cat.id) LIMIT 1000;
INSERT IGNORE INTO example.cat SELECT * FROM shop.catalogs;

-- Error Code: 1054. Unknown column 'catalogs.id' in 'where clause'


SELECT * FROM cat;
