#include <iostream>
#include <vector>
#include <string>
#include "helper.h"

std::vector<std::string> readFile() {
    std::vector<std::string> lines;
    auto lambda = [&](void* handler, std::string line) {
        lines.push_back(line);
    };
    readInputFile(nullptr, lambda);
    return lines;
}

int main() {
    auto lines = readFile();
    int registers[4] = { 0, 0, 0, 0 };
    int instruction = 0;
    while (instruction < lines.size()) {
        auto parts = split(lines[instruction++], " ");
        if (parts[0] == "cpy") {
            int value;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                 value = registers[parts[1][0] - 'a'];
            else
                 value = std::stoi(parts[1]);
            registers[parts[2][0] - 'a'] = value;
        } else if (parts[0] == "inc") {
            registers[parts[1][0] - 'a']++;
        } else if (parts[0] == "dec") {
            registers[parts[1][0] - 'a']--;
        } else if (parts[0] == "jnz") {
            int value;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            if (value != 0)
                instruction += std::stoi(parts[2]) - 1;
        }
    }
    std::cout << registers[0] << std::endl;
    return 0;
}
