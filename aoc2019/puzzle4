def intcodeComputer(memory, noun, verb):
    memory[1] = noun
    memory[2] = verb
    instructionPointer = 0
    while memory[instructionPointer] != 99:
        opcode = memory[instructionPointer]
        if opcode == 1:
            parameter1 = memory[memory[instructionPointer + 1]]
            parameter2 = memory[memory[instructionPointer + 2]]
            memory[memory[instructionPointer + 3]] = parameter1 + parameter2
            instructionPointer += 4
        if opcode == 2:
            parameter1 = memory[memory[instructionPointer + 1]]
            parameter2 = memory[memory[instructionPointer + 2]]
            memory[memory[instructionPointer + 3]] = parameter1 * parameter2
            instructionPointer += 4
    return memory

file = open("input", "r") 
input = file.read().strip('\n')
memory = input.split(',')
memory = [int(i) for i in memory]
for noun in range(100):
    for verb in range(100):
        if intcodeComputer(memory[:], noun, verb)[0] == 19690720:
            print 100 * noun + verb
