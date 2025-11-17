from rich.console import Console
from rich.json import JSON
from rich import print

console = Console()

data = '{"name": "Alice", "age": 25, "active": true}'
json_data = JSON(data)
#print(type(json_data))

console.print(json_data)
print(json_data)

'''
$ python3 rich-printing.py
{
  "name": "Alice",
  "age": 25,
  "active": true
}
{
  "name": "Alice",
  "age": 25,
  "active": true
}
~/github/twt/json [main]
$
'''