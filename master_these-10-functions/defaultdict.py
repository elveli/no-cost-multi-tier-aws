# https://www.youtube.com/watch?v=zPfSwhofPpk
# 

from collections import defaultdict

words = [ "any all", "apple orange", "apple", "world", "world", "", "hello", "albany"]

word_count = defaultdict(int)
#print(word_count)

for word in words:
    word_count[word] +=1

print(list(word_count))

# list out
# ['any all', 'apple orange', 'apple', 'world', '', 'hello', 'albany']

# dict out:
# {'any all': 1, 'apple orange': 1, 'apple': 1, 'world': 2, '': 1, 'hello': 1, 'albany': 1}

