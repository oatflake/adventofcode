import sys
import itertools

input = open("input", "r")
costs = dict()
citys = set()
for line in input:
    parts = line.split(" ")
    costs[(parts[0], parts[2])] = int(parts[4])
    costs[(parts[2], parts[0])] = int(parts[4])
    citys.add(parts[0])
    citys.add(parts[2])
perm = itertools.permutations(citys)
minCost = sys.maxsize
for route in perm:
    cost = 0
    for i in range(len(route) - 1):
        cost += costs[(route[i], route[i + 1])]
    minCost = min(minCost, cost)
print minCost
