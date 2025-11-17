from datetime import datetime, timedelta

# Function to get sunrise/sunset times from the Sunrise-Sunset API
def get_sunrise_sunset(lat, lng, date):
    url = f"https://api.sunrise-sunset.org/json?lat={lat}&lng={lng}&date={date}&formatted=0"
    #url = f"https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400"
    response = requests.get(url)
    data = response.json()
    
    if data['status'] == 'OK':
        sunrise = data['results']['sunrise']
        sunset = data['results']['sunset']
        return sunrise, sunset
    else:
        print("Error fetching sunrise/sunset data")
        return None

# Get sunrise and sunset for each day of the year
def get_sunrise_sunset_for_year(lat, lng):
    start_date = datetime(datetime.now().year, 1, 1)
    dates = [start_date + timedelta(days=i) for i in range(365)]  # All days of the year
    
    for date in dates:
        date_str = date.strftime('%Y-%m-%d')
        sunrise, sunset = get_sunrise_sunset(lat, lng, date_str)
        print(f"Date: {date_str}, Sunrise: {sunrise}, Sunset: {sunset}")

# Example usage
#https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400
lat=36.720160
lng=-4.4203400
if coordinates:
    get_sunrise_sunset_for_year(lat, lng)

# https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400
# {
# "results": {
# "sunrise": "6:24:18 AM",
# "sunset": "5:42:22 PM",
# "solar_noon": "12:03:20 PM",
# "day_length": "11:18:04",
# "civil_twilight_begin": "5:59:35 AM",
# "civil_twilight_end": "6:07:05 PM",
# "nautical_twilight_begin": "5:29:33 AM",
# "nautical_twilight_end": "6:37:07 PM",
# "astronomical_twilight_begin": "4:59:36 AM",
# "astronomical_twilight_end": "7:07:04 PM"
# },
# "status": "OK",
# "tzid": "UTC"
# }