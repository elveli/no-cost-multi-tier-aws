# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# set

#
# removing dups from a list while applying a function
#
nums = [1,2,2,3,3,3,4,4,4,4]

# set:
uniq_squares = {
    x**2 for x in nums
}

# returns set

print(uniq_squares)

# returns only unique squares
# {16, 1, 4, 9}

