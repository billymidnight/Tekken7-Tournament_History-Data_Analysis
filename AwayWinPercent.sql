SELECT
  p.name AS participant,
  COUNT(*) FILTER (WHERE c.away = p.name AND c.winner = p.name) AS away_wins,
  COUNT(*) FILTER (WHERE c.away = p.name) AS away_appearances,
 (COUNT(*) FILTER (WHERE c.away = p.name AND c.winner = p.name) / COUNT(*) FILTER (WHERE c.away = p.name)::float) * 100 AS away_win_percentage
 FROM participants AS p
JOIN
centralunit AS c ON p.name = c.away

GROUP BY
p.name
ORDER BY
P.NAME
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  