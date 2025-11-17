# https://opencagedata.com/tutorials/geocode-in-python#batch
# https://opencagedata.com/tutorials/geocode-in-python#background

import os,sys
from opencage.geocoder import OpenCageGeocode
from pprint import pprint



key = os.getenv('OPENCAGE_KEY')
#print(key)
geocoder = OpenCageGeocode(key)
query = u'Bosutska ulica 10, Trnje, Zagreb, Croatia'

# no need to URI encode query, module does that for you
results = geocoder.geocode(query)

print(u'%f;%f;%s;%s' % (results[0]['geometry']['lat'],
                        results[0]['geometry']['lng'],
                        results[0]['components']['country_code'],
                        results[0]['annotations']['timezone']['name']))
