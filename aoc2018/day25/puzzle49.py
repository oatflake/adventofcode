def readInput():
    input = open("input", "r")
    points = []
    for line in input:
        line = line.strip().split(",")
        points.append([int(i) for i in line])
    return points

def distance(p1, p2):
    dist = 0
    for i in range(4):
        dist += abs(p1[i] - p2[i])
    return dist

def main():
    points = readInput()
    constellation = [points[-1]]
    listLength = len(points) - 1
    constellations = 1
    while listLength > 0:
        i = 0
        constellationSize = len(constellation)
        while i < listLength:
            point = points[i]
            inConstellation = False
            for cPoint in constellation:
                if distance(cPoint, point) <= 3:
                    inConstellation = True
                    break
            if inConstellation:
                constellation.append(point)
                points[i] = points[listLength - 1]
                listLength -= 1
            else:
                i += 1
        if constellationSize == len(constellation):
            constellations += 1
            constellation = [points[listLength - 1]]
            listLength -= 1
    print constellations

main()