import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

input = open("input", "r").read().strip("\n")
computer = IntcodeComputer(input)

panels = dict()
orientations = [(0, 1), (1, 0), (0, -1), (-1, 0)]
direction = 0
position = (0, 0)
computer.addInput(1)
waitForFirstOutput = True

while True:
    output = computer.execute()
    if output == None:
        break
    if waitForFirstOutput:
        panels[position] = output
    else:
        direction = (direction + output * 2 - 1) % 4
        offset = orientations[direction]
        position = (position[0] + offset[0], position[1] + offset[1])
        computer.addInput(panels[position] if position in panels else 0)
    waitForFirstOutput = not waitForFirstOutput

width = max(map(lambda a: a[0], panels.keys()))
height = -min(map(lambda a: a[1], panels.keys()))

grid = [["."] * (width + 1) for i in range(height + 1)]
for key in panels.keys():
    grid[key[1] + height][key[0]] = "#" if panels[key] == 1 else "."
for i in range(len(grid) - 1, -1, -1):
    line = grid[i]
    print("".join(line))
