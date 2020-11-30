class Reindeer:
    def __init__(self, name, speed, travelDuration, restDuration):
        self.name = name
        self.speed = speed
        self.travelDuration = travelDuration
        self.restDuration = restDuration
        self.stamina = self.travelDuration
        self.distanceTraveled = 0
        self.resting = 0

    def simulate(self):
        if self.resting == self.restDuration:
            self.stamina = self.travelDuration
            self.resting = 0
        if self.stamina > 0:
            self.distanceTraveled += self.speed
            self.stamina -= 1
        else:
            self.resting += 1

    def __str__(self):
        result = self.name
        result += "\t speed: " + str(self.speed)
        result += "\t travelDuration: " + str(self.travelDuration)
        result += "\t restDuration: " + str(self.restDuration)
        result += "\t stamina: " + str(self.stamina)
        result += "\t distanceTraveled: " + str(self.distanceTraveled)
        result += "\t resting: " + str(self.resting)
        return result

input = open("input", "r")

reindeers = []
for line in input:
    parts = line.split(" ")
    reindeers.append(Reindeer(parts[0], int(parts[3]), int(parts[6]), int(parts [-2])))

finishLine = 2503
for i in range(finishLine):
    for reindeer in reindeers:
        reindeer.simulate()

print reduce(lambda a, b: a if a.distanceTraveled > b.distanceTraveled else b, reindeers).distanceTraveled
