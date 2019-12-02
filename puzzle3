file = open("input", "r") 
input = file.read().strip('\n')
#input = "1,1,1,4,99,5,6,0,99"
intcode = input.split(',')
intcode = [int(i) for i in intcode]
intcode[1] = 12
intcode[2] = 2
index = 0
while intcode[index] != 99:
    opcode = intcode[index]
    if opcode == 1:
        intcode[intcode[index + 3]] = intcode[intcode[index + 1]] + intcode[intcode[index + 2]]
        index += 4
    if opcode == 2:
        intcode[intcode[index + 3]] = intcode[intcode[index + 1]] * intcode[intcode[index + 2]]
        index += 4
#print str(intcode).strip('[').strip(']').replace(' ', '')
print intcode[0]
