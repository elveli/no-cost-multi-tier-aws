# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# # generator comprehension
# returns value only when needed
# does not store prev values
# gives next value

# asks for each value sequantially
# and add it to a sum that its storing internally
# generators

sum_of_squares = sum(
    x**2
    for x in range(1000000) # range of million. range numbers one by one.
)

# this is list comprehension:
# sum_of_squares = [ x**2 for x in range(1000000)  ]
# # range of million. range numbers one by one.
# print(list(sum_of_squares))

# note no list here:
print(sum_of_squares)


# returns:
# 333332833333500000