package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"
import "core:slice"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)
    
    // looking at the input file, all numbers have only two digits
    Mask :: bit_set[0..<100]
    rules : [100]Mask
    
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        if (len(line) == 0) {
            break
        }
    	parts := strings.split(line, "|")
        defer delete(parts)

        i, okI := strconv.parse_int(parts[0])
        x, okX := strconv.parse_int(parts[1])
        assert(okI && okX)

        rules[i] |= Mask{x}
    }

    result := 0
    pages : [dynamic]int
    defer delete(pages)

    compare :: proc(a : int, b : int, rules : rawptr) -> bool {
        rules := cast(^[100]Mask)rules
        return rules[a] & Mask{b} != {}
    }

    for line in strings.split_lines_iterator(&it) {
        parts := strings.split(line, ",")
        defer delete(parts)

        clear(&pages)
        for part in parts {
            i, okI := strconv.parse_int(part)
            assert(okI)
            append(&pages, i)
        }

        valid := true
        occured : Mask
        for i in pages {
            if rules[i] & occured != {} {
                valid = false
                break
            }
            occured |= Mask{i}
        }

        if !valid {
            slice.sort_by_with_data(pages[:], compare, &rules)
            result += pages[len(pages) >> 1]
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
