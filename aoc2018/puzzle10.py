import sys

minLength = sys.maxsize
for i in range(0, 26):
    input = open("input", "r").read().strip('\n')
    input = input.replace(chr(ord('a') + i), "")
    input = input.replace(chr(ord('A') + i), "")
    while True:
        length = len(input)
        for letter in range(0, 26):
            l = chr(ord('a') + letter)
            u = chr(ord('A') + letter)
            input = input.replace(u + l, "")
            input = input.replace(l + u, "")
        if len(input) == length:
            break
    minLength = min(minLength, len(input))
print(minLength)
