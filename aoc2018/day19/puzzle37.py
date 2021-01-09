def readProgram(input):
    instructions = []
    line = input.readline()
    while line:
        line = line.strip().split(" ")
        line[1] = int(line[1])
        line[2] = int(line[2])
        line[3] = int(line[3])
        instructions.append(line)
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

def execute(ipRegister, instructions, operations):
    registers = [0] * 6
    instructionPointer = 0
    while 0 <= instructionPointer < len(instructions):
        registers[ipRegister] = instructionPointer
        name, a, b, c = instructions[instructionPointer]
        operations[name](a, b, c, registers)
        instructionPointer = registers[ipRegister] + 1
    return registers[0]

def main():
    instructions = []
    with open("input", "r") as input:
        ipRegister = int(input.readline().strip().split(" ")[1])
        instructions = readProgram(input)
    operations = { "addr":addr, "addi":addi, "mulr":mulr, "muli":muli, \
                "banr":banr, "bani":bani, "borr":borr, "bori":bori, \
                "setr":setr, "seti":seti, "gtir":gtir, "gtri":gtri, \
                "gtrr":gtrr, "eqir":eqir, "eqri":eqri, "eqrr":eqrr }
    print execute(ipRegister, instructions, operations)

main()