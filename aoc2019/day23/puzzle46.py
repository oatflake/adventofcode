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
NAT = None
deliveredYbyNAT = set()
while True:
    if queue.qsize() == 0 and NAT != None:
        computers[0].addInput(NAT[0])
        computers[0].addInput(NAT[1])
        if NAT[1] in deliveredYbyNAT:
            print(NAT[1])
            break
        deliveredYbyNAT.add(NAT[1])
        NAT = None
    while queue.qsize() > 0:
        i = queue.get()
        computers[i[0]].addInput(i[1])
        computers[i[0]].addInput(i[2])
    for computer in computers:
        outputI = computer.execute()
        if outputI != None:
            outputX = computer.execute()
            outputY = computer.execute()
            if outputI == 255:
                NAT = (outputX, outputY)
            else:
                queue.put((outputI, outputX, outputY))
