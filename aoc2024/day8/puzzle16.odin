package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem"

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    antennas := make(map[rune][dynamic][2]int)
    defer delete(antennas)

    antinodes := make(map[[2]int]struct{})
    defer delete(antinodes)

    it := string(data)
    width := 0
    height := 0
    for line in strings.split_lines_iterator(&it) {
        for char, x in line {
            if char != '.' {
                arr, ok := &antennas[char]
                if !ok {
                    antennas[char] = make([dynamic][2]int)
                    arr, ok = &antennas[char]
                    assert(ok)
                }
                append(arr, [2]int{x, height})
            }
        }

        width = len(line)
        height += 1
    }

    clamp2 :: proc(x : [2]int, min : [2]int, max : [2]int) -> [2]int {
        return [2]int{ clamp(x.x, min.x, max.x), clamp(x.y, min.y, max.y) }
    }

    for key, antenna in antennas {
        for a, i in antenna {
            for b in antenna[i + 1:] {
                for node1 := a; clamp2(node1, 0, {width - 1, height - 1}) == node1; node1 += a - b {
                    antinodes[node1] = {}
                }
                for node2 := b; clamp2(node2, 0, {width - 1, height - 1}) == node2; node2 += b - a {
                    antinodes[node2] = {}
                }
            }
        }
    }
    
    result := len(antinodes)
    fmt.println(result)

    for key, antenna in antennas {
    	delete(antenna)
    }
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
