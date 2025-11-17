# https://www.youtube.com/watch?v=nrN3Gq1A92Y

coordinate = [4,10]
larger_coordinate = [1,2,3]

list_of_pairs = [[ "A", "B"], ["C", "D"],[ "E", "F" ]]

for _ in range(2):
    print("foo")

x, _ = coordinate
print(x,_)

second_elements = [ b for _,b in list_of_pairs]
print(second_elements)
# out
# ['B', 'D', 'F']

for i,j in list_of_pairs:
    print(i,j)
    # out
    # A B
    # C D
    # E F