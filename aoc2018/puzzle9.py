input = open("input", "r").read().strip('\n')
while True:
    length = len(input)
    for letter in range(0, 26):
        l = chr(ord('a') + letter)
        u = chr(ord('A') + letter)
        input = input.replace(u + l, "")
        input = input.replace(l + u, "")
    if len(input) == length:
        break
print len(input)
