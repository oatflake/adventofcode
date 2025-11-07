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
    
    width := len(lines[0])
    height := len(lines)

    // deal with empty line
    if len(lines[height - 1]) == 0 {
        height -= 1
    }

    result : int = 0

    for x := 1; x < width - 1; x += 1 {
        for y := 1; y < height - 1; y += 1 {
            if lines[y][x] != 'A' {
                continue
            }

            if  (lines[y - 1][x - 1] != 'M' || lines[y + 1][x + 1] != 'S') &&
                (lines[y - 1][x - 1] != 'S' || lines[y + 1][x + 1] != 'M')
            {
                continue
            }

            if  (lines[y + 1][x - 1] != 'M' || lines[y - 1][x + 1] != 'S') &&
                (lines[y + 1][x - 1] != 'S' || lines[y - 1][x + 1] != 'M')
            {
                continue
            }

            result += 1
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
