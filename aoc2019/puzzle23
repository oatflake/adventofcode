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

def totalEnergy(position, velocity):
    potentialEnergy = absSum(position)
    kinecticEnergy = absSum(velocity)
    return potentialEnergy * kinecticEnergy

input = open("input", "r")
positions = []
for line in input:
    line = line.strip("\n")[1:-1].split(", ")
    coords = tuple(int(coord.split("=")[1]) for coord in line)
    positions.append(coords)
velocities = [(0, 0, 0)] * len(positions)

for steps in range(1000):
    for i in range(len(positions)):
        for j in range(len(positions)):
            if i == j:
                continue
            velocities[i] = add(velocities[i], gravity(positions[i], positions[j]))

    for i in range(len(positions)):
        positions[i] = add(positions[i], velocities[i])

totalSystemEnergy = 0
for i in range(len(positions)):
    totalSystemEnergy += totalEnergy(positions[i], velocities[i])
print totalSystemEnergy
