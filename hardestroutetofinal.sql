with wt as 
(select year, winner from centralunit where round = 'Final')

select ad.year, wt.winner, sum(ad.loser_rating) as difficulty
from    (
			select cu.year, cu.round, cu.winner, cu.loser, p.rating as loser_rating
			from centralunit cu
			join participants p  on cu.loser = p.name ) ad
join wt on ad.year = wt.year
where ad.winner = wt.winner
group by ad.year, wt.winner
order by YEAR 


































