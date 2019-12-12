import sys
import operator

def mul(scalar, vector):
    return tuple(vector[i] * scalar for i in range(len(vector)))

def add(vectorA, vectorB):
    return tuple(vectorA[i] + vectorB[i] for i in range(len(vectorA)))

input = open("input", "r")
ingredientVectors = []
calories = []
for line in input:
    parts = line.strip("\n").split(" ")
    capacity = int(parts[2][:-1])
    durability = int(parts[4][:-1])
    flavor = int(parts[6][:-1])
    texture = int(parts[8][:-1])
    ingredientVectors.append((capacity, durability, flavor, texture))
    calories.append(int(parts[10]))
    
maxTotalScore = -sys.maxsize
combinations = ((i, j, k, l) for i in range(101) for j in range(101) for k in range(101) for l in range(101))
for cookie in combinations:
    i, j, k, l = cookie
    if i + j + k + l != 100:
        continue
    if i * calories[0] + j * calories[1] + k * calories[2] + l * calories[3] != 500:
        continue
    result = mul(i, ingredientVectors[0])
    result = add(result, mul(j, ingredientVectors[1]))
    result = add(result, mul(k, ingredientVectors[2]))
    result = add(result, mul(l, ingredientVectors[3]))
    result = map(lambda a: max(a, 0), result)
    maxTotalScore = max(maxTotalScore, reduce(operator.mul, result))
print maxTotalScore
