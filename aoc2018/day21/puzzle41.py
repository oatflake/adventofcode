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

def execute(ipRegister, instructions, operations, (registers, instructionPointer)):
    registers[ipRegister] = instructionPointer
    name, a, b, c = instructions[instructionPointer]
    operations[name](a, b, c, registers)
    # Upon inspection of the (translated) assembly code, one can notice that register 0 is used at
    # eqrr 1 0 2                  r2 = 1 if r1 == r0 else 0
    # which is when instructionPointer == 28.
    # The next two lines of the assembly code then determine whether to loop or to terminate.
    # So let's just execute the code and wait for the first execution of eqrr 1 0 2 and print register 1.
    if instructionPointer == 28:
        print registers[1]
    instructionPointer = registers[ipRegister] + 1
    return (registers, instructionPointer)

def main():
    instructions = []
    with open("input", "r") as input:
        ipRegister = int(input.readline().strip().split(" ")[1])
        instructions = readProgram(input)
    operations = { "addr":addr, "addi":addi, "mulr":mulr, "muli":muli, \
                "banr":banr, "bani":bani, "borr":borr, "bori":bori, \
                "setr":setr, "seti":seti, "gtir":gtir, "gtri":gtri, \
                "gtrr":gtrr, "eqir":eqir, "eqri":eqri, "eqrr":eqrr }
    registers = [0] * 6
    # After printing the registers when executing eqrr 1 0 2:
    # Register 1, which is checked for equality with register 0, is 5970144 upon hitting that instruction for the first time.
    # Setting register 0 to 5970144 then turns out to indeed terminate the code. Hence, this is our solution.
    registers[0] = 5970144
    instructionPointer = 0
    while 0 <= instructionPointer < len(instructions):
        (registers, instructionPointer) = execute(ipRegister, instructions, operations, (registers, instructionPointer))

main()


"""
#ip 4
seti 123 0 1                r1 = 123
bani 1 456 1                r1 = r1 & 456
eqri 1 72 1                 r1 = 1 if r1 == 72 else 0
addr 1 4 4                  ip = r1 + ip
seti 0 0 4                  ip = 0
seti 0 3 1                  r1 = 0
bori 1 65536 5              r5 = r1 | 65536
seti 8586263 3 1            r1 = 8586263
bani 5 255 2                r2 = r5 & 255
addr 1 2 1                  r1 = r1 + r2
bani 1 16777215 1           r1 = r1 & 16777215
muli 1 65899 1              r1 = r1 * 65899
bani 1 16777215 1           r1 = r1 & 16777215
gtir 256 5 2                r2 = 1 if 256 > r5 else 0
addr 2 4 4                  ip = r2 + ip
addi 4 1 4                  ip = ip + 1
seti 27 8 4                 ip = 27
seti 0 1 2                  r2 = 0
addi 2 1 3                  r3 = r2 + 1
muli 3 256 3                r3 = r3 * 256
gtrr 3 5 3                  r3 = 1 if r3 > r5 else 0
addr 3 4 4                  ip = r3 + ip
addi 4 1 4                  ip = ip + 1
seti 25 8 4                 ip = 25
addi 2 1 2                  r2 = r2 + 1
seti 17 7 4                 ip = 17
setr 2 0 5                  r5 = r2
seti 7 8 4                  ip = 7
eqrr 1 0 2                  r2 = 1 if r1 == r0 else 0
addr 2 4 4                  ip = r2 + ip
seti 5 4 4                  ip = 5
"""
