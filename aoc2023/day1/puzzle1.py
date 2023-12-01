file = open("input", "r")
sum = 0
for line in file:
    line = line.strip("\n")
    firstDigit = 0
    lastDigit = 0
    for i in range(len(line)):
        if line[i].isdigit():
            firstDigit = int(line[i])
            break
    for i in range(len(line) - 1, -1, -1):
        if line[i].isdigit():
            lastDigit = int(line[i])
            break
    sum += firstDigit * 10 + lastDigit
print(sum)