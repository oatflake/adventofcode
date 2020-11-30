import sys

input = open("input", "r").read().strip('\n')

image = ["2" for i in range(25 * 6)]
for layerIndex in range(len(input)/(25*6)):
    numZeros = 0 
    for i in range(25*6):
        if image[i] == "2":
            if input[layerIndex * (25*6) + i] == "0":
                image[i] = "0"
            if input[layerIndex * (25*6) + i] == "1":
                image[i] = "1"
for i in range(6):
    line = ""
    for j in range(25):
        line += image[i * 25 + j]
    print line
