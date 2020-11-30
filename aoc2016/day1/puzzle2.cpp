#include <iostream>
#include <string>
#include <vector>
#include <unordered_set>
#include "../helper.h"

struct Direction {
    enum Turn {
        LEFT,
        RIGHT
    };

    Turn turn;
    int forward;

    Direction(const std::string& str) {
        if (str[0] == 'L')
            this->turn = Turn::LEFT;
        else //(str[0] == 'R')
            this->turn = Turn::RIGHT;
        this->forward = std::stoi(str.substr(1));
    }
};

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
    std::vector<Vec2i> orientations = { vec2i(0, 1), vec2i(1, 0), vec2i(0, -1), vec2i(-1, 0) };
    int facing = 0;
    Vec2i currentPos;
    std::unordered_set<Vec2i> visited;
    visited.insert(currentPos);
    for (const auto& instruction : instructions) {
        bool found = false;
        facing = (facing + (instruction.turn == Direction::Turn::LEFT ? -1 : 1) + 4) % 4;
        Vec2i dir = orientations[facing];
        for (int i = 0; i < instruction.forward; i++) {
            currentPos = currentPos + dir;
            std::unordered_set<Vec2i>::const_iterator iter = visited.find(currentPos);
            if (iter != visited.end()) {
                found = true;
                break;
            }
            visited.insert(currentPos);
        }
        if (found)
            break;
    }
    std::cout << abs(currentPos[0]) + abs(currentPos[1]) << std::endl;
    return 0;
}
