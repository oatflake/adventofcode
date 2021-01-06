# --- taken from: https://www.geeksforgeeks.org/euclidean-algorithms-basic-and-extended/ ---
def gcdExtended(a, b):  
  
    # Base Case  
    if a == 0 :   
        return b, 0, 1
             
    gcd, x1, y1 = gcdExtended(b%a, a)  
     
    # Update x and y using results of recursive  
    # call  
    x = y1 - (b//a) * x1  
    y = x1  
     
    return gcd, x, y 
# ------------------------------------------------------------------------------------------



# Instead of a recursive formula, let's use the manhatten distance and do some math
# in order to get the cell entry in constant time.
def cell(x, y):
    manhattenDistance = x - 1 + y - 1
    bottomOfDiagonal = manhattenDistance + 1
    firstCellOnDiagonal = bottomOfDiagonal * (bottomOfDiagonal - 1) / 2 + 1
    cell = firstCellOnDiagonal + bottomOfDiagonal - y
    return cell

def main():
    input = open("input", "r")
    line = input.readline()
    input.close()
    parts = line.split(" ")
    row = int(parts[16][:-1])
    column = int(parts[18][:-2])

    number = 20151125
    factor = 252533
    groupSize = 33554393
    cellID = cell(column, row)

    # we would like to compute:
    # n * f^i = (n^{i^{-1}} * f)^i
    # as that allows us to easily use pow with 3 parameters
    #
    # note that groupSize is a prime
    # hence, using the euler function: phi(groupSize) = groupSize - 1
    # phi(groupSize) is what we have to use in the exponent
    #
    # so we get the inverse of i in the exponent using the 
    # extended euclidean algorithm and phi(groupSize)
    i = cellID - 1
    iInv = gcdExtended(i, groupSize - 1)[1] 
    iInv += (groupSize - 1) # adding (groupSize - 1) since iInv must not be negative
    number = pow(number, iInv, groupSize) # otherwise pow would throw an exception
    number = pow(number * factor, i, groupSize)
    print number
main()