import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from Queue import Queue
from IntcodeComputer import IntcodeComputer
import sys

class Robot:
    def __init__(self):
        self.pos = (0, 0)
        self.oxygenPos = None

def findPath(start, target):
    queue = Queue()
    queue.put((start, None))
    visited = dict()
    while queue.qsize() > 0:
        pos, origin = queue.get()
        if pos in visited:
            continue
        visited[pos] = origin
        if pos == target:
            break
        if not pos in level:
            continue
        if level[pos] == 0:
            continue
        queue.put(((pos[0], pos[1] + 1), pos))
        queue.put(((pos[0], pos[1] - 1), pos))
        queue.put(((pos[0] + 1, pos[1]), pos))
        queue.put(((pos[0] - 1, pos[1]), pos))
    current = visited[target]
    path = [target]
    while current != None:
        path.append(current)
        current = visited[current]
    path.reverse()
    return path[1:]

def followPath(path, robot):
    for pos in path:
        command = commands[(pos[0] - robot.pos[0], pos[1] - robot.pos[1])]
        computer.addInput(command)
        output = computer.execute()
        if output == 0:
            print("ERROR: RAN INTO WALL DURING PATHFINDING")
        robot.pos = pos

def explore(currentPos, newPos, depth, robot):
    if newPos in level:
        return
    if depth == 0:
        return
    if robot.pos != currentPos:
        followPath(findPath(robot.pos, currentPos), robot)
    command = commands[(newPos[0] - currentPos[0], newPos[1] - currentPos[1])]
    computer.addInput(command)
    output = computer.execute()
    level[newPos] = output
    if output == 2:
        robot.oxygenPos = newPos
    if output == 0:
        return
    robot.pos = newPos
    explore(newPos, (newPos[0], newPos[1] + 1), depth - 1, robot)
    explore(newPos, (newPos[0], newPos[1] - 1), depth - 1, robot)
    explore(newPos, (newPos[0] + 1, newPos[1]), depth - 1, robot)
    explore(newPos, (newPos[0] - 1, newPos[1]), depth - 1, robot)

def exploreMap(depth, robot):
    level[(0, 0)] = 1
    explore((0, 0), (0, 1), depth, robot)
    explore((0, 0), (0, -1), depth, robot)
    explore((0, 0), (-1, 0), depth, robot)
    explore((0, 0), (1, 0), depth, robot)

def spreadOxygen(oxygenPos):
    queue = Queue()
    queue.put((oxygenPos, 0))
    visited = set()
    timePassed = 0
    while queue.qsize() > 0:
        pos, tmpTimePassed = queue.get()
        if pos in visited:
            continue
        visited.add(pos)
        if not pos in level:
            continue
        if level[pos] == 0:
            continue
        timePassed = tmpTimePassed
        queue.put(((pos[0], pos[1] + 1), timePassed + 1))
        queue.put(((pos[0], pos[1] - 1), timePassed + 1))
        queue.put(((pos[0] + 1, pos[1]), timePassed + 1))
        queue.put(((pos[0] - 1, pos[1]), timePassed + 1))
    return timePassed

oxygenPos = None
commands = {(0, 1) : 1, (0, -1) : 2, (-1, 0) : 3, (1, 0) : 4}
inputFile = open("input", "r").read().strip("\n")
computer = IntcodeComputer(inputFile)
robot = Robot()
level = dict()
exploreMap(10000, robot)

minX = minY = sys.maxsize
maxX = maxY = -sys.maxsize
for coord, value in level.items():
    minX = min(coord[0], minX)
    minY = min(coord[1], minY)
    maxX = max(coord[0], maxX)
    maxY = max(coord[1], maxY)
for y in range(minY, maxY + 1):
    line = ""
    for x in range(minX, maxX + 1):
        if (x, y) == robot.pos:
            line += "o"
        elif (x, y) in level:
            if level[(x, y)] == 0:
                line += "#"
            elif level[(x, y)] == 1:
                line += "."
            elif level[(x, y)] == 2:
                line += "!"
        else:
            line += " "
    print(line)

print("oxygen time", spreadOxygen(robot.oxygenPos))
