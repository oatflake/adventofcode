def readInput():
    input = open("input", "r")
    instructions = []
    for line in input:
        parts = line.strip().split(" ")
        if parts[0] == "jmp":
            parts[1] = int(parts[1])
        if parts[0] == "jie":
            parts[1] = parts[1][0]
            parts[2] = int(parts[2])
        if parts[0] == "jio":
            parts[1] = parts[1][0]
            parts[2] = int(parts[2])
        instructions.append(parts)
    return instructions

class Computer:
    def __init__(self, instructions):
        self.registers = dict()
        self.registers["a"] = 0
        self.registers["b"] = 0
        self.instructions = instructions
        self.instructionPointer = 0
    
    def run(self):
        while 0 <= self.instructionPointer < len(self.instructions):
            instruction = self.instructions[self.instructionPointer]
            if instruction[0] == "hlf":
                self.registers[instruction[1]] /= 2
                self.instructionPointer += 1
            if instruction[0] == "tpl":
                self.registers[instruction[1]] *= 3
                self.instructionPointer += 1
            if instruction[0] == "inc":
                self.registers[instruction[1]] += 1
                self.instructionPointer += 1
            if instruction[0] == "jmp":
                self.instructionPointer += instruction[1]
            if instruction[0] == "jie":
                if self.registers[instruction[1]] % 2 == 0:
                    self.instructionPointer += instruction[2]
                else:
                    self.instructionPointer += 1
            if instruction[0] == "jio":
                if self.registers[instruction[1]] == 1:
                    self.instructionPointer += instruction[2]
                else:
                    self.instructionPointer += 1

computer = Computer(readInput())
computer.run()
print computer.registers["b"]