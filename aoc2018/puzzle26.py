input = open("input", "r")

map = ""
width = 0
for line in input:
    line = line.strip('\n')
    width = len(line)
    map += line

offset = [1, width, -1, -width]
class Car:
    def __init__(self, pos, rot):
        self.pos = pos
        self.rot = rot
        self.state = 0

    def move(self):
        self.pos += offset[self.rot]

    def rotate(self, track):
        if track == '\\':
            self.rot = [1, 0, 3, 2][self.rot]
        if track == '/':
            self.rot = [3, 2, 1, 0][self.rot]
        if track == '+':
            if self.state == 0:
                self.rot += 3
            if self.state == 2:
                self.rot += 1
            self.rot %= 4
            self.state += 1
            self.state %= 3

cars = []
for i in range(len(map)):
    c = map[i]
    if c == '<':
        cars.append(Car(i, 2))
    if c == '>':
        cars.append(Car(i, 0))
    if c == '^':
        cars.append(Car(i, 3))
    if c == 'v':
        cars.append(Car(i, 1))

def simulate(cars):
    while True:
        cars = sorted(cars, key = lambda car: car.pos)
        carsCopy = cars[:]
        for car in cars:
            car.move()
            car.rotate(map[car.pos])
            for other in cars:
                if car == other:
                    continue
                if car.pos == other.pos:
                    carsCopy.remove(car)
                    carsCopy.remove(other)
        cars = carsCopy
        if len(cars) == 1:
            return cars[0].pos

result = simulate(cars)
print str(result % width) + "," + str(result // width)
