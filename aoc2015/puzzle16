input = open("input", "r")
encodedCharacters = 0
codeLiterals = 0
for line in input:
    line = line.strip("\n")
    codeLiterals += len(line)
    encodedCharacters += len(line) + line.count("\"") + line.count("\\") + 2
print encodedCharacters - codeLiterals
