input = open("input", "r")
input = input.read().strip("\n").split(' ')
input = [int(x) for x in input]

def metaSum(i):
    numChildren = input[i]
    numMetaData = input[i + 1]
    offset = 2
    sum = 0
    if numChildren > 0:
        childrenSums = [0] * numChildren
        for c in range(numChildren):
            pointer = i + offset
            childOffset, childSum = metaSum(pointer)
            offset += childOffset
            childrenSums[c] = childSum
        for m in range(numMetaData):
            if input[i + offset + m] <= numChildren:
                sum += childrenSums[input[i + offset + m] - 1]
    else:
        for m in range(numMetaData):
            sum += input[i + offset + m]
    offset += numMetaData
    return offset, sum

print(metaSum(0)[1])
