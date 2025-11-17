
# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# 
# 

matrix = [[1,2,3], [4,5,6], [7,8,9]]
print (matrix)

flattened = [ 
    num 
    for row in matrix 
    for num in row
]

print(flattened)

#[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
#[1, 2, 3, 4, 5, 6, 7, 8, 9]