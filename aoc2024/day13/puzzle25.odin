package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)
    
    result := 0

    a, b, c : [2]int
    i := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    	parts := strings.split(line, " ")
        defer delete(parts)

        if i == 3 {
            i = 0
            continue
        }
        i += 1

        ok1, ok2 : bool
        switch i {
        case 1:
            a.x, ok1 = strconv.parse_int(parts[2][2 : len(parts[2]) - 1])
            a.y, ok2 = strconv.parse_int(parts[3][2:])
            assert(ok1 && ok2)
        case 2:
            b.x, ok1 = strconv.parse_int(parts[2][2 : len(parts[2]) - 1])
            b.y, ok2 = strconv.parse_int(parts[3][2:])
            assert(ok1 && ok2)
        case 3:
            c.x, ok1 = strconv.parse_int(parts[1][2 : len(parts[1]) - 1])
            c.y, ok2 = strconv.parse_int(parts[2][2:])
            assert(ok1 && ok2)
            
            numerator := b.y * c.x - c.y * b.x
            denominator := b.y * a.x - b.x * a.y
            if numerator % denominator != 0 {
                continue
            }
            x := numerator / denominator

            numerator = c.y - a.y * x
            denominator = b.y
            if numerator % denominator != 0 {
                continue
            }
            y := numerator / denominator

            result += x * 3 + y
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
