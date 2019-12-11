def compute(output):
    if output not in circuit:
        return int(output)
    rule = circuit[output]
    if output in visited:
        return visited[output]
    parts = rule.split(" ")
    if "AND" in rule:
        visited[output] = compute(parts[0]) & compute(parts[2])
        return visited[output]
    elif "OR" in rule:
        visited[output] = compute(parts[0]) | compute(parts[2])
        return visited[output]
    elif "LSHIFT" in rule:
        visited[output] = compute(parts[0]) << compute(parts[2])
        return visited[output]
    elif "RSHIFT" in rule:
        visited[output] = compute(parts[0]) >> compute(parts[2])
        return visited[output]
    elif "NOT" in rule:
        visited[output] = ~compute(parts[1])
        return visited[output]
    else:
        visited[output] = compute(parts[0])
        return visited[output]

input = open("input", "r")
circuit = dict()
visited = dict()
for line in input:
    line = line.strip("\n")
    output = line.split(" ")[-1]    
    circuit[output] = line

visited = dict()
a = compute("a")
print a
