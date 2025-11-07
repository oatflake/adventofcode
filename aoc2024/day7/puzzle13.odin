package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"

evaluate :: proc(test : int, numbers : []int, fromIndex : int, value : int) -> bool {
    assert(fromIndex <= len(numbers))
    if len(numbers) == fromIndex {
        return test == value
    }
    a := evaluate(test, numbers[:], fromIndex + 1, value * numbers[fromIndex])
    b := evaluate(test, numbers[:], fromIndex + 1, value + numbers[fromIndex])
    return a || b
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    result := 0
    
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    	parts := strings.split(line, " ")
        defer delete(parts)

        sum, ok := strconv.parse_int(parts[0][:len(parts[0])-1])
        assert(ok)
        
        numbers : [dynamic]int
        defer delete(numbers)

        for part in parts[1:] {
            num, ok := strconv.parse_int(part)
            assert(ok)
            append(&numbers, num)
        }

        if evaluate(sum, numbers[:], 1, numbers[0]) {
            result += sum
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
