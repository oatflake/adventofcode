package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:text/regex"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    result := 0
    pattern, err := regex.create("^mul\\([0-9]{1,3},[0-9]{1,3}\\).*")
    defer regex.destroy(pattern)
    
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    	for i in 0..<len(line) {
            part := line[i : min(i + 13, len(line))]
            capture, success := regex.match_and_allocate_capture(pattern, part)
            defer regex.destroy(capture)
            
            if success {
                end := strings.index_rune(part, ')')
                assert(end != -1)

                numbers := strings.split(part[4:end], ",")
                assert(len(numbers) == 2)
                defer delete(numbers)
                
                x, okX := strconv.parse_int(numbers[0])
                y, okY := strconv.parse_int(numbers[1])
                assert(okX && okY)
                
                result += x * y
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
