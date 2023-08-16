SELECT LEAST(cu1.home, cu1.away) AS team1, GREATEST(cu1.home, cu1.away) AS team2, COUNT(DISTINCT cu1.year) AS match_count
FROM tournament_history cu1
JOIN tournament_history cu2 ON (LEAST(cu1.home, cu1.away) = LEAST(cu2.home, cu2.away) AND GREATEST(cu1.home, cu1.away) = GREATEST(cu2.home, cu2.away))
GROUP BY team1, team2
ORDER BY match_count DESC;
