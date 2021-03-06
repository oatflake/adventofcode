import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

def intToPos(i, levelWidth):
    return (i % levelWidth, i / levelWidth)

def posToInt(x, y, levelWidth):
    return x + y * levelWidth

def findIntersections(level, levelWidth, levelHeight):
    intersections = set()
    for i in range(len(level)):
        if level[i] != 46:
            pos = intToPos(i, levelWidth)
            neighbors = 0
            for j in range(-1, 2, 2):
                if 0 < pos[0] + j < levelWidth and level[posToInt(pos[0] + j, pos[1], levelWidth)] != 46:
                    neighbors += 1
            for j in range(-1, 2, 2):
                if 0 < pos[1] + j < levelHeight and level[posToInt(pos[0], pos[1] + j, levelWidth)] != 46:
                    neighbors += 1
            if neighbors >= 3:
                intersections.add(pos)
    return intersections

def constructLevel():
    level = []
    levelWidth = 0
    firstLineBreak = False
    while True:
        output = computer.execute()
        if output == None:
            break
        if output != 10:
            level.append(output)
        else:
            firstLineBreak = True
        if not firstLineBreak:
            levelWidth += 1
    return level, levelWidth

input = open("input", "r").read().strip("\n")
computer = IntcodeComputer(input)
level, width = constructLevel()
height = len(level) / width
intersections = findIntersections(level, width, height)

alignmentParameters = 0
for intersecion in intersections:
    alignmentParameters += intersecion[0] * intersecion[1]
print(alignmentParameters)
