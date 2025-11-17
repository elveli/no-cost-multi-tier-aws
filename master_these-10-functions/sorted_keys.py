people = [
    { "name": "Alice", "age": 10 },
    { "name": "Alice2", "age": 100 },
    { "name": "Alice3", "age": 1000 },
    { "name": "Alice4", "age": 10000 }
]

sorted_ppl = sorted(people, key=lambda person: person["age"], reverse=True)
print(sorted_ppl)

""" 
[{'name': 'Alice', 'age': 10}, {'name': 'Alice2', 'age': 100}, {'name': 'Alice3', 'age': 1000}, {'name': 'Alice4', 'age': 10000}]
~/git/twt/master_these-10-functions  



[{'name': 'Alice4', 'age': 10000}, {'name': 'Alice3', 'age': 1000}, {'name': 'Alice2', 'age': 100}, {'name': 'Alice', 'age': 10}]
~/git/twt/master_these-10-functions  
"""