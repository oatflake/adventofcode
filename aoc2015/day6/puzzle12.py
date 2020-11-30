input = open("input", "r")
grid = [[0]*1000 for i in range(1000)]
for line in input:
    coords = line.replace("turn on ", "").replace("toggle ", "").replace("turn off ", "")
    coords = coords.replace(" through ", ",")
    coords = map(int, coords.split(","))
    if line.startswith("turn on"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] += 1
    if line.startswith("toggle"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] += 2
    if line.startswith("turn off"):
        for x in range(coords[0], coords[2] + 1):
            for y in range(coords[1], coords[3] + 1):
                grid[x][y] = max(0, grid[x][y] - 1)
lights = 0
for x in range(1000):
    for y in range(1000):
        lights += grid[x][y]
print lights
