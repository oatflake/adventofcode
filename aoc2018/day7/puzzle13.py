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
while queue:
    node = heapq.heappop(queue)
    result += node
    visited.add(node)
    if node in outgoingEdges:
        for child in outgoingEdges[node]:
            ready = True
            if child in incomingEdges:
                for parent in incomingEdges[child]:
                    if not parent in visited:
                        ready = False
            if ready:
                heapq.heappush(queue, child)
print result
