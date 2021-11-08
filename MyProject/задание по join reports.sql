USE sd;
SHOW TABLES;

-- -- ---------------------------------------------------------
-- краткий отчет по встрече для клиента: дата, время, длительность, формат встречи, тип встречи, коуч, коучи, первичный запрос, контектст, рефлексия, конспект, краткое резюме, ключевые открытия
SELECT 
	s_l.data AS дата_сессии,
    s_l.start_time AS начало,
    s_l.duration AS длительность,
    s_t.name AS тип,
    s_f.name AS формат,
    CONCAT(c.first_name, ' ', c.last_name) AS коучи,
	CONCAT(ch.first_name, ' ', ch.last_name) AS коуч,
    r.start_client_request AS запрос_на_встречу,
	r.introspection AS рефлексия,
    r.outline AS конспект_встречи,
    r.resume AS краткие_итоги,
    r.end_client_insights AS открытия,
    r.end_client_results AS личные_итоги
FROM sessions_list AS s_l 
JOIN reports AS r
	ON s_l.id = r.id_session
JOIN session_format AS s_f
	ON s_f.id = s_l.id_format_session
JOIN sessions_type AS s_t
	ON s_t.id = s_l.id_type_session
JOIN clients AS c
	ON c.id = s_l.id_client
JOIN coaches AS ch
	ON ch.id = s_l.id_coach
WHERE s_l.id = 23;

-- INTO OUTFILE '/report_for_client_short.txt'
-- FIELDS TERMINATED BY '\n'
-- LINES TERMINATED BY '\n';
-- ----------------------------------------------------------
-- отчет по коучу: коуч, статус клиентов, количество клиентов, количестов треков по каждому клиеyne, количество сессий

SHOW COLUMNS FROM reports; 
SHOW COLUMNS FROM clients;
SHOW COLUMNS FROM sessions_list;
SELECT id_client_status , COUNT(id) FROM clients GROUP BY id_client_status;
SELECT sl.id_coach, cs.name статус_клиента, ts.name статус_трека, COUNT(DISTINCT sl.id_client) колво_клиентов, COUNT(DISTINCT tl.id) колво_треков, COUNT(DISTINCT sl.id) колво_сессий FROM sessions_list sl 
	JOIN clients c 
		ON sl.id_client = c.id
	JOIN tracks_list tl
		ON sl.id_client = tl.id_client
	JOIN client_status cs
		ON c.id_client_status = cs.id
	JOIN tracks_status ts
		ON tl.id_status = ts.id
	WHERE sl.id_coach = 1 
    GROUP BY sl.id_coach, c.id_client_status, tl.id_status
    ORDER BY id_coach;

-- отчет по часам работы
SELECT YEAR(data) год, MONTH(data) месяц, COUNT(id) колво_сессий, SEC_TO_TIME(SUM(TIME_TO_SEC(duration))) рабочих_часов
	FROM sessions_list 
    WHERE id_coach = 1
    GROUP BY YEAR(data), MONTH(data) 
    ORDER BY id_coach, MONTH(data);

-- отчет для акта(за месяц): дата, клиент, запрос, результат, длительность 
SELECT sl.data дата,CONCAT (c.last_name,' ',c.first_name) клиент,r.start_client_request цель ,r.resume результат,sl.duration длительность
	FROM sessions_list sl 
		JOIN reports r
			ON sl.id = r.id_session
		JOIN clients c
			ON sl.id_client = c.id
	WHERE MONTH(data) = 8 AND id_coach = 1 ORDER BY data;

-- отчеты по треку
SHOW FULL COLUMNS FROM tracks_list;
SELECT * FROM tracks_list WHERE id_client = 11;

-- треки клиента с результатами
SELECT 
	tl.id_client,
    ts.name статус_трека,
    tl.name название_трека, 
    tv.goal цель_трека,
    tv.willdoit план_достижеия,
    tv.obstacles препятствия,
    sl.data дата_сессии,
    cr.facts результаты,
    cr.kpd над_чем_работать,
    cr.hw задачи
		FROM tracks_list tl
			JOIN clients_reports cr
				ON tl.id = cr.id_track
			JOIN tracks_status ts
				ON tl.id_status = ts.id
			JOIN sessions_list sl
				ON cr.id_session = sl.id
			JOIN track_view tv
				ON tl.id = tv.id_track
		WHERE tl.id_client = 11
		ORDER BY tl.id_status, tl.name,sl.data;
    
SHOW FULL COLUMNS FROM clients_reports;

-- полный отчет по клиенту (с треками) = краткий отчет + отчет по трекам + отчет коуча
SELECT 
	s_l.id,
    s_l.data AS дата_сессии,
    s_l.start_time AS начало,
    s_l.duration AS длительность,
    s_t.name AS тип,
    s_f.name AS формат,
    CONCAT(c.first_name, ' ', c.last_name) AS коучи,
	CONCAT(ch.first_name, ' ', ch.last_name) AS коуч,
    r.start_client_request AS запрос_на_встречу,
	r.introspection AS рефлексия,
    r.outline AS конспект_встречи,
    cr.id_track работа_по_треку,
    cr.facts что_было_сделано,
    cr.kpd ключевые_причины,
    cr.hw задача,
    cr.hw итоги,
    r.resume AS краткие_итоги,
    r.end_client_insights AS открытия,
    r.end_client_results AS личные_итоги
FROM sessions_list AS s_l 
JOIN reports AS r
	ON s_l.id = r.id_session
JOIN session_format AS s_f
	ON s_f.id = s_l.id_format_session
JOIN sessions_type AS s_t
	ON s_t.id = s_l.id_type_session
JOIN clients AS c
	ON c.id = s_l.id_client
JOIN coaches AS ch
	ON ch.id = s_l.id_coach
JOIN clients_reports cr
	ON cr.id_session = s_l.id
WHERE s_l.id = 11;
