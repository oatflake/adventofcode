def dfs(node, target, graph):
    if node == target:
        return []
    for child in graph[node]:
        path = dfs(child, target, graph)
        if path != None:
            path.append(child)
            return path
    return None

input = open("input", "r")
graph = dict()
for line in input:
    nodePair = line.strip('\n').split(")")
    if not nodePair[0] in graph:
        graph[nodePair[0]] = []
    if not nodePair[1] in graph:
        graph[nodePair[1]] = []
input = open("input", "r")
for line in input:
    nodePair = line.strip('\n').split(")")
    graph[nodePair[0]].append(nodePair[1])
pathYOU = dfs("COM", "YOU", graph)
pathSAN = dfs("COM", "SAN", graph)
pathYOULength = len(pathYOU) - 1
pathSANLength = len(pathSAN) - 1
while pathYOU[pathYOULength] == pathSAN[pathSANLength]:
    pathYOULength -= 1
    pathSANLength -= 1
print pathYOULength + pathSANLength
