package main

import "core:fmt"
import "core:os"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    Span :: struct {
        startIndex : i32,
        length : i32
    }
    freeSpans : [dynamic]Span
    defer delete(freeSpans)
    files : [dynamic]Span
    defer delete(files)

    offset : i32 = 0
    for char, index in data[:len(data) - 1] {
        if index % 2 == 0 {
            append(&files, Span{ startIndex = offset, length = i32(char - '0') })
        } else {
            append(&freeSpans, Span{ startIndex = offset, length = i32(char - '0') })
        }
        offset += i32(char - '0')
    }

    #reverse for &file, i in files {
        for &freeSpan in freeSpans[:i] {
            if file.length <= freeSpan.length {
                file.startIndex = freeSpan.startIndex
                freeSpan.length -= file.length
                freeSpan.startIndex += file.length
                break
            }
        }
    }
    
    result : i64 = 0
    for file, id in files {
        result += i64(file.startIndex) * i64(file.length) * i64(id)
        result += i64(file.length) * i64(file.length - 1) / 2 * i64(id)
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
