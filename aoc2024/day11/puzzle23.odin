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

Param :: struct {
    stone : u128,
    iteration : int
}

evaluate :: proc(dict : ^map[Param]int, stone : u128, i : int) -> int {
    param := Param{stone, i}
    if param in dict {
        return dict[param]
    }

    result := 0
    
    if i == 0 {
        result = 1
    } else if stone == 0 {
        result = evaluate(dict, 1, i - 1)
    } else if countDigits(stone) % 2 == 0 {
        splitStone := splitNumber(stone)
        a := evaluate(dict, splitStone[0], i - 1)
        b := evaluate(dict, splitStone[1], i - 1)
        result = a + b
    } else {
        result = evaluate(dict, stone * 2024, i - 1)
    }

    dict[param] = result
    return result
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    parts := strings.split(string(data[:len(data)-1]), " ")
    defer delete(parts)

    dict : map[Param]int
    defer delete(dict)

    result := 0

    for part in parts {
        num, ok := strconv.parse_u128(part)
        assert(ok)
        result += evaluate(&dict, num, 75)
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
