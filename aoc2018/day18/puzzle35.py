def readInput():
    input = open("input", "r")
    grid = ""
    width = 0
    height = 0
    for line in input:
        line = line.strip()
        grid += line
        width = len(line)
        height += 1
    return list(grid), width, height

def main():
    readbuffer, width, height = readInput()
    writebuffer = readbuffer[:]
    for k in range(10):
        for y in range(height):
            for x in range(width):
                trees = 0
                lumberyards = 0
                for dx in range(-1, 2):
                    for dy in range(-1, 2):
                        if dx == 0 and dy == 0:
                            continue
                        nx, ny = x + dx, y + dy
                        if nx < 0 or nx >= width or ny < 0 or ny >= height:
                            continue
                        neighbor = readbuffer[nx + ny * width]
                        trees += 1 if neighbor == "|" else 0
                        lumberyards += 1 if neighbor == "#" else 0
                i = x + y * width
                writebuffer[i] = readbuffer[i]
                if readbuffer[i] == "." and trees >= 3:
                    writebuffer[i] = "|"
                if readbuffer[i] == "|" and lumberyards >= 3:
                    writebuffer[i] = "#"
                if readbuffer[i] == "#" and not (lumberyards >= 1 and trees >= 1):
                    writebuffer[i] = "."
        tmp = writebuffer
        writebuffer = readbuffer
        readbuffer = tmp
    return readbuffer.count("#") * readbuffer.count("|")
print main()