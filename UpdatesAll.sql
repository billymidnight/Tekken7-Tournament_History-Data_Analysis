update participants
set finals = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM CENTRALUNIT
	WHERE ROUND = 'Semifinal'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.WINNER;

update participants
set semifinals = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM CENTRALUNIT
	WHERE ROUND = 'Quarterfinal'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.WINNER;



update participants
set appearances = subquery_2.appearance_count
FROM (
	SELECT participant, COUNT(*) AS appearance_count
			FROM (
			  SELECT home AS participant FROM CENTRALUNIT
			  UNION ALL
			  SELECT away AS participant FROM CENTRALUNIT
			) AS subquery
GROUP BY participant
ORDER BY appearance_count DESC
) as subquery_2
WHERE PARTICIPANTS.NAME = SUBQUERY_2.participant;

update participants
set win_percent = subquery_2.win_percentage
from 
				( SELECT
		  p.name AS participant,
		  COUNT(*) FILTER (WHERE c.winner = p.name) AS wins,
		  COUNT(DISTINCT CASE WHEN c.home = p.name THEN c.year || c.round ELSE NULL END) +
			COUNT(DISTINCT CASE WHEN c.away = p.name THEN c.year || c.round ELSE NULL END) AS appearances,
		  ROUND(COALESCE(COUNT(*) FILTER (WHERE c.winner = p.name)::numeric / 
			NULLIF(COUNT(DISTINCT CASE WHEN c.home = p.name THEN c.year || c.round ELSE NULL END) +
			COUNT(DISTINCT CASE WHEN c.away = p.name THEN c.year || c.round ELSE NULL END), 0) * 100, 0), 2) AS win_percentage
		FROM
		  participants AS p
		JOIN
		  centralunit AS c ON p.name = c.winner OR p.name = c.home OR p.name = c.away
		--WHERE c.round in ('Final') 
		GROUP BY
		  p.name
		ORDER BY
		  p.name) as subquery_2
where participants.name = subquery_2.participant;


update participants
set years_participated = subquery_2.years_participated
									FROM ( SELECT
								  p.name,
								  COUNT(DISTINCT c.year) AS years_participated,
								  COUNT(CASE WHEN p.name = c.winner AND ROUND = 'Final' THEN 1 END) AS trophies,
								  ROUND(COUNT(CASE WHEN p.name = c.winner AND ROUND = 'Final' THEN 1 END) * 100.0 / COUNT(DISTINCT c.year), 2) AS trophies_percentage
								FROM
								  participants p
								LEFT JOIN
								  centralunit c ON p.name = c.home OR p.name = c.away
								GROUP BY
								  p.name
								  order by p.name desc

									) as subquery_2
WHERE PARTICIPANTS.NAME = SUBQUERY_2.name;


update participants
set wins = subquery.wins
FROM (
	SELECT WINNER, COUNT(*) AS wins 
	FROM CENTRALUNIT
	--WHERE ROUND = 'Semifinal'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.WINNER;

update participants
set trophies = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM CENTRALUNIT
	WHERE ROUND = 'Final'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.WINNER;


update participants
set consecutive_trophies = subquery.consecutive_wins
FROM (
	SELECT subquery.winner,
    count(*) AS consecutive_wins,
    string_agg(subquery.year::text, ','::text) AS years
   FROM ( SELECT centralunit.winner,
            centralunit.year,
            row_number() OVER (ORDER BY centralunit.year) - row_number() OVER (PARTITION BY centralunit.winner ORDER BY centralunit.year) AS streak
           FROM centralunit
          WHERE centralunit.round::text = 'Final'::text) subquery
  GROUP BY subquery.winner, subquery.streak
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.WINNER;

UPDATE PARTICIPANTS
SET trophy_frequency = (trophies::numeric / NULLIF(years_participated, 0)) * 100;

update participants
set finals_percent = subquery.win_percentage
FROM (
	SELECT
  p.name AS participant,
  COUNT(*) FILTER (WHERE c.winner = p.name) AS wins,
  COUNT(DISTINCT CASE WHEN c.home = p.name THEN c.year || c.round ELSE NULL END) +
    COUNT(DISTINCT CASE WHEN c.away = p.name THEN c.year || c.round ELSE NULL END) AS appearances,
  ROUND(COALESCE(COUNT(*) FILTER (WHERE c.winner = p.name)::numeric / 
    NULLIF(COUNT(DISTINCT CASE WHEN c.home = p.name THEN c.year || c.round ELSE NULL END) +
    COUNT(DISTINCT CASE WHEN c.away = p.name THEN c.year || c.round ELSE NULL END), 0) * 100, 0), 2) AS win_percentage
FROM
  participants AS p
JOIN
  centralunit AS c ON p.name = c.winner OR p.name = c.home OR p.name = c.away
WHERE c.round in ('Final') 
GROUP BY
  p.name
ORDER BY
  p.name
) as subquery
WHERE PARTICIPANTS.NAME = SUBQUERY.participant;


update participants set wins = 0 where wins is null;
update participants set consecutive_trophies = 0 where consecutive_trophies is null;
update participants set semifinals = 0 where semifinals is null;


update participants
set cumedist = x.cumedist 
from
(
select name, rating,
ROUND(((cume_dist() over (order by rating)) * 100)::numeric, 2) as cumedist
from participants)x
where participants.name = x.name
























































































































































