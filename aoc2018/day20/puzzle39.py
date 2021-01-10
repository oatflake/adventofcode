import sys
from collections import deque

def move((x, y), dir):
    if dir == "N":
        return x, y + 1
    elif dir == "S":
        return x, y - 1
    elif dir == "W":
        return x - 1, y
    elif dir == "E":
        return x + 1, y
    else:
        print "ERROR: Called move with ", dir

def options(word, i, l):
    ranges = []
    begin = i + 1
    openBrackets = 0
    for j in range(1, l):
        k = i + j
        if word[k] == "(":
            openBrackets += 1
        if word[k] == ")":
            if openBrackets == 0:
                ranges.append((begin, k - begin))
                break
            else:
                openBrackets -= 1
        if openBrackets == 0 and word[k] == "|":
            ranges.append((begin, k - begin))
            begin = k + 1
    return ranges, i + j + 1

def follow(word, pos, i, l, level, memo):
    posCopy = pos
    if (posCopy, i, l) in memo:
        return memo[(posCopy, i, l)]
    j = 0
    newPos = pos
    for j in range(l):
        k = i + j
        if word[k] != "(":
            newPos = move(pos, word[k])
            if not newPos in level:
                level[newPos] = set()
            level[newPos].add(pos)
            level[pos].add(newPos)
            pos = newPos
        else:
            break
    if j < l - 1:
        newPositions = set()
        ranges, newIndex = options(word, k, l - j)
        for (rangeBegin, rangeLength) in ranges:
            tmpPositions = follow(word, newPos, rangeBegin, rangeLength, level, memo)
            for tmpPos in tmpPositions:
                positions = follow(word, tmpPos, newIndex, l - newIndex + i, level, memo)
                newPositions = newPositions.union(positions)
        memo[(posCopy, i, l)] = newPositions
        return newPositions
    else:
        memo[(posCopy, i, l)] = set([newPos])
        return set([newPos])
    
def bfs(level, startPos):
    queue = deque([(startPos, 0)])
    seen = set()
    steps = 0
    while len(queue) > 0:
        current, steps = queue.popleft()
        for neighbor in level[current]:
            if not neighbor in seen:
                queue.append((neighbor, steps + 1))
                seen.add(neighbor)
    return steps

def main():
    input = open("input", "r").readline().strip()[1:-1]
    level = dict()
    level[(0,0)] = set()
    follow(input, (0, 0), 0, len(input), level, dict())
    print bfs(level, (0,0))

main()