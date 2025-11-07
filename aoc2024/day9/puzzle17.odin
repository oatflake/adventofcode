package main

import "core:fmt"
import "core:os"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    unpacked : [dynamic]i16
    defer delete(unpacked)

    for char, index in data[:len(data) - 1] {
        if index % 2 == 0 {
            id := i16(index >> 1)
            for i in 0..<(char - '0') {
                append(&unpacked, id)
            }
        } else {
            for i in 0..<(char - '0') {
                append(&unpacked, -1)
            }
        }
    }

    i := 0
    #reverse for id, j in unpacked {
        if id == -1 {
            continue
        }
        foundFree := false
        for ; i < j; i += 1 {
            if unpacked[i] == -1 {
                foundFree = true
                break
            }
        }
        if foundFree {
            unpacked[i] = id
            unpacked[j] = -1
        } else {
            break
        }
    }
    
    result : i64 = 0
    for id, i in unpacked {
        if id == -1 {
            break
        }
        result += i64(id) * i64(i)
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
