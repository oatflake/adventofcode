class Bot:
    def __init__(self, coord, radius):
        self.radius = radius
        self.coord = coord

def readInput():
    input = open("input", "r")
    bots = []
    for line in input:
        line = line[len("pos=<"):]
        line = line.split(">, r=")
        coord = line[0].split(",")
        coord = [int(c) for c in coord]
        radius = int(line[1])
        bots.append(Bot(coord, radius))
    return bots

def distance(coord1, coord2):
    dist = 0
    for i in range(3):
        dist += abs(coord1[i] - coord2[i])
    return dist

def main():
    bots = readInput()
    maxBot = Bot(None, -1)
    for bot in bots:
        if bot.radius > maxBot.radius:
            maxBot = bot
    inRange = 0
    for bot in bots:
        if distance(bot.coord, maxBot.coord) < maxBot.radius:
            inRange += 1
    print inRange

main()