input = open("input", "r").read()
floor = 0
for i in range(len(input)):
    floor += 1 if input[i] == "(" else -1
    if floor == -1:
        break
print i + 1
