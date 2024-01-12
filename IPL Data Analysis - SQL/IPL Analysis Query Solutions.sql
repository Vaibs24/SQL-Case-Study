select * from deliveries
select * from matches

update matches
set winner = null where result = 'tie'

exec sp_rename 'deliveries.over','over_no','column'

--WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?

select top 5 player_of_match,count(*) as awards_count from matches
group by player_of_match
order by awards_count desc 

--HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?

select season,winner as team,count(*) as matches_won from matches
where winner is not null
group by season, winner
order by season

--WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

select avg(strike_rate) as average_strike_rate 
from(select batsman,(sum(total_runs)/count(ball))*100 as strike_rate from deliveries group by batsman)as batsman_stats

--WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTINGSECOND?

with bat as(
select winner, count(*) as bat_first from matches
where (winner = toss_winner and toss_decision = 'bat') or (winner != toss_winner and toss_decision = 'field')
group by winner), bowl as (
select winner, count(*) as bat_second from matches
where (winner = toss_winner and toss_decision = 'field') or (winner != toss_winner and toss_decision = 'bat')
group by winner)

select b.winner as team, b.bat_first, w.bat_second from bat b
join bowl w on w.winner = b.winner

--WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?

select top 1 batsman, sum(batsman_runs)*100/count(*) as strike_rate from deliveries 
group by batsman 
having sum(total_runs)>=200
order by strike_rate desc

--HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?

select bowler, batsman, count(*) as no_dismiss from deliveries
where bowler = 'SL Malinga' and player_dismissed is not null
group by bowler,batsman

--WHAT IS THE PERCENTAGE OF BOUNDARIES (FOURS AND SIXESCOMBINED) RUNS BY EACH BATSMAN?

with runs as (select batsman, sum(batsman_runs) as total_runs from deliveries
group by batsman), bound_runs as (select batsman, sum(batsman_runs) as boun_runs from deliveries
where batsman_runs = 4 or batsman_runs = 6
group by batsman)

select r.batsman, r.total_runs, b.boun_runs, b.boun_runs*100/r.total_runs as boundry_percent from runs r
join bound_runs b on b.batsman = r.batsman

--WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

select season,batting_team,avg(fours+sixes) as average_boundaries
from(select season,match_id,batting_team,
sum(case when batsman_runs=4 then 1 else 0 end)as fours,
sum(case when batsman_runs=6 then 1 else 0 end) as sixes
from deliveries,matches 
where deliveries.match_id=matches.id
group by season,match_id,batting_team) as team_bounsaries
group by season,batting_team
order by season

--WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?

with part1 as(
select season, batting_team, batsman, non_striker, sum(total_runs) as runs_bat from deliveries, matches
where deliveries.match_id = matches.id
group by season, batting_team, batsman, non_striker
), part as (select p1.season as season, p1.batting_team as team, p1.batsman as batsman1, p1.non_striker as batsman2, p1.runs_bat as bat1_run, p2.runs_bat as bat2_run from part1 p1
join part1 p2 on (p2.season = p1.season and p2.batting_team = p1.batting_team and p2.batsman = p1.non_striker and p2.non_striker = p1.batsman)), high_part as (
select season, team, batsman1, batsman2, (bat1_run+bat2_run) as partnership, ROW_NUMBER() over(partition by season, team order by (bat1_run+bat2_run) desc) as ro from part)

select season, team, batsman1, batsman2, partnership from high_part
where ro=1
order by season, team


--HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?

select bowling_team, sum(case when wide_runs != 0 or noball_runs !=0 then 1 else 0 end)/COUNT(distinct match_id) as avg_extra from deliveries
group by bowling_team

--WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?

select top 1 match_id, bowler, count(*) as wickets from deliveries
where player_dismissed is not null and dismissal_kind IN ('caught and bowled','bowled','stumped','caught','lbw')
group by match_id, bowler
order by wickets desc

--HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?

select winner, city, COUNT(*) as no_wins from matches
where winner is not null
group by winner, city
order by winner, city

--HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?

select toss_winner, COUNT(*) as win_tosses from matches
group by toss_winner
order by win_tosses desc

--WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

select top 1 batting_team, sum(total_runs) as score from deliveries
group by batting_team, match_id
order by score desc

--WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?

select top 1 batsman, SUM(batsman_runs) as batsman_score from deliveries
group by match_id, inning, batsman
order by batsman_score desc

--WHICH ARE THE TOP 5 BOWLERS ACCORDING TO ECONOMY RATE WHO BOWLED MORE THAN 5 OVERS?

with ov as (
select bowler, over_no from deliveries
group by bowler, over_no
), overs as (
select bowler, COUNT(*) as total_overs from ov
group by bowler
)

select top 5 d.bowler, o.total_overs, sum(d.total_runs)/o.total_overs as econ_rate from deliveries d
join overs o on o.bowler = d.bowler
group by d.bowler, o.total_overs
having o.total_overs > 5
order by econ_rate

--WHICH ARE THE TOP 5 BATSMAN WITH MAXIMUM SIXES ?

select top 5 batsman, sum(case when batsman_runs = 6 then 1 else 0 end) as no_sixes from deliveries
group by batsman
order by no_sixes desc

--WHAT ARE AVERAGE SCORES IN EACH CITY?

with cte as (
select m.city as city, m.id, d.inning,  sum(d.total_runs) as score from deliveries d
join matches m on m.id = d.match_id
group by m.city, m.id, d.inning)

select city, avg(score) as avg_score from cte
group by city
order by avg_score desc

--WHAT ARE THE NUMBER OF WINS BY CITY WHILE BATTING FIRST AND BATTING SECOND?

with bat as(
select city, count(*) as bat_first from matches
where (winner = toss_winner and toss_decision = 'bat') or (winner != toss_winner and toss_decision = 'field')
group by city), bowl as (
select city, count(*) as bat_second from matches
where (winner = toss_winner and toss_decision = 'field') or (winner != toss_winner and toss_decision = 'bat')
group by city)

select b.city, b.bat_first, w.bat_second from bat b
join bowl w on w.city = b.city




