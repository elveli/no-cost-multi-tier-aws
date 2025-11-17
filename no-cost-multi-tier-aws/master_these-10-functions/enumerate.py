tasks = [ "t1", "t2", "t3", "t4" ]

for index, task in enumerate(tasks):
    print(f"{index + 1}. {task}")

""" 
1. t1
2. t2
3. t3
4. t4 
"""

print(list(enumerate(tasks)))
# tuple
# [(0, 't1'), (1, 't2'), (2, 't3'), (3, 't4')]
