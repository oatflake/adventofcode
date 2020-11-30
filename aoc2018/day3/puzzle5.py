import sys

input = open("input", "r")
maxX = -sys.maxint - 1
maxY = -sys.maxint - 1
claims = []
for line in input:
    split = line.split(' ')
    coords = split[2].split(',')
    x = int(coords[0])
    y = int(coords[1][:-1])
    coords = split[3].split('x')
    w = int(coords[0])
    h = int(coords[1])
    maxX = max(x + w, maxX)
    maxY = max(y + h, maxY)
    claims.append((x, y, w, h))
fabric = [0] * ((maxX + 1) * (maxY + 1))
for claim in claims:
    for i in range(claim[0], claim[0] + claim[2]):
        for j in range(claim[1], claim[1] + claim[3]):
            fabric[i + j * (maxX + 1)] += 1
result = 0
for i in fabric:
    if i > 1:
        result += 1
print(result)
