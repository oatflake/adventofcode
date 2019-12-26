#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

struct Direction {
    enum Turn {
        LEFT,
        RIGHT
    };

    Turn turn;
    int forward;

    Direction(std::string str) {
        if (str[0] == 'L')
            this->turn = Turn::LEFT;
        else //(str[0] == 'R')
            this->turn = Turn::RIGHT;
        this->forward = std::stoi(str.substr(1));
    }
};

std::string to_string(Direction dir) {
    std::string result;
    result += dir.turn == Direction::Turn::LEFT ? "L" : "R";
    result += std::to_string(dir.forward);
    return result;
}

std::vector<Direction> readInput() {
    std::vector<Direction> directions;
    auto lambda = [&](void* handler, std::string line) {
        std::vector<std::string> splitLine = split(line, ", ");
        for (const auto& instr : splitLine) {
            directions.push_back(Direction(instr));
        }
    };
    readInputFile(nullptr, lambda);
    return directions;
}

int main () { 
    std::vector<Direction> instructions = readInput();
    Vec2i currentPos = Vec2i();
    
    std::vector<Vec2i> orientations = { vec2i(0, 1), vec2i(1, 0), vec2i(0, -1), vec2i(-1, 0) };
    int facing = 0;
    for (auto instruction : instructions) {
        facing = (facing + (instruction.turn == Direction::Turn::LEFT ? -1 : 1) + 4) % 4;
        Vec2i dir = orientations[facing];
        currentPos = currentPos + instruction.forward * dir;
    }
    std::cout << abs(currentPos[0]) + abs(currentPos[1]) << std::endl;
    return 0;
}
