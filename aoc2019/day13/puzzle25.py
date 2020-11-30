import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

input = open("input", "r").read().strip("\n")
computer = IntcodeComputer(input)

level = dict()
event = [-1]*3
while True:
    for i in range(3):
        event[i] = computer.execute()
    if event[0] == None:
        break
    level[(event[0], event[1])] = event[2]
blocks = 0
for key, value in level.items():
    if value == 2:
        blocks += 1
print(blocks)
