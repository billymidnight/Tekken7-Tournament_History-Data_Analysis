SELECT
  p.name AS participant,
  COUNT(*) FILTER (WHERE c.home = p.name AND c.winner = p.name) AS home_wins,
  COUNT(*) FILTER (WHERE c.home = p.name) AS home_appearances,
 (COUNT(*) FILTER (WHERE c.home = p.name AND c.winner = p.name) / COUNT(*) FILTER (WHERE c.home = p.name)::float) * 100 AS home_win_percentage
 FROM participants AS p
JOIN
centralunit AS c ON p.name = c.home

GROUP BY
p.name
ORDER BY
p.name;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  