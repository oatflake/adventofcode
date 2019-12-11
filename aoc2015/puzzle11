input = open("input", "r")
grid = [[False]*1000 for i in range(1000)]
for line in input:
    coords = line.replace("turn on ", "").replace("toggle ", "").replace("turn off ", "")
    coords = coords.replace(" through ", ",")
    coords = map(int, coords.split(","))
    if line.startswith("turn on"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] = True
    if line.startswith("toggle"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] = not grid[x][y]
    if line.startswith("turn off"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] = False
lights = 0
for x in range(1000):
    for y in range(1000):
        if grid[x][y]:
            lights += 1
print lights
