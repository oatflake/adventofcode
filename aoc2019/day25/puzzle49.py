import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer
from queue import Queue
from itertools import combinations
from functools import reduce

def runGame():
    level = dict()
    currentPos = (0, 0)
    code = open("input", "r").read().strip("\n")
    computer = IntcodeComputer(code)
    blacklist = { "infinite loop", "molten lava", "escape pod", "giant electromagnet", "photons" }
    s = ""
    firstTileDiscovered = False
    commands = ["map", "collect", "enter"]      # auto mode
    commandIndex = 0
    while True:
        output = computer.execute()
        if output == None:
            if computer.done:
                break
            if not firstTileDiscovered:
                level[(0, 0)] = parseTile((0,0), s)[0]
                firstTileDiscovered = True
            #print(s)
            text = commands[commandIndex] #text = input("") # interactive mode, commented out just as all prints which aren't neccessary for auto solution
            commandIndex += 1
            if text == "map":
                currentTile = level[currentPos]
                level = dict()
                level[currentPos] = currentTile
                explore(level, currentPos, computer)
                #for tile in level.items():
                #    print (tile[0], tile[1])
            elif text.startswith("goto"):   # convenience for interactive mode, not needed for solution
                text = text.split(" ")
                targetPos = (int(text[1]), int(text[2]))
                currentPos = visit(level, currentPos, targetPos, computer).pos
            elif text.startswith("get"):    # convenience for interactive mode, not needed for solution
                text = text[4:]
                for tile in level.items():
                    if text in tile[1].items:
                        currentPos = visit(level, currentPos, tile[0], computer).pos
                        for c in ("take " + text):
                            computer.addInput(ord(c))
                        computer.addInput(10)
                        currentPos = visit(level, tile[0], currentPos, computer).pos
            elif text == "collect":
                for tile in level.items():
                    if len(tile[1].items) > 0:
                        currentPos = visit(level, currentPos, tile[0], computer).pos
                        for item in tile[1].items:
                            if not item in blacklist:
                                for c in ("take " + item):
                                    computer.addInput(ord(c))
                                computer.addInput(10)
                        currentPos = visit(level, tile[0], currentPos, computer).pos
            elif text == "enter":
                currentPos = tryEntering(level, currentPos, computer)
            else:           # default game input behaviour for interactive mode
                for c in text:
                    computer.addInput(ord(c))
                computer.addInput(10)
            s = ""
        else:
            s += chr(output)

def itemOperation(operation, items, computer):
    s = ""
    for item in items:
        for c in (operation + " " + item):
            computer.addInput(ord(c))
        computer.addInput(10)
    while True:
        output = computer.execute()
        if output == None:
            return s
        s += chr(output)

def drop(items, computer):
    return itemOperation("drop", items, computer)

def take(items, computer):
    return itemOperation("take", items, computer)

def tryEntering(level, currentPos, computer):
    currentPos = visit(level, currentPos, (-1, 2), computer).pos  # hardcoded Security Checkpoint coordinates... should probably look this up from level
    for c in ("inv"):
        computer.addInput(ord(c))
    computer.addInput(10)
    s = ""
    while True:
        output = computer.execute()
        if output == None:
            break
        s += chr(output)
    s = s.split("\n")
    items = []
    for item in s:
        if item.startswith("- "):
            items.append(item[2:])
    #print(items)
    powerset = reduce(lambda a, b: a + b, [list(map(list, combinations(items,n))) for n in range(len(items)+1)])
    for combination in powerset:
        drop(items, computer)
        take(combination, computer)
        currentPos = visit(level, currentPos, (-2, 2), computer).pos  # hardcoded Pressure-Sensitive Floor coordinates... should probably look this up from level
        if currentPos == (-2, 2):
            break
    return currentPos

def bfs(level, start, goal):
    queue = Queue()
    queue.put((start, None))
    visited = dict()
    while queue.qsize() > 0:
        node, parent = queue.get()
        if node in visited:
            continue
        visited[node] = parent
        if node == goal:
            break
        for neighbor in level[node].neighborTiles:
            if neighbor == goal or neighbor in level:
                queue.put((neighbor, node))
    path = []
    current = goal
    while current != None:
        path.append(current)
        current = visited[current]
    path.reverse()
    #print(path)
    return path

def pathToInstructions(path):
    instructions = []
    for i in range(len(path) - 1):
        dx = path[i + 1][0] - path[i][0]
        dy = path[i + 1][1] - path[i][1]
        if dx > 0:
            instructions.append("east")
        elif dx < 0:
            instructions.append("west")
        elif dy > 0:
            instructions.append("north")
        elif dy < 1:
            instructions.append("south")
    return instructions

def followPath(path, computer):
    instructions = pathToInstructions(path)
    for instruction in instructions:
        for c in instruction:
            computer.addInput(ord(c))
        computer.addInput(10)

def parseTile(pos, s):
    ejectedStr = "you are ejected back to the checkpoint"
    if not "== " in s:
        return None
    #print (s)
    if not "Analysis complete!" in s:
        s = s.split("Command?")
        ejected = ejectedStr in s[-2]
        s = s[-2].strip("\n").split(ejectedStr)[0].split("\n")
        currentTile = Tile(pos, s)
        #print (currentTile)
    else:
        print (s)
        currentTile = Tile(pos) # data doesn't matter at this point, we have successfully entered the room
        ejected = False
    return currentTile, ejected

def visit(level, startPos, targetPos, computer):
    if startPos == targetPos:
        return level[startPos]
    path = bfs(level, startPos, targetPos)
    followPath(path, computer)
    currentTile = None
    s = ""
    ejected = False
    while True:
        output = computer.execute()
        if output == None:
            currentTile, ejected = parseTile(targetPos, s)
            level[targetPos] = currentTile
            s = ""
            break
        else:
            s += chr(output)
    if ejected:
        currentTile = level[path[-2]]
    return currentTile

def explore(level, startPos, computer):
    stack = level[startPos].neighborTiles[:]
    currentPos = startPos
    while len(stack) > 0:
        nextPos = stack.pop()
        if nextPos in level:
            continue
        currentTile = visit(level, currentPos, nextPos, computer)
        startStr = ""
        currentPos = currentTile.pos
        for i in range(len(currentTile.neighborTiles)):
            if not currentTile.neighborTiles[i] in level:
                stack.append(currentTile.neighborTiles[i])
    if currentPos != startPos:
        visit(level, currentPos, startPos, computer)

class Tile:
    def __init__(self, pos, s = [""]):
        self.pos = pos
        self.name = s[0]
        self.directions = []    # in the end this field wasn't used for anything but checking if parsing worked properly
        self.items = []
        self.neighborTiles = []
        if "- north" in s:
            self.directions.append("north")
            self.neighborTiles.append((pos[0], pos[1] + 1))
        if "- east" in s:
            self.directions.append("east")
            self.neighborTiles.append((pos[0] + 1, pos[1]))
        if "- west" in s:
            self.directions.append("west")
            self.neighborTiles.append((pos[0] - 1, pos[1]))
        if "- south" in s:
            self.directions.append("south")
            self.neighborTiles.append((pos[0], pos[1] - 1))
        if "Items here:" in s:
            itemsIndex = s.index("Items here:") + 1
            while itemsIndex < len(s) and s[itemsIndex] != "":
                self.items.append(s[itemsIndex][2:])
                itemsIndex += 1
    def __str__(self):
        return "Tile \tname: " + self.name + "\n" \
        + "\tpos: " + str(self.pos) + "\n" \
        + "\tdirections: " + str(self.directions) + "\n" \
        + "\titems: " + str(self.items) + "\n" \
        + "\tneighborTiles: " + str(self.neighborTiles) + "\n"


runGame()