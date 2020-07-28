results = set()
result = 0
end = False
while not end:
    input = open("input", "r")
    for line in input:
        if result in results:
            end = True
            break
        results.add(result)
        line = line.strip("\n")
        result += int(line)
print(result)
