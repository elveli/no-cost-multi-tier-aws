# https://www.youtube.com/watch?v=MXQN6nnEwOU&t=22s

values = [1,2,3,4,5,6,7,8,9,10]

def only_even(x):
    return x % 2 == 0

evens = list(
    filter(
        only_even,
        values
    )
)

print (evens)
# [2, 4, 6, 8, 10]

# or

evens2 = list(
    filter(
        lambda x: x % 2 == 0,
        values
    )
)

print (evens2)
# [2, 4, 6, 8, 10]

greater_than_5 = list(
    filter(
        lambda x: x > 5,
        values
    )
)

print (greater_than_5)
# [6, 7, 8, 9, 10]

strings = [ "apple", "banana", "apple", "orange", "carrot", "apple", "banana"]

filtered = list(filter(lambda x: len(x) > 5, strings))
print(filtered)
#
# ['banana', 'orange', 'carrot', 'banana']

ages = [
    { 'name': 'p1', 'age': 25 },
    { 'name': 'p2', 'age': 55 },
    { 'name': 'p3', 'age': 66 },
    { 'name': 'p4', 'age': 77 },
    { 'name': 'p5', 'age': 88 },
    { 'name': 'p6'}
]

filtered = list (filter(lambda x: x.get('age',0) > 67, ages))
print(filtered)
#
# [{'name': 'p4', 'age': 77}, {'name': 'p5', 'age': 88}]

sales = [
    ( '2022-08-06', 100),
    ( '2022-098-06', 11),
    ( '2022-09-06', 11100),
    ( '2022-05-06', 333),
]

filtered = list (filter(lambda x: x[1] > 200, sales))
print(filtered)

#
# [('2022-09-06', 11100), ('2022-05-06', 333)]

