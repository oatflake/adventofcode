input = open("input", "r").read()
coordSanta = coordRobo = (0, 0)
visited = set([coordSanta])
offsets = {"<": (-1, 0), ">": (1, 0), "^": (0, 1), "v": (0, -1)}
for instruction in input:
    direction = offsets[instruction]
    coordSanta = (coordSanta[0] + direction[0], coordSanta[1] + direction[1])
    visited.add(coordSanta)
    coordSanta, coordRobo = coordRobo, coordSanta
print len(visited)
