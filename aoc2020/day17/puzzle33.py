import math

def toIndex(x, y, z, n):
    return x + y * n + z * n * n

def toCoord(i, n):
    return i % n, (i // n) % n, i // (n * n)

def needsExpansion(grid, width):
    for x in range(width):
        for y in range(width):
            if grid[toIndex(x, y, 0, width)] == '#':
                return True
    for x in range(width):
        for z in range(width):
            if grid[toIndex(x, 0, z, width)] == '#':
                return True
    for y in range(width):
        for z in range(width):
            if grid[toIndex(0, y, z, width)] == '#':
                return True
    for x in range(width):
        for y in range(width):
            if grid[toIndex(x, y, width - 1, width)] == '#':
                return True
    for x in range(width):
        for z in range(width):
            if grid[toIndex(x, width - 1, z, width)] == '#':
                return True
    for y in range(width):
        for z in range(width):
            if grid[toIndex(width - 1, y, z, width)] == '#':
                return True
    return False

def initGrid(gridSlice, width):
    newGrid = ['.'] * (width * width * width)
    for x in range(width):
        for y in range(width):
            newGrid[toIndex(x, y, width // 2, width)] = gridSlice[x + y * width]
    return newGrid

def expand(grid, width):
    newWidth = width * 3
    newGrid = ['.'] * (newWidth * newWidth * newWidth)
    for x in range(width):
        for y in range(width):
            for z in range(width):
                c = grid[toIndex(x, y, z, width)]
                newGrid[toIndex(width + x, width + y, width + z, newWidth)] = c
    return newGrid, newWidth

def changeState(readGrid, i, width):
    state = readGrid[i]
    x, y, z = toCoord(i, width)
    activeNeighbors = 0
    for x1 in range(x - 1, x + 2):
        for y1 in range(y - 1, y + 2):
            for z1 in range(z - 1, z + 2):
                if x1 < 0 or x1 >= width or y1 < 0 or y1 >= width or z1 < 0 or z1 >= width:
                    continue
                if x == x1 and y == y1 and z == z1:
                    continue
                if readGrid[toIndex(x1,y1,z1,width)] == '#':
                    activeNeighbors = activeNeighbors + 1
    if state == '#':
        if activeNeighbors == 2 or activeNeighbors == 3:
            return '#'
        else:
            return '.'
    else:
        if activeNeighbors == 3:
            return '#'
        else:
            return '.'

def simulate(readGrid, width):
    writeGrid = readGrid[:]
    for i in range(6):
        if needsExpansion(readGrid, width):
            readGrid, width = expand(readGrid, width)
            writeGrid = readGrid[:]
        for i in range(len(readGrid)):
            writeGrid[i] = changeState(readGrid, i, width)
        writeGrid, readGrid = readGrid, writeGrid
    count = 0
    for i in range(len(readGrid)):
        count = count + 1 if readGrid[i] == '#' else count
    return count

def main():
    input = open("input", "r")
    width = 0
    gridSlice = ""
    for line in input:
        line = line.strip()
        width = len(line)
        gridSlice += line
    gridSlice = list(gridSlice)
    grid = initGrid(gridSlice, width)
    print simulate(grid, width)

main()
