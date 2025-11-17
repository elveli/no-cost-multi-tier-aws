#https://www.youtube.com/watch?v=CnbgMnUCsUM
# 

from random import choice, choices, sample

names = [ i for i in range(10000)]

winner = choice(names)
print(winner)

winners = sample(names, k=7)
print(winners)

'''
7326
[3207, 3408, 6558, 8786, 2445, 6105, 8803]

'''