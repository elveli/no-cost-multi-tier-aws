
words = [ "apple", "banana", "apple", "orange", "carrot", "apple", "banana"]

i = 0

while i < len(words):
    word = words[i]

    if word == "carrot":
        print("Carrot found")
        break

    i += 1
else:
    print ("Carrot not found")
