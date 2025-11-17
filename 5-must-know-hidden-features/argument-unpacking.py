# https://www.youtube.com/watch?v=nrN3Gq1A92Y

def numbers(a,b,c,d):
    print(a,b,c,d)

lst=[1,2,3,4]
numbers(lst[0],lst[1],lst[2],lst[3])
# 1 2 3 4

numbers(*lst)
# 1 2 3 4

lst = "okay"
numbers(*lst)
# o k a y

# * for unpacking iterable


values = {
    "key": "5",
    "target": 10
}

def parse_values(key,target):
    print(key, target)

parse_values(values["key"], values["target"])
# 5 10

parse_values(**values)
# 5 10
# ** for unpacking dictionary

