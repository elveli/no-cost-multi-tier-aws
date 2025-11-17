# https://www.youtube.com/watch?v=zPfSwhofPpk

from collections import Counter

words = [ "apple", "banana", "apple", "orange", "carrot", "apple", "banana"]

count = Counter(words)
print(count)
# out Counter({'apple': 3, 'banana': 2, 'orange': 1, 'carrot': 1})

print(count["apple"])
# out: 3

count_most_common = Counter(words).most_common(2)
print(count_most_common)
# out: [('apple', 3), ('banana', 2)]

