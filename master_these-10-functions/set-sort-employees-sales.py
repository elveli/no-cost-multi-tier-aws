# Employee sales data for each day
monday = ['Tom', 'Richie', 'Talia', 'Roberto', 'Alex']
tuesday = ['Aaron', 'Megan', 'Sandy', 'Richie', 'Talia']
wednesday = ['Aaron', 'Talia', 'Megan', 'Rufus', 'Xavier']
thursday = ['Aaron', 'Alex', 'Talia', 'Javier', 'Sandy']
friday = ['Richie', 'Sandy', 'Javier', 'Sandy', 'Talia']

# Task 1: Create a list of all employee names (with each name only appearing once)
all_employees = set(
    monday +
    tuesday + 
    wednesday + 
    thursday + 
    friday
)
zip_all = zip(monday,tuesday,wednesday,thursday,friday)

# zip
#print(list(zip_all))
# [('Tom', 'Aaron', 'Aaron', 'Aaron', 'Richie'), ('Richie', 'Megan', 'Talia', 'Alex', 'Sandy'), ('Talia', 'Sandy', 'Megan', 'Talia', 'Javier'), ('Roberto', 'Richie', 'Rufus', 'Javier', 'Sandy'), ('Alex', 'Talia', 'Xavier', 'Sandy', 'Talia')]

# set:
# print(all_employees)
# out
# {'Sandy', 'Aaron', 'Alex', 'Rufus', 'Xavier', 'Roberto', 'Richie', 'Javier', 'Talia', 'Tom', 'Megan'}

# Task 2: Sort the list alphabetically
sorted_employees = sorted(all_employees)

# Task 3: Create a new list to determine the name of the employee and the number of days they had a sale
employee_sales_count = []
for employee in sorted_employees:
    print(employee)
    days_with_sale = [
        day for day in [monday, tuesday, wednesday, thursday, friday] 
        if employee in day
    ]

    employee_sales_count.append((employee, 
                                 len(days_with_sale)))

# Print the results
print("All Employee Names (with each name appearing once):")

# print(sorted_employees)
# out
# ['Aaron', 'Alex', 'Javier', 'Megan', 'Richie', 'Roberto', 'Rufus', 'Sandy', 'Talia', 'Tom', 'Xavier']

#print (employee_sales_count)
# <class 'list'>
# out
# [('Aaron', 3), ('Alex', 2), ('Javier', 2), ('Megan', 2), ('Richie', 3), ('Roberto', 1), ('Rufus', 1), ('Sandy', 3), ('Talia', 5), ('Tom', 1), ('Xavier', 1)]

print("\n*** Employee Sales Count: ***")

for employee, count in employee_sales_count:
    print(f"{employee}: {count} days")