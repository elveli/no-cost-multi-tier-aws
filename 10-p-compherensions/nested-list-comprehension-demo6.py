# https://www.youtube.com/watch?v=twxE0dEp3qQ
# 
# 

import pprint
printer = pprint.PrettyPrinter()

# lst = [[[
#     num
#     for num in range(5)]
#     for _ in range (5)]
#     for _ in range(5)
# ]

# this is more readbale:

lst = [[[ num for num in range(5)] for _ in range (5)] for _ in range(5) ]

# _ anonymous variable

printer.pprint(lst)

# prints
# 5 x 5 matrix:
""" 
[[[0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]],
 [[0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]],
 [[0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]],
 [[0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]],
 [[0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]]] 
  """