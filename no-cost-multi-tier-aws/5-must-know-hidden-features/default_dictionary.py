# https://www.youtube.com/watch?v=nrN3Gq1A92Y

from collections import defaultdict

def defaultfunc():
    return 0

#char_count = defaultdict(int)

# or
char_count = defaultdict(defaultfunc)

string = "aaaaaabbbbbcccdddddeeeeeffffffggg"

for char in string:
    char_count[char] += 1
    #print(char, char_count[char])

print(char_count)
# out
# defaultdict(<function defaultfunc at 0x1041e4280>, 
# {'a': 6, 'b': 5, 'c': 3, 'd': 5, 'e': 5, 'f': 6, 'g': 3})