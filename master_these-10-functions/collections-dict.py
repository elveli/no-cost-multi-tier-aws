# https://www.youtube.com/watch?v=zPfSwhofPpk

from collections import defaultdict

words = [ "apple", "banana", "apple", "orange", "carrot", "apple", "banana"]
         
word_count = defaultdict(int)
print(list(word_count)) # out: []

for w in words:
    word_count[w] += 1
    print(dict(word_count)) 
    '''
    Looping:
    {'apple': 1}
    {'apple': 1, 'banana': 1}
    {'apple': 2, 'banana': 1}
    {'apple': 2, 'banana': 1, 'orange': 1}
    {'apple': 2, 'banana': 1, 'orange': 1, 'carrot': 1}
    {'apple': 3, 'banana': 1, 'orange': 1, 'carrot': 1}
    {'apple': 3, 'banana': 2, 'orange': 1, 'carrot': 1}
    {'apple': 3, 'banana': 2, 'orange': 1, 'carrot': 1}
'''

print(dict(word_count))
# out {'apple': 3, 'banana': 2, 'orange': 1, 'carrot': 1}

def def_func():
    return 20

word_count2 = defaultdict(def_func)
print(word_count2[0]) #out: 20

letters = defaultdict(int)
print(dict(letters)) # out: {}

for letter in "Mississippi":
    letters[letter] += 1
    print(dict(letters)) 
    '''
    Looping out:
    {'M': 1}
    {'M': 1, 'i': 1}
    {'M': 1, 'i': 1, 's': 1}
    {'M': 1, 'i': 1, 's': 2}
    {'M': 1, 'i': 2, 's': 2}
    {'M': 1, 'i': 2, 's': 3}
    {'M': 1, 'i': 2, 's': 4}
    {'M': 1, 'i': 3, 's': 4}
    {'M': 1, 'i': 3, 's': 4, 'p': 1}
    {'M': 1, 'i': 3, 's': 4, 'p': 2}
    {'M': 1, 'i': 4, 's': 4, 'p': 2}
    {'M': 1, 'i': 4, 's': 4, 'p': 2}
    
    '''

print(dict(letters))
# out {'M': 1, 'i': 4, 's': 4, 'p': 2}

