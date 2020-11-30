import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

def check(x, y, input):
    computer = IntcodeComputer(input)
    computer.addInput(x)
    computer.addInput(y)
    return computer.execute()

def findSlope(input):
    firstOne = -1
    lastOne = -1
    testRange = 1000
    for j in range(testRange):
        output = check(testRange, j, input)
        if output == 1:
            if firstOne == -1:
                firstOne = j
        else:
            if firstOne != -1:
                lastOne = j
                break
    return (float(firstOne) / testRange, float(lastOne) / testRange)

input = open("input", "r").read()
mF, mL = findSlope(input)

"""
got: 
yF = mF * xF
yL = mL * xL

looking for: x, y
with: 
s = 99
y = mF * (x + s)
y + s = mL * x
<=>
y = mF * x + mF * s
y + s = mL * x
<=>
-s = mF * x + mF * s - mL * x
<=>
-s - mF * s = mF * x - mL * x
<=>
-s - mF * s = (mF - mL) * x
<=>
x = (-99 - mF * 99) / (mF - mL)
"""

x = (-99 - mF * 99) / (mF - mL)
xi = int(x) - 1     # dunno why minus 1 works, maybe some float to int conversion stuff?...
y = mF * (x + 99)
yi = int(y) - 1     # dunno why minus 1 works, maybe some float to int conversion stuff?...
print(xi * 10000 + yi)

