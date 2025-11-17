import requests

# Get API key from OpenCage
OPENCAGE_API_KEY = 'YOUR_OPENCAGE_API_KEY'
CITY = 'City_Name'  # Replace with your desired city

def get_coordinates(city):
    url = f'https://api.opencagedata.com/geocode/v1/json?q={city}&key={OPENCAGE_API_KEY}'
    response = requests.get(url)
    data = response.json()
    
    if data['total_results'] > 0:
        # Get the first result's coordinates
        lat = data['results'][0]['geometry']['lat']
        lng = data['results'][0]['geometry']['lng']
        return lat, lng
    else:
        print("City not found")
        return None

coordinates = get_coordinates(CITY)
if coordinates:
    lat, lng = coordinates
    print(f"Coordinates for {CITY}: Latitude: {lat}, Longitude: {lng}")

