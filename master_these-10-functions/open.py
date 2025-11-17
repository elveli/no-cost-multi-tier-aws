#file = open ("text.txt", "w")
# overwrites

""" file.write("hello\n")
file.close() """

with open("test.txt", "r") as f:
    text = f.read()
    print(text)


