package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)
    
    width : int
    for width = 0; width < len(data); width += 1 {
        if data[width] == '\n' {
            break
        }
    }
    height := len(data) / (width + 1)
    
    pos : [2]int
    for pos.y = 0; pos.y < height; pos.y += 1 {
        for pos.x = 0; pos.x < width; pos.x += 1 {
            if data[pos.y * (width + 1) + pos.x] == '^' {
                break
            }
        }
        if data[pos.y * (width + 1) + pos.x] == '^' {
            break
        }
    }
    
    directions : [4][2]int = { { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 } }
    currentDirection := 0

    //printMap :: proc(data : []byte) {
    //    ss := strings.split_lines(string(data))
    //    defer delete(ss)
    //    for s in ss {
    //        fmt.println(s)
    //    }
    //}

    //printMap(data[:])
    for {
        data[pos.y * (width + 1) + pos.x] = 'X'
        newPos := pos + directions[currentDirection]

        tmp : [2]int = { clamp(newPos.x, 0, width - 1), clamp(newPos.y, 0, height - 1) }
        if newPos != tmp {
            break
        }

        if data[newPos.y * (width + 1) + newPos.x] == '#' {
            currentDirection = (currentDirection + 1) % 4
        } else {
            pos = newPos
        }
        //fmt.println("--------------------------------------------")
        //printMap(data[:])
    }

    result := 0
    for char in data {
        if char == 'X' {
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
