#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include "helper.h"

uint64_t read(const std::string& input, std::unordered_map<char, uint64_t>& registers) {
    if (input[0] >= 'a' && input[0] <= 'z')
        return registers[input[0]];
    return std::stoi(input);
}

std::vector<std::string> readInput() {
    std::vector<std::string> instructions;
    auto lambda = [&](const std::string& line) {
        instructions.push_back(line);
    };
    readInputFile(lambda);
    return instructions;
}

int main() {
    auto instructions = readInput();
    uint64_t instructionPointer = 0;
    std::unordered_map<char, uint64_t> registers;
    uint64_t sound = 0;
    while (instructionPointer < instructions.size() && instructionPointer >= 0) {
        auto parts = split(instructions[instructionPointer++], " ");
        if (parts[0] == "snd"){
            uint64_t value = read(parts[1], registers);
            sound = value;
        }
        if (parts[0] == "set"){
            uint64_t value = read(parts[2], registers);
            registers[parts[1][0]] = value;
        }
        if (parts[0] == "add"){
            uint64_t value = read(parts[2], registers);
            registers[parts[1][0]] += value;
        }
        if (parts[0] == "mul"){
            uint64_t value = read(parts[2], registers);
            registers[parts[1][0]] *= value;
        }
        if (parts[0] == "mod"){
            uint64_t value = read(parts[2], registers);
            registers[parts[1][0]] %= value;
        }
        if (parts[0] == "rcv"){
            if (registers[parts[1][0]] != 0) {
                registers[parts[1][0]] = sound;
                std::cout << sound << std::endl;
                break;
            }
        }
        if (parts[0] == "jgz"){
            uint64_t value = read(parts[2], registers);
            if (read(parts[1], registers) > 0)
                instructionPointer += value - 1;
        }
    }
    
    return 0;
}
