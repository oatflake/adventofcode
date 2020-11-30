import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

def apply(path, offset, pa, pb, pc, i, j, k):
    maxLen = 21
    if i + j + k > maxLen - 4:
        return None
    if len(path) == offset:
        return []
    result = None

    if i == -1:
        allAs = (path[offset:offset + e] for e in range(1, maxLen))
    else:
        allAs = (pa for e in range(0, 1))
    for a in allAs:
        if path.startswith(a, offset):
            result = apply(path, offset + len(a), a, pb, pc, i + 1, j, k)
            if result != None:
                return [a] + result

    if i != -1:
        if j == -1:
            allBs = (path[offset:offset + e] for e in range(1, maxLen))
        else:
            allBs = (pb for e in range(0, 1))
        for b in allBs:
            if path.startswith(b, offset):
                result = apply(path, offset + len(b), pa, b, pc, i, j + 1, k)
                if result != None:
                    return [b] + result
    
    if i != -1 and j != -1:
        if k == -1:
            allCs = (path[offset:offset + e] for e in range(1, maxLen))
        else:
            allCs = (pc for e in range(0, 1))
        for c in allCs:
            if path.startswith(c, offset):
                result = apply(path, offset + len(c), pa, pb, c, i, j, k + 1)
                if result != None:
                    return [c] + result
    return result

UP = 94
DOWN = 118
LEFT = 60
RIGHT = 62
LEFT_TURN = 76
RIGHT_TURN = 82
COMMA = 44
LINE_BREAK = 10

def dfs(node, level, currentPath, intersections, parent, allNodes, levelWidth, resultingPaths):
    currentPath.append(node)
    neighbors = ((node[0] - 1, node[1]), (node[0] + 1, node[1]), (node[0], node[1] - 1), (node[0], node[1] + 1))
    checkedNeighbors = 0
    for neighbor in neighbors:
        if neighbor[0] < 0 or neighbor[0] >= width or neighbor[1] < 0 or neighbor[1] >= len(level) / width:
            continue 
        if level[posToInt(neighbor, levelWidth)] == 46:
            continue
        if neighbor == parent or (neighbor in currentPath and not neighbor in intersections):
            continue
        checkedNeighbors += 1
        dfs(neighbor, level, currentPath, intersections, node, allNodes, levelWidth, resultingPaths)
    if checkedNeighbors == 0:
        if len(allNodes.difference(set(currentPath))) == 0:
            resultingPaths.append(currentPath[:])
    currentPath.pop()

def intToPos(i, levelWidth):
    return (i % levelWidth, i // levelWidth)

def posToInt(pos, levelWidth):
    x, y = pos
    return x + y * levelWidth

def findIntersections(level, levelWidth, levelHeight):
    intersections = set()
    for i in range(len(level)):
        if level[i] != 46:
            pos = intToPos(i, levelWidth)
            neighbors = 0
            for j in range(-1, 2, 2):
                if 0 < pos[0] + j < levelWidth and level[posToInt((pos[0] + j, pos[1]), levelWidth)] != 46:
                    neighbors += 1
            for j in range(-1, 2, 2):
                if 0 < pos[1] + j < levelHeight and level[posToInt((pos[0], pos[1] + j), levelWidth)] != 46:
                    neighbors += 1
            if neighbors >= 3:
                intersections.add(pos)
    return intersections

def findRobot(level, levelWidth):
    orientations = (UP, DOWN, LEFT, RIGHT)
    for i in range(len(level)):
        if level[i] in orientations:
            return intToPos(i, levelWidth)

def findAllPositions(level, levelWidth):
    allPositions = set()
    for i in range(len(level)):
        if level[i] != 46:
            allPositions.add(intToPos(i, levelWidth))
    return allPositions

def convertPathToASCII(path, facing):  # not taking care of 180 degree turns, shouldn't be needed
    currentIndex = 0
    nextIndex = 1
    directions = { (UP, 1, 0) : (RIGHT_TURN, RIGHT), (UP, -1, 0) : (LEFT_TURN, LEFT), 
    (DOWN, 1, 0) : (LEFT_TURN, RIGHT), (DOWN, -1, 0) : (RIGHT_TURN, LEFT), 
    (LEFT, 0, 1) : (LEFT_TURN, DOWN), (LEFT, 0, -1) : (RIGHT_TURN, UP), 
    (RIGHT, 0, 1) : (RIGHT_TURN, DOWN), (RIGHT, 0, -1) : (LEFT_TURN, UP) }
    convertedPath = ""
    currentPos = path[0]
    while nextIndex < len(path):
        currentPos = path[currentIndex]
        if currentPos[0] != path[nextIndex][0] and currentPos[1] != path[nextIndex][1]:
            nextPos = path[nextIndex - 1]
            dx = nextPos[0] - currentPos[0]
            dy = nextPos[1] - currentPos[1]
            key = (facing, 0 if dx == 0 else dx / abs(dx), 0 if dy == 0 else dy / abs(dy))
            if key in directions:
                dir = directions[key]
                convertedPath += chr(dir[0])
                facing = dir[1]
                convertedPath += chr(COMMA)
            else:
                print ("ERROR KEY", key)
            convertedPath += str(max(abs(dx), abs(dy)))
            convertedPath += chr(COMMA)
            currentIndex = nextIndex - 1
        nextIndex += 1
    nextPos = path[nextIndex - 1]
    dx = nextPos[0] - currentPos[0]
    dy = nextPos[1] - currentPos[1]
    key = (facing, 0 if dx == 0 else dx / abs(dx), 0 if dy == 0 else dy / abs(dy))
    if key in directions:
        dir = directions[key]
        convertedPath += chr(dir[0])
        convertedPath += chr(COMMA)
        facing = dir[1]
    else:
        print ("ERROR KEY", key)
    convertedPath += str(max(abs(dx), abs(dy)))
    convertedPath += chr(COMMA)
    return convertedPath

def constructLevel(computer):
    level = []
    levelWidth = 0
    firstLineBreak = False
    while True:
        output = computer.execute()
        if output == None:
            break
        if output != 10:
            level.append(output)
        else:
            firstLineBreak = True
        if not firstLineBreak:
            levelWidth += 1
    return level, levelWidth

def findPathParts(level, levelWidth, intersections):
    robotPos = findRobot(level, levelWidth)
    robotOrientation = level[posToInt(robotPos, levelWidth)]
    allPaths = []
    dfs(robotPos, level, [], intersections, None, findAllPositions(level, levelWidth), levelWidth, allPaths)
    parts = None
    for path in allPaths:
        convertedPath = convertPathToASCII(path, robotOrientation)
        parts = apply(convertedPath, 0, "", "", "", -1, -1, -1)
        if parts != None:
            wrongsplit = False
            for part in parts:
                if part[-1] != ",":
                    wrongsplit = True
                    break
            if not wrongsplit:
                break
    for i in range(len(parts)):
        parts[i] = parts[i][:-1]
    return parts

def findASCIIInput(level, levelWidth, intersections, videoFeed):
    parts = findPathParts(level, width, intersections)
    knownParts = dict()
    functionsASCII = [65, 66, 67]
    numFunctions = 0
    for part in parts:
        if not part in knownParts:
            knownParts[part] = functionsASCII[numFunctions]
            numFunctions += 1

    mainFunction = ""
    mainFunction += chr(knownParts[parts[0]])
    for i in range(1, len(parts)):
        mainFunction += chr(COMMA)
        mainFunction += chr(knownParts[parts[i]])
    mainFunction += chr(LINE_BREAK)

    otherFunctions = [None] * 3
    for part in parts:
        functionIndex = knownParts[part]
        if otherFunctions[functionIndex - 65] != None:
            continue
        function = part[:]
        function += chr(LINE_BREAK)
        otherFunctions[functionIndex - 65] = function

    result = mainFunction
    for otherFunction in otherFunctions:
        result += otherFunction

    result += (chr(121) if videoFeed else chr(110))
    result += chr(LINE_BREAK)
    return result

rawinput = open("input", "r").read().strip("\n")
computer = IntcodeComputer(rawinput)
level, width = constructLevel(IntcodeComputer(rawinput[:]))
height = len(level) / width
intersections = findIntersections(level, width, height)

asciiInput = findASCIIInput(level, width, intersections, False)
print(asciiInput)
for i in asciiInput:
    computer.addInput(ord(i))
computer.memory[0] = 2

robotOutput = ""
lastOutput = 0
while True:
    output = computer.execute()
    if output == None:
        break
    if output < 256:
        robotOutput += chr(output)
    lastOutput = output
print(robotOutput)
print("collected dust:", lastOutput)
