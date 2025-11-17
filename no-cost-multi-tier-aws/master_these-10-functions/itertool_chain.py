# https://www.youtube.com/watch?v=zPfSwhofPpk

from itertools import chain

list1 = [1,2,3]
list2 = ["a", "b", "c" ]

com_list = list1 + list2

#print(com_list) # Immediate and mem intensive

comb_chain = chain(list1, list2)
#print(next(comb_chain))


print(list(comb_chain))