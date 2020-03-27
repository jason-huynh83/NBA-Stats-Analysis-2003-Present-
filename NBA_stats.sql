create database NBA_stats;
use NBA_stats;

create table Win_Loss (
	counter int,
    SEASON int,
	GAME_ID int,
    TEAM_ID_HOME int,
    PTS_HOME float(5,1),
    TEAM_ID_AWAY int,
    PTS_AWAY float(5,1),
    HOME_TEAM_WINS int
);

create table player_stats (
	counter int,
	GAME_ID int,
    PLAYER_ID int,
    TEAM_ID int,
    PLAYER_NAME varchar(100),
    FGM int,
    FGA int,
    FG_PCT float(7,5),
    FG3M int,
    FG3A int,
    FG3_PCT float(7,5),
    FTM int,
    FTA int,
    FT_PCT float(7,5),
    OREB int,
    DREB int,
    REB int,
    AST int,
    STL int,
    BLK int,
    T_O int, 
    PF int,
    PTS int,
    PLUS_MINUS int
);

create table teams (
	counter int,
	TEAM_ID int,
    CITY varchar (200),
    NICKNAME varchar(200)
);

select * from win_loss;
select * from teams;
select * from player_stats;

drop table win_loss;
drop table player_stats;
drop table teams;


/*Home Wins with win_loss and teams tables*/
select win_loss.HOME_TEAM_WINS, teams.CITY, teams.NICKNAME
from win_loss
inner join teams
on win_loss.TEAM_ID_HOME = teams.TEAM_ID
where HOME_TEAM_WINS = 1;

/*Home Losses with win_loss and teams tables*/
select win_loss.HOME_TEAM_WINS, teams.CITY, teams.NICKNAME
from win_loss
inner join teams
on win_loss.TEAM_ID_HOME = teams.TEAM_ID
where HOME_TEAM_WINS = 0;

/*Away_Team wins and losses*/
select win_loss.HOME_TEAM_WINS, win_loss.TEAM_ID_AWAY, teams.CITY, teams.NICKNAME
from win_loss
inner join teams
on win_loss.TEAM_ID_AWAY = teams.TEAM_ID;

/*home wins specified season (2018)*/
select win_loss.HOME_TEAM_WINS, teams.CITY, teams.NICKNAME
from win_loss
inner join teams
on win_loss.TEAM_ID_HOME = teams.TEAM_ID
where SEASON = 2018;

/*away game wins specified season (2018)*/
select win_loss.HOME_TEAM_WINS, win_loss.TEAM_ID_AWAY, teams.CITY, teams.NICKNAME
from win_loss
inner join teams
on win_loss.TEAM_ID_AWAY = teams.TEAM_ID
where SEASON = 2018;

/*Player name with Player stats vs home wins*/
select player_stats.GAME_ID, player_stats.PLAYER_NAME, player_stats.REB, player_stats.AST, player_stats.STL, 
player_stats.BLK, player_stats.T_O, 
player_stats.PTS, player_stats.PLUS_MINUS, Win_Loss.HOME_TEAM_WINS
from player_stats
inner join win_loss
on player_stats.GAME_ID = Win_Loss.GAME_ID
where player_stats.PLAYER_NAME = 'LeBron James';


/* ??? */
select player_stats.PLAYER_NAME, player_stats.REB, player_stats.AST, player_stats.STL, 
player_stats.BLK, player_stats.T_O, 
player_stats.PTS, player_stats.PLUS_MINUS, Win_Loss.HOME_TEAM_WINS,
win_loss.HOME_TEAM_WINS, teams.CITY, teams.NICKNAME
from ((player_stats
inner join win_loss on player_stats.GAME_ID = Win_Loss.GAME_ID)
inner join teams on win_loss.TEAM_ID_HOME = teams.TEAM_ID);
