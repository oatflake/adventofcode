minutes = 200

def read(state, x, y, dx, dy, level):
    if level <= 0 or level >= minutes * 2 + 2:
        return 0
    result = 0
    if x + dx == 2 and y + dy == 2:     # read from mid
        if dx < 0:
            for i in range(5):
                result += state[4 + i * 5 + (level - 1) * 25]
        if dx > 0:
            for i in range(5):
                result += state[0 + i * 5 + (level - 1) * 25]
        if dy < 0:
            for i in range(5):
                result += state[i + 4 * 5 + (level - 1) * 25]
        if dy > 0:
            for i in range(5):
                result += state[i + 0 * 5 + (level - 1) * 25]
    elif 0 <= x + dx < 5 and 0 <= y + dy < 5:   # within our level, but not mid
        result = state[(x + dx) + (y + dy) * 5 + level * 25]
    else:       # read outside
        if dx < 0:
            result = state[1 + 2 * 5 + (level + 1) * 25]
        if dx > 0:
            result = state[3 + 2 * 5 + (level + 1) * 25]
        if dy < 0:
            result = state[2 + 1 * 5 + (level + 1) * 25]
        if dy > 0:
            result = state[2 + 3 * 5 + (level + 1) * 25]
    return result

def process(state, result):
    for i in range(len(state)):
        localI = i % 25
        level = i / 25
        if localI == 12:
            continue
        x, y = localI % 5, localI / 5
        neighbors = 0
        for offset in ((1,0), (-1, 0), (0,1), (0,-1)):
            neighbors += read(state, x, y, offset[0], offset[1], level)
        if state[i] == 1:
            result[i] = 1 if neighbors == 1 else 0
        else:
            result[i] = 1 if neighbors == 1 or neighbors == 2 else 0

def printEris(eris, round):
    print "---------ERIS round", round, "----------"
    for level in range(len(eris) / 25):
        print "----- LEVEL", level, "-----"
        for y in range(5):
            s = ""
            for x in range(5):
                if eris[x + y * 5 + level * 25] == 1:
                    s += "#"
                else:
                    s += "."
            print s

input = open("input", "r")
eris = [0]*(25*(minutes + 1))
for line in input:
    eris += map(lambda x: 1 if x == "#" else 0, line.strip("\n"))
eris += [0]*(25*(minutes + 1))

copy = eris[:]
for round in range(minutes):
    #printEris(eris, round)
    process(eris, copy)
    eris, copy = copy, eris
#printEris(eris, minutes)

bugs = 0
for bug in eris:
    bugs += bug
print bugs

