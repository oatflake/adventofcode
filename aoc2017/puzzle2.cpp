#include <iostream>
#include <string>
#include "helper.h"

std::string readInput() {
    std::string word;
    auto lambda = [&](const std::string& line){
        word = line;
    };
    readInputFile(lambda);
    return word;
}

int main() {
    auto line = readInput();
    int count = 0;
    int lineSize = line.size();
    for (int i = 0; i < lineSize; i++) {
        if (line[i] == line[(i + lineSize / 2) % lineSize])
            count += line[i] - '0';
    }
    std::cout << count << std::endl;
    return 0;
}
