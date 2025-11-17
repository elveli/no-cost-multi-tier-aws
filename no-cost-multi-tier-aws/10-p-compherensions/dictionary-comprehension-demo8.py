# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# tuples
# dictionaty comprehension

def square(x):
    return x**2

# list of tuples

pairs = [ 
    ("a", 1),
    ("b", 2),
    ("c", 3),
]

print(pairs)
# [('a', 1), ('b', 2), ('c', 3)]

my_dict = { key+key: square(value)
           for key, value in pairs
           if value % 2 == 0
           }

print(my_dict)

#returns:
{'bb': 4}

