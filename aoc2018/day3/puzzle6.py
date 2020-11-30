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

for k in range(len(claims)):
    claim = claims[k]
    ok = True
    for i in range(claim[0], claim[0] + claim[2]):
        for j in range(claim[1], claim[1] + claim[3]):
            if fabric[i + j * (maxX + 1)] != 1:
                ok = False
    if ok:  
        print(k + 1)
