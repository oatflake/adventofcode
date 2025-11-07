package main

import "core:fmt"
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
    
    startPos : [2]int
    for startPos.y = 0; startPos.y < height; startPos.y += 1 {
        for startPos.x = 0; startPos.x < width; startPos.x += 1 {
            if data[startPos.y * (width + 1) + startPos.x] == '^' {
                break
            }
        }
        if data[startPos.y * (width + 1) + startPos.x] == '^' {
            break
        }
    }
    
    Mask :: bit_set[0..<4]
    visited := make([dynamic]Mask, len(data))
    defer delete(visited)
    directions : [4][2]int = { { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 } }
    currentDirection := 0

    //printMap :: proc(visited : []Mask, data : []u8, width : int, height : int) {
    //    line := make([dynamic]u8, width)
    //    defer delete(line)
    //    for y in 0..<height {
    //        for x in 0..<width {
    //            line[x] = data[y * (width + 1) + x]
    //            line[x] = visited[y * (width + 1) + x] != {} ? 'X' : line[x]
    //        }
    //        fmt.println(string(line[:]))
    //    }
    //}

    //printMap(visited[:], data[:], width, height)
    
    result := 0

    for ty in 0..<height {
        for tx in 0..<width {
            if data[ty * (width + 1) + tx] != '.' {
                continue
            }
            
            data[ty * (width + 1) + tx] = '#'
            
            pos := startPos
            currentDirection = 0
            for i := 0; i < len(visited); i += 1 {
                visited[i] = {}
            }

            loop := false
            for {
                visited[pos.y * (width + 1) + pos.x] |= Mask{currentDirection}
                newPos := pos + directions[currentDirection]

                tmp : [2]int = { clamp(newPos.x, 0, width - 1), clamp(newPos.y, 0, height - 1) }
                if newPos != tmp {
                    break
                }

                mask := Mask{currentDirection}
                if visited[newPos.y * (width + 1) + newPos.x] & mask != {} {
                    loop = true
                    break
                }

                if data[newPos.y * (width + 1) + newPos.x] == '#' {
                    currentDirection = (currentDirection + 1) % 4
                } else {
                    pos = newPos
                }
            }

            //fmt.println("--------------------------------------------")
            //printMap(visited[:], data[:], width, height)

            data[ty * (width + 1) + tx] = '.'

            if loop {
                result += 1
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
