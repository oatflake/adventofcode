import sys
from sets import Set

input = open("input", "r")
input = [line.strip('\n').split(',') for line in input]

paths = [Set(), Set()]
for i in range(len(input)):
    lastPosition = (0, 0)
    for j in range(len(input[i])):
        move = input[i][j]
        offset = int(move[1:])
        direction = move[:1]
        for k in range(1, offset + 1):
            if direction == "L":
                newPosition = (lastPosition[0] - k, lastPosition[1])
            elif direction == "R":
                newPosition = (lastPosition[0] + k, lastPosition[1])
            elif direction == "U":
                newPosition = (lastPosition[0], lastPosition[1] + k)
            elif direction == "D":
                newPosition = (lastPosition[0], lastPosition[1] - k)
            else:
                print "Unknown Direction"
            paths[i].add(newPosition)
        lastPosition = newPosition

pathIntersections = paths[0].intersection(paths[1])

closestDistance = sys.maxsize
for pathIntersection in pathIntersections:
    closestDistance = min(closestDistance, abs(pathIntersection[0]) + abs(pathIntersection[1]))
print closestDistance
