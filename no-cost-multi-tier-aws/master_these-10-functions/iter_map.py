import sys
x = [1,2,3,4,5,6,7,8,9,10]

y = map(lambda i: i**2, x)
# print (y)

# print(sys.getsizeof(x))
# print(sys.getsizeof(y))

print(next(y))
print(next(y))
print(next(y))
print(next(y))
print(next(y))
print(next(y))

print("For loops starts")

# print (list(y))

for i in y:
    print(i)
    print(next(y))