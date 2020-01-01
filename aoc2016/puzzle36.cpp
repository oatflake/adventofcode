#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

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

int fillMap(std::vector<bool> row1) {
    std::vector<bool> row2 = row1;
    int rowSize = row1.size();
    int count = 0;
    for (int x = 0; x < rowSize; x++) {
        count += row1[x] ? 1 : 0;
    }
    for (int y = 0; y < 400000 - 1; y++) {
        for (int x = 0; x < rowSize; x++) {
            bool left = x - 1 < 0 ? true : row1[(x - 1)];
            bool right = x + 1 >= rowSize ? true : row1[(x + 1)];
            bool center = row1[x];
            bool rule1 = !left && !center && right;
            bool rule2 = left && !center && !right;
            bool rule3 = !left && center && right;
            bool rule4 = left && center && !right;
            row2[x] = (!(rule1 || rule2 || rule3 || rule4));
            count += row2[x] ? 1 : 0;
        }
        row1.swap(row2);
    }
    return count;
}

int main() {
    auto map = readInput();
    std::cout << fillMap(map) << std::endl;
    return 0;
}
