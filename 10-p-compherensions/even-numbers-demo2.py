# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# 
evens = []

for number in range(50):
    is_even = number % 2 == 0
    if is_even:
        evens.append(number)
        #print(evens)

evens = [ number for number in range(50) if number % 2 == 0]
print(evens)