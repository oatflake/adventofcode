def sums(input, output):
    sum = 0
    for i in range(len(input) - 1, -1, -1):
        sum += input[i]
        output[i] = sum % 10

input = open("input", "r").read().strip("\n")
offset = int(input[:7])
input = map(int, (input*10000)[offset:])

output = input[:]
for i in range(100):
    input, output = output, input
    sums(input, output)

print ''.join(map(str, output[:8]))
