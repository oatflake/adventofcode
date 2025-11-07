package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    lines := strings.split_lines(string(data))
    defer delete(lines)
    
    directions : [8][2]int = { { 0, 1 }, { 1, 1 }, { 1, 0 }, { 1, -1 }, { 0, -1 }, { -1, -1 }, { -1, 0 }, { -1, 1 } }
    width := len(lines[0])
    height := len(lines)

    // deal with empty line
    if len(lines[height - 1]) == 0 {
        height -= 1
    }

    result : int = 0

    for x := 0; x < width; x += 1 {
        for y := 0; y < height; y += 1 {
            for dir in directions {
                if  (dir.x > 0 && x + 3 >= width)   ||
                    (dir.x < 0 && x - 3 <  0)       ||
                    (dir.y > 0 && y + 3 >= height)  ||
                    (dir.y < 0 && y - 3 <  0)
                {
                    continue
                }
                valid := true
                for char, index in "XMAS" {
                    if (char != rune(lines[y + index * dir.y][x + index * dir.x])) {
                        valid = false
                        break
                    }
                }
                if valid {
                    result += 1
                }
            }
        }
    }
    
    fmt.println(result)
}

main :: proc() {
    defaultAllocator := context.allocator
    trackingAllocator : mem.Tracking_Allocator
    mem.tracking_allocator_init(&trackingAllocator, defaultAllocator)
    context.allocator = mem.tracking_allocator(&trackingAllocator)

    run()

    for _, value in trackingAllocator.allocation_map {
        fmt.printf("%v: Leaked %v bytes\n", value.location, value.size)
    }

    assert(len(trackingAllocator.allocation_map) == 0)
    assert(len(trackingAllocator.bad_free_array) == 0)
}
