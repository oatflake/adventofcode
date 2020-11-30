input = open("input", "r").read().strip("\n").split(' ')
numPlayers = int(input[0])
numMarbles = int(input[6])

class Marble:
    def __init__(self, value, left, right):
        self.value = value
        self.left = left
        self.right = right

currentMarble = Marble(0, None, None)
currentMarble.left = currentMarble
currentMarble.right = currentMarble
placedMarbles = 1
players = [0] * numPlayers
currentPlayer = 0
for i in range(1, numMarbles + 1):
    if i % 23 == 0:
        players[currentPlayer] += i
        for j in range(6):
            currentMarble = currentMarble.left
        players[currentPlayer] += currentMarble.left.value
        currentMarble.left.left.right = currentMarble
        currentMarble.left = currentMarble.left.left.right
    else:
        newMarble = Marble(placedMarbles, currentMarble.right, currentMarble.right.right)
        currentMarble.right.right.left = newMarble
        currentMarble.right.right = newMarble
        currentMarble = newMarble
    placedMarbles += 1
    currentPlayer += 1
    currentPlayer %= numPlayers

maxScore = -1
for score in players:
    if score > maxScore:
        maxScore = score
print maxScore
