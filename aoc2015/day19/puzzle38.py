import random

def applyRule(startString, ruleItems):
    results = set()
    for key, value in ruleItems:
        index = startString.find(key, 0)
        if index != -1:
            string = startString[:]
            string = string[:index] + value + string[index + len(key):]
            return string
    return None

input = open("input", "r")
gotAllRules = False
medicine = ""
rules = dict()
for line in input:
    line = line.strip("\n")
    if line == "":
        gotAllRules = True
        continue
    if gotAllRules:
        medicine = line
    else:
        line = line.split(" => ")
        rules[line[1]] = line[0]

solutionFound = False
while not solutionFound:
    current = medicine
    steps = 0
    ruleItems = rules.items()
    random.shuffle(ruleItems)
    while current != None:
        if current == "e":
            print steps
            solutionFound = True
            break
        current = applyRule(current, ruleItems)
        steps += 1