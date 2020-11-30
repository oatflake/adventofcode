#include <iostream>
#include <string>
#include <vector>
#include "../helper.h"

std::vector<bool> readInput() {
    std::vector<bool> map;
    auto lambda = [&](void*, std::string line){
        for (int i = 0; i < line.size(); i++) {
            map.push_back(line[i] == '.');
        }
    };
    readInputFile(nullptr, lambda);
    return map;
}

void fillMap(std::vector<bool>& map) {
    int rowSize = map.size();
    for (int y = 0; y < 39; y++) {
        for (int x = 0; x < rowSize; x++) {
            bool left = x - 1 < 0 ? true : map[(x - 1) + y * rowSize];
            bool right = x + 1 >= rowSize ? true : map[(x + 1) + y * rowSize];
            bool center = map[x + y * rowSize];
            bool rule1 = !left && !center && right;
            bool rule2 = left && !center && !right;
            bool rule3 = !left && center && right;
            bool rule4 = left && center && !right;
            map.push_back(!(rule1 || rule2 || rule3 || rule4));
        }
    }
}

int main() {
    auto map = readInput();
    fillMap(map);
    int safeTiles = 0;
    for (int i = 0; i < map.size(); i++) {
        if (map[i])
            safeTiles++;
    }
    std::cout << safeTiles << std::endl;
    return 0;
}
