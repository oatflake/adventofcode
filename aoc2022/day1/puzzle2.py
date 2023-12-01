import heapq

file = open("input", "r")
maxSums = []
currentSum = 0
for line in file:
    line = line.strip("\n")
    if line == "":
        if len(maxSums) < 3:
            heapq.heappush(maxSums, currentSum)
        else:
            heapq.heappushpop(maxSums, currentSum)
        currentSum = 0
    else:
        currentSum += int(line)
print(sum(maxSums))