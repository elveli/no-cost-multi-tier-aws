
##functions:

# open json file

# read json entries one by one

#  Calculate the absolute differences with yesterday and tomorrow

# $ python3 sunset-sunrise-calculations.py
# The day with the biggest difference is 2024-01-02 with a difference of 15.
# ~/github/twt/json [main]
# $
 # https://api.opencagedata.com/geocode/v1/json?key=KEY&q=52.3877830%2C+9.7334394&pretty=1&no_annotations=1

# https://opencagedata.com/api

 # https://api.opencagedata.com/geocode/v1/json?q=-22.6792%2C+14.5272&key=YOUR-API-KEY&pretty=1

# def get_json_from_opencage():
# for i in range(365):
   #  get_url for each day
   #  add to list
   #  return list

# loop_over_year

# useful links
# https://opencagedata.com/api#annotations
# https://blog.opencagedata.com/post/102277416388/the-sun-also-rises-but-when-exactly

# "sun" : {
#                "rise" : {
#                   "astronomical" : 1415596380,
#                   "civil" : 1415601120,
#                   "nautical" : 1415598720
#                },
#                "set" : {
#                   "astronomical" : 1415643300,
#                   "civil" : 1415638560,
#                   "nautical" : 1415640960
#                }
#             },
# Enjoy! The full docs are on the API docs page, and as alays you can turn off annotations by setting no_annotations=1 in your query.

import json
from rich import print

json_data = "year_data_2024.json" #"sample_sunrise_data.json"

with open(json_data, "r") as file:
    json_data = json.load(file)

#print(json_data)
#print(len(json_data))

# Initialize variables to track the biggest difference
max_difference = 0
max_diff_day = None

# Loop through the data, skipping the first and last days
for i in range(1, len(json_data) - 1):
    today_value = json_data[i]['sunset_time']
    yesterday_value = json_data[i - 1]['sunset_time']
    tomorrow_value = json_data[i + 1]['sunset_time']
    
    # Calculate the absolute differences with yesterday and tomorrow
    diff_yesterday = abs(today_value - yesterday_value)
    diff_tomorrow = abs(today_value - tomorrow_value)
    
    # Calculate the total difference
    total_difference = diff_yesterday + diff_tomorrow
    
    # Check if this is the largest difference found
    if total_difference > max_difference:
        max_difference = total_difference
        max_diff_day = json_data[i]['date']

# Output the day with the largest difference
print(f"The day with the biggest difference is {max_diff_day} with a difference of {max_difference}.")

# results annotations sun rise apparent
'''


 {
   "documentation" : "https://opencagedata.com/api",
   "licenses" : [
      {
         "name" : "see attribution guide",
         "url" : "https://opencagedata.com/credits"
      }
   ],
   "rate" : {
      "limit" : 10000,
      "remaining" : 8976,
      "reset" : 1718841600
   },
   "results" : [
      {
         "annotations" : {
            "DMS" : {
               "lat" : "22\u00b0 40' 45.26256'' S",
               "lng" : "14\u00b0 31' 37.93728'' E"
            },
            "MGRS" : "33KVQ5143391910",
            "Maidenhead" : "JG77gh36gx",
            "Mercator" : {
               "x" : 1617161.042,
               "y" : -2576805.433
            },
            "OSM" : {
               "edit_url" : "https://www.openstreetmap.org/edit?way=184393212#map=16/-22.67924/14.52720",
               "note_url" : "https://www.openstreetmap.org/note/new#map=16/-22.67924/14.52720&layers=N",
               "url" : "https://www.openstreetmap.org/?mlat=-22.67924&mlon=14.52720#map=16/-22.67924/14.52720"
            },
            "UN_M49" : {
               "regions" : {
                  "AFRICA" : "002",
                  "NA" : "516",
                  "SOUTHERN_AFRICA" : "018",
                  "SUB-SAHARAN_AFRICA" : "202",
                  "WORLD" : "001"
               },
               "statistical_groupings" : [
                  "LEDC"
               ]
            },
            "callingcode" : 264,
            "currency" : {
               "alternate_symbols" : [
                  "N$"
               ],
               "decimal_mark" : ".",
               "disambiguate_symbol" : "N$",
               "format" : "%n %u",
               "html_entity" : "$",
               "iso_code" : "NAD",
               "iso_numeric" : "516",
               "name" : "Namibian Dollar",
               "smallest_denomination" : 5,
               "subunit" : "Cent",
               "subunit_to_unit" : 100,
               "symbol" : "$",
               "symbol_first" : 0,
               "thousands_separator" : ","
            },
            "flag" : "\ud83c\uddf3\ud83c\udde6",
            "geohash" : "k7fqfx67u7m1bew3kzh3",
            "qibla" : 31.02,
            "roadinfo" : {
               "drive_on" : "left",
               "road" : "Woermann Street",
               "road_type" : "residential",
               "speed_in" : "km/h"
            },
            "sun" : {
               "rise" : {
                  "apparent" : 1718775720,
                  "astronomical" : 1718770920,
                  "civil" : 1718774220,
                  "nautical" : 1718772600
               },
               "set" : {
                  "apparent" : 1718814300,
                  "astronomical" : 1718819100,
                  "civil" : 1718815740,
                  "nautical" : 1718817420
               }
            },
            "timezone" : {
               "name" : "Africa/Windhoek",
               "now_in_dst" : 0,
               "offset_sec" : 7200,
               "offset_string" : "+0200",
               "short_name" : "CAT"
            },
            "what3words" : {
               "words" : "outsmarted.cheering.chemical"
            }
         },
         "bounds" : {
            "northeast" : {
               "lat" : -22.6791681,
               "lng" : 14.5277944
            },
            "southwest" : {
               "lat" : -22.6793015,
               "lng" : 14.5266951
            }
         },
         "components" : {
            "ISO_3166-1_alpha-2" : "NA",
            "ISO_3166-1_alpha-3" : "NAM",
            "ISO_3166-2" : [
               "NA-ER"
            ],
            "_category" : "road",
            "_normalized_city" : "Swakopmund",
            "_type" : "road",
            "city" : "Swakopmund",
            "continent" : "Africa",
            "country" : "Namibia",
            "country_code" : "na",
            "postcode" : "13001",
            "road" : "Woermann Street",
            "road_type" : "residential",
            "state" : "Erongo Region",
            "suburb" : "Central"
         },
         "confidence" : 9,
         "distance_from_q" : {
            "meters" : 4
         },
         "formatted" : "Woermann Street, Swakopmund 13001, Namibia",
         "geometry" : {
            "lat" : -22.6792396,
            "lng" : 14.5272048
         }
      }
   ],
   "status" : {
      "code" : 200,
      "message" : "OK"
   },
   "stay_informed" : {
      "blog" : "https://blog.opencagedata.com",
      "mastodon" : "https://en.osm.town/@opencage"
   },
   "thanks" : "For using an OpenCage API",
   "timestamp" : {
      "created_http" : "Wed, 19 Jun 2024 11:03:55 GMT",
      "created_unix" : 1718795035
   },
   "total_results" : 1
}

'''