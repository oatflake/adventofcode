import sys

input = open("input", "r").read().strip('\n')

minLayerIndex = -1
minZeros = sys.maxsize
for layerIndex in range(len(input)/(25*6)):
    numZeros = 0 
    for i in range(25*6):
        if input[layerIndex * (25*6) + i] == "0":
            numZeros += 1
    if numZeros < minZeros:
        minLayerIndex = layerIndex
        minZeros = numZeros
ones = 0
twos = 0
for i in range(25*6):
    if input[minLayerIndex * (25*6) + i] == "1":
        ones += 1
    if input[minLayerIndex * (25*6) + i] == "2":
        twos += 1
print ones * twos
