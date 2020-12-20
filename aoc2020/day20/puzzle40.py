input = open("input", "r")
from functools import reduce
from operator import add

class Tile:
    width = 10
    def __init__(self, id, map):
        self.id = id
        self.map = map
        self.borderIDs = self.calcBorderIds()
        
    def toBorderID(self, border):
        id1 = id2 = 0
        for i in range(10):
            j = 9 - i
            id1 += (1 if border[i] == '#' else 0) * pow(2, i)
            id2 += (1 if border[j] == '#' else 0) * pow(2, i)
        return (id1, id2)
    
    def calcBorderIds(self):
        top = bottom = left = right = ""
        for i in range(10):
            top += self.map[i + 0 * Tile.width]
            bottom = self.map[i + (Tile.width - 1) * Tile.width] + bottom
            left = self.map[0 + i * Tile.width] + left
            right += self.map[Tile.width - 1 + i * Tile.width]
        ids = map(self.toBorderID, [top, left, bottom, right])
        return ids

    def rightRotated(self, tmpMap):
        [top,left,bottom,right] = self.borderIDs
        rotateImage(self.map, tmpMap, Tile.width)
        return [left,bottom,right,top]

    def horizontallyFlipped(self, tmpMap):
        [(tLR, tRL),(lBT,lTB),(bRL,bLR),(rTB,rBT)] = self.borderIDs
        flipImage(self.map, tmpMap, Tile.width)
        return [(tRL,tLR),(rBT,rTB),(bLR,bRL),(lTB,lBT)]

    def orientTowards(self, otherBorder, matchedBorderIndex):
        (a,b) = otherBorder
        border = (b,a)
        tmpMap = self.map[:]
        if self.borderIDs[matchedBorderIndex] == border:
            return
        for i in range(3):
            self.borderIDs = self.rightRotated(tmpMap)
            tmpMap, self.map = self.map, tmpMap
            if self.borderIDs[matchedBorderIndex] == border:
                return
        self.borderIDs = self.horizontallyFlipped(tmpMap)
        tmpMap, self.map = self.map, tmpMap
        if self.borderIDs[matchedBorderIndex] == border:
            return
        for i in range(3):
            self.borderIDs = self.rightRotated(tmpMap)
            tmpMap, self.map = self.map, tmpMap
            if self.borderIDs[matchedBorderIndex] == border:
                return

    def printTile(self):
        for y in range(Tile.width):
            print reduce(add, self.map[y * Tile.width : (y + 1) * Tile.width])

def rotateImage(image, tmpImage, width):
    for y in range(width):
        for x in range(width):
            x1 =  width - 1 - y
            y1 = x
            tmpImage[x1 + y1 * width] = image[x + y * width]

def flipImage(image, tmpImage, width):
    for y in range(width):
        for x in range(width):
            x1 = width - 1 - x 
            tmpImage[x1 + y * width] = image[x + y * width]

def parseTiles():
    tiles = []
    i = 0
    tileID = -1
    tileMap = ""
    for line in input:
        line = line.strip()
        if i == 0:
            tileID = int(line.split(" ")[1][:-1])
            tileMap = ""
        elif 0 < i < 11:
            tileMap += line
        if i == 11:
            tiles.append(Tile(tileID, list(tileMap)))
        i += 1
        i %= 12
    return tiles

def connectBorders(tiles):
    borderToTiles = dict()
    for tile in tiles:
        for (a, b) in tile.borderIDs:
            border = min(a, b)
            if not border in borderToTiles:
                borderToTiles[border] = []
            borderToTiles[border].append(tile)
    return borderToTiles

def findCorners(tiles, borderToTiles):
    corners = []
    for tile in tiles:
        neighbors = 0
        for (a, b) in tile.borderIDs:
            border = min(a, b)
            if len(borderToTiles[border]) == 2:
                neighbors += 1
        if neighbors == 2:
            corners.append(tile)
    return corners

def orientLeftTopCorner(tile, borderToTiles):
    [top, left, bottom, right] = map(min, tile.borderIDs)
    tmpMap = tile.map[:]
    while len(borderToTiles[top]) != 1 or len(borderToTiles[left]) != 1:
        tile.borderIDs = tile.rightRotated(tmpMap)
        tile.map, tmpMap = tmpMap, tile.map
        [top, left, bottom, right] = map(min, tile.borderIDs)

def orientTopTiles(topLeftCorner, borderToTiles):
    topTiles = []
    x = 0
    current = topLeftCorner
    while current != None:
        topTiles.append(current)
        current.pos = (x,0)
        x += 1
        neighbor = None
        for n in borderToTiles[min(current.borderIDs[3])]:
            if n != current:
                neighbor = n
        if neighbor != None:
            neighbor.orientTowards(current.borderIDs[3], 1)
        current = neighbor
    return topTiles

def orientTileColumn(topTile, borderToTiles):
    x = topTile.pos[0]
    y = 0
    current = topTile
    while current != None:
        current.pos = (x,y)
        y += 1
        neighbor = None
        for n in borderToTiles[min(current.borderIDs[2])]:
            if n != current:
                neighbor = n
        if neighbor != None:
            neighbor.orientTowards(current.borderIDs[2], 0)
        current = neighbor

def orientTilesVertically(topTiles, borderToTiles):
    for topTile in topTiles:
        orientTileColumn(topTile, borderToTiles)

def mergeTiles(tilesMap, maxX, maxY):
    mergedMap = []
    for ty in range(maxY + 1):
        y1 = 1
        y2 = Tile.width - 1
        for y in range(y1, y2, 1):
            for tx in range(maxX + 1):
                tile = tilesMap[(tx, ty)]
                x1 = y * Tile.width + 1
                x2 = (y + 1) * Tile.width + -1
                mergedMap += tile.map[x1 : x2]
    return mergedMap

def printMergedMap(mergedMap, width, height):
    for y in range(height):
        print reduce(add, mergedMap[y * width : (y + 1) * width])

def searchMonsters(image, width, height):
    monsterPattern = [(0,1), (1,2), (4,2), (5,1), (6,1), \
                    (7,2), (10,2), (11,1), (12,1), (13,2), \
                    (16,2), (17,1), (18,1), (18,0), (19,1)]
    monsters = 0
    for x in range(width - 19):
        for y in range(height - 2):
            ok = True
            for d in monsterPattern:
                x1, y1 = x + d[0], y + d[1]
                ok = ok and image[x1 + y1 * width] == '#'
            if ok:
                monsters += 1
    return monsters

def lookForSeaMonsters(image, width, height):
    tmpImage = image[:]
    monsters = []
    monsters.append(searchMonsters(image, width, height))
    for i in range(3):
        rotateImage(image, tmpImage, width)
        image, tmpImage = tmpImage, image
        monsters.append(searchMonsters(image, width, height))
    flipImage(image, tmpImage, width)
    image, tmpImage = tmpImage, image
    monsters.append(searchMonsters(image, width, height))
    for i in range(3):
        rotateImage(image, tmpImage, width)
        image, tmpImage = tmpImage, image
        monsters.append(searchMonsters(image, width, height))
    return monsters

def main():
    tiles = parseTiles()
    borderToTiles = connectBorders(tiles)
    corners = findCorners(tiles, borderToTiles)
    result = 1
    for corner in corners:
        result *= corner.id
    topLeftCorner = corners[0]
    orientLeftTopCorner(topLeftCorner, borderToTiles)
    topTiles = orientTopTiles(topLeftCorner, borderToTiles)
    orientTilesVertically(topTiles, borderToTiles)
    tilesMap = dict()
    for tile in tiles:
        tilesMap[tile.pos] = tile
    maxX = max(map(lambda t: t.pos[0], corners))
    maxY = max(map(lambda t: t.pos[1], corners))
    mergedMap = mergeTiles(tilesMap, maxX, maxY)
    mergedWidth = (maxX + 1) * (Tile.width - 2)
    mergedHeight = (maxY + 1) * (Tile.width - 2)
    monsters = lookForSeaMonsters(mergedMap, mergedWidth, mergedHeight)
    monstersCount = reduce(add, monsters)
    #printMergedMap(mergedMap, mergedWidth, mergedHeight)
    count = 0
    for c in mergedMap:
        if c == '#':
            count += 1
    return count - monstersCount * 15

print main()