package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    left : [dynamic]i64
    defer delete(left)
    right : [dynamic]i64
    defer delete(right)
    
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    	parts := strings.split(line, "   ")
        defer delete(parts)

        x, okX := strconv.parse_i64(parts[0])
        y, okY := strconv.parse_i64(parts[1])
        assert(okX && okY)
        append(&left, x)
        append(&right, y)
    }

    slice.sort(left[:])
    slice.sort(right[:])
    
    result : i64 = 0
    for i in 0..<len(left) {
        result += abs(left[i] - right[i])
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
