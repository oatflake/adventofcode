import time

def getDigit(number, digit):
    return (number / 10**digit) % 10

def getParameter(memory, instructionPointer, instruction, parameterIndex):
    address = instructionPointer + parameterIndex
    """ note: parameters are offset by 2, but start counting at 1, whereas getDigits starts counting at 0, 
              which is why we need parameterIndex + 1 instead of parameterIndex + 2 """
    return memory[memory[address]] if getDigit(instruction, parameterIndex + 1) == 0 else memory[address]

def intcodeComputer(memory, input):
    instructionPointer = 0
    while memory[instructionPointer] != 99:
        instruction = memory[instructionPointer]
        opcode = instruction % 100
        parameter1 = getParameter(memory, instructionPointer, instruction, 1)
        parameter2 = getParameter(memory, instructionPointer, instruction, 2)
        if opcode == 1:
            #print parameter1, " + " , parameter2, " @ ", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = parameter1 + parameter2
            instructionPointer += 4
        if opcode == 2:
            #print parameter1, " * " , parameter2, " @ ", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = parameter1 * parameter2
            instructionPointer += 4
        if opcode == 3:
            #print "store ", input, " @ ", memory[instructionPointer + 1]
            memory[memory[instructionPointer + 1]] = input
            instructionPointer += 2
        if opcode == 4:
            print "output:", parameter1
            instructionPointer += 2
        if opcode == 5:
            #print "jump if true: ", parameter1, "to", parameter2
            if parameter1 != 0:
                instructionPointer = parameter2
            else:
                instructionPointer += 3
        if opcode == 6:
            #print "jump if false: ", parameter1, "to", parameter2
            if parameter1 == 0:
                instructionPointer = parameter2
            else:
                instructionPointer += 3
        if opcode == 7:
            #print "set less than", parameter1, parameter2, "@", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = 1 if parameter1 < parameter2 else 0
            instructionPointer += 4
        if opcode == 8:
            #print "set equal", parameter1, parameter2, "@", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = 1 if parameter1 == parameter2 else 0
            instructionPointer += 4
    return memory

file = open("input", "r") 
input = file.read().strip('\n')
memory = input.split(',')
memory = [int(i) for i in memory]
intcodeComputer(memory[:], 5)
