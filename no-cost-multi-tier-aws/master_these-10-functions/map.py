
str = [ "my", "word", "apple", "pear", ""]

lenths = map (len, str)
#print(lenths)
print(list(lenths))

#help(map)

# lambda ananymous function

pituus = map (
    lambda x: 
    x + "s",
    str
)

print(list(pituus))

# [2, 4, 5, 4, 0]
# ['mys', 'words', 'apples', 'pears', 's']

def add_s (x):
    return x + "s"

pituus2 = map (
    add_s,
    str
)

print(list(pituus2))

numbers = [1,2,3,4]
def square(number:int):
    return number**2

print(list(map(square,numbers)))

# out:
# [2, 4, 5, 4, 0]
# ['mys', 'words', 'apples', 'pears', 's']
# ['mys', 'words', 'apples', 'pears', 's']
# [1, 4, 9, 16]