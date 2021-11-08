USE sd;
--  создадим триггер который будет считать количество треков и сессий и вставлять данные в таблицу coach_profile

SHOW TRIGGERS;

DELIMITER //
DROP TRIGGER IF EXISTS coach_1_qty_sessions;
CREATE TRIGGER coach_1_qty_sessions
AFTER INSERT ON sessions_list
FOR EACH ROW
BEGIN
	DECLARE tot_sessions INT;
    DECLARE tot_clients INT;
    DECLARE tot_tracks INT;
    SELECT COUNT(id) INTO tot_sessions FROM sessions_list WHERE id_coach = 1;
    SELECT COUNT(id_client) INTO tot_clients FROM sessions_list WHERE id_coach = 1;
    SELECT COUNT(id) INTO tot_tracks FROM tracks_list WHERE id_coach = 1;
    UPDATE coach_profile SET Current_qty_session = tot_sessions WHERE id_coach = 1;
    UPDATE coach_profile SET Current_qty_clients = tot_clients WHERE id_coach = 1;
    UPDATE coach_profile SET Current_qty_tracks = tot_tracks WHERE id_coach = 1;
 
END//
DELIMITER ;

SELECT * FROM coach_profile;
SELECT * FROM sessions_list;
INSERT INTO `sessions_list` VALUES (204,'1977-04-12','09:29:38',NULL,NULL,3,1,13,2,'2014-02-06 00:45:22','2001-01-23 20:20:01');

-- дописал время окончания по внесенным тестовым зписям (для следующей задачи)
UPDATE `sd`.`sessions_list` SET `end_time` = '10:00:00' WHERE (`id` = '201');
UPDATE `sd`.`sessions_list` SET `end_time` = '10:00:00' WHERE (`id` = '202');
UPDATE `sd`.`sessions_list` SET `end_time` = '11:00:00' WHERE (`id` = '203');
UPDATE `sd`.`sessions_list` SET `end_time` = '11:00:00' WHERE (`id` = '204');

-- хранимая процедура для обновления данных по количеству сессий и треков в профайле клиента

DELIMITER //
DROP PROCEDURE IF EXISTS qty_session_to_profile//
CREATE PROCEDURE qty_session_to_profile()
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE qty_c INT;
    DECLARE id_f_sl INT;
    DECLARE is_end INT DEFAULT 0;
    DECLARE qty_session INT;
    DECLARE qty_tracks INT;
	SELECT COUNT(id) INTO qty_c FROM client_profile;
    
   WHILE i <= qty_c DO
		SELECT COUNT(id) INTO qty_session FROM sessions_list WHERE id_client = i;
        SELECT COUNT(id) INTO qty_tracks FROM tracks_list WHERE id_client = i;
        UPDATE client_profile SET Current_qty_session = qty_session WHERE id_client = i;
        UPDATE client_profile SET Current_qty_tracks = qty_tracks WHERE id_client = i;
		SET i = i + 1;
	END WHILE;	
END//

CALL qty_session_to_profile()//

DELIMITER ;

SELECT * FROM sessions_list;
SELECT * FROM client_profile;
SELECT COUNT(id) FROM tracks_list WHERE id_client = 3;

-- ТРИГЕР обновления длительности сессии после занесения данных
DELIMITER //
DROP TRIGGER IF EXISTS duration;
CREATE TRIGGER duration
BEFORE INSERT ON sessions_list
FOR EACH ROW
BEGIN
	SET NEW.duration = SUBTIME(NEW.end_time,NEW.start_time);
END//
DELIMITER ;

INSERT INTO `sessions_list` VALUES (206,'1977-04-12','09:29:38','10:22:22',NULL,3,1,13,2,'2014-02-06 00:45:22','2001-01-23 20:20:01');
