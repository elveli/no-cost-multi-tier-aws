# Specify the file path and the string to remove
file_path = "example.txt"
string_to_remove = "Remove watcher:"

# Step 1: Read the contents of the file
with open(file_path, "r") as file:
    content = file.read()

# Step 2: Replace the specific string with ":"
updated_content = content.replace(string_to_remove, ":")

# Step 3: Write the updated content back to the file
with open(file_path, "w") as file:
    file.write(updated_content)
print(f"The string '{string_to_remove}' has been removed from the file.")