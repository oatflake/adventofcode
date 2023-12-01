file = open("input", "r")
maxSum = 0
currentSum = 0
for line in file:
    line = line.strip("\n")
    if line == "":
        maxSum = max(maxSum, currentSum)
        currentSum = 0
    else:
        currentSum += int(line)
print(maxSum)