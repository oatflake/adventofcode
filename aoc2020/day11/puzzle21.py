def readInput():
    input = open("input", "r")
    level = ""
    width = 0
    height = 0
    for line in input:
        width = len(line) - 1
        height += 1
        level += line.strip()
    return list(level), width, height

def updateLevel(width, height, level, newLevel):
    changed = False
    for i in range(len(level)):
        newLevel[i] = level[i]
        x = i % width
        y = i // width
        occupiedCount = 0
        for dx in range(-1, 2, 1):
            for dy in range(-1, 2, 1):
                nx = x + dx
                ny = y + dy
                if (nx == x and ny == y) or nx >= width or nx < 0 or ny >= height or ny < 0:
                    continue
                occupiedCount += 1 if level[nx + ny * width] == '#' else 0
        if level[i] == 'L' and occupiedCount == 0:
            changed = True
            newLevel[i] = '#'
        if level[i] == '#' and occupiedCount >= 4:
            changed = True
            newLevel[i] = 'L'
    return changed

def countOccupiedSeats(level):
    occupiedCount = 0
    for i in range(len(level)):
        occupiedCount += 1 if level[i] == '#' else 0
    return occupiedCount

def main():
    level, width, height = readInput()
    newLevel = level[:]
    while updateLevel(width, height, level, newLevel):
        tmp = newLevel
        newLevel = level
        level = tmp
    print countOccupiedSeats(level)

main()
