import requests
import json
from datetime import datetime, timedelta

# Function to generate all dates for a year
def generate_dates_for_year(year):
    start_date = datetime(year, 1, 1)
    end_date = datetime(year, 12, 31)
    delta = timedelta(days=1)
    while start_date <= end_date:
        yield start_date.strftime("%Y-%m-%d")
        start_date += delta

# Function to fetch JSON data for each date from the API
def fetch_data_for_dates(year):
    #api_url_template = "https://example.com/api/data?date={}"
    # https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date=2024-10-15
    api_url_template = "https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date={}"
    results = []

    # Loop over each date in the year
    for date in generate_dates_for_year(year):
        print(date)
        api_url = api_url_template.format(date)
        response = requests.get(api_url)
        
        # Check if the request was successful
        if response.status_code == 200:
            # Parse JSON response
            data = response.json()
            results.append({date: data})
        else:
            print(f"Failed to fetch data for {date}")
    
    return results

# Example usage for the year 2024
year = 2024
data_for_year = fetch_data_for_dates(year)

# Save the data to a JSON file
with open(f'data_{year}.json', 'w') as outfile:
    json.dump(data_for_year, outfile, indent=4)
