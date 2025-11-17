#
# zip(*iterables) --> A zip object yielding tuples until an input is exhausted

age = [ 1,3,5,100]
name = [ "s1", "s2", "s3", "s4", "TIM"]
gender = [ "Female", "Male", "Male" ] #minimum list of 3

combined = list(zip(name, age, gender))

print(combined, "\n\n")

for name, age, gender in combined:
    print(f"{name} is {age} yr old and is {gender}.")


"""
tuples:

[('s1', 1), ('s2', 3), ('s3', 5), ('s4', 100)] 


s1 is 1 yr old.
s2 is 3 yr old.
s3 is 5 yr old.
s4 is 100 yr old.
"""

""" 
gender:
[('s1', 1, 'Female'), ('s2', 3, 'Male'), ('s3', 5, 'Male')] 


s1 is 1 yr old and is Female.
s2 is 3 yr old and is Male.
s3 is 5 yr old and is Male. """



list_a= [1,2,3,4]
list_b = ['a','b', 'c','d','extra']

print(list_a, list_b)
zipper = zip(list_a, list_b)
print(list(zipper))

