import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

def check(x, y, input):
    computer = IntcodeComputer(input)
    computer.addInput(x)
    computer.addInput(y)
    return computer.execute()

input = open("input", "r").read()
total = 0
for i in range(50):
    for j in range(50):
        total += check(i, j, input)
print(total)
