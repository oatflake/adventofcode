import sys

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
maxPower = -sys.maxint - 1
maxIndex = 0
maxSize = 1
for i in range(gridSize * gridSize):
    if grid[i] > maxPower:
        maxIndex = i
        maxPower = grid[i]

summedGrid = grid[:]
for s in range(1, 300):
    for j in range(gridSize - s):
        for i in range(gridSize):
            summedGrid[i + gridSize * j] = grid[i + gridSize * j] + summedGrid[i + gridSize * (j + 1)]
    for j in range(gridSize - s):
        sum = 0
        for i in range(s + 1):
            sum += summedGrid[i + gridSize * j]
        for i in range(gridSize - s):
            tmp = summedGrid[i + gridSize * j]
            #print sum
            if sum > maxPower:
                maxIndex = i + gridSize * j
                maxPower = sum
                maxSize = s
            sum += summedGrid[i + s + 1 + gridSize * j] - tmp
print maxIndex % gridSize, maxIndex / gridSize, maxSize + 1
