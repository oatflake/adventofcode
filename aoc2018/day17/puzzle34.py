import sys
from enum import Enum
sys.setrecursionlimit(5000)

def readInput():
    input = open("input", "r")
    lines = []
    minX, maxX = sys.maxint, -1
    minY, maxY = sys.maxint, -1
    for line in input:
        parts = line.strip().split(", ")
        parts0 = parts[0].split("=")
        parts1 = parts[1].split("=")[1].split("..")
        a, bmin, bmax = int(parts0[1]), int(parts1[0]), int(parts1[1])
        lines.append((parts0[0], a, bmin, bmax))
        if parts0[0] == "x":
            minX = min(minX, a)
            maxX = max(maxX, a)
            minY = min(minY, bmin)
            maxY = max(maxY, bmax)
        else:
            minY = min(minY, a)
            maxY = max(maxY, a)
            minX = min(minX, bmin)
            maxX = max(maxX, bmax)
    minX, maxX = minX - 1, maxX + 1
    size = width, height = maxX - minX + 1, maxY - minY + 1
    grid = ["."] * (width * height)
    for line in lines:
        if line[0] == "x":
            x = line[1]
            for y in range(line[2], line[3] + 1):
                x1, y1 = x - minX, y - minY
                grid[x1 + y1 * width] = "#"
        else:
            y = line[1]
            for x in range(line[2], line[3] + 1):
                x1, y1 = x - minX, y - minY
                grid[x1 + y1 * width] = "#"
    springPos = (500 - minX, 0)
    grid[springPos[0] + springPos[1] * width] = "+"
    return grid, size, springPos

class Direction(Enum):
    DOWN = 0,
    LEFT = 1,
    RIGHT = 2

def flow(grid, (width, height), (x, y), dir):
    if y == height - 1:
        return False
    i = x + (y + 1) * width
    if grid[i] == "|":
        return False
    overflow = False
    if grid[i] == ".":
        grid[i] = "~"
        overflow = flow(grid, (width, height), (x, y + 1), Direction.DOWN)
        if not overflow:
            grid[i] = "|"
            return False
    if grid[i] != ".":
        leftOverflow, rightOverflow = True, True
        if dir != Direction.RIGHT:
            l = (x - 1) + y * width
            if grid[l] != "#":
                grid[l] = "~"
                leftOverflow = flow(grid, (width, height), (x - 1, y), Direction.LEFT)
                if not leftOverflow:
                    grid[l] = "|"
        if dir != Direction.LEFT:
            r = (x + 1) + y * width
            if grid[r] != "#":
                grid[r] = "~"
                rightOverflow = flow(grid, (width, height), (x + 1, y), Direction.RIGHT)
                if not rightOverflow:
                    grid[r] = "|"
        if dir == Direction.DOWN:
            if leftOverflow and not rightOverflow:
                x1 = x - 1
                while x1 >= 0 and grid[x1 + y * width] == "~":
                    grid[x1 + (y) * width] = "|"
                    x1 -= 1
            if not leftOverflow and rightOverflow:
                x1 = x + 1
                while x1 <= width - 1 and grid[x1 + y * width] == "~":
                    grid[x1 + (y) * width] = "|"
                    x1 += 1
        return leftOverflow and rightOverflow
    return overflow

def main():
    grid, (width, height), springPos = readInput()
    flow(grid, (width, height), springPos, Direction.DOWN)
    for y in range(height):
        s = ""
        for x in range(width):
            s += grid[x + y * width]
        #print s
    print grid.count("~")

main()
