class Sample:
    def __init__(self, before, instruction, after):
        self.before = before
        self.instruction = instruction
        self.after = after
    
    def apply(self, operation):
        a, b, c = self.instruction[1], self.instruction[2], self.instruction[3]
        tmp = self.before[:]
        operation(a, b, c, tmp)
        match = True
        for i in range(len(tmp)):
            match = match and tmp[i] == self.after[i]
        return match

def readSamples(input):
    samples = []
    while True:
        before = input.readline().strip()
        if before == "":
            break
        instruction = input.readline().strip()
        after = input.readline().strip()
        input.readline().strip()

        before = before[len("Before: ["):-1].split(", ")
        before = [int(s) for s in before]
        instruction = instruction.split(" ")
        instruction = [int(s) for s in instruction]
        after = after[len("After:  ["):-1].split(", ")
        after = [int(s) for s in after]
        samples.append(Sample(before, instruction, after))
    return samples

def readProgram(input):
    instructions = []
    line = input.readline()
    while line:
        line = line.strip()
        instructions.append([int(s) for s in line.split(" ")])
        line = input.readline()
    return instructions

def addr(a, b, c, registers):
    registers[c] = registers[a] + registers[b]

def addi(a, b, c, registers):
    registers[c] = registers[a] + b

def mulr(a, b, c, registers):
    registers[c] = registers[a] * registers[b]

def muli(a, b, c, registers):
    registers[c] = registers[a] * b

def banr(a, b, c, registers):
    registers[c] = registers[a] & registers[b]

def bani(a, b, c, registers):
    registers[c] = registers[a] & b

def borr(a, b, c, registers):
    registers[c] = registers[a] | registers[b]

def bori(a, b, c, registers):
    registers[c] = registers[a] | b

def setr(a, b, c, registers):
    registers[c] = registers[a]

def seti(a, b, c, registers):
    registers[c] = a

def gtir(a, b, c, registers):
    registers[c] = 1 if a > registers[b] else 0

def gtri(a, b, c, registers):
    registers[c] = 1 if registers[a] > b else 0

def gtrr(a, b, c, registers):
    registers[c] = 1 if registers[a] > registers[b] else 0

def eqir(a, b, c, registers):
    registers[c] = 1 if a == registers[b] else 0

def eqri(a, b, c, registers):
    registers[c] = 1 if registers[a] == b else 0

def eqrr(a, b, c, registers):
    registers[c] = 1 if registers[a] == registers[b] else 0

def main():
    samples = []
    instructions = []
    with open("input", "r") as input:
        samples = readSamples(input)
        input.readline()
        instructions = readProgram(input)
    operations = [addr, addi, mulr, muli, \
                banr, bani, borr, bori, setr, seti, \
                gtir, gtri, gtrr, eqir, eqri, eqrr]
    result = 0
    for sample in samples:
        matches = 0
        for operation in operations:
            matches += 1 if sample.apply(operation) else 0
        result += 1 if matches >= 3 else 0
    print result
main()