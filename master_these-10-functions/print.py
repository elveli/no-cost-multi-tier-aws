
age = 23
name = "Tim"

print ("My name is", name, "and I'm", age, "years old.", sep="|")

print ("My name is", name, "and I'm", age, "years old.", sep=",")

""" My name is|Tim|and I'm|23|years old.
My name is,Tim,and I'm,23,years old. """

print ("My name is", name, end=" | ")
print("and I'm", age, "years old.")

#prints:
# My name is|Tim|and I'm|23|years old.
# My name is,Tim,and I'm,23,years old.
# My name is Tim | and I'm 23 years old.