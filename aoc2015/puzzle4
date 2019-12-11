input = open("input", "r")
length = 0
for line in input:
    dimensions = map(int, line.split("x"))
    volume = dimensions[0] * dimensions[1] * dimensions[2]
    dimensions = sorted(dimensions)
    minPerimeter = 2 * (dimensions[0] + dimensions[1])
    length += minPerimeter + volume
print length
