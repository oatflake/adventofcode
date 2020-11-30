input = open("input", "r").read()
coord = (0, 0)
visited = set([coord])
offsets = {"<": (-1, 0), ">": (1, 0), "^": (0, 1), "v": (0, -1)}
for instruction in input:
    direction = offsets[instruction]
    coord = (coord[0] + direction[0], coord[1] + direction[1])
    visited.add(coord)
print len(visited)
