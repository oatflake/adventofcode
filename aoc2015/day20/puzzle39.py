from math import sqrt

input = 34000000

def presents(n):
    sum = 1 + n
    limit = int(sqrt(n)) + 1
    for i in range(2, limit):
        if n % i == 0:
            sum += i
            o = n / i
            if o != i:
                sum += o
    return sum * 10

for k in range(input):
    if presents(k) >= input:
        print k
        break