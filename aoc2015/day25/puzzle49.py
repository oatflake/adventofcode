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

    print number * pow(factor, cellID - 1, groupSize) % groupSize
main()