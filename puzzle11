def dfs(node, graph, pathLength):
    sumPathLengths = pathLength
    for child in graph[node]:
        sumPathLengths += dfs(child, graph, pathLength + 1)
    return sumPathLengths

input = open("input", "r")
graph = dict()
for line in input:
    nodePair = line.strip('\n').split(")")
    if not nodePair[0] in graph:
        graph[nodePair[0]] = []
    if not nodePair[1] in graph:
        graph[nodePair[1]] = []
roots = set(graph.keys())
input = open("input", "r")
for line in input:
    nodePair = line.strip('\n').split(")")
    graph[nodePair[0]].append(nodePair[1])
    if nodePair[1] in roots:
        roots.remove(nodePair[1])
pathsLenthsSum = 0
for root in roots:
    pathsLenthsSum += dfs(root, graph, 0)
print pathsLenthsSum
