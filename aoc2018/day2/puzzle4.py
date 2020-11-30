input = open("input", "r")
lines = []
for line in input:
    lines.append(line)
result = ""
end = False
for i in range(len(lines)):
    for j in range(i + 1, len(lines)):
        differences = 0
        for k in range(len(lines[i])):
            if lines[i][k] != lines[j][k]:
                differences += 1
        if differences == 1:
            for k in range(len(lines[i])):
                if lines[i][k] == lines[j][k]:
                    result += lines[i][k]
            end = True
            break
    if end:
        break
print(result)
