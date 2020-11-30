#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <queue>
#include "../helper.h"

int64_t read(const std::string& input, std::unordered_map<char, int64_t>& registers) {
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

enum State {
    RUNNING,
    WAITING,
    SENDING,
    TERMINATED
};

class Computer {
    std::unordered_map<char, int64_t> registers;
    std::vector<std::string> instructions;
    int64_t instructionPointer = 0;
    int64_t id;
    std::queue<int64_t> queue;
public:
    Computer(std::vector<std::string> instructions, int64_t id) : instructions(instructions), id(id) { 
        registers['p'] = id;
    }

    std::tuple<State, int64_t> execute() {
        if (instructionPointer >= instructions.size() || instructionPointer < 0)
            return std::make_tuple<State, int64_t>(State::TERMINATED, 0);
        auto parts = split(instructions[instructionPointer++], " ");
        if (parts[0] == "snd"){
            int64_t value = read(parts[1], registers);
            return std::make_tuple<State, int64_t>(State::SENDING, std::move(value));
        }
        if (parts[0] == "set"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] = value;
        }
        if (parts[0] == "add"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] += value;
        }
        if (parts[0] == "mul"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] *= value;
        }
        if (parts[0] == "mod"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] %= value;
        }
        if (parts[0] == "rcv"){
            if (queue.empty()) {
                instructionPointer--;
                return std::make_tuple<State, int64_t>(State::WAITING, 0);
            }
            registers[parts[1][0]] = queue.front();
            queue.pop();
        }
        if (parts[0] == "jgz"){
            int64_t value = read(parts[2], registers);
            if (read(parts[1], registers) > 0)
                instructionPointer += value - 1;
        }
        return std::make_tuple<State, int64_t>(State::RUNNING, 0);
    }

    void add(int64_t value) {
        queue.push(value);
    }
};

int main() {
    int send1 = 0;
    auto instructions = readInput();
    Computer c1(instructions, 0);
    Computer c2(instructions, 1);
    bool end = false;
    while (!end) {
        State state1;
        int64_t result1;
        std::tie(state1, result1) = c1.execute();
        State state2;
        int64_t result2;
        std::tie(state2, result2) = c2.execute();
        if (state1 == State::TERMINATED)
            std::cout << "1 terminated" << std::endl;
        if (state2 == State::TERMINATED)
            std::cout << "2 terminated" << std::endl;
        if (state1 == State::SENDING) {
            c2.add(result1);
        }
        if (state2 == State::SENDING) {
            send1++;
            c1.add(result2);
        }
        end = state1 == State::WAITING && state2 == State::WAITING;
    }
    std::cout << send1 << std::endl;
    return 0;
}
