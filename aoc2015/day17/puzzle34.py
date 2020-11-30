input = open("input", "r")
eggnogg = 150
containers = []
count = 0
for line in input:
    containers.append(int(line.strip("\n")))
combinedContainers = []
for i in range(len(containers)):
    combinedContainers.append((set([i]), containers[i]))
for i in range(len(containers)):
    newCombinedContainers = []
    seenCombo = set()
    for container in range(len(containers)):
        for key, value in combinedContainers:
            if not container in key:
                key = set(key)
                key.add(container)
                value += containers[container]
                frozen = frozenset(key)
                if frozen not in seenCombo:
                    if value == eggnogg:
                        count += 1
                    if value < eggnogg:
                        newCombinedContainers.append((key, value))
                    seenCombo.add(frozen)
    if count > 0:
        break
    combinedContainers = newCombinedContainers
print count
