#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include "../helper.h"

int readInput() {
    int maxValue = 1 << 31;
    std::unordered_map<std::string, int> registers;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, " ");
        auto registerName = parts[0];
        auto operation = parts[1];
        int value = std::stoi(parts[2]);
        auto conditionalRegisterName = parts[4];
        auto condition = parts[5];
        auto conditionalValue = std::stoi(parts[6]);
        auto iter = registers.find(registerName);
        int registerValue;
        if (iter == registers.end()) {
            registers[registerName] = 0;
            registerValue = 0;
        } else {
            registerValue = iter->second;
        }
        iter = registers.find(conditionalRegisterName);
        int conditionalRegisterValue;
        if (iter == registers.end()) {
            registers[conditionalRegisterName] = 0;
            conditionalRegisterValue = 0;
        } else {
            conditionalRegisterValue = iter->second;
        }
        if (condition == "<") {
            if (conditionalRegisterValue < conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        if (condition == "<=") {
            if (conditionalRegisterValue <= conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        if (condition == ">") {
            if (conditionalRegisterValue > conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        if (condition == ">=") {
            if (conditionalRegisterValue >= conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        if (condition == "==") {
            if (conditionalRegisterValue == conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        if (condition == "!=") {
            if (conditionalRegisterValue != conditionalValue)
                registers[registerName] = operation == "inc" ? registerValue + value : registerValue - value;
        }
        for (const auto& iter : registers) {
            if (iter.second > maxValue)
                maxValue = iter.second;
        }
    };
    readInputFile(lambda);
    return maxValue;
}

int main() {
    int maxValue = readInput();
    std::cout << maxValue << std::endl;
    return 0;
}
