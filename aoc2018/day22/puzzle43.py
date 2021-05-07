from enum import Enum

class RegionType(Enum):
    ROCKY = 0
    WET = 1
    NARROW = 2

def readInput():
    input = open("input")
    input = input.read().split("\n")
    depth = int(input[0].split(": ")[1])
    target = input[1].split(": ")[1].split(",")
    target = (int(target[0]), int(target[1]))
    return depth, target 

def erosionLevel(geologicIndex, depth):
    return (geologicIndex + depth) % 20183

def geologicIndices(width, height, depth):
    indices = [0] * (width * height)
    for x in range(1, width):
        indices[x] = x * 16807
    for y in range(1, height):
        indices[y * width] = y * 48271
    for y in range(1, height):
        for x in range(1, width):
            e1 = erosionLevel(indices[(x - 1) + y * width], depth)
            e2 = erosionLevel(indices[x + (y - 1) * width], depth)
            indices[x + y * width] = e1 * e2
    indices[width - 1 + (height - 1) * width] = 0
    return indices

def level(depth, target):
    width = target[0] + 1
    height = target[1] + 1
    indices = geologicIndices(width, height, depth)
    regions = [None] * (width * height)
    for i in range(width * height):
        regions[i] = RegionType(erosionLevel(indices[i], depth) % 3)
    return regions

def risk(regions):
    sum = 0
    for region in regions:
        sum += region.value
    return sum

def main():
    depth, target = readInput()
    regions = level(depth, target)
    print risk(regions)

main()