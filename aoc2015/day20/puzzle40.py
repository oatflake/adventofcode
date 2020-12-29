from math import sqrt

input = 34000000

def presents(n):
    sum = 0
    limit = int(sqrt(n)) + 1
    for i in range(1, limit):
        if n % i == 0:
            o = n / i
            if o <= 50:
                sum += i
            if o != i:
                if i <= 50:
                    sum += o
    return sum * 11

for k in range(input):
    if presents(k) >= input:
        print k
        break