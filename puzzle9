def getDigit(number, digit):
    return (number / 10**digit) % 10

def getParameter(memory, instructionPointer, instruction, parameterIndex):
    address = instructionPointer + parameterIndex
    return memory[memory[address]] if getDigit(instruction, parameterIndex + 1) == 0 else memory[address]

def intcodeComputer(memory, input):
    instructionPointer = 0
    while memory[instructionPointer] != 99:
        instruction = memory[instructionPointer]
        opcode = instruction % 100
        if opcode == 1:
            parameter1 = getParameter(memory, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, instructionPointer, instruction, 2)
            #print parameter1, " + " , parameter2, " @ ", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = parameter1 + parameter2
            instructionPointer += 4
        if opcode == 2:
            parameter1 = getParameter(memory, instructionPointer, instruction, 1)
            parameter2 = getParameter(memory, instructionPointer, instruction, 2)
            #print parameter1, " * " , parameter2, " @ ", memory[instructionPointer + 3]
            memory[memory[instructionPointer + 3]] = parameter1 * parameter2
            instructionPointer += 4
        if opcode == 3:
            #parameter1 = getParameter(memory, instructionPointer, instruction, 1)
            #print "store ", input, " @ ", memory[instructionPointer + 1]
            memory[memory[instructionPointer + 1]] = input
            instructionPointer += 2
        if opcode == 4:
            parameter1 = getParameter(memory, instructionPointer, instruction, 1)
            print "output: ", parameter1 #memory[instructionPointer + 1]
            instructionPointer += 2
    return memory

file = open("input", "r") 
input = file.read().strip('\n')
memory = input.split(',')
memory = [int(i) for i in memory]
intcodeComputer(memory[:], 1)
