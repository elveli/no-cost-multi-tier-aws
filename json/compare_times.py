from datetime import datetime
from rich import print

# Example datetime strings
datetime_str1 = "2024-09-27 14:30:00"  # 2:30 PM
datetime_str2 = "2024-10-01 09:45:00"  # 9:45 AM

# Convert strings to datetime objects
datetime1 = datetime.strptime(datetime_str1, "%Y-%m-%d %H:%M:%S")
datetime2 = datetime.strptime(datetime_str2, "%Y-%m-%d %H:%M:%S")

# Extract time components
time1 = datetime1.time()
time2 = datetime2.time()


print(time1,"\n",time2)

# Compare the times
if time1 < time2:
    print(f"{time1} is earlier in the day than {time2}")
elif time1 > time2:
    print(f"{time1} is later in the day than {time2}")
else:
    print(f"{time1} is the same as {time2}")

'''
$ python3 compare_times.py
14:30:00
 09:45:00
14:30:00 is later in the day than 09:45:00
~/github/twt/json [main]
$
'''