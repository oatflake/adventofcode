basePattern = [0, 1, 0, -1]

def createPattern(length, frequency, i):
    return basePattern[((i + 1) / frequency) % 4]
    
def dot(array1, length, frequency):
    result = 0
    for i in range(len(array1)):
        result += array1[i] * createPattern(length, frequency, i)
    return result

def fft(readBuffer, writeBuffer):
    bufferLength = len(readBuffer)
    for i in range(bufferLength):
        writeBuffer[i] = abs(dot(readBuffer, bufferLength, 1 + i)) % 10

input = open("input", "r").read().strip("\n")
input = map(int, input)

output = input[:]
for i in range(100):
    input, output = output, input
    fft(input, output)

answer = ""
for i in range(8):
    answer += str(output[i])
print answer
