N = 1000000

def destination(currentIndex, cups):
    destIndex = (currentIndex + (N - 1)) % N
    while destIndex in cups:
        destIndex = (destIndex + (N - 1)) % N
    return destIndex

def main():
    input = "215694783"
    cups, currentIndex = prepareCups(input)
    for i in range(10000000):
        aIndex = cups[currentIndex]
        bIndex = cups[aIndex]
        cIndex = cups[bIndex]
        cups[currentIndex] = cups[cIndex]
        destIndex = destination(currentIndex, [aIndex, bIndex, cIndex])
        cups[cIndex] = cups[destIndex]
        cups[destIndex] = aIndex
        currentIndex = cups[currentIndex]
    firstIndex = cups[0]
    secondIndex = cups[firstIndex]
    return (firstIndex + 1) * (secondIndex + 1)

def prepareCups(input):
    input = map(int, list(input))
    cups = [i + 1 for i in range(N)]
    for i in range(len(input) - 1):
        cups[input[i] - 1] = input[i + 1] - 1 
    cups[input[-1] - 1] = len(input)
    cups[-1] = input[0] - 1
    return cups, input[0] - 1

print main()