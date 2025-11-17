
rng = range(10)
print (list(rng))

rng = range(2, 10)
print (list(rng))

# help(range)
#  range(start, stop[, step]) -> range object

rng = range(2, 10,3)
print (list(rng))

rng = range(10, -10, -2)
print(list(rng))
print(rng)

# out:
'''
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
[2, 3, 4, 5, 6, 7, 8, 9]
[2, 5, 8]
[10, 8, 6, 4, 2, 0, -2, -4, -6, -8]
range(10, -10, -2)
'''