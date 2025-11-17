# filter
# it will take all itmes in the iterable object
# then pass it to a compatible function

def longer_than_4(str1):
    return len(str1) > 4

str = [ "my", "word", "apple", "pear", ""]

filtered = filter(longer_than_4, str)
print(list(filtered))
# out
# ['apple']

filtered2 = filter(
    lambda x: 
    len(x) > 4, 
    str
    )

print(list(filtered2))
# out
# ['apple']

list_nums = [1,2.0,4,5.0]

def check_ints(number):
    if type(number) == int:
        return True
    else:
        return False

print(list(filter(check_ints,list_nums)))

# same with lambda
print(list
      (filter(
          lambda x:
          type(x) == int,
          list_nums
      )
    )
)