--Calculates the win percentage for each participant whilst playing at home
--Query outputs home wins, home appearances and then home_wins/home_appearances*100 i.e. home win percentage alongside each name from participant_table
--Inner Join utilized


SELECT
  p.name AS participant,
  COUNT(*) FILTER (WHERE c.home = p.name AND c.winner = p.name) AS home_wins,
  COUNT(*) FILTER (WHERE c.home = p.name) AS home_appearances,
 (COUNT(*) FILTER (WHERE c.home = p.name AND c.winner = p.name) / COUNT(*) FILTER (WHERE c.home = p.name)::float) * 100 AS home_win_percentage
 FROM participants_table AS p
JOIN
tournament_history AS c ON p.name = c.home

GROUP BY
p.name
ORDER BY
p.name;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
