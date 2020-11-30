#include <iostream>
#include <vector>
#include <cmath>
#include "../helper.h"

int distance(Vector<int, 2> a, Vector<int, 2> b) {
    Vector<int, 2> d = Vector<int, 2>::abs(a - b);
    int dy = std::max(0, d[1] - d[0] / 2);
    return (d[0] + dy) / 2;
}

Vec2i north(Vec2i a) {
    return a + vec2i(0, 2);
}

Vec2i northWest(Vec2i a) {
    return a + vec2i(-2, 1);
}

Vec2i northEast(Vec2i a) {
    return a + vec2i(2, 1);
}

Vec2i south(Vec2i a) {
    return a + vec2i(0, -2);
}

Vec2i southWest(Vec2i a) {
    return a + vec2i(-2, -1);
}

Vec2i southEast(Vec2i a) {
    return a + vec2i(2, -1);
}

std::vector<std::string> readInput() {
    std::vector<std::string> result;
    auto lambda = [&](std::string line) {
        result = split(line, ",");
    };
    readInputFile(lambda);
    return result;
}

int main() {
    auto input = readInput();
    Vec2i pos = vec2i(0, 0);
    for (const auto& dir : input) {
        if (dir == "n")
            pos = north(pos);
        if (dir == "nw")
            pos = northWest(pos);
        if (dir == "ne")
            pos = northEast(pos);
        if (dir == "s")
            pos = south(pos);
        if (dir == "sw")
            pos = southWest(pos);
        if (dir == "se")
            pos = southEast(pos);
    }
    Vec2i a = vec2i(0, 0);
    int d = distance(a, pos);
    std::cout << d << std::endl;
    return 0;
}
