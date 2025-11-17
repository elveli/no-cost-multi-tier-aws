# https://www.youtube.com/watch?v=u3T7hmLthUU&t=1162s
# yield example

def f(x):
    for i in range(x):
        #print (i)
        yield i

def gen():
    print("in gen() function")
    yield 1
    print("pause 1")
    yield 2
    print("pause 2")
    yield 3
    print("pause 3")
    yield 4
    print("pause 4")





# for i in f(5):
#     print(i)

x= gen()

print(next(x))
print(next(x))
print(next(x))
print(next(x))

    