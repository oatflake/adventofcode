import sys
from sets import Set

input = open("input", "r")
input = [line.strip('\n').split(',') for line in input]

paths = [[], []]
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
            paths[i].append(newPosition)
        lastPosition = newPosition

pathIntersections = Set(paths[0]).intersection(Set(paths[1]))

closestDistance = sys.maxsize
closestIntersection = (sys.maxsize, sys.maxsize)
for pathIntersection in pathIntersections:
    distance = paths[0].index(pathIntersection) + paths[1].index(pathIntersection)
    if distance < closestDistance:
        closestDistance = distance
        closestIntersection = pathIntersection

print closestDistance + 2
