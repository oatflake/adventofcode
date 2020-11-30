import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from IntcodeComputer import IntcodeComputer

input = open("input", "r").read().strip("\n")
computer = IntcodeComputer(input)

ascii = "NOT A T\n\
NOT B J\n\
OR T J\n\
NOT C T\n\
OR T J\n\
AND D J\n\
OR E T\n\
AND E T\n\
OR H T\n\
AND T J\n\
RUN\n"

#print(ascii)
for c in ascii:
    #print(ord(c))
    computer.addInput(ord(c))

result = ""
while True:
    output = computer.execute()
    if output == None:
        break
    if output > 256:
        result = output
        break
    result += chr(output)
print(result)
