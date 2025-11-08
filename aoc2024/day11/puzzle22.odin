package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"

countDigits :: proc(num : u128) -> int {
    if num == 0 {
        return 1
    }
    count := 0
    num := num
    for num != 0 {
        num /= 10
        count += 1
    }
    return count
}

splitNumber :: proc(num : u128) -> [2]u128 {
    digits := countDigits(num)
    assert(digits % 2 == 0)
    p : u128 = 1
    for i in 0 ..< digits / 2 {
        p *= 10
    }
    return [2]u128 { num / p, num % p }
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    parts := strings.split(string(data[:len(data)-1]), " ")
    defer delete(parts)

    readBuffer : [dynamic]u128
    defer delete(readBuffer)
    writeBuffer : [dynamic]u128
    defer delete(writeBuffer)

    for part in parts {
        num, ok := strconv.parse_u128(part)
        assert(ok)
        append(&readBuffer, num)
    }

    for i in 0 ..< 25 {
        numStones := len(readBuffer)
        for stone in readBuffer {
            if countDigits(stone) % 2 == 0 {
                numStones += 1
            }
        }
        resize(&writeBuffer, numStones)

        j := 0
        for stone in readBuffer {
            if stone == 0 {
                writeBuffer[j] = 1
            } else if countDigits(stone) % 2 == 0 {
                splitStone := splitNumber(stone)
                writeBuffer[j] = splitStone[0]
                j += 1
                writeBuffer[j] = splitStone[1]
            } else {
                writeBuffer[j] = stone * 2024
            }
            j += 1
        }

        readBuffer, writeBuffer = writeBuffer, readBuffer
    }

    fmt.println(len(readBuffer))
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
