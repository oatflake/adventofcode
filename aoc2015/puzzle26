import sys
import itertools

input = open("input", "r")
names = set()
happiness = dict()
for line in input:
    parts = line.strip(".\n").split(" ")
    names.add(parts[0])
    happiness[(parts[0], parts[-1])] = (1 if parts[2] == "gain" else -1) * int(parts[3])
for name in names:
    happiness[("me", name)] = 0
    happiness[(name, "me")] = 0
names.add("me")

maxHappiness = -sys.maxsize
for seating in itertools.permutations(names):
    seatingHappiness = 0
    for i in range(len(seating)):
        a, b = seating[i], seating[(i + 1) % len(seating)]
        seatingHappiness += happiness[(a, b)] + happiness[(b, a)]
    maxHappiness = max(seatingHappiness, maxHappiness)
print maxHappiness
