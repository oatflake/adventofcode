import time
from Queue import Queue

def getDigit(number, digit):
    return (number / 10**digit) % 10

def getParameter(memory, relativeBase, instructionPointer, instruction, parameterIndex):
    address = instructionPointer + parameterIndex
    """ note: parameters are offset by 2, but start counting at 1, whereas getDigits starts counting at 0, 
              which is why we need parameterIndex + 1 instead of parameterIndex + 2 """
    if getDigit(instruction, parameterIndex + 1) == 0:
        if not address in memory:
            memory[address] = 0
        if not memory[address] in memory:
            memory[memory[address]] = 0     
        return memory[memory[address]] 
    elif getDigit(instruction, parameterIndex + 1) == 1:
        if not address in memory:
            memory[address] = 0
        return memory[address]
    else:
        if not address in memory:
            memory[address] = 0
        if not relativeBase + memory[address] in memory:
            memory[relativeBase + memory[address]] = 0     
        return memory[relativeBase + memory[address]] 

def intcodeComputer((memory, instructionPointer, relativeBase), input):
    while memory[instructionPointer] != 99:
        instruction = memory[instructionPointer]
        #print "instruction", instruction
        opcode = instruction % 100
        if opcode == 1:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print parameter1, " + " , parameter2, " @ ", memory[instructionPointer + 3]
            if getDigit(instruction, 4) == 2:
                memory[relativeBase + memory[instructionPointer + 3]] = parameter1 + parameter2
            else:
                memory[memory[instructionPointer + 3]] = parameter1 + parameter2
            instructionPointer += 4
        if opcode == 2:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print parameter1, " * " , parameter2, " @ ", memory[instructionPointer + 3]
            if getDigit(instruction, 4) == 2:
                memory[relativeBase + memory[instructionPointer + 3]] = parameter1 * parameter2
            else:
                memory[memory[instructionPointer + 3]] = parameter1 * parameter2
            instructionPointer += 4
        if opcode == 3:
            #print "store instruction", memory[instructionPointer], memory[instructionPointer + 1]
            #print "relativeBase", relativeBase
            #print "store ", input[inputIndex], " @ ", memory[instructionPointer + 1]
            if getDigit(instruction, 2) == 2:
                memory[relativeBase + memory[instructionPointer + 1]] = input.get()
            else:
                memory[memory[instructionPointer + 1]] = input.get()
            instructionPointer += 2
        if opcode == 4:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            #print "output:", parameter1
            instructionPointer += 2
            return (memory, instructionPointer, relativeBase), parameter1
        if opcode == 5:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print "jump if true: ", parameter1, "to", parameter2
            if parameter1 != 0:
                instructionPointer = parameter2
            else:
                instructionPointer += 3
        if opcode == 6:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print "jump if false: ", parameter1, "to", parameter2
            if parameter1 == 0:
                instructionPointer = parameter2
            else:
                instructionPointer += 3
        if opcode == 7:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print "set less than", parameter1, parameter2, "@", memory[instructionPointer + 3]
            if getDigit(instruction, 4) == 2:
                memory[relativeBase + memory[instructionPointer + 3]] = 1 if parameter1 < parameter2 else 0
            else:
                memory[memory[instructionPointer + 3]] = 1 if parameter1 < parameter2 else 0
            instructionPointer += 4
        if opcode == 8:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
            #print "set equal", parameter1, parameter2, "@", memory[instructionPointer + 3]
            if getDigit(instruction, 4) == 2:
                memory[relativeBase + memory[instructionPointer + 3]] = 1 if parameter1 == parameter2 else 0
            else:
                memory[memory[instructionPointer + 3]] = 1 if parameter1 == parameter2 else 0
            instructionPointer += 4
        if opcode == 9:
            parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
            #print "set relative base", parameter1
            relativeBase += parameter1
            instructionPointer += 2
    return None

file = open("input", "r")
input = file.read().strip('\n')
#input = "1102,34915192,34915192,7,4,7,99,0"
memory = input.split(',')
memory = [int(i) for i in memory]
dictMemory = dict()
for i in range(len(memory)):
    dictMemory[i] = memory[i]
computer = (dictMemory, 0, 0)
queue = Queue()
queue.put(1)
while True:    
    output = intcodeComputer(computer, queue)
    if output == None:
        break
    computer = output[0]
    print output[1]
