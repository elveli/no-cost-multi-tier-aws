# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# 
options = [ "any", "apple", "world", "", "hello", "albany"]


valid_strings = [
    string
    for string in options
    if len(string) >= 2
    if string[0] == "a"
    if string[-1] == "y"
]

print(valid_strings)