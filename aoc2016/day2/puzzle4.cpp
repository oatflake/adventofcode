#include <iostream>
#include <string>
#include <cmath>
#include "../helper.h"

std::string readInput() {
    std::string keypad = "  1  "
                         " 234 "
                         "56789" 
                         " ABC "
                         "  D  ";
    std::string code;
    int x = 0;
    int y = 2;
    auto lambda = [&](void* handler, std::string line) {
        for (char c : line) {
            int oldX = x;
            int oldY = y;
            if (c == 'L')
                x = std::max(x - 1, 0);
            if (c == 'R')
                x = std::min(x + 1, 4);
            if (c == 'U')
                y = std::max(y - 1, 0);
            if (c == 'D')
                y = std::min(y + 1, 4);
            if (keypad[x + 5 * y] == ' ') {
                x = oldX;
                y = oldY;
            }
        }
        code += keypad[x + 5 * y];
    };
    readInputFile(nullptr, lambda);
    return code;
}

int main() {
    std::string code = readInput();
    std::cout << code << std::endl;
}
