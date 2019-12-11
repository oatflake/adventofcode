import json

def addNumbers(arbitraryStuff):
    if isinstance(arbitraryStuff, basestring):
        return 0
    if isinstance(arbitraryStuff, int):
        return arbitraryStuff
    if isinstance(arbitraryStuff, dict):
        sum = 0
        for i in arbitraryStuff:
            sum += addNumbers(arbitraryStuff[i])
        return sum
    if isinstance(arbitraryStuff, list):
        sum = 0
        for i in arbitraryStuff:
            sum += addNumbers(i)
        return sum
    print "Unknown Type: ", arbitraryStuff

input = json.load(open("input"))
print addNumbers(input)
