input = open("input", "r")

niceStrings = 0
for line in input:
    twoPairs = (line[i:i+2] in line[i+2:] for i in range(len(line) - 1))
    requirement1 = reduce(lambda a, b: a or b, twoPairs)
    sandwitched = map(lambda s: s[0] == s[2], (line[i:i+3] for i in range(len(line) - 2)))
    requirement2 = reduce(lambda a, b: a or b, sandwitched)
    if requirement1 and requirement2:
        niceStrings += 1
print niceStrings
