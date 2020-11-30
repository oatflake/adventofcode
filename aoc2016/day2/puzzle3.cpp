#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include "../helper.h"

std::vector<int> readInput() {
    std::vector<int> code;
    int x = 1;
    int y = 1;
    auto lambda = [&](void* handler, std::string line) {
        for (char c : line) {
            if (c == 'L')
                x = std::max(x - 1, 0);
            if (c == 'R')
                x = std::min(x + 1, 2);
            if (c == 'U')
                y = std::max(y - 1, 0);
            if (c == 'D')
                y = std::min(y + 1, 2);
        }
        code.push_back(x + y * 3 + 1);
    };
    readInputFile(nullptr, lambda);
    return code;
}

int main() {
    std::vector<int> code = readInput();
    for (int i : code) {
        std::cout << i;
    }
    std::cout << std::endl;
}
