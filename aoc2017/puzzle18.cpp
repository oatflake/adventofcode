#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

std::string readInput() {
    std::string result;
    auto lambda = [&](const std::string& line) {
        result = line;
    };
    readInputFile(lambda);
    return result;
}

int main() {
    auto line = readInput();
    int totalGarbage = 0;
    bool garbage = false;
    bool ignoreNext = false;
    for (char c : line) {
        if (ignoreNext) {
            ignoreNext = false;
            continue;
        }
        if (garbage) {
            if (c == '!')
                ignoreNext = true;
            else if (c == '>')
                garbage = false;
            else
                totalGarbage++;
        } else {
            if (c == '<')
                garbage = true;
        }
    }
    std::cout << totalGarbage << std::endl;
}
