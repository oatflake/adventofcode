#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <queue>
#include "../helper.h"

int64_t read(const std::string& input, std::unordered_map<char, int64_t>& registers) {
    if (input[0] >= 'a' && input[0] <= 'z') {
        if (registers.find(input[0]) != registers.end())
            return registers[input[0]];
        return 0;
    }
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

enum State {
    RUNNING,
    TERMINATED
};

class Computer {
    std::unordered_map<char, int64_t> registers;
    std::vector<std::string> instructions;
    int64_t instructionPointer = 0;
    int64_t multiplications = 0;
public:
    Computer(std::vector<std::string> instructions) : instructions(instructions) { }

    std::tuple<State, int64_t> execute() {
        if (instructionPointer >= instructions.size() || instructionPointer < 0) {
            int64_t m = multiplications;
            return std::make_tuple<State, int64_t>(State::TERMINATED, std::move(m));
        }
        auto parts = split(instructions[instructionPointer++], " ");
        if (parts[0] == "set"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] = value;
        }
        if (parts[0] == "sub"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] = read(parts[1], registers) - value;
        }
        if (parts[0] == "mul"){
            int64_t value = read(parts[2], registers);
            multiplications++;
            registers[parts[1][0]] = read(parts[1], registers) * value;
        }
        if (parts[0] == "jnz"){
            int64_t value = read(parts[2], registers);
            if (read(parts[1], registers) != 0)
                instructionPointer += value - 1;
        }
        return std::make_tuple<State, int64_t>(State::RUNNING, 0);
    }
};

int main() {
    auto instructions = readInput();
    Computer computer(instructions);
    bool end = false;
    int64_t result;
    while (!end) {
        State state;
        std::tie(state, result) = computer.execute();
        if (state == State::TERMINATED)
            end = true;
    }
    std::cout << result << std::endl;
    return 0;
}
