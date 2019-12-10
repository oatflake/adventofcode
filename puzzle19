def greatestCommonDivisor(a, b):
    while b != 0:
        t = b
        b = a % b
        a = t
    return a

input = open("input", "r")
y = 0
asteroids = []
for line in input:
    for x in range(len(line)):
        if line[x] == "#":
            asteroids.append((x, y))
    y += 1
maxVisible = -1
maxAsteroid = (-1, -1)
for asteroid in asteroids:
    visibleAsteroids = set()
    for otherAsteroid in asteroids:
        if otherAsteroid == asteroid:
            continue
        dx = otherAsteroid[0] - asteroid[0]
        dy = otherAsteroid[1] - asteroid[1]
        gcd = greatestCommonDivisor(abs(dx), abs(dy))
        visibleAsteroids.add((dx/gcd, dy/gcd))
    if len(visibleAsteroids) > maxVisible:
        maxVisible = len(visibleAsteroids)
        maxAsteroid = asteroid
print maxVisible, maxAsteroid
