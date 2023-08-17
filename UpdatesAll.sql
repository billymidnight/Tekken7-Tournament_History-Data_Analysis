--Update script for the participants_table.csv table. Periodically updates trophies, finals, win_percent, etc...
-- Relelvant output query can be found in participants.csv

--Updating finals by utilizing a subquery that counts semifinal wins.
update participants_table
set finals = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM tournament_history
	WHERE ROUND = 'Semifinal'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS_table.NAME = SUBQUERY.WINNER;

--Updating semifinals by utilizing a subquery that counts quarterfinal wins.
update participants_table
set semifinals = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM tournament_history
	WHERE ROUND = 'Quarterfinal'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS_table.NAME = SUBQUERY.WINNER;

--Updating total number of appearances per participant by utilizing a subquery that aggregates home and away appearances and groups by name.
update participants_table
set appearances = subquery_2.appearance_count
FROM (
	SELECT participant, COUNT(*) AS appearance_count
			FROM (
			  SELECT home AS participant FROM tournament_history
			  UNION ALL
			  SELECT away AS participant FROM tournament_history
			) AS subquery
GROUP BY participant
ORDER BY appearance_count DESC
) as subquery_2
WHERE PARTICIPANTS_table.NAME = SUBQUERY_2.participant;

-- Updating win percentage for each participant by utilizing a subquery which is a direct script of WinPercent.sql (located in main branch of repository)
update participants_table
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
		  participants_table AS p
		JOIN
		  tournament_history AS c ON p.name = c.winner OR p.name = c.home OR p.name = c.away
		--WHERE c.round in ('Final') 
		GROUP BY
		  p.name
		ORDER BY
		  p.name) as subquery_2
where participants_table.name = subquery_2.participant;

-- Updating number of tournaments participated in by using subquery that treats each individual tournament as a 'year'
update participants_table
set years_participated = subquery_2.years_participated
								FROM (SELECT p.name,
								  COUNT(DISTINCT c.year) AS years_participated,
								  COUNT(CASE WHEN p.name = c.winner AND ROUND = 'Final' THEN 1 END) AS trophies,
								  ROUND(COUNT(CASE WHEN p.name = c.winner AND ROUND = 'Final' THEN 1 END) * 100.0 / COUNT(DISTINCT c.year), 2) AS trophies_percentage
								FROM
								  participants_table p
								LEFT JOIN
								  tournament_history c ON p.name = c.home OR p.name = c.away
								GROUP BY
								  p.name
								ORDER BY p.name desc) as subquery_2
WHERE PARTICIPANTS_table.NAME = SUBQUERY_2.name;

--Updating total number of wins across tournament history utilizing a subquery
update participants_table
set wins = subquery.wins
FROM (
	SELECT WINNER, COUNT(*) AS wins 
	FROM tournament_history
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS_table.NAME = SUBQUERY.WINNER;

--Updating total number of trophies by utilizing a subquery that counts number of wins in 'Final's
update participants_table
set trophies = subquery.finalsappearances
FROM (
	SELECT WINNER, COUNT(*) AS FINALSAPPEARANCES 
	FROM tournament_history
	WHERE ROUND = 'Final'
	GROUP BY WINNEr
	order by winner
) as subquery
WHERE PARTICIPANTS_table.NAME = SUBQUERY.WINNER;

--Updates highest number of consecutive trophies won for each participant ; Reference consecutive_trophies.sql on repository
update participants_table
set consecutive_trophies = subquery.consecutive_wins
FROM (
	SELECT subquery.winner,
    count(*) AS consecutive_wins,
    string_agg(subquery.year::text, ','::text) AS years
   FROM ( SELECT tournament_history.winner,
            tournament_history.year,
            row_number() OVER (ORDER BY tournament_history.year) - row_number() OVER (PARTITION BY tournament_history.winner ORDER BY tournament_history.year) AS streak
           FROM tournament_history
          WHERE tournament_history.round::text = 'Final'::text) subquery
  GROUP BY subquery.winner, subquery.streak
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC
) as subquery
WHERE PARTICIPANTS_table.NAME = SUBQUERY.WINNER;

-- Updates trophy frequency
-- Trophy frequency is a measure of number of trophies won per tournament mulitplied for 100 for numerical convenience.
UPDATE PARTICIPANTS
SET trophy_frequency = (trophies::numeric / NULLIF(years_participated, 0)) * 100;

-- Updates win_percent for each participant maintained in finals alone.
-- Similar script to win_percent with the additional conditional of "round = 'Final'"
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
  tournament_history AS c ON p.name = c.winner OR p.name = c.home OR p.name = c.away
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

--Updates cumulative distance in descending order based off on rating
update participants
set cumedist = x.cumedist 
from
(
select name, rating,
ROUND(((cume_dist() over (order by rating)) * 100)::numeric, 2) as cumedist
from participants)x
where participants.name = x.name
























































































































































