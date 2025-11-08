package main

import "core:container/queue"
import "core:fmt"
import "core:os"
import "core:mem"

toPos :: proc(index : int, width : int) -> [2]int {
    return { index % (width + 1), index / (width + 1) }
}

toIndex :: proc(pos : [2]int, width : int) -> int {
    return pos.x + pos.y * (width + 1)
}

clamp2 :: proc(v : [2]int, min : [2]int, max : [2]int) -> [2]int {
    return { clamp(v.x, min.x, max.x), clamp(v.y, min.y, max.y) }
}

areaCost :: proc(data : []byte, width : int, height : int, startIndex : int, marked : ^[dynamic]bool, open : ^queue.Queue([2]int)) -> int {
    startPos := toPos(startIndex, width)
    queue.push_back(open, startPos)
    marked[startIndex] = true

    area := 0
    perimeter := 0

    for queue.len(open^) > 0 {
        node := queue.pop_back(open)
        area += 1

        neighbors := [4][2]int{ node + {0, 1}, node - {0, 1}, node + {1, 0}, node - {1, 0} }
        for neighbor in neighbors {
            neighborIndex := toIndex(neighbor, width)

            if  clamp2(neighbor, 0, { width - 1, height - 1 }) != neighbor ||
                data[startIndex] != data[neighborIndex]
            {
                perimeter += 1
                continue
            }

            if marked[neighborIndex] {
                continue
            }

            marked[neighborIndex] = true
            queue.push_back(open, neighbor)
        }
    }

    return area * perimeter
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)
    
    width := 0
    for ; width < len(data); width += 1 {
        if data[width] == '\n' {
            break
        }
    }
    height := len(data) / (width + 1)

    marked := make([dynamic]bool, len(data))
    defer delete(marked)

    open : queue.Queue([2]int)
    queue.init(&open)
    defer queue.destroy(&open)

    result := 0

    for char, i in data {
        if char == '\n' {
            continue
        }

        if marked[i] {
            continue
        }

        result += areaCost(data[:], width, height, i, &marked, &open)
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
