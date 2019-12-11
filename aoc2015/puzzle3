input = open("input", "r")
paper = 0
for line in input:
    dimensions = map(int, line.split("x"))
    area1 = dimensions[0] * dimensions[1]
    area2 = dimensions[0] * dimensions[2]
    area3 = dimensions[1] * dimensions[2]
    paper += 2 * (area1 + area2 + area3) + min(area1, area2, area3)
print paper
