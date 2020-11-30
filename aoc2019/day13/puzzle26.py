import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import os
import sys
import time
from IntcodeComputer import IntcodeComputer

def showScreen((screen, sizeX, sizeY)):
    output = ""
    symbols = [" ", "#", "w", "_", "o"]
    for y in range(sizeY):
        for x in range(sizeX):
            output += symbols[screen[y][x]]
        output += "\n"
    print(output)

def levelToScreen(level):
    maxX = maxY = -sys.maxsize
    for key, value in level.items():
        maxX = max(key[0], maxX)
        maxY = max(key[1], maxY)
    maxX += 1
    maxY += 1
    screen = [[0] * maxX for i in range(maxY)] # access via [y][x]
    for key, value in level.items():
        screen[key[1]][key[0]] = value
    return screen, maxX, maxY

inputFile = open("input", "r").read().strip("\n")
computer = IntcodeComputer(inputFile)
computer.memory[0] = 2

level = dict()
event = [-1] * 3
score = 0
paddlePos = (-1, -1)
ballPos = (-1, -1)
memoryCopy = None
blocks = 0
while True:
    # I'm not sure when to draw the screen, ball and paddle aren't always present...
    foundPaddle = False
    foundBall = False
    for key, value in level.items():    # so let's check if we can find ball and paddle
        if value == 3:
            foundPaddle = True
            paddlePos = key
        if value == 4:
            foundBall = True
            #ballVel = (key[0] - ballPos[0], key[1] - ballPos[1])
            ballPos = key
    if foundPaddle and foundBall:       # and draw screen if we can find them both
        #os.system("clear")
        showScreen(levelToScreen(level))
        print("SCORE: ", score)

    # once again I'm not sure when to provide input
    if computer.input.qsize() == 0:     # so let's input something when the computer ran out of input
        """
        # lets cheat this game:
        # finding the ball position in memory, ball x coord seems to be at 388
        # finding the ball position in memory, ball y coord seems to be at 389
        # finding the paddle position in memory, paddle x coord seems to be at 392
        if (memoryCopy != None):
            for key in computer.memory:
                if key in memoryCopy:
                    if memoryCopy[key] != computer.memory[key]:
                        print key, "OLD", memoryCopy[key], "NEW", computer.memory[key]
                else:
                    print key, "NEW", computer.memory[key]
        memoryCopy = dict(computer.memory)
        """

        # failed attemt at cheating: score is too low...
        #if blocks > 0 and computer.memory[389] > 17:    # cheating: teleport the ball to the top
        #    computer.memory[389] = 1

        if blocks > 0:    # cheating: teleport paddle below ball. note: paddle does not update without input
            computer.memory[392] = computer.memory[388] - 1

        joystick = 1    # paddle does not update its position without input, therefore provide some input other than 0
        computer.addInput(joystick)
        #time.sleep(.005)
    for i in range(3):
        event[i] = computer.execute()
    if event[0] == None:
        break
    if event[0] == -1:
        score = event[2]
    else:
        level[(event[0], event[1])] = event[2]
    blocks = 0                    # check how many blocks are left, so we can stop cheating and let the game end
    for key, value in level.items():
        if value == 2:
            blocks += 1
