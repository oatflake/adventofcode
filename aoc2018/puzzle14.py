import heapq

input = open("input", "r")

outgoingEdges = dict()
incomingEdges = dict()
for line in input:
    split = line.split(' ')
    if not split[1] in outgoingEdges:
        outgoingEdges[split[1]] = []
    outgoingEdges[split[1]].append(split[7])
    if not split[7] in incomingEdges:
        incomingEdges[split[7]] = []
    incomingEdges[split[7]].append(split[1])
queue = []
visited = set()
src = set(outgoingEdges.keys()) - set(incomingEdges.keys())
for node in src:
    heapq.heappush(queue, node)
result = ""
workersQueue = []
time = 0
while queue or workersQueue:
    if len(workersQueue) < 5 and len(queue) > 0:
        node = heapq.heappop(queue)
        result += node
        heapq.heappush(workersQueue, (time + 61 + ord(node) - ord('A'), node))
    else:
        newTime, node = heapq.heappop(workersQueue)
        visited.add(node)
        time = newTime
        if node in outgoingEdges:
            for child in outgoingEdges[node]:
                ready = True
                if child in incomingEdges:
                    for parent in incomingEdges[child]:
                        if not parent in visited:
                            ready = False
                if ready:
                    heapq.heappush(queue, child)
print time
