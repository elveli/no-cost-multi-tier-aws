import json
import random
from datetime import datetime, timedelta

# Function to generate a random value for each attribute (customize as needed)
def generate_random_values():
    return {
        "sunset_time": random.randint(17277576, 1727757623),  # Random integer between 1 and 100
        "sunrise_time": random.randint(17277576, 1727757623),# round(random.uniform(0, 10), 2),  # Random float between 0 and 10, rounded to 2 decimals
        "value3": random.choice([True, False])  # Random boolean
    }

# Generate list of entries for each day of the year
def generate_year_data(year):
    start_date = datetime(year, 1, 1)
    year_data = []

    for i in range(365):  # Assumes non-leap year; adjust for leap years if needed
        current_date = start_date + timedelta(days=i)
        date_str = current_date.strftime("%Y-%m-%d")  # Format date as YYYY-MM-DD
        entry = {
            "date": date_str,
            **generate_random_values()  # Merge the random attribute values
        }
        year_data.append(entry)

    return year_data

# Specify the year you want data for
year = 2024
year_data = generate_year_data(year)

# Write the data to a JSON file
with open(f"year_data_{year}.json", "w") as json_file:
    json.dump(year_data, json_file, indent=2)

print(f"JSON data for the year {year} has been generated.")
