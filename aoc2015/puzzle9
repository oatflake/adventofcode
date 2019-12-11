input = open("input", "r")

niceStrings = 0
for line in input:
    threeVowels = reduce(lambda a, b: a + b, map(line.count, "aeiou")) >= 3
    doubleLetter = False
    for i in range(len(line) - 1):
        doubleLetter = doubleLetter or line[i] == line[i + 1]
    forbidden = reduce(lambda a, b: a or b, map(lambda a: a in line, ["ab", "cd", "pq", "xy"]))
    if not forbidden and threeVowels and doubleLetter:
        niceStrings += 1
print niceStrings
