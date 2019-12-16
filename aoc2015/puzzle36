size = 100
frames = 100

def coordToInt(x, y):
    return y * size + x

def intToCoord(i):
    return (i % size, i / size)

def animate(readBuffer, writeBuffer):
    for i in range(size*size):
        coord = intToCoord(i)
        neighborsOn = 0
        for x in range(coord[0] - 1, coord[0] + 1 + 1):
            for y in range(coord[1] - 1, coord[1] + 1 + 1):
                j = coordToInt(x, y)
                if j == i:
                    continue
                if x >= 0 and y >= 0 and x < size and y < size:
                    if readBuffer[j]:
                        neighborsOn += 1
        if readBuffer[i]:
            writeBuffer[i] = neighborsOn == 2 or neighborsOn == 3
        else:
            writeBuffer[i] = neighborsOn == 3
    corners = [(0, 0), (size - 1, 0), (0, size - 1), (size - 1, size - 1)]
    for corner in corners:
        writeBuffer[coordToInt(corner[0], corner[1])] = True

input = open("input", "r")
lights = []
for line in input:
    for char in line.strip("\n"):
        lights.append(char == "#")

lightsCopy = lights[:]
for frame in range(frames):
    animate(lights, lightsCopy)
    lights, lightsCopy = lightsCopy, lights

lightsTurnedOn = 0
for light in lights:
    if light == True:
        lightsTurnedOn += 1
print lightsTurnedOn
