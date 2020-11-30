input = "3113322113"

for round in range(40):
    c = input[0]
    k = 1
    output = ""
    for i in range(1, len(input)):
        if c == input[i]:
            k += 1
        else:
            output += str(k) + str(c)
            c = input[i]
            k = 1
    input = output + str(k) + str(c)
print len(input)
