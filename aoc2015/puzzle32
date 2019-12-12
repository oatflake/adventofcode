input = open("input", "r")

target = {"children": 3, "cats": 7, "samoyeds": 2, "pomeranians": 3, "akitas": 0, "vizslas": 0, "goldfish": 5, "trees": 3, "cars": 2, "perfumes": 1}

sues = []
for line in input:
    parts = line[line.index(":") + 2 :].strip("\n").split(", ")
    sue = dict()
    for part in parts:
        part = part.split(":")
        sue[part[0]] = int(part[1])
    sues.append(sue)

for i in range(len(sues)):
    sue = sues[i]
    matching = True
    for key in target.keys():
        if key in sue:
            if key == "cats" or key == "trees":
                matching = matching and sue[key] > target[key]
            elif key == "pomeranians" or key == "goldfish":
                matching = matching and sue[key] < target[key]
            else:
                matching = matching and sue[key] == target[key]
    if matching:
        print i + 1
        break
