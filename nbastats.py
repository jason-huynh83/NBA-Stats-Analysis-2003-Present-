# -*- coding: utf-8 -*-
"""
Created on Tue Mar 24 21:42:37 2020

@author: User
"""

#Goal is to use an ETL (Extract, Transform, Load) NBA stats for NBA win predictions
#games_details has Game ID, player ID, Team ID and player stats
#games have GAME ID, pts home and pts away home team wins
#can analyze which team has the best home winning record, worse winning record, etc
#MySQL database will have: GAME_ID, HOME_TEAM_ID, TEAM_ABR, AWAY_TEAM_ID, TEAM_ABR, PLAYER_STATS, WIN/LOSE


#glob module finds all the path names matching a specified pattern according to the rules used by the Unix shell, although
#are returned in arbitrary order.

#The OS module in python provides a way of using the Operating System

import os
import glob
import pandas as pd
import sqlalchemy

database_connection = sqlalchemy.create_engine("mysql+mysqlconnector://root:password123@localhost:3306/nba_stats")

#Reading the files in this path, storing in an array called files_names
files_path = 'C:\\Users\\User\\Documents\\School\\code\\NBA_stats'
read_files = glob.glob(os.path.join(files_path, "*.csv"))
files_names = [] #empty array
print("Files in the folder")
for num in range(0, len(read_files)):
    stored_files = read_files[num] #storing value from read_files in local variable stored_files
    files_names.append(stored_files) #storing value from stored_file and adding element to array files_names
    print(files_names[num]) #printing array, cannot add to reading csv because it won't read single \

print('\n')

my_files = ['games','games_details', 'teams'] #array of strings for filenames

#reading CSV files and storing them in dataframes using Pandas and importing dataframe into MySQL Database
i = 0
for reading in range(0, len(my_files)):
    games = pd.read_csv(files_path + '\\' +my_files[reading]+ '.csv', index_col = 'counter')
    if i == 0:  
        df_games = pd.DataFrame(games, columns = ['GAME_ID', 'SEASON', 'TEAM_ID_home', 'PTS_home', 'TEAM_ID_away', 'PTS_away', 'HOME_TEAM_WINS'])
        df_games.to_sql("Win_Loss", con = database_connection, if_exists = 'append', chunksize = 1000)
        print(df_games)
        i += 1     
    elif i==1:
        df_games_details = pd.DataFrame(games, columns = ['GAME_ID', 'PLAYER_ID', 'TEAM_ID', 
                                                          'PLAYER_NAME', 'FGM', 'FGA', 'FG_PCT',
                                                          'FG3M', 'FG3A', 'FG3_PCT', 'FTM', 'FTA',
                                                          'FT_PCT', 'OREB', 'DREB', 'REB', 'AST', 'STL',
                                                          'BLK', 'T_O', 'PF', 'PTS', 'PLUS_MINUS'])
        df_games_details.to_sql("player_stats", con = database_connection, if_exists = 'append', chunksize = 1000)
        print(df_games_details)
        i += 1
    elif i==2:
        df_teams = pd.DataFrame(games, columns = ['TEAM_ID', 'CITY', 'NICKNAME'])
        df_teams.to_sql("teams", con = database_connection, if_exists = 'append', chunksize = 1000)
        print(df_teams)

