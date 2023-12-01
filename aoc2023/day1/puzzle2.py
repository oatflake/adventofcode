spelledOut = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

def toDigit(i, line):
    if line[i].isdigit():
        return int(line[i])
    for k in range(len(spelledOut)):
        if line.startswith(spelledOut[k], i):
            return k + 1
    return -1

file = open("input", "r")
sum = 0
for line in file:
    line = line.strip("\n")
    firstDigit = 0
    lastDigit = 0
    for i in range(len(line)):
        if toDigit(i, line) != -1:
            firstDigit = toDigit(i, line)
            break
    for i in range(len(line) - 1, -1, -1):
        if toDigit(i, line) != -1:
            lastDigit = toDigit(i, line)
            break
    sum += firstDigit * 10 + lastDigit
print(sum)