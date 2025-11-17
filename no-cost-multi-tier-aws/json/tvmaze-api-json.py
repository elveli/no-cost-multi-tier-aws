# https://www.youtube.com/watch?v=q30GEwUe5gY
# 

import json
import requests
import pprint
from pprint import PrettyPrinter

printer = PrettyPrinter()

url = "http://api.tvmaze.com/singlesearch/shows"
show = input("Please input a show name: ")

params = { "q": show}

response = requests.get(url,params)
data = json.loads(response.text)

name = data['name']
premiered = data['premiered']
summary = data['summary']
network = data['network']['name']

# 'network': {'country': {'code': 'US',
#                          'name': 'United States',
#                          'timezone': 'America/New_York'},
#              'id': 8,
#              'name': 'HBO',

print(f"{name} premiered on {premiered} on {network}. It summary is {summary}")
#printer.pprint(data)

'''
$ 
{'_links': {'previousepisode': {'href': 'https://api.tvmaze.com/episodes/1079686',
                                'name': 'Latching'},
            'self': {'href': 'https://api.tvmaze.com/shows/139'}},
 'averageRuntime': 30,
 'dvdCountry': None,
 'ended': '2017-04-16',
 'externals': {'imdb': 'tt1723816', 'thetvdb': 220411, 'tvrage': 30124},
 'genres': ['Drama', 'Romance'],
 'id': 139,
 'image': {'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/31/78286.jpg',
           'original': 'https://static.tvmaze.com/uploads/images/original_untouched/31/78286.jpg'},
 'language': 'English',
 'name': 'Girls',
 'network': {'country': {'code': 'US',
                         'name': 'United States',
                         'timezone': 'America/New_York'},
             'id': 8,
             'name': 'HBO',
             'officialSite': 'https://www.hbo.com/'},
 'officialSite': 'http://www.hbo.com/girls',
 'premiered': '2012-04-15',
 'rating': {'average': 6.4},
 'runtime': 30,
 'schedule': {'days': ['Sunday'], 'time': '22:00'},
 'status': 'Ended',
 'summary': '<p>This Emmy winning series is a comic look at the assorted '
            'humiliations and rare triumphs of a group of girls in their '
            '20s.</p>',
 'type': 'Scripted',
 'updated': 1704794122,
 'url': 'https://www.tvmaze.com/shows/139/girls',
 'webChannel': None,
 'weight': 97}

'''