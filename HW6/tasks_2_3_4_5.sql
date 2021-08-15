SHOW DATABASES;
USE vk;

-- ЗАДАНИЕ 2 
-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- РЕШЕНИЕ посчитать сообщения от пользователей, которые в друзьях c данным
 
INSERT INTO friendship_request (from_user_id, to_user_id, status) VALUES (6,9,1);
INSERT INTO friendship_request (from_user_id, to_user_id, status) VALUES (6,13,1);
 
 
 SELECT from_user_id,COUNT(text) AS q FROM message WHERE from_user_id IN (
 SELECT IF(from_user_id = 6, to_user_id, from_user_id) AS friend_id
    FROM friendship_request
    WHERE
      (from_user_id = 6 OR to_user_id = 6)
      AND `status` = 1)
      AND
      to_user_id = 6 
      GROUP BY from_user_id ORDER BY q DESC LIMIT 1;
 
-- Задание 3
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT * FROM `like`;
SELECT user_id, COUNT(*) FROM `like` GROUP BY user_id; -- количество лайков по пользователям
SELECT user_id FROM `profile` ORDER BY TIMESTAMPDIFF(YEAR,birthday,NOW()) LIMIT 10; -- список 10 самых молодых пользователей
SELECT COUNT(*) FROM `like` WHERE user_id IN (SELECT * FROM (SELECT user_id FROM `profile` ORDER BY TIMESTAMPDIFF(YEAR,birthday,NOW()) LIMIT 10)temp_tab);

-- Задание 4
-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT 
    (SELECT COUNT(*) AS fl FROM `like` 
			WHERE user_id IN
		   (SELECT * FROM (SELECT user_id FROM `profile` WHERE user_id = `like`.user_id AND gender = 'f')temp_tab)) AS Females_likes,
	COUNT(*) - (SELECT COUNT(*) AS fl FROM `like` 
			WHERE user_id IN
		   (SELECT * FROM (SELECT user_id FROM `profile` WHERE user_id = `like`.user_id AND gender = 'f')temp_tab)) AS Males_likes	
FROM `like`;

-- Задание 5
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Решение активность измеряется по постам, лайкам, запросам в друзья, сообщениям. Сложим все активности по айди пользователя
SELECT user_id, 
	(SELECT COUNT(*) FROM `message` WHERE from_user_id = `profile`.user_id ) +
    (SELECT COUNT(*) FROM `like` WHERE user_id = `profile`.user_id ) +
    (SELECT COUNT(*) FROM `friendship_request` WHERE from_user_id = `profile`.user_id ) +
    (SELECT COUNT(*) FROM `post` WHERE user_id = `profile`.user_id ) as total_act
FROM `profile` GROUP BY user_id ORDER BY total_act LIMIT 10;
