import math

def computeOre(amount, chemical):
    if chemical == "ORE":
        return amount
    if chemical in resources:
        leftOver = resources[chemical]
        difference = leftOver - amount
        leftOver = max(difference, 0)
        amount = -min(difference, 0)
        resources[chemical] = leftOver
    reaction = reactions[chemical]
    ore = 0
    if not chemical in resources:
        resources[chemical] = 0
    factor = int(math.ceil(float(amount) / reaction[-2]))
    resources[chemical] += factor * reaction[-2] - amount;
    for i in range(0, len(reaction) - 2, 2):
        ingredientAmount = reaction[i]
        ingredient = reaction[i + 1]
        ore += computeOre(ingredientAmount * factor, ingredient)
    return ore

input = open("input", "r")
reactions = dict()
for line in input:
    line = line.strip("\n").replace(",", "").replace("=> ", "")
    chemicals = line.split(" ")
    for i in range(0, len(chemicals), 2):
        chemicals[i] = int(chemicals[i])
    reactions[chemicals[-1]] = chemicals

oreBudget = 1000000000000
fuelLower = 0
fuelUpper = 1
resources = dict()
while computeOre(fuelUpper, "FUEL") < oreBudget:
    fuelUpper *= 2
    resources = dict()
midFuel = 0

while fuelLower <= fuelUpper:
    midFuel = (fuelUpper + fuelLower) / 2
    resources = dict()
    ore = computeOre(midFuel, "FUEL")
    resources = dict()
    if oreBudget == ore or (oreBudget > ore and oreBudget < computeOre(midFuel + 1, "FUEL")):
        break
    if ore < oreBudget:
        fuelLower = midFuel + 1
    else:
        fuelUpper = midFuel - 1
print midFuel
