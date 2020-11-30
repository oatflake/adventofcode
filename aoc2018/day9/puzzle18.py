import sys

input = open("input", "r").read().strip("\n").split(' ')
numPlayers = int(input[0])
numMarbles = int(input[6]) * 100
leftNeighbors = [-1] * (numMarbles + 1)
rightNeighbors = [-1] * (numMarbles + 1)
currentMarble = 0
leftNeighbors[0] = currentMarble
rightNeighbors[0] = currentMarble
placedMarbles = 1
players = [0] * numPlayers
currentPlayer = 0
for i in range(1, numMarbles + 1):
    if i % 23 == 0:
        players[currentPlayer] += i
        for j in range(6):
            currentMarble = leftNeighbors[currentMarble]
        players[currentPlayer] += leftNeighbors[currentMarble]
        rightNeighbors[leftNeighbors[leftNeighbors[currentMarble]]] = currentMarble
        leftNeighbors[currentMarble] = rightNeighbors[leftNeighbors[leftNeighbors[currentMarble]]]
    else:
        leftNeighbors[placedMarbles] = rightNeighbors[currentMarble]
        rightNeighbors[placedMarbles] = rightNeighbors[rightNeighbors[currentMarble]]
        leftNeighbors[rightNeighbors[rightNeighbors[currentMarble]]] = placedMarbles
        rightNeighbors[rightNeighbors[currentMarble]] = placedMarbles
        currentMarble = placedMarbles
    placedMarbles += 1
    currentPlayer += 1
    currentPlayer %= numPlayers

maxScore = -1
for score in players:
    if score > maxScore:
        maxScore = score
print maxScore
