from Queue import Queue

class IntcodeComputer:
    def createMemory(self, string):
        memory = string.split(',')
        dictMemory = dict()
        for i in range(len(memory)):
            dictMemory[i] = int(memory[i])
        return dictMemory

    def __init__(self, program):
        self.memory = self.createMemory(program)
        self.instructionPointer = 0
        self.relativeBase = 0
        self.input = Queue()

    def getDigit(self, number, digit):
        return (number / 10**digit) % 10

    def read(self, address):
        if not address in self.memory:
            self.memory[address] = 0
        return self.memory[address]

    def getParameter(self, instruction, parameterIndex):
        address = self.instructionPointer + parameterIndex
        """ note: parameters are offset by 2, but start counting at 1, whereas getDigits starts counting at 0, 
                  which is why we need parameterIndex + 1 instead of parameterIndex + 2 """
        if self.getDigit(instruction, parameterIndex + 1) == 0:
            return self.read(self.read(address))
        elif self.getDigit(instruction, parameterIndex + 1) == 1:
            return self.read(address)
        else:
            return self.read(self.relativeBase + self.read(address)) 

    def execute(self):
        while self.memory[self.instructionPointer] != 99:
            instruction = self.memory[self.instructionPointer]
            opcode = instruction % 100
            parameter1 = self.getParameter(instruction, 1)
            parameter2 = self.getParameter(instruction, 2)
            param3Address = self.read(self.instructionPointer + 3)
            param3Address += self.relativeBase if self.getDigit(instruction, 4) == 2 else 0
            if opcode == 1:
                self.memory[param3Address] = parameter1 + parameter2
                self.instructionPointer += 4
            if opcode == 2:
                self.memory[param3Address] = parameter1 * parameter2
                self.instructionPointer += 4
            if opcode == 3:
                baseOffset = self.relativeBase if self.getDigit(instruction, 2) == 2 else 0
                if self.input.qsize() == 0:
                    self.input.put(-1)
                    return None
                else:
                    value = self.input.get()
                self.memory[baseOffset + self.read(self.instructionPointer + 1)] = value
                self.instructionPointer += 2
            if opcode == 4:
                self.instructionPointer += 2
                return parameter1
            if opcode == 5:
                self.instructionPointer = parameter2 if parameter1 != 0 else self.instructionPointer + 3
            if opcode == 6:
                self.instructionPointer = parameter2 if parameter1 == 0 else self.instructionPointer + 3
            if opcode == 7:
                self.memory[param3Address] = 1 if parameter1 < parameter2 else 0
                self.instructionPointer += 4
            if opcode == 8:
                self.memory[param3Address] = 1 if parameter1 == parameter2 else 0
                self.instructionPointer += 4
            if opcode == 9:
                self.relativeBase += parameter1
                self.instructionPointer += 2
        return None

    def addInput(self, value):
        self.input.put(value)
