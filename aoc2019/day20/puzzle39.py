from Queue import Queue

def parseInput():
    input = open("input", "r")
    levelStr = ""
    width = 0
    height = 0
    for line in input:
        line = line.strip("\n")
        levelStr += line
        width = len(line)
        height += 1
    graph = dict()
    portals = dict()
    for i in range(len(levelStr)):
        char = levelStr[i]
        if char == ".":
            pos = (i % width, i / width)
            graph[pos] = []
            offsets = ((1, 0), (-1, 0), (0, 1), (0, -1))
            for offset in offsets:
                neighbor = (pos[0] + offset[0], pos[1] + offset[1])
                neighborChar = levelStr[neighbor[0] + neighbor[1] * width]
                if neighborChar == ".":
                    graph[pos].append(neighbor)
                elif neighborChar.isupper():
                    secondChar = levelStr[(neighbor[0] + offset[0]) + (neighbor[1] + offset[1]) * width]
                    if offset[0] + offset[1] > 0:
                        portal = neighborChar + secondChar
                    else:
                        portal = secondChar + neighborChar
                    if not portal in portals:
                        portals[portal] = []
                    portals[portal].append(pos)
    start = (-1, -1)
    goal = (-1, -1)
    for portal, positions in portals.items():
        if portal == "AA":
            start = positions[0]
            if len(positions) != 1:
                print "ERROR AA"
        elif portal == "ZZ":
            goal = positions[0]
            if len(positions) != 1:
                print "ERROR ZZ"
        else:
            graph[positions[0]].append(positions[1])
            graph[positions[1]].append(positions[0])
            if len(positions) != 2:
                print "ERROR", portal
    return graph, start, goal

def bfs(graph, start, goal):
    queue = Queue()
    queue.put((start, None))
    visited = dict()
    while queue.qsize() > 0:
        (node, parent) = queue.get()
        if node in visited:
            continue
        visited[node] = parent
        if node == goal:
            break
        for neighbor in graph[node]:
            if neighbor in visited:
                continue
            queue.put((neighbor, node))
    current = goal
    path = []
    while current != None:
        path.append(current)
        current = visited[current]
    path.reverse()
    return path

graph, start, goal = parseInput()
print len(bfs(graph, start, goal)) - 1
