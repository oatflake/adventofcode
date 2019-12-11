import hashlib

input = "bgvyzdsv"
allZero = False
i = -1
while not allZero:
    i += 1
    hash = hashlib.md5(input + str(i)).hexdigest()
    allZero = reduce(lambda a, b: a and b, map(lambda a: a == "0", hash[:5]))
print i
