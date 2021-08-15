SELECT * FROM `profile` LIMIT 100;
SELECT * FROM `profile` WHERE user_id = 1;
SELECT user_id, firstname, lastname FROM `profile` WHERE user_id = 1;


SELECT user_id, firstname, lastname
FROM `profile` WHERE firstname LIKE '%a%';

SELECT user_id, firstname, lastname
FROM `profile` WHERE firstname NOT LIKE '%a%';

SELECT user_id, firstname, lastname
FROM `profile` WHERE firstname LIKE '%a%' AND lastname LIKE '%a%';


SELECT * FROM `profile` 
WHERE birthday > '2010-01-01' AND birthday <= '2019-12-31';

SELECT * FROM `profile` 
WHERE birthday BETWEEN '2010-01-01' AND '2019-12-31';

SELECT * FROM `profile` WHERE gender IN ('m','f');
SELECT * FROM `profile` WHERE user_id IN (2,12,35);
SELECT * FROM `profile` WHERE user_id NOT IN (2,12,35);

SELECT DISTINCT gender FROM `profile`;

SELECT * FROM `profile` ORDER BY firstname;
SELECT * FROM `profile` ORDER BY firstname DESC;
SELECT * FROM `profile` ORDER BY firstname DESC, lastname;

SELECT * FROM post LIMIT 5;
SELECT * FROM post LIMIT 10, 5;
SELECT * FROM post LIMIT 5 OFFSET 10;

SELECT USER(); -- текущий пользователь MySQL
SELECT VERSION(); -- версия MySQL
SELECT UUID();

SELECT
  ROUND(), -- математическое округление, если значение >= .5, то увеличит +1
  CEILING(), -- в большую степень
  FLOOR(); -- в меньшую степень

SELECT
  TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM `profile`
ORDER BY age;

SELECT 
  DAYNAME(CONCAT(YEAR(NOW()), RIGHT(birthday, 6)))
FROM `profile`
ORDER BY birthday DESC;

SELECT
  gender,
  IF(gender = 'm', 'Мужской', 'Женский')
FROM `profile`;

SELECT
  IFNULL(media_id, ''), 
  IF(media_id IS NULL, '-', address)
FROM `profile` LIMIT 100;
		   
SELECT
  CASE gender
    WHEN 'm' THEN 'Мужской'
    WHEN 'f' THEN 'Женский'
    ELSE 'Иное'
  END AS gender_rus
FROM `profile`;

SELECT
  gender
FROM `profile`
GROUP BY gender;

SELECT
  gender,
  -- user_id,
  GROUP_CONCAT(user_id)
FROM `profile`
GROUP BY gender;


SELECT
  gender,
  -- user_id,
  ANY_VALUE(user_id)
FROM `profile`
GROUP BY gender;

SELECT
  gender,
  COUNT(user_id)
FROM `profile`
GROUP BY gender;

SELECT
  gender,
  COUNT(*)
FROM `profile`
GROUP BY gender
WITH ROLLUP;

SELECT
  gender,
  COUNT(*) AS cnt
FROM `profile`
GROUP BY gender
HAVING cnt > 10;

-- Данные пользователя
SELECT
  user_id,
  (SELECT email FROM `user` WHERE `user`.id = `profile`.user_id) AS email,
  (SELECT phone FROM `user` WHERE `user`.id = `profile`.user_id) AS phone,
  CONCAT(firstname, ' ', lastname) AS user_name,
  birthday,
  gender,
  address,
  (SELECT url FROM media WHERE media.id = `profile`.media_id) AS media_url
FROM `profile`;

-- Фотографии пользователя
SELECT
  *,
  (SELECT `name` FROM media_type WHERE media_type.id = media.media_type_id) AS media_type_name
FROM media
WHERE
  user_id = 85
  AND media_type_id = (SELECT id FROM media_type WHERE `name` = 'img');

-- Кол-во медиа пользователей
SELECT
  user_id,
  COUNT(*) AS cnt
FROM media
GROUP BY user_id ORDER BY cnt DESC;

-- Кол-во медиа всех типов
SELECT
  media_type_id,
  (SELECT name FROM media_type WHERE media_type.id = media.media_type_id) AS media_type_name,
  COUNT(*) AS cnt
FROM media
GROUP BY media_type_id;

-- Кол-во медиа в каждом месяце (сезонность)
set global sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT
	MONTHNAME(created_at) AS MN,
	COUNT(id)
FROM media
GROUP BY MN
ORDER BY MONTH(created_at);

-- Пользователи, которым меньше 14 лет
SELECT
  *, TIMESTAMPDIFF(YEAR, birthday, NOW())
FROM profile
WHERE 
  TIMESTAMPDIFF(YEAR, birthday, NOW()) < 14;

-- Друзья пользователя
SELECT
  IF(from_user_id = 11, to_user_id, from_user_id) AS friend_id
FROM friendship_request
WHERE
  (from_user_id = 11 OR to_user_id = 11)
  AND `status` = 1;

-- Посты друзей пользователя
SELECT
  *
FROM post
WHERE
  user_id IN (
    SELECT IF(from_user_id = 11, to_user_id, from_user_id) AS friend_id
    FROM friendship_request
    WHERE
      (from_user_id = 11 OR to_user_id = 11)
      AND `status` = 1);

SELECT IF(from_user_id = 11, to_user_id, from_user_id) AS friend_id
    FROM friendship_request WHERE
      (from_user_id = 11 OR to_user_id = 11);
SELECT * FROM friendship_request WHERE from_user_id = 11 OR to_user_id = 11;

SELECT * FROM post WHERE user_id = 45;

-- Лайки к медиа пользователя
SELECT
  *,
  (SELECT COUNT(*) FROM `like` WHERE media_id = media.id) AS c_like
FROM media;

-- Кол-во сообщений пользователя
SELECT
 COUNT(*) AS cnt
FROM message
WHERE
  from_user_id = 2  OR to_user_id = 2
