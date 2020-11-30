#include <iostream>
#include <string>
#include <array>
#include <cmath>
#include <unordered_map>
#include "../helper.h"

std::unordered_map<Vec2i, char> readInput(int& width, int& height) {
    std::unordered_map<Vec2i, char> map;
    int y = 0;
    auto lambda = [&](const std::string& line) {
        width = line.size();
        for (int x = 0; x < line.size(); x++)
            map[vec2i(x, y)] = line[x];
        y++;
    };
    readInputFile(lambda);
    height = y;
    return map;
}

int main() {
    int width, height;
    auto map = readInput(width, height);
    Vec2i pos = vec2i(width / 2, height / 2);
    int direction = 0;
    std::array<Vec2i, 4> offsets = { vec2i(0, -1), vec2i(1, 0), vec2i(0, 1), vec2i(-1, 0) };
    int infected = 0;
    for (int i = 0; i < 10000; i++) {
        if (map.find(pos) != map.end() && map[pos] == '#')
            direction = (direction + 1) % 4;
        else
            direction = (direction - 1 + 4) % 4;
        map[pos] = (map.find(pos) == map.end() || map[pos] == '.') ? '#' : '.';
        if (map[pos] == '#')
            infected++;
        pos = pos + offsets[direction];
    }
    std::cout << infected << std::endl;
    return 0;
}
