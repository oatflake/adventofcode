numberOfPasswords = 0
for password in range(382345, 843167 + 1):
    digits = [(password / 10**i) % 10 for i in range(6)]
    digits.reverse()
    sameAdjacentDigits = False
    sameAdjacentDigitsCounter = 0
    digitsIncrease = True
    for i in range(len(digits) - 1):
        if digits[i] == digits[i + 1]:
            sameAdjacentDigitsCounter += 1
        else:
            sameAdjacentDigits |= sameAdjacentDigitsCounter == 1
            sameAdjacentDigitsCounter = 0
        if digits[i] > digits[i + 1]:
            digitsIncrease = False
    if (sameAdjacentDigits or sameAdjacentDigitsCounter == 1) and digitsIncrease:
        numberOfPasswords += 1
print numberOfPasswords
