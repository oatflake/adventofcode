def dealNewStack(oldStack):
    newStack = oldStack[:]
    newStack.reverse()
    return newStack

def cutN(oldStack, n):
    return oldStack[n:] + oldStack[:n]

def dealIncrement(oldStack, n):
    stackSize = len(oldStack)
    newStack = [-1] * stackSize
    for i in range(stackSize):
        newStack[(i * n) % stackSize] = oldStack[i]
    return newStack

stack = [-1] * 10007
for i in range(10007):
    stack[i] = i
input = open("input", "r")
for line in input:
    line = line.strip("\n")
    if line.startswith("deal with increment"):
        n = int(line.split(" ")[-1])
        stack = dealIncrement(stack, n)
    if line.startswith("deal into new stack"):
        stack = dealNewStack(stack)
    if line.startswith("cut"):
        n = int(line.split(" ")[-1])
        stack = cutN(stack, n)

for i in range(len(stack)):
    if stack[i] == 2019:
        print i
        break
