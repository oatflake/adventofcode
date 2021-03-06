import math

def findStation(asteroids):
    maxVisible = dict()
    maxAsteroid = (-1, -1)
    for asteroid in asteroids:
        visibleAsteroids = dict()
        for otherAsteroid in asteroids:
            if otherAsteroid == asteroid:
                continue
            dx = otherAsteroid[0] - asteroid[0]
            dy = otherAsteroid[1] - asteroid[1]
            gcd = greatestCommonDivisor(abs(dx), abs(dy))
            direction = (dx/gcd, dy/gcd)
            if not direction in visibleAsteroids:
                visibleAsteroids[direction] = []
            visibleAsteroids[direction].append(otherAsteroid)
        if len(visibleAsteroids) > len(maxVisible):
            maxVisible = dict(visibleAsteroids)
            maxAsteroid = asteroid
    return maxVisible, maxAsteroid

def greatestCommonDivisor(a, b):
    while b != 0:
        t = b
        b = a % b
        a = t
    return a

def distance(coord, station):
    dx = coord[0] - station[0]
    dy = coord[1] - station[1]
    return dx * dx + dy * dy

def polarAngle(coord):
    PI = 3.1415926
    angle = math.atan2(float(coord[1]), float(coord[0]))
    return (angle + PI * 2. + PI / 2. + 0.001) % (PI * 2.)

input = open("input", "r")
y = 0
asteroids = []
for line in input:
    for x in range(len(line)):
        if line[x] == "#":
            asteroids.append((x, y))
    y += 1

visibleAsteroids, station = findStation(asteroids)

polarCoordKeys = sorted(visibleAsteroids.keys(), key=polarAngle)
for direction in polarCoordKeys:
    visibleAsteroids[direction] = sorted(visibleAsteroids[direction], key=lambda coord: distance(coord, station))

facingIndex = 0
for i in range(199):
    direction = polarCoordKeys[facingIndex % len(polarCoordKeys)]
    asteroidsLine = visibleAsteroids[direction]
    visibleAsteroids[direction] = asteroidsLine[1:]
    if len(visibleAsteroids[direction]) == 0:
        del visibleAsteroids[direction]
        polarCoordKeys.remove(direction)
    else:
        facingIndex += 1

facingDirection = polarCoordKeys[facingIndex % len(polarCoordKeys)]
betAsteroid = visibleAsteroids[facingDirection][0]
print betAsteroid[0]*100 + betAsteroid[1]

