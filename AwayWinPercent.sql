-- Calculates the win percentage for each participant whilst playing away from home
-- Query outputs away wins, away appearances and then away_wins/away_appearances*100 i.e. away win percentage alongside each name from participant_table
--Inner Join utilized

SELECT
  p.name AS participant,
  COUNT(*) FILTER (WHERE c.away = p.name AND c.winner = p.name) AS away_wins,
  COUNT(*) FILTER (WHERE c.away = p.name) AS away_appearances,
 (COUNT(*) FILTER (WHERE c.away = p.name AND c.winner = p.name) / COUNT(*) FILTER (WHERE c.away = p.name)::float) * 100 AS away_win_percentage
 FROM participants_table AS p
JOIN
tournament_history AS c ON p.name = c.away

GROUP BY
p.name
ORDER BY
P.NAME
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
