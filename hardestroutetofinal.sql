-- Calculates (for each tournament) the total difficulty of opponents faced by the eventual winner of that tournament
-- Tournaments differentiated by tournament ID (running from 1930 through 2271)
-- With clause used to match the tournament history with a subquery of champions
-- Inner join utilized to match each loser with their rating from the participants_table table
-- Output query ordered by difficulty and outputs the tournament ID, its winner and the sum difficulty

with wt as 
(select year, winner from tournament_history where round = 'Final')

select ad.year, wt.winner, sum(ad.loser_rating) as difficulty
from    (
			select cu.year, cu.round, cu.winner, cu.loser, p.rating as loser_rating
			from tournament_history cu
			join participants_table p  on cu.loser = p.name ) ad
join wt on ad.year = wt.year
where ad.winner = wt.winner
group by ad.year, wt.winner
order by YEAR 


































