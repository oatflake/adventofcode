package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:mem"
import "core:text/regex"

Robot :: struct {
    pos : [2]i32,
    vel : [2]i32
}

simulate :: proc(robots : []Robot) -> i64
{
    quadrants : [4]i64
    for &robot in robots
    {
        robot.pos += robot.vel * 100
        robot.pos = ((robot.pos % { 101, 103 }) + { 101, 103 }) % { 101, 103 }
        index := 0
        if robot.pos.x == 50 || robot.pos.y == 51
        {
            continue
        }
        if robot.pos.x > 50
        {
            index += 1
        }
        if robot.pos.y > 51
        {
            index += 2
        }
        quadrants[index] += 1
    }
    return quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    robots : [dynamic]Robot
    defer delete(robots)

    regularExpression, err := regex.create("^p=(-?\\d+),(-?\\d+) v=(-?\\d+),(-?\\d+)$")
    assert(err == nil)
    defer regex.destroy(regularExpression)

    capture := regex.preallocate_capture()
    defer regex.destroy(capture)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        numGroups, success := regex.match_with_preallocated_capture(regularExpression, line, &capture)
        assert(success)

        posX, ok1 := strconv.parse_i64(capture.groups[1])
        posY, ok2 := strconv.parse_i64(capture.groups[2])
        velX, ok3 := strconv.parse_i64(capture.groups[3])
        velY, ok4 := strconv.parse_i64(capture.groups[4])
        assert(ok1 && ok2 && ok3 && ok4)

        append(&robots, Robot{{i32(posX), i32(posY)}, {i32(velX), i32(velY)}})
    }

    result := simulate(robots[:])
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
