numberOfPasswords = 0
for password in range(382345, 843167 + 1):
    digits = [(password / 10**i) % 10 for i in range(6)]
    digits.reverse()
    sameAdjacentDigits = False
    digitsIncrease = True
    for i in range(len(digits) - 1):
        if digits[i] == digits[i + 1]:
            sameAdjacentDigits = True
        if digits[i] > digits[i + 1]:
            digitsIncrease = False
    if sameAdjacentDigits and digitsIncrease:
        numberOfPasswords += 1
print numberOfPasswords
