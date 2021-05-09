import sys
import math
import heapq

class Bot:
    def __init__(self, coord, radius):
        self.radius = radius
        self.coord = coord

def readInput():
    input = open("input", "r")
    bots = []
    for line in input:
        line = line[len("pos=<"):]
        line = line.split(">, r=")
        coord = line[0].split(",")
        coord = [int(c) for c in coord]
        radius = int(line[1])
        bots.append(Bot(coord, radius))
    return bots

def rootBoxSize(bots):
    minCoords, maxCoords = [sys.maxint] * 3, [-sys.maxint - 1] * 3
    for bot in bots:
        for i in range(3):
            minCoords[i] = min(minCoords[i], bot.coord[i] - bot.radius)
            maxCoords[i] = max(maxCoords[i], bot.coord[i] + bot.radius)
    size = max(abs(min(minCoords)), abs(max(maxCoords)))
    return pow(2, math.ceil(math.log(size, 2)))

def distance(coord1, coord2):
    dist = 0
    for i in range(3):
        dist += abs(coord1[i] - coord2[i])
    return dist

def clamp(x, a, b):
    return max(a, min(x, b))

def intersects(botCoord, botRange, boxCoord, boxSize):
    c = [clamp(botCoord[i], boxCoord[i] - boxSize, boxCoord[i] + boxSize) for i in range(3)]
    return distance(c, botCoord) <= botRange

def search(bots):
    # idea: perform some sort of voxelization of distance fields by subdividing space
    # but instead of finding all voxels, home in on the one within range of most bots (and closest to the origin)
    queue = [(-len(bots), rootBoxSize(bots), 0, [0, 0, 0])]
    while True:
        numBots, boxSize, distanceToOrigin, boxCoord = heapq.heappop(queue)
        if boxSize < 1:
            return numBots, boxSize, distanceToOrigin, boxCoord
        childSize = boxSize / 2
        for i in range(-1, 2, 2):
            for j in range(-1, 2, 2):
                for k in range(-1, 2, 2):
                    childCoord = [boxCoord[0] + childSize * i, boxCoord[1] + childSize * j, boxCoord[2] + childSize * k]
                    botsInRange = 0
                    for bot in bots:
                        if intersects(bot.coord, bot.radius, childCoord, childSize):
                            botsInRange += 1
                    childDistanceToOrigin = abs(childCoord[0]) + abs(childCoord[1]) + abs(childCoord[2])
                    heapq.heappush(queue, (-botsInRange, childSize, childDistanceToOrigin, childCoord))
    return -1

def main():
    bots = readInput()
    numBots, boxSize, distanceToOrigin, boxCoord = search(bots)
    # didn't quite work, we get some voxel with an offset of .5
    # but the surrounding points seem promising
    maxInRange = -1
    result = None
    for x in range(-1, 2, 2):
        for y in range(-1, 2, 2):
            for z in range(-1, 2, 2):
                c = [boxCoord[0] + x * .5, boxCoord[1] + y * .5, boxCoord[2] + z * .5]
                inRange = 0
                for bot in bots:
                    if distance(bot.coord, c) <= bot.radius:
                        inRange += 1
                if inRange > maxInRange:
                    maxInRange = inRange
                    result = c
    print int(abs(result[0]) + abs(result[1]) + abs(result[2]))
    
main()