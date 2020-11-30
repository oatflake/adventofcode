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

# compute manhatten distances to points, store min in grid
width = maxX - minX + 1
height = maxY - minY + 1
grid = [0] * (width * height)
for i in range(len(grid)):
    x = (i % width) + minX
    y = (i // width) + minY
    closestPoint = -1
    minDist = sys.maxsize
    sameDist = False
    for j in range(len(points)):
        p = points[j]
        dist = abs(x - p[0]) + abs(y - p[1])
        if dist == minDist:
            sameDist = True
        if dist < minDist:
            minDist = dist
            closestPoint = j
            sameDist = False
    grid[i] = -1 if sameDist else closestPoint

# compute areas
areas = [0] * len(points)
for cell in grid:
    if cell != -1:
        areas[cell] += 1
for i in range(width):
    if grid[i + 0 * width] != -1:
        areas[grid[i + 0 * width]] = -1
    if grid[i + (height - 1) * width] != -1:
        areas[grid[i + (height - 1) * width]] = -1
for i in range(height):
    if grid[0 + i * width] != -1:
        areas[grid[0 + i * width]] = -1
    if grid[(width - 1) + i * width] != -1:
        areas[grid[(width - 1) + i * width]] = -1

# find largest area
maxArea = -1
maxID = -1
for i in range(len(areas)):
    if areas[i] > maxArea:
        maxArea = areas[i]
        maxID = i
print(maxArea)
