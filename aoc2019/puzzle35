from Queue import Queue
import heapq

def bfs(level, width, height, ownedKeys, startPos):
    results = set()
    queue = Queue()
    queue.put((startPos, 0))
    visited = dict()
    while queue.qsize() > 0:
        node, cost = queue.get()
        visited[node] = cost
        nodeTile = level[node[0] + width * node[1]]
        if nodeTile.islower() and not nodeTile in ownedKeys:
            tmpSet = set(ownedKeys)
            tmpSet.add(nodeTile)
            results.add((frozenset(tmpSet), cost, node))
            continue
        neighbors = ((-1, 0), (1, 0), (0, 1), (0, -1))
        for neighbor in neighbors:
            x, y = node[0] + neighbor[0], node[1] + neighbor[1]
            if x < 0 or x >= width or y < 0 or y >= height:
                continue
            if (x, y) in visited:
                continue
            tile = level[x + y * width]
            if tile == '#':
                continue
            if tile.isupper() and not tile.lower() in ownedKeys:
                continue
            queue.put(((x, y), cost + 1))
    return results

def dijkstra(level, width, height, startPos, allKeys):
    visited = set()
    heap = []
    heapq.heappush(heap, (0, frozenset(), startPos))
    i = 0
    while len(heap) > 0:
        i += 1
        cost, keys, pos = heapq.heappop(heap)
        if (keys, pos) in visited:
            continue
        visited.add((keys, pos))
        if len(allKeys.difference(keys)) == 0:
            return cost
        edges = bfs(level, width, height, keys, pos)
        for edge in edges:
            childKeys, edgeCost, childPos = edge
            if not (childKeys, childPos) in visited:
                totalCost = cost + edgeCost
                heapq.heappush(heap, (totalCost, childKeys, childPos))

input = open("input", "r")
level = ""
width = 0
height = 0
for line in input:
    line = line.strip("\n")
    level += line
    width = len(line)
    height += 1
startPos = level.index('@')
startPos = (startPos % width, startPos // width)

allKeys = set()
for char in level:
    if char.islower():
        allKeys.add(char)

print dijkstra(level, width, height, startPos, allKeys)
