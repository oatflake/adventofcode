package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"

findInvalidIndex :: proc(report : []i32, ignoredIndex : int) -> int {
    assert(len(report) >= 3)
    valid := true
    
    ascending : bool
    a : i32
    if ignoredIndex == 0 {
        ascending = report[1] < report[2]
        a = report[1]
    } else if ignoredIndex == 1 {
        ascending = report[0] < report[2]
        a = report[0]
    } else {
        ascending = report[0] < report[1]
        a = report[0]
    }

    startIndex := ignoredIndex == 0 ? 2 : 1
    for index := startIndex; index < len(report); index += 1 {
        if index == ignoredIndex {
            continue
        }
        b := report[index]
        if ((a < b) != ascending) || a == b || abs(a - b) > 3 {
            valid = false
            return index
        }
        a = b
    }

    return -1
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    // create sufficiently large levels array
    levelsCount := 0
    for char in data {
        if char == '\n' || char == ' ' {
            levelsCount += 1
        }
    }

    levels := make([dynamic]i32, 0, levelsCount)
    defer delete(levels)
    reports : [dynamic][]i32
    defer delete(reports)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        reportStart := len(levels)
        parts := strings.split(line, " ")
        defer delete(parts)

        for part in parts {
            level, ok := strconv.parse_i64(part)
            assert(ok)
            append(&levels, i32(level))
        }
        append(&reports, levels[reportStart : len(levels)])
    }
    // make sure levels have not moved around in memory, to ensure the slices stored in reports are valid
    assert(len(levels) == levelsCount)

    safeReportsCount := 0
    for report in reports {
        invalidIndex := findInvalidIndex(report, -1)
        if invalidIndex == -1 {
            safeReportsCount += 1
        } else {
            assert(invalidIndex >= 1)
            if  findInvalidIndex(report, invalidIndex - 1) == -1 || 
                findInvalidIndex(report, invalidIndex) == -1 || 
                findInvalidIndex(report, 0) == -1 
            {
                safeReportsCount += 1
            }
        }
    }

    fmt.println(safeReportsCount)
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
