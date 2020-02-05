#include <iostream>
#include <string>
#include <tuple>
#include "helper.h"

std::tuple<std::string, int> readInput() {
    std::string map;
    int width;
    auto lambda = [&](const std::string& line) {
        map += line;
        width = line.size();
    };
    readInputFile(lambda);
    return std::make_tuple(map, width);
}

enum Direction {
    LEFT,
    RIGHT,
    UP,
    DOWN
};

std::string follow(const std::string& map, int begin, int width, int height) {
    std::string path;
    Direction dir = Direction::DOWN;
    int current = begin;
    while (map[current] != ' ') {
        char c = map[current];
        int currentX = current % width;
        int currentY = current / width;
        if (c == '+') {
            if (dir != Direction::LEFT && dir != Direction::RIGHT && 
                currentX - 1 >= 0 && map[current - 1] != ' ') 
            {
                dir = Direction::LEFT;
            } else if (dir != Direction::RIGHT && dir != Direction::LEFT && 
                currentX + 1 < width && map[current + 1] != ' ') 
            {
                dir = Direction::RIGHT;
            } else if (dir != Direction::UP && dir != Direction::DOWN && 
                currentY - 1 >= 0 && map[current - width] != ' ') 
            {
                dir = Direction::UP;
            } else if (dir != Direction::DOWN && dir != Direction::UP && 
                currentY + 1 < height && map[current + width] != ' ') 
            {
                dir = Direction::DOWN;
            }
        }
        if (c >= 'A' && c <= 'Z') {
            path.push_back(map[current]);
        }
        switch (dir) {
            case (Direction::DOWN): currentY += 1; break;
            case (Direction::UP): currentY -= 1; break;
            case (Direction::LEFT): currentX -= 1; break;
            case (Direction::RIGHT): currentX += 1; break;
            default: break;
        }
        if (currentX < 0 || currentX >= width || currentY < 0 || currentY >= height)
            break;
        current = currentX + currentY * width;
    }
    return path;
}

int main() {
    std::string map;
    int width;
    std::tie(map, width) = readInput();
    int height = map.size() / width;
    int begin = -1;
    for (begin = 0; begin < width; begin++) {
        if (map[begin] == '|')
            break;
    }
    auto result = follow(map, begin, width, height);
    std::cout << result << std::endl;
    return 0;
}
