input = open("input", "r")

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
        return min(id1, id2)
    
    def calcBorderIds(self):
        top = bottom = left = right = ""
        for i in range(10):
            top += self.map[i + 0 * Tile.width]
            bottom += self.map[i + (Tile.width - 1) * Tile.width]
            left += self.map[0 + i * Tile.width]
            right += self.map[Tile.width - 1 + i * Tile.width]
        ids = map(self.toBorderID, [top, left, bottom, right])
        return ids

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
            tiles.append(Tile(tileID, tileMap))
        i += 1
        i %= 12
    return tiles

def connectBorders(tiles):
    borderToTiles = dict()
    for tile in tiles:
        for border in tile.borderIDs:
            if not border in borderToTiles:
                borderToTiles[border] = []
            borderToTiles[border].append(tile)
    return borderToTiles

def findCorners(tiles, borderToTiles):
    corners = []
    for tile in tiles:
        neighbors = 0
        for border in tile.borderIDs:
            if len(borderToTiles[border]) == 2:
                neighbors += 1
        if neighbors == 2:
            corners.append(tile)
    return corners

def main():
    tiles = parseTiles()
    borderToTiles = connectBorders(tiles)
    corners = findCorners(tiles, borderToTiles)
    result = 1
    for corner in corners:
        result *= corner.id
    return result

print main()