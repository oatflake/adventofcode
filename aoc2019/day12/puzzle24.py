def add(vectorA, vectorB):
    return tuple(vectorA[i] + vectorB[i] for i in range(len(vectorA)))

def sub(vectorA, vectorB):
    return tuple(vectorA[i] - vectorB[i] for i in range(len(vectorA)))

def absVec(vectorA):
    return tuple(abs(i) for i in vectorA)

def componentNormalize(vectorA):
    absA = map(lambda a: max(a, 1), absVec(vectorA))
    return tuple(vectorA[i] / absA[i] for i in range(len(vectorA)))

def gravity(positionA, positionB):
    difference = sub(positionB, positionA)
    return componentNormalize(difference)

def absSum(vector):
    return reduce(lambda a, b: abs(a) + abs(b), vector)

def greatestCommonDivisor(a, b):
    while b != 0:
        t = b
        b = a % b
        a = t
    return a

input = open("input", "r")
positions = []
for line in input:
    line = line.strip("\n")[1:-1].split(", ")
    coords = tuple(int(coord.split("=")[1]) for coord in line)
    positions.append(coords)
velocities = [(0, 0, 0)] * len(positions)
originalPositions = positions[:]

found = [False] * 3
stepsTillRepeats =  [-1] * 3
steps = 0
while False in found:
    for i in range(len(positions)):
        for j in range(len(positions)):
            if i == j:
                continue
            velocities[i] = add(velocities[i], gravity(positions[i], positions[j]))

    for i in range(len(positions)):
        positions[i] = add(positions[i], velocities[i])

    matched = [True] * 3
    for i in range(len(positions)):
        for j in range(3):
            if positions[i][j] != originalPositions[i][j] or velocities[i][j] != 0:
                matched[j] = False
    steps += 1
    for j in range(3):
        if matched[j] and not found[j]:
            found[j] = True
            stepsTillRepeats[j] = steps

ggtXY = greatestCommonDivisor(stepsTillRepeats[0], stepsTillRepeats[1])
lcmXY = stepsTillRepeats[0] * stepsTillRepeats[1] / ggtXY
ggtXYZ = greatestCommonDivisor(lcmXY, stepsTillRepeats[2])
print lcmXY * stepsTillRepeats[2] / ggtXYZ
