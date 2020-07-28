input = open("input", "r")
result = 0
for line in input:
    line = line.strip("\n")
    result += int(line)
print(result)
