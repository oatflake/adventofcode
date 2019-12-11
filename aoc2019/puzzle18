import time
from Queue import Queue

def getDigit(number, digit):
    return (number / 10**digit) % 10

def read(memory, address):
    if not address in memory:
        memory[address] = 0
    return memory[address]

def createComputer(string):
    memory = string.split(',')
    dictMemory = dict()
    for i in range(len(memory)):
        dictMemory[i] = int(memory[i])
    return (dictMemory, 0, 0)

def getParameter(memory, relativeBase, instructionPointer, instruction, parameterIndex):
    address = instructionPointer + parameterIndex
    """ note: parameters are offset by 2, but start counting at 1, whereas getDigits starts counting at 0, 
              which is why we need parameterIndex + 1 instead of parameterIndex + 2 """
    if getDigit(instruction, parameterIndex + 1) == 0:
        return read(memory, read(memory, address))
    elif getDigit(instruction, parameterIndex + 1) == 1:
        return read(memory, address)
    else:
        return read(memory, relativeBase + read(memory, address)) 

def intcodeComputer((memory, instructionPointer, relativeBase), input):
    while memory[instructionPointer] != 99:
        instruction = memory[instructionPointer]
        opcode = instruction % 100
        parameter1 = getParameter(memory, relativeBase, instructionPointer, instruction, 1)
        parameter2 = getParameter(memory, relativeBase, instructionPointer, instruction, 2)
        param3Address = read(memory, instructionPointer + 3) 
        param3Address += relativeBase if getDigit(instruction, 4) == 2 else 0
        if opcode == 1:
            memory[param3Address] = parameter1 + parameter2
            instructionPointer += 4
        if opcode == 2:
            memory[param3Address] = parameter1 * parameter2
            instructionPointer += 4
        if opcode == 3:
            baseOffset = relativeBase if getDigit(instruction, 2) == 2 else 0
            memory[baseOffset + read(memory, instructionPointer + 1)] = input.get()
            instructionPointer += 2
        if opcode == 4:
            instructionPointer += 2
            return (memory, instructionPointer, relativeBase), parameter1
        if opcode == 5:
            instructionPointer = parameter2 if parameter1 != 0 else instructionPointer + 3
        if opcode == 6:
            instructionPointer = parameter2 if parameter1 == 0 else instructionPointer + 3
        if opcode == 7:
            memory[param3Address] = 1 if parameter1 < parameter2 else 0
            instructionPointer += 4
        if opcode == 8:
            memory[param3Address] = 1 if parameter1 == parameter2 else 0
            instructionPointer += 4
        if opcode == 9:
            relativeBase += parameter1
            instructionPointer += 2
    return None

file = open("input", "r")
input = file.read().strip('\n')
computer = createComputer(input)
computerInput = Queue()
computerInput.put(2)
while True:    
    output = intcodeComputer(computer, computerInput)
    if output == None:
        break
    computer = output[0]
    print output[1]
