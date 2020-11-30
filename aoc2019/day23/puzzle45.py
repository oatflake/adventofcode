import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer
from Queue import Queue

input = open("input", "r").read().strip("\n")
computers = []
for i in range(50):
    computers.append(IntcodeComputer(input))
    computers[i].addInput(i)

queue = Queue()
end = False
while not end:
    while queue.qsize() > 0:
        i = queue.get()
        computers[i[0]].addInput(i[1])
        computers[i[0]].addInput(i[2])
    for computer in computers:
        outputI = computer.execute()
        if outputI != None:
            outputX = computer.execute()
            outputY = computer.execute()
            queue.put((outputI, outputX, outputY))
            if outputI == 255:
                print(outputY)
                end = True
