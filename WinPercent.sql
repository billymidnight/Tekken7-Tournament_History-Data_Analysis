--Calculates and queries each participant's overall win_percentage across the entire tournament history from available data
--Output query has (in order) name, wins, appearances, wins/appearances*100 i.e. win_percent

SELECT
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
  p.name;
  
