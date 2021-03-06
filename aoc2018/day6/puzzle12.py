import sys

input = open("input", "r")
points = []
for line in input:
    coords = line.split(", ")
    points.append((int(coords[0]), int(coords[1])))

# compute bounding area
minX = sys.maxsize
maxX = -sys.maxsize - 1
minY = sys.maxsize
maxY = -sys.maxsize - 1
for p in points:
    minX = min(minX, p[0])
    maxX = max(maxX, p[0])
    minY = min(minY, p[1])
    maxY = max(maxY, p[1])

# compute manhatten distances to points, compute area
width = maxX - minX + 1
height = maxY - minY + 1
area = 0
for i in range(width * height):
    x = (i % width) + minX
    y = (i // width) + minY
    sumDist = 0
    for j in range(len(points)):
        p = points[j]
        sumDist += abs(x - p[0]) + abs(y - p[1])
    area += 1 if sumDist < 10000 else 0
print(area)
