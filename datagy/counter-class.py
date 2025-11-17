# https://www.youtube.com/watch?v=Lmsz6h25yiA&list=PLYt6YwKmonu3YiFvjO4Wf5jXJzNCxurrq

from collections import Counter

counts = Counter()
print(counts)

str = "djfhlskdjfhlskdjhfwoerhpweor kjhsdlfkjhl ;woerh;weoriu; oiuwe;ro iuwe;roi u"

counts_dict = {}

for i in str:
    if i in counts_dict:
        counts_dict[i] += 1
    else:
        counts_dict[i] = 1

print(counts_dict)
# {'d': 4, 'j': 5, 'f': 4, 'h': 7, 'l': 4, 's': 3, 'k': 4, 'w': 6, 'o': 7, 'e': 6, 'r': 6, 'p': 1, ' ': 5, ';': 5, 'i': 4, 'u': 4}

counts = Counter(str)
print(counts)
# Counter({'h': 7, 'o': 7, 'w': 6, 'e': 6, 'r': 6, 'j': 5, ' ': 5, ';': 5, 'd': 4, 'f': 4, 'l': 4, 'k': 4, 'i': 4, 'u': 4, 's': 3, 'p': 1})

c_lists = Counter([1,2,3,4,555,555,6])
print(c_lists)
# Counter({555: 2, 1: 1, 2: 1, 3: 1, 4: 1, 6: 1})

c_tuples = Counter((1,2,999,4,555,999,6))
print(c_tuples)
# Counter({999: 2, 1: 1, 2: 1, 4: 1, 555: 1, 6: 1})


strings = [ "apple", "banana", "apple", "orange", "carrot", "apple", "banana"]

str_c = Counter(strings)
print(str_c)
# Counter({'apple': 3, 'banana': 2, 'orange': 1, 'carrot': 1})

print(str_c['banana'])
# 2

print(str_c.get('banana'))
# 2

print(str_c.most_common(1))
# [('apple', 3)]

print(str_c.most_common()[0][0])
# apple

print(str_c.most_common()[-1][0])
# carrot

str_c.update(['carrot', 'carrot'])
print(str_c)
# Counter({'apple': 3, 'carrot': 3, 'banana': 2, 'orange': 1})

strings2 = [ "cat", "dog", "cow", "bat", "bat", "lion", "snake", "carrot"]
str_c2 = Counter(strings2)

total = str_c + str_c2
print(total)
Counter({'apple': 3, 'carrot': 3, 'banana': 2, 'bat': 2, 'orange': 1, 'cat': 1, 'dog': 1, 'cow': 1, 'lion': 1, 'snake': 1})

str_c = Counter(strings)

print(str_c & str_c2)
# Counter({'carrot': 1})

print(str_c | str_c2)
# Counter({'apple': 3, 'banana': 2, 'bat': 2, 'orange': 1, 'carrot': 1, 'cat': 1, 'dog': 1, 'cow': 1, 'lion': 1, 'snake': 1})

