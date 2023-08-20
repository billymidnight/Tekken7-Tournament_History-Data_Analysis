SELECT p.nation AS nation,
       SUM(p.trophies) AS total_trophies
FROM participants AS p
JOIN (
    SELECT winner, COUNT(*) AS trophies
    FROM centralunit
    WHERE round = 'Final'
    GROUP BY winner
) AS c ON p.name = c.winner
GROUP BY p.nation;
