--Groups participants by nation and aggregates trophies for nation for nationality-based analysis
--Group by clause and inner join utilized
SELECT p.nation AS nation,
       SUM(p.trophies) AS total_trophies
FROM participants_table AS p
JOIN (
    SELECT winner, COUNT(*) AS trophies
    FROM tournament_history
    WHERE round = 'Final'
    GROUP BY winner
) AS c ON p.name = c.winner
GROUP BY p.nation;
