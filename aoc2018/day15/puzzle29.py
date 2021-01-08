from enum import Enum
from collections import deque
import sys

class UnitType(Enum):
    GOBLIN = 0
    ELF = 1

class Unit:
    def __init__(self, tile, type):
        self.tile = tile
        self.type = type
        self.hp = 200
        self.attackPower = 3

class Tile:
    def __init__(self, x, y, wall):
        self.x = x
        self.y = y
        self.wall = wall
        self.unit = None

class Game:
    def __init__(self, level, width, height):
        self.width = width
        self.height = height
        self.tiles = [ None ] * (width * height)
        self.goblins = []
        self.elves = []
        for y in range(height):
            for x in range(width):
                i = x + y * width
                self.tiles[i] = Tile(x, y, level[i] == "#")
                if level[i] == "G":
                    goblin = Unit(self.tiles[i], UnitType.GOBLIN)
                    self.goblins.append(goblin)
                    self.tiles[i].unit = goblin
                if level[i] == "E":
                    elf = Unit(self.tiles[i], UnitType.ELF)
                    self.elves.append(elf)
                    self.tiles[i].unit = elf

    def printLevel(self):
        for y in range(self.height):
            line = ""
            for x in range(self.width):
                tile = self.tiles[x + y * self.width]
                if tile.wall:
                    line += "#"
                elif tile.unit == None:
                    line += "."
                else:
                    line += "E" if tile.unit.type == UnitType.ELF else "G"
            print line
        
def round(game):
    units = []
    units += game.elves
    units += game.goblins
    units.sort(key = lambda u: u.tile.x + u.tile.y * game.width)
    for unit in units:
        if unit.hp > 0:
            if len(game.goblins) == 0 or len(game.elves) == 0:
                return False
            turn(game, unit)
    return True

def neighborTiles(game, (x, y)):
    tiles = []
    neighborPositions = [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
    for neighborPos in neighborPositions:
        if 0 <= neighborPos[0] < game.width and 0 <= neighborPos[1] < game.height:
            tiles.append(game.tiles[neighborPos[0] + neighborPos[1] * game.width])
    return tiles

def bfs(game, startTiles, inrange):
    queue = deque([(s, 0) for s in startTiles])
    results = []
    stepsToGoal = sys.maxint
    closed = dict()
    for s in startTiles:
        closed[s] = None
    while len(queue) > 0:
        currentTile, steps = queue.popleft()
        if steps > stepsToGoal:
            break
        if currentTile in inrange:
            stepsToGoal = steps
            results.append(currentTile)
        for neighborTile in neighborTiles(game, (currentTile.x, currentTile.y)):
            if neighborTile.wall == False and neighborTile.unit == None and not neighborTile in closed:
                queue.append((neighborTile, steps + 1))
                closed[neighborTile] = currentTile
    return results

def adjacentEnemies(game, unit):
    enemies = []
    for neighborTile in neighborTiles(game, (unit.tile.x, unit.tile.y)):
        if neighborTile.wall == False and neighborTile.unit != None and neighborTile.unit.type != unit.type:
            enemies.append(neighborTile.unit)
    return enemies

def move(game, unit):
    targets = game.elves if unit.type == UnitType.GOBLIN else game.goblins
    inrange = set()
    for target in targets:
        for tile in neighborTiles(game, (target.tile.x, target.tile.y)):
            if tile.wall == False and tile.unit == None:
                inrange.add(tile)
    startTiles = []
    for tile in neighborTiles(game, (unit.tile.x, unit.tile.y)):
        if tile.wall == False and tile.unit == None:
            startTiles.append(tile)
    nearestTargetTiles = bfs(game, startTiles, inrange)
    nearestTargetTiles.sort(key = lambda t: t.x + t.y * game.width)
    if len(nearestTargetTiles) > 0:
        chosen = nearestTargetTiles[0]
        moves = bfs(game, [chosen], startTiles)
        moves.sort(key = lambda t: t.x + t.y * game.width)
        unit.tile.unit = None
        unit.tile = moves[0]
        moves[0].unit = unit

def turn(game, unit):
    enemies = adjacentEnemies(game, unit)
    if len(enemies) == 0:
        move(game, unit)
        enemies = adjacentEnemies(game, unit)
    if len(enemies) > 0:
        enemies.sort(key = lambda e: e.tile.x + e.tile.y * game.width)
        enemies.sort(key = lambda e: e.hp)
        enemy = enemies[0]
        enemy.hp -= unit.attackPower
        if enemy.hp <= 0:
            enemy.tile.unit = None
            if enemy.type == UnitType.ELF:
                game.elves.remove(enemy)
            else:
                game.goblins.remove(enemy)

def main():
    input = open("input", "r")
    level = ""
    width = 0
    height = 0
    for line in input:
        line = line.strip()
        level += line
        width = len(line)
        height += 1
    game = Game(level, width, height)
    #game.printLevel()
    r = 0
    while len(game.goblins) > 0 and len(game.elves) > 0:
        r += 1 if round(game) else 0
        #print r
        #game.printLevel()
    units = game.goblins + game.elves
    hpSum = 0
    for unit in units:
        hpSum += unit.hp
    print r * hpSum
main()
