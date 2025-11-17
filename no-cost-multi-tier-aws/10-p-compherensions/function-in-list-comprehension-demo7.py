# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# 

def square(x):
    return x**2

def valid(x):
    return True

squared_numbers = [
    square(x)
    for x in range(10)
    if valid(x)
]

print(squared_numbers)
# out
# [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

