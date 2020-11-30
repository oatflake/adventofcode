input = open("input", "r")
lines = []
for line in input:
    lines.append(line)

state = lines[0][len("initial state: "):-1]
rules = dict()

for i in range(2, len(lines)):
    split = lines[i].strip("\n").split(" => ")
    rules[split[0]] = split[1]

startIndex = 0
for i in range(20):
    newState = ""
    state = "....." + state + "....."
    for j in range(2, len(state) - 2):
        key = state[j - 2 : j + 3]
        if key in rules:
            newState += rules[key]
        else:
            newState += "."
    firstPot = newState.find('#')
    if firstPot == -1:
        print "error: not pot found"
    startIndex += -3 + firstPot
    state = newState.strip('.')
sum = 0
for c in state:
    sum += startIndex if c == '#' else 0
    startIndex += 1
print sum
