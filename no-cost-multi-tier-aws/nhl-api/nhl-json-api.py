# https://github.com/techwithtim/3-Mini-Python-Projects-For-Intermediates/blob/main/nba-scores.py
# https://www.youtube.com/watch?v=NpmFbWO6HPU

#from requests import get
import requests
from pprint import PrettyPrinter

BASE_URL = "https://api-web.nhle.com"
ALL_JSON = "/v1/scoreboard/tor/now"
# https://api-web.nhle.com/v1/scoreboard/tor/now

printer = PrettyPrinter()

# 
# #         BASE_URL + stats).json()['league']['standard']['regularSeason']['teams']

#python dictionary
data = requests.get(BASE_URL + ALL_JSON, verify=False).json()['gamesByDate']

#['gamesByDate']#['date']['games']
#printer.pprint(data.keys())
#printer.pprint(data)


# dict_keys(['focusedDate', 'focusedDateCount', 'clubTimeZone', 'clubUTCOffset', 'clubScheduleLink', 'gamesByDate'])

# https://www.youtube.com/watch?v=NpmFbWO6HPU&list=PLTl90bQPNvmP-adXe1JTZlx6opDAc_CFI&index=23


for game in data:
    printer.pprint(game.keys()) # dict_keys(['date', 'games'])
    #home_team = game['homeTeam']
    #away_team = game['awayTeam']
    dates = game['date']
    games = game['games']
    #printer.pprint(away_team['gameScheduleState'])
    printer.pprint(dates)
    printer.pprint(games)
    break

#     $ python3 nhl_scores.py
# focusedDate
# focusedDateCount
# clubTimeZone
# clubUTCOffset
# clubScheduleLink
# gamesByDate


# keys:
# dict_keys(['focusedDate', 'focusedDateCount', 'clubTimeZone', 'clubUTCOffset', 
# 'clubScheduleLink', 'gamesByDate'])

#     games = get(BASE_URL + scoreboard).json()['games']




# def get_links():
#     data = get(BASE_URL + ALL_JSON).json()
#     links = data['links']
#     return links


# def get_scoreboard():
#     scoreboard = get_links()['currentScoreboard']
#     games = get(BASE_URL + scoreboard).json()['games']

#     for game in games:
#         home_team = game['homeTeam']
#         away_team = game['awayTeam']
#         clock = game['clock']
#         period = game['period']

#         print("------------------------------------------")
#         print(f"{home_team['triCode']} vs {away_team['triCode']}")
#         print(f"{home_team['score']} - {away_team['score']}")
#         print(f"{clock} - {period['current']}")


# def get_stats():
#     stats = get_links()['leagueTeamStatsLeaders']
#     teams = get(
#         BASE_URL + stats).json()['league']['standard']['regularSeason']['teams']

#     teams = list(filter(lambda x: x['name'] != "Team", teams))
#     teams.sort(key=lambda x: int(x['ppg']['rank']))

#     for i, team in enumerate(teams):
#         name = team['name']
#         nickname = team['nickname']
#         ppg = team['ppg']['avg']
#         print(f"{i + 1}. {name} - {nickname} - {ppg}")


# get_stats()