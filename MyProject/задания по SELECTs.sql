-- создаем представления для отслеживания динамики и объема работы по трекам клиента
SELECT * FROM clients_reports;
SELECT * FROM sessions_list;

CREATE OR REPLACE VIEW tracks_dinamic AS SELECT sl.id_client id_клиента,
        CONCAT(c.first_name,' ', c.last_name) клиент,
        cr.id_track номер_трека,
        tl.name название_трека,
		sl.id номер_сессии, 
        sl.data дата,
        CONCAT(ch.first_name, ' ', ch.last_name) коуч,
        sl.duration длительность,
        cr.facts результаты,
        cr.introspection_end оценка
	FROM clients_reports cr
		JOIN sessions_list sl
			ON sl.id = cr.id_session
		JOIN clients c
			ON c.id = sl.id_client
		JOIN tracks_list tl
			ON tl.id = cr.id_track
		JOIN coaches ch
			ON ch.id = sl.id_coach
	ORDER BY sl.id_client, cr.id_track;
    
SELECT * FROM tracks_dinamic;

-- представление на оценку реализации плана работ коуча
SELECT * FROM coach_report WHERE id_track = 3;
SELECT * FROM coach_strategy;
SELECT * FROM track_view;
SELECT * FROM tracks_list;
SELECT * FROM reports;
CREATE OR REPLACE VIEW coach_work AS SELECT 
		tl.id_coach,
		sl.id_client номер_клиента,
        tl.id_client,
        tv.id_track номер_трека,
        tl.name название_трека,
        tv.goal цель_трека,
        tv.coach_strategy стратегия_работы,
        cs.id,
        cs.step_n номер_шага,
        cs.step шаг,
        cs.qty_sessions планируемое_кво_сессий,
        cr.id_session номер_сессии,
        sl.data дата,
        cr.seccion_goal цель_на_сессию,
        cr.session_results результаты,
        cr.stars супер,
        r.end_coach_can_better над_чем_работать
	FROM coach_report cr
		JOIN track_view tv
			ON tv.id_track = cr.id_track
		JOIN sessions_list sl
			ON sl.id = cr.id_session
		JOIN tracks_list tl
			ON tl.id = cr.id_track
		JOIN coach_strategy cs
			ON cs.id_track = cr.id_track
		JOIN reports r
			ON r.id_session = sl.id
	ORDER BY sl.id_client, tv.id_track, cs.step_n;

SELECT * FROM coach_work WHERE id_coach = 1;

        

