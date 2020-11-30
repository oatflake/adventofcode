fuelSum = 0
file = open("input", "r") 
for line in file: 
    requiredFuel = int(line) / 3 - 2
    fuelForModule = 0
    while requiredFuel > 0:
        fuelForModule += requiredFuel
        requiredFuel = requiredFuel / 3 - 2
    fuelSum += fuelForModule
print fuelSum
