def read(state, x, y):
    if 0 <= x < 5 and 0 <= y < 5:
        return state[x + y * 5]
    return 0

def process(state, result):
    for i in range(len(state)):
        x, y = i % 5, i / 5
        neighbors = 0
        for offset in ((1,0), (-1, 0), (0,1), (0,-1)):
            neighbors += read(state, x + offset[0], y + offset[1])
        if state[i] == 1:
            result[i] = 1 if neighbors == 1 else 0
        else:
            result[i] = 1 if neighbors == 1 or neighbors == 2 else 0

def biodiversity(state):
    result = 0
    for i in range(len(state)):
        result += 2**i * state[i]
    return result

input = open("input", "r")
eris = []
for line in input:
    eris += map(lambda x: 1 if x == "#" else 0, line.strip("\n"))

biodiversities = set()
copy = eris[:]
while True:
    diversity = biodiversity(eris)
    if diversity in biodiversities:
        print diversity
        break
    biodiversities.add(diversity)
    process(eris, copy)
    eris, copy = copy, eris

