#include <iostream>
#include <vector>
#include <string>
#include "../helper.h"

std::vector<std::string> readFile() {
    std::vector<std::string> lines;
    auto lambda = [&](void* handler, std::string line) {
        lines.push_back(line);
    };
    readInputFile(nullptr, lambda);
    return lines;
}

template<int N>
void run(int aInit, std::vector<std::string> lines, int (&output)[N]) {
    int registers[4] = { aInit, 0, 0, 0 };
    int instruction = 0;
    int outputSize = 0;
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
        } else if (parts[0] == "out") {
            int value;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            output[outputSize++] = value;
            if (outputSize == N)
                break;
        }
    }
}

int main() {
    int aInit = 0;
    auto lines = readFile();
    int output[10];
    while (true) {
        run<10>(aInit, lines, output);
        bool ok = true;
        for (int i = 0; i < 10; i++) {
            if (output[i] != i % 2) {
                aInit++;
                ok = false;
                break;
            }
        }
        if (ok)
            break;
    }
    std::cout << aInit << std::endl;
    return 0;
}
