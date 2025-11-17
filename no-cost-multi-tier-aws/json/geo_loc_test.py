
import json,os
import requests
import pprint
from pprint import PrettyPrinter

printer = PrettyPrinter()

key = os.getenv('OPENCAGE_KEY')
#print(key)

if not key:
    print("API key is missing. Please set the OPENCAGE_KEY environment variable.")
    exit(1)

#url = "http://api.opencagedata.com/geocode/v1/json?key=key&q=52.3877830%2C+9.7334394&pretty=1&no_annotations=1"

#url = f"http://api.opencagedata.com/geocode/v1/json?key={key}&q=52.3877830%2C+9.7334394&pretty=1&no_annotations=1"

url = f"https://api.opencagedata.com/geocode/v1/json?q=Rua+Cafel%C3%A2ndia%2C+Carapicu%C3%ADba%2C+Brasil&key={key}&pretty=1"

response = requests.get(url)
data = json.loads(response.text)
printer.pprint(data)

# Extract the location bounds from the results
if 'results' in data and len(data['results']) > 0:
    first_result = data['results'][0]  # Access the first element of the results list
    print("in if")
    geometry = first_result.get('geometry')  # Get 'geometry' from the first result
    formatted = first_result.get('formatted')
    annotations = first_result.get('annotations')

    # if formatted:
    #     printer.pprint(formatted)

    if annotations:
        #printer.pprint(annotations)
        sunrise = annotations.get('sun')
        printer.pprint(first_result['annotations']['sun']['rise']['nautical'])
        printer.pprint(first_result['annotations']['sun']['set']['nautical'])

    if geometry:
        lat = geometry.get('lat')
        #printer.pprint(lat)
    else:
        print("Lat data is not available in the first result.")
else:
    print("No results found in the response.")

'''
$ pp geo_loc_test.py
in if
'Design Offices, Philipsbornstraße 2, 30165 Hanover, Germany'
52.387783
dict_keys(['documentation', 'licenses', 'rate', 'results', 'status', 'stay_informed', 'thanks', 'timestamp', 'total_results'])
(py_envs) ~/github/twt/json [main]
$


#{'northeast': {'lat': 52.387833, 'lng': 9.7334894},
#'southwest': {'lat': 52.387733, 'lng': 9.7333894}}
#'''

#printer.pprint(data)
#printer.pprint(data.keys())

# dict_keys(['documentation', 'licenses', 'rate', 'results', 'status', 'stay_informed', 'thanks', 'timestamp', 'total_results'])

'''
$ python3 geo_loc_test.py
http://api.opencagedata.com/geocode/v1/json?key=7c250aac0e194cc98584ca2e492cc25e&q=52.3877830%2C+9.7334394&pretty=1&no_annotations=1
{'documentation': 'https://opencagedata.com/api',
 'licenses': [{'name': 'see attribution guide',
               'url': 'https://opencagedata.com/credits'}],
 'rate': {'limit': 2500, 'remaining': 2497, 'reset': 1727395200},
 'results': [{'bounds': {'northeast': {'lat': 52.387833, 'lng': 9.7334894},
                         'southwest': {'lat': 52.387733, 'lng': 9.7333894}},
              'components': {'ISO_3166-1_alpha-2': 'DE',
                             'ISO_3166-1_alpha-3': 'DEU',
                             'ISO_3166-2': ['DE-NI'],
                             '_category': 'building',
                             '_normalized_city': 'Hanover',
                             '_type': 'building',
                             'city': 'Hanover',
                             'city_district': 'Vahrenwald-List',
                             'continent': 'Europe',
                             'country': 'Germany',
                             'country_code': 'de',
                             'county': 'Region Hannover',
                             'house_number': '2',
                             'office': 'Design Offices',
                             'political_union': 'European Union',
                             'postcode': '30165',
                             'road': 'Philipsbornstraße',
                             'state': 'Lower Saxony',
                             'state_code': 'NI',
                             'suburb': 'Vahrenwald'},
              'confidence': 10,
              'distance_from_q': {'meters': 0},
              'formatted': 'Design Offices, Philipsbornstraße 2, 30165 '
                           'Hanover, Germany',
              'geometry': {'lat': 52.387783, 'lng': 9.7334394}}],
 'status': {'code': 200, 'message': 'OK'},
 'stay_informed': {'blog': 'https://blog.opencagedata.com',
                   'mastodon': 'https://en.osm.town/@opencage'},
 'thanks': 'For using an OpenCage API',
 'timestamp': {'created_http': 'Thu, 26 Sep 2024 01:07:13 GMT',
               'created_unix': 1727312833},
 'total_results': 1}
~/github/twt/json
'''