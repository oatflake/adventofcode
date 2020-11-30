import time
input = "cqjxjnds"

def increasing(string):
    tripples = (string[i:i+3] for i in range(len(string)-2))
    differences = map(lambda s: ord(s[0]) == ord(s[1]) - 1 == ord(s[2]) - 2, tripples)
    return reduce(lambda a, b: a or b, differences)

def illegaChars(string):
    return "i" in string or "o" in string or "l" in string

def twoPairs(string):
    i = 0
    character = ""
    pairs = set()
    while i < len(string):
        if character == string[i]:
            if character in pairs:
                return True
            pairs.add(character)
            character = ""
        else:
            character = string[i]
        i += 1
    return len(pairs) >= 2

while not increasing(input) or illegaChars(input) or not twoPairs(input):
    shift = True
    for i in range(len(input) - 1, -1, -1):
        if ord(input[i]) < ord("z"):
            input = input[0:i] + chr(ord(input[i]) + 1) + input[i+1:len(input)]
            shift = False
            break
        input = input[0:i] + "a" + input[i+1:len(input)]
    if shift:
        input += "a"
print input
