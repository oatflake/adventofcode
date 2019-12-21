def applyRules(startString):
    results = set()
    for key, value in rules.items():
        for replacement in value:
            index = startString.find(key, 0)
            while index != -1:
                string = startString[:]
                string = string[:index] + replacement + string[index + len(key):]
                results.add(string)
                index = startString.find(key, index + 1)
    return results

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
        if line[0] not in rules:
            rules[line[0]] = []
        rules[line[0]].append(line[1])

print len(applyRules(medicine))
