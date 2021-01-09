from math import sqrt

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
    registers[0] = 1
    instructionPointer = 0
    while 0 <= instructionPointer < len(instructions):
        print registers
        registers[ipRegister] = instructionPointer
        name, a, b, c = instructions[instructionPointer]
        operations[name](a, b, c, registers)
        instructionPointer = registers[ipRegister] + 1
    return registers[0]

"""
Running these instructions takes forever. 
So let's approach this similary to the puzzle on day 23 in 2017: 
Printing registers and formulating a hypothesis on what's going on.

Upon inspection of the registers when running part 1 of the puzzle, one can notice
that registers 1 and 3 are counters running up to the value in register 2.

Furthermore, register 5 (periodically) contains the product of register 1 and 3.
Whenever that product is the same as register 2, shortly thereafter register 0 
gets increased by the value in register 1.

A hypothesis based on these observations can then be made without inspecting 
the actual instructions of the program:
The sum of the factors of the value in register 2 is computed!

The output of part 1 of the puzzle confirms this.

So let's take whatever value register 2 contains in part 2 of the puzzle, and 
compute the sum of its factors.
"""

"""
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
"""

def main():
    register2 = 10551298
    sumOfFactors = 0
    for i in range(1, int(sqrt(register2)) + 1):
        if register2 % i == 0:
            sumOfFactors += i
            j = register2 // i
            if j != i:
                sumOfFactors += j
    print sumOfFactors

main()