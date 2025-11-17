
import json,os,sys #,certifi
#import requests
import pprint
from opencage.geocoder import OpenCageGeocode
from pprint import PrettyPrinter

printer = PrettyPrinter()

def enter_city(number):
    is_alpha = lambda s: s.isalpha()
    contains_space = lambda s: ' ' in s
    city = input(f"Enter name of city {number}: ")
    if is_alpha(city) or contains_space(city): # city names needs to contain letters or can have spaces.
        return city
    else:
        print(f"City name {city} contains non-letter chars.")
        exit(1)

def get_latitude(results, city):
    if results and len(city):
        latitude = results[0]['geometry']['lat']
        return latitude
    else:
        sys.stderr.write("City not found: %s\n" % city)
        exit(1)

def main():
    key = os.getenv('OPENCAGE_KEY')
    #print(key)

    if not key:
        print("Opencage API key is missing. Please set the OPENCAGE_KEY environment variable.")
        exit(1)

    city1 = enter_city(1)
    city2 = enter_city(2)

    geocoder = OpenCageGeocode(key)

    results_city1 = geocoder.geocode(city1)
    results_city2 = geocoder.geocode(city2)

    # printer.pprint(results_city1)
    #printer.pprint(results_city2)

    lat_city1 = get_latitude(results_city1, city1)
    lat_city2 = get_latitude(results_city2, city2)
    #print(lat_city1,lat_city2)

    more_northern = city1 if lat_city1 > lat_city2 else city2

    each_degree_of_latitude = 111 # km
    lat_difference = abs(lat_city1 - lat_city2) * each_degree_of_latitude

    print(f"City {more_northern} is more northern. Latitude difference between {city1} and {city2} is {lat_difference:.2f} km.")

if __name__ == "__main__":
    main()


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