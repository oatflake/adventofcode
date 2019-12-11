input = open("input", "r")
memoryCharacters = 0
codeLiterals = 0
for line in input:
    line = line.strip("\n")
    codeLiterals += len(line)
    line = line[1:-1]
    i = 0
    while i < len(line):
        if line[i] == "\\":
            i += 3 if line[i + 1] == "x" else 1
        memoryCharacters += 1
        i += 1
print codeLiterals - memoryCharacters
