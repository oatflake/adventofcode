from enum import Enum
import heapq

class RegionType(Enum):
    ROCKY = 0
    WET = 1
    NARROW = 2

class Tool(Enum):
    NEITHER = 1
    TORCH = 2
    CLIMBING_GEAR = 4
    
    def __lt__(self, other):
        if self.__class__ is other.__class__:
            return self.value < other.value
        return NotImplemented

def readInput():
    input = open("input")
    input = input.read().split("\n")
    depth = int(input[0].split(": ")[1])
    target = input[1].split(": ")[1].split(",")
    target = (int(target[0]), int(target[1]))
    return depth, target 

def erosionLevel(geologicIndex, depth):
    return (geologicIndex + depth) % 20183

def geologicIndices(width, height, depth, target):
    indices = [0] * (width * height)
    for x in range(1, width):
        indices[x] = x * 16807
    for y in range(1, height):
        indices[y * width] = y * 48271
    for y in range(1, height):
        for x in range(1, width):
            if (x, y) == target:
                indices[target[0] + target[1] * width] = 0
            else:
                e1 = erosionLevel(indices[(x - 1) + y * width], depth)
                e2 = erosionLevel(indices[x + (y - 1) * width], depth)
                indices[x + y * width] = e1 * e2
    return indices

def level(depth, width, height, target):
    indices = geologicIndices(width, height, depth, target)
    regions = [None] * (width * height)
    for i in range(width * height):
        regions[i] = RegionType(erosionLevel(indices[i], depth) % 3)
    return regions

def edge(currentRegion, targetRegion, equippedTool):
    if currentRegion == targetRegion:
        return (1, equippedTool)
    tool = Tool(7^((1 << currentRegion.value) + (1 << targetRegion.value)))
    return (8 if equippedTool != tool else 1, tool)

def path(visited, current):
    result = [current]
    while visited[current] != None:
        result.append(visited[current])
        current = visited[current]
    result.reverse()
    return result

def pathCost(regions, width, height, target):
    queue = []
    heapq.heappush(queue, (0, (0, 0), Tool.TORCH, None))
    visited = dict()
    deltas = [(1, 0), (0, 1), (-1, 0), (0, -1)]
    while queue:
        currentCost, (x, y), tool, parent = heapq.heappop(queue) 
        if (x, y, tool) in visited:
            continue
        visited[(x, y, tool)] = parent
        if (x, y) == target:
            #print path(visited, (x, y, tool))
            return currentCost + (7 if tool != Tool.TORCH else 0)
        currentRegion = regions[x + y * width]
        for d in deltas:
            nx, ny = x + d[0], y + d[1]
            if nx < 0 or ny < 0 or nx >= width or ny >= height:
                continue
            neighborRegion = regions[nx + ny * width]
            edgeCost, newTool = edge(currentRegion, neighborRegion, tool)
            heapq.heappush(queue, (currentCost + edgeCost, (nx, ny), newTool, (x, y, tool)))
    return "ERROR, NO PATH FOUND"

def printLevel(regions, width, height):
    for y in range(height):
        line = ""
        for x in range(width):
            if regions[x + y * width] == RegionType.ROCKY:
                line += "."
            if regions[x + y * width] == RegionType.WET:
                line += "="
            if regions[x + y * width] == RegionType.NARROW:
                line += "|"
        print line

def main():
    depth, target = readInput()
    width, height = target[0] * 2, target[1] * 2
    regions = level(depth, width, height, target)
    print pathCost(regions, width, height, target)
    #printLevel(regions, width, height)

main()