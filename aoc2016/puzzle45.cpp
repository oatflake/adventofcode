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
    int registers[4] = { 7, 0, 0, 0 };
    int instruction = 0;
    while (instruction < lines.size()) {
        auto parts = split(lines[instruction++], " ");
        if (parts[0] == "cpy") {
            int value;
            if ('a' > parts[2][0] || parts[2][0] > 'd')
                continue;
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
            int value2;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            if ('a' <= parts[2][0] && parts[2][0] <= 'd')
                value2 = registers[parts[2][0] - 'a'];
            else
                value2 = std::stoi(parts[2]);
            if (value != 0)
                instruction += value2 - 1;
        } else if (parts[0] == "tgl") {
            int value;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            int modifiedInstruction = instruction + value - 1;
            if (modifiedInstruction >= lines.size())
                continue;
            auto tglParts = split(lines[modifiedInstruction], " ");
            if (tglParts.size() == 2) {
                if (tglParts[0] == "inc")
                    lines[modifiedInstruction].replace(0, 3, "dec");
                else
                    lines[modifiedInstruction].replace(0, 3, "inc");
            } else if (tglParts.size() == 3) {
                if (tglParts[0] == "jnz")
                    lines[modifiedInstruction].replace(0, 3, "cpy");
                else
                    lines[modifiedInstruction].replace(0, 3, "jnz");
            }
        }
    }
    std::cout << registers[0] << std::endl;
    return 0;
}
