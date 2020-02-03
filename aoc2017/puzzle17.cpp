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
    int totalScore = 0;
    int currentGroupScore = 0;
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
            if (c == '>')
                garbage = false;
        } else {
            if (c == '<')
                garbage = true;
            if (c == '{')
                currentGroupScore++;
            if (c == '}') {
                totalScore += currentGroupScore;
                currentGroupScore--;
            }
        }
    }
    std::cout << totalScore << std::endl;
}
