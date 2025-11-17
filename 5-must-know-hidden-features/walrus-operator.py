#

def f(x):
    return x-1

# f(x) called twice
results = [f(x) for x in range(10) if f(x) >3]

print(results)
# [4, 5, 6, 7, 8]

#walrus method:

# calling function only once:
results_walrus = [ result for x in range(10) if (result := f(x)) > 3]
print(results_walrus)
# [4, 5, 6, 7, 8]
