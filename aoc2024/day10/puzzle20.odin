package main

import "core:fmt"
import "core:os"
import "core:mem"
import "core:container/queue"

bfs :: proc(startPos : [2]int, data : []byte, width : int, height : int) -> int {
    toIndex :: proc(pos : [2]int, width : int) -> int {
        return pos.y * (width + 1) + pos.x
    }

    clamp2 :: proc(v : [2]int, min : [2]int, max : [2]int) -> [2]int{
        return [2]int{ clamp(v.x, min.x, max.x), clamp(v.y, min.y, max.y) }
    }

    assert(data[toIndex(startPos, width)] == '0')

    marked := make(map[[2]int]struct{})
    defer delete(marked)

    open : queue.Queue([2]int)
    queue.init(&open)
    defer queue.destroy(&open)
    queue.push_back(&open, startPos)

    nines := 0

    for queue.len(open) != 0 {
        node := queue.pop_front(&open)

        if data[node.y * (width + 1) + node.x] == '9' {
            nines += 1
            continue
        }

        neighbors := [4][2]int{ node + { 1, 0 }, node - { 1, 0 }, node + { 0, 1 }, node - { 0, 1 } }
        for neighbor in neighbors {
            if  clamp2(neighbor, 0, {width - 1, height - 1} ) == neighbor && 
                data[toIndex(node, width)] + 1 == data[toIndex(neighbor, width)] &&
                !(neighbor in marked)
            {
                marked[neighbor] = {}
                queue.push_back(&open, neighbor)
            }
        }
    }

    return nines
}

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
    
    result := 0

    for char, i in data {
        if char == '0' {
            result += bfs({ i % (width + 1), i / (width + 1) }, data[:], width, height)
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
