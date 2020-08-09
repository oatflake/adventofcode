gridSerial = 3031 # input
gridSize = 300

def powerLevel(x, y):
    rackID = x + 10
    powerLevel = rackID * y
    powerLevel += gridSerial
    powerLevel *= rackID
    return int(str(powerLevel)[-3]) - 5

grid = [0] * (gridSize * gridSize)
for i in range(gridSize):
    for j in range(gridSize):
        grid[i + gridSize * j] = powerLevel(i, j)
for i in range(gridSize - 2):
    for j in range(gridSize):
        for k in range(1, 3):
            grid[i + gridSize * j] += grid[(i + k) + gridSize * j]

for i in range(gridSize):
    for j in range(gridSize - 2):
        for k in range(1, 3):
            grid[i + gridSize * j] += grid[i + gridSize * (j + k)]

maxPower = -100
index = 0
for i in range(gridSize * gridSize):
    if grid[i] > maxPower:
        index = i
        maxPower = grid[i]
print index % gridSize, index / gridSize
