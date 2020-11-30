# --- taken from: https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm ---

def xgcd(a, b):
    """return (g, x, y) such that a*x + b*y = g = gcd(a, b)"""
    x0, x1, y0, y1 = 0, 1, 1, 0
    while a != 0:
        (q, a), b = divmod(b, a), a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
    return b, x0, y0

def modinv(a, b):
    """return x such that (x * a) % b == 1"""
    g, x, _ = xgcd(a, b)
    if g != 1:
        raise Exception('gcd(a, b) != 1')
    return x % b

# -------------------------------------------------------------------------------------------------------------------

# dealNewStack, cutN and dealIncrement are all linear transformations!
#
# the inverse of a linear function is also linear:
# h(x) = y = r * x + s    # h(x) is linear
# h^{-1}(y) = x = (y - s) / r = y * r^{-1} - s * r^{-1}    # h^{-1} is linear as well!
#
# we can also combine linear functions, and the result will be once again a linear function
# f(x) = a * x + b    # f(x) is linear.
# g(x) = c * x + d    # g(x) is linear.
# g(f(x)) = c * (a * x + b) + d = (c * a) * x + (c * b + d)    # g(f(x)) is also linear!
#
# therefore, all linear transformations can be combined into one linear function: f'
# f'(x) = q * x + p
#
# q and p are unknowns, which we have to find.
# f'(0) = p
# f'(1) - f'(0) = (q * 1 + p) - p = q
# therefore determine f'(0) and f'(1) to find p and q this way!
#
# then f' has to be applied often!
# f'(x) = q * x + p
# f'(f'(x)) = q * (q * x + p) + p = q * q * x + q * p + p
# f'(f'(f'(x))) = q * q * q * x + q * q * p + q * p + p
# f'^k(x) = q^k * x + p * (1 + q + q * q + q * q * q + ... + q^(k-1))
# notice the geometric series! https://en.wikipedia.org/wiki/Finite_geometric_series#Derivation
#
# so f'^k becomes:
# f'^k(x) = q^k * x + p(1 - q^k) / (1 - q)
#
# inversing dealNewStack and cutN is easy.
# dealIncrement is multiplication, so we need the multiplicative inverse aka division
# the extended euclidean algorithm can be used to that, see above from wikibooks 
# we also need the multiplicative inverse for dividing by (1 - q) when computing f'^k


def dealNewStackInverse(cardPos):
    return (deckSize - cardPos - 1) % deckSize

def cutNInverse(cardPos, n):
    return (cardPos + n) % deckSize

def dealIncrementInverse(cardPos, n):
    n = modinv(n, deckSize)
    return (cardPos * n) % deckSize

def inverseShuffle(lines, x):
    for i in range(len(lines) - 1, -1, -1):
        line = lines[i]    
        if line.startswith("deal with increment"):
            n = int(line.split(" ")[-1])
            x = dealIncrementInverse(x, n)
        if line.startswith("deal into new stack"):
            x = dealNewStackInverse(x)
        if line.startswith("cut"):
            n = int(line.split(" ")[-1])
            x = cutNInverse(x, n)
    return x

def multipleShuffles(x, q, p, k, m):
    return (pow(q, k, m) * x + p * (1 - pow(q, k, m)) * modinv(1 - q + m, m)) % m

year = 2020
deckSize = 119315717514047
shuffles = 101741582076661

input = open("input", "r")
lines = []
for line in input:
    lines.append(line.strip("\n"))

p = inverseShuffle(lines, 0)
q = inverseShuffle(lines, 1) - p

result = multipleShuffles(year, q, p, shuffles, deckSize)
print result
