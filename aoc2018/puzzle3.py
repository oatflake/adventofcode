input = open("input", "r")
twos = 0
threes = 0
for line in input:
    foundTwo = False
    foundThree = False
    for l in line:
        if line.count(l) == 2:
            foundTwo = True
        if line.count(l) == 3:
            foundThree = True
    if foundTwo:
        twos += 1
    if foundThree:
        threes += 1
print(twos * threes)
