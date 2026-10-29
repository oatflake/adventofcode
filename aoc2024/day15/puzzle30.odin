package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem"

canMove :: proc(tiles : []rune, tilesSize : [2]int, pos : [2]int, dir : [2]int) -> bool
{
    coord := pos + dir
    tile := tiles[coord.x + coord.y * tilesSize.x]
    if tile == '.'
    {
        return true
    }
    if tile == '#'
    {
        return false
    }
    if tile == '[' && dir.x == 0
    {
        return canMove(tiles[:], tilesSize, coord, dir) && canMove(tiles[:], tilesSize, coord + {1, 0}, dir)
    }
    if tile == ']' && dir.x == 0
    {
        return canMove(tiles[:], tilesSize, coord, dir) && canMove(tiles[:], tilesSize, coord - {1, 0}, dir)
    }
    if (tile == '[' || tile == ']') && dir.y == 0
    {
        return canMove(tiles[:], tilesSize, coord, dir)
    }
    assert(false)
    return false
}

makeSpace :: proc(tiles : []rune, tilesSize : [2]int, pos : [2]int, dir : [2]int)
{
    coord := pos + dir
    tile := tiles[coord.x + coord.y * tilesSize.x]
    if tile == '.'
    {
        return
    }
    assert(tile != '#')
    if tile == '[' && dir.x == 0
    {
        coordL := coord
        coordR := coord + {1, 0}
        makeSpace(tiles[:], tilesSize, coordL, dir)
        makeSpace(tiles[:], tilesSize, coordR, dir)
        tiles[coordL.x + coordL.y * tilesSize.x] = '.'
        tiles[coordR.x + coordR.y * tilesSize.x] = '.'
        coordL = coordL + dir
        coordR = coordR + dir
        tiles[coordL.x + coordL.y * tilesSize.x] = '['
        tiles[coordR.x + coordR.y * tilesSize.x] = ']'
        return
    }
    if tile == ']' && dir.x == 0
    {
        coordL := coord - {1, 0}
        coordR := coord
        makeSpace(tiles[:], tilesSize, coordL, dir)
        makeSpace(tiles[:], tilesSize, coordR, dir)
        tiles[coordL.x + coordL.y * tilesSize.x] = '.'
        tiles[coordR.x + coordR.y * tilesSize.x] = '.'
        coordL = coordL + dir
        coordR = coordR + dir
        tiles[coordL.x + coordL.y * tilesSize.x] = '['
        tiles[coordR.x + coordR.y * tilesSize.x] = ']'
        return
    }
    if (tile == '[' || tile == ']') && dir.y == 0
    {
        makeSpace(tiles[:], tilesSize, coord, dir)
        coord += dir
        tiles[coord.x + coord.y * tilesSize.x] = tile
        return
    }
    assert(false)
}

simulate :: proc(tiles : []rune, tilesSize : [2]int, pos : [2]int, directions : []rune)
{
    pos := pos
    for direction in directions
    {
        dir : [2]int
        switch direction
        {
            case '<':
                dir = {-1, 0}
            case '>':
                dir = {1, 0}
            case '^':
                dir = {0, -1}
            case 'v':
                dir = {0, 1}
        }
        if canMove(tiles[:], tilesSize, pos, dir)
        {
            makeSpace(tiles, tilesSize, pos, dir)
            coord := pos + dir
            tiles[coord.x + coord.y * tilesSize.x] = '@'
            tiles[pos.x + pos.y * tilesSize.x] = '.'
            pos = coord
        }
    }
}

score :: proc(tiles : []rune, tilesSize : [2]int) -> int
{
    result := 0
    for tile, i in tiles
    {
        if tile == '['
        {
            result += (i % tilesSize.x) + (i / tilesSize.x) * 100
        }
    }
    return result
}

print :: proc(tiles : []rune, tilesSize : [2]int)
{
    for i := 0; i < tilesSize.y; i += 1
    {
        s := tiles[tilesSize.x * i : tilesSize.x * (i + 1)]
        fmt.println(s)
    }
}

run :: proc() {
    data, ok := os.read_entire_file("input")
    assert(ok)
    defer delete(data)

    tiles : [dynamic]rune
    defer delete(tiles)

    directions : [dynamic]rune
    defer delete(directions)
    
    hasReadMap := false

    pos : [2]int
    x := 0
    y := 0
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        if !hasReadMap
        {
            if len(line) == 0
            {
                hasReadMap = true
            }
            else
            {
                x = 0
                for char in line
                {
                    switch char
                    {
                        case '#':
                            append(&tiles, '#')
                            append(&tiles, '#')
                        case 'O':
                            append(&tiles, '[')
                            append(&tiles, ']')
                        case '.':
                            append(&tiles, '.')
                            append(&tiles, '.')
                        case '@':
                            append(&tiles, '@')
                            append(&tiles, '.')
                            pos = {x, y}
                    }
                    x += 2
                }
                y += 1
            }
        }
        else
        {
            for char in line
            {
                append(&directions, char)
            }
        }
    }

    simulate(tiles[:], {x, y}, pos, directions[:])
    //print(tiles[:], {x, y})
    result := score(tiles[:], {x, y})
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
