#include <string>
#include <iostream>
#include <vector>
#include "../helper.h"

std::vector<int> readInput() {
    std::vector<int> input;
    auto lambda = [&](const std::string& line) {
        input.push_back(std::stoi(line));
    };
    readInputFile(lambda);
    return input;
}

int main() {
    auto offsets = readInput();
    int index = 0;
    int steps = 0;
    while (index >= 0 && index < offsets.size()) {
        int offset = offsets[index];
        offsets[index] += offsets[index] >= 3 ? -1 : 1;
        index += offset;
        steps++;
    }
    std::cout << steps << std::endl;
    return 0;
}
