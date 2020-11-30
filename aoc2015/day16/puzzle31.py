input = open("input", "r")

target = set(["children: 3", "cats: 7", "samoyeds: 2", "pomeranians: 3", "akitas: 0", "vizslas: 0", "goldfish: 5", "trees: 3", "cars: 2", "perfumes: 1"])

sues = []
for line in input:
    sues.append(set(line[line.index(":") + 2 :].strip("\n").split(", ")))

for i in range(len(sues)):
    if len(sues[i].difference(target)) == 0:
        print i + 1
        break
