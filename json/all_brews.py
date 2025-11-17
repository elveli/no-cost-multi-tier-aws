import requests

print(f"Make a request to the API and get the first 200 breweries,\n filter these to retrieve only the brewery name and filter out all names containing a numeric character.")

max_per_page = 200
response_challenge1 = requests.get(f"http://api.openbrewerydb.org/v1/breweries?per_page={max_per_page}")

# filter these to retrieve only the brewery name and filter OUT all names containing a numeric character
breweries_without_num_char_challenge1 = [
    brewery['name'] 
    for brewery in response_challenge1.json() 
    if not any(char.isdigit() 
    for char in brewery['name'])
]

breweries_without_num_char_challenge1_sorted=sorted(breweries_without_num_char_challenge1)

print(f"Filtered Breweries (first {max_per_page}):")


for brew in breweries_without_num_char_challenge1_sorted:
    print(brew)

print()

print("Number of Brewery names without numeric chars:", len(breweries_without_num_char_challenge1))
print()

# Challenge 2
print("\nExpand the above solution to retrieve all breweries from the API")

all_breweries = []
page = 1

while True:
    response_challenge2 = requests.get(f"http://api.openbrewerydb.org/v1/breweries?per_page={max_per_page}&page={page}")
    
    breweries_challenge2 = [
        brewery['name'] 
        for brewery in response_challenge2.json() 
        if not any(char.isdigit() 
        for char in brewery['name'])
    ]

    if not breweries_challenge2:
        print(f"Finished processing all pages. {page} pages found.")
        break

    all_breweries.extend(breweries_challenge2)
    #print(f"Processed page: {page}")
    page += 1

# Get unique brewery names
unique_breweries = list(set(all_breweries))


unique_breweries_sorted = sorted(list(set(all_breweries)))

print("\nChallenge 2 - Unique Breweries (all):")
print("Number of Breweries:", len(unique_breweries))

for brew in unique_breweries_sorted:
    print(brew)
#print(unique_breweries)