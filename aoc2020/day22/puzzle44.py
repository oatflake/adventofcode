from collections import deque

def readInput():
    input = open("input", "r")
    deck1 = deque()
    deck2 = deque()
    current = deck1
    for line in input:
        if line.startswith("Player"):
            continue
        elif line == "\n":
            current = deck2
        else:
            line = line.strip()
            current.append(int(line))
    return deck1, deck2

def createNewDeck(oldDeck, size):
    stack = []
    newDeck = deque()
    for i in range(size):
        stack.append(oldDeck.popleft())
    for i in range(size):
        card = stack.pop()
        oldDeck.appendleft(card)
        newDeck.appendleft(card)
    return newDeck

def play(deck1, deck2):
    history = set()
    while len(deck1) > 0 and len(deck2) > 0:
        if (str(deck1), str(deck2)) in history:
            return True
        history.add((str(deck1), str(deck2)))
        card1 = deck1.popleft()
        card2 = deck2.popleft()
        if card1 <= len(deck1) and card2 <= len(deck2):
            tmpDeck1 = createNewDeck(deck1, card1)
            tmpDeck2 = createNewDeck(deck2, card2)
            player1WinsRound = play(tmpDeck1, tmpDeck2)
        else:
            player1WinsRound = card1 > card2
        if player1WinsRound:
            deck1.append(card1)
            deck1.append(card2)
        else:
            deck2.append(card2)
            deck2.append(card1)
    return len(deck2) == 0

def score(scoredDeck):
    l = len(scoredDeck)
    score = 0
    for i in range(1, l + 1):
        score += scoredDeck[l - i] * i
    return score

def main():
    deck1, deck2 = readInput()
    return score(deck1) if play(deck1, deck2) else score(deck2)

print main()