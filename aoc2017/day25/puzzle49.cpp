#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <tuple>
#include "../helper.h"

std::tuple<char, char, char, char, char> parseValue(char state, std::ifstream& inputFile) {
    std::string line;
    getline(inputFile,line);
    char readValue = split(line, "is ")[1][0];
    getline(inputFile,line);
    char writeValue = split(line, "value ")[1][0];
    getline(inputFile,line);
    char dir = split(line, "the ")[1][0];
    getline(inputFile,line);
    char nextState = split(line, "state ")[1][0];
    return { state, readValue, writeValue, dir, nextState };
}

bool parseState(std::ifstream& inputFile, 
    std::vector<std::tuple<char, char, char, char, char>>& transitions) 
{
    std::string line;
    if (!getline(inputFile,line))
        return false;
    char state = split(line, "state ")[1][0];
    transitions.push_back(parseValue(state, inputFile));
    transitions.push_back(parseValue(state, inputFile));
    getline(inputFile,line);
    return true;
}

std::tuple<char, int, std::vector<std::tuple<char, char, char, char, char>>> readInput() {
    std::string line;
    std::ifstream inputFile ("input");
    char startState;
    int steps;
    std::vector<std::tuple<char, char, char, char, char>> transitions;
    if (inputFile.is_open()) {
        getline(inputFile,line);
        startState = split(line, " ")[3][0];
        getline(inputFile,line);
        steps = std::stoi(split(line, " ")[5]);
        getline(inputFile,line);
        while (parseState(inputFile, transitions)) {}
        inputFile.close();
        return { startState, steps, transitions };
    }
    else {
        std::cout << "Unable to open file";
        return { 0, 0, {} };
    }
}

class TuringMachine {
    char state;
    int steps;
    int cursor;
    std::unordered_map<int, std::tuple<char, char, char>> transitions;
    std::unordered_map<int, char> tape;
public:
    TuringMachine(char startState, int maxSteps, std::vector<std::tuple<char, char, char, char, char>> transitions) {
        this->state = startState;
        this->steps = maxSteps;
        this->cursor = 0;
        for (auto transition : transitions) {
            char state, readValue, writeValue, dir, nextState;
            std::tie(state, readValue, writeValue, dir, nextState) = transition;
            this->transitions[(state << 8) | readValue] = { writeValue, dir, nextState };
        }
    }
    int run() {
        for (; steps > 0; steps--) {
            char readValue;
            auto tapeIter = tape.find(cursor);
            readValue = '0';
            if (tapeIter != tape.end())
                readValue = tapeIter->second;
            char writeValue, dir, nextState;
            std::tie(writeValue, dir, nextState) = transitions[(state << 8) | readValue];
            tape[cursor] = writeValue;
            cursor += dir == 'l' ? -1 : 1;
            state = nextState;
        }
        int checkSum = 0;
        for (auto cell : tape) {
            checkSum += cell.second - '0';
        }
        return checkSum;
    }
};

int main() {
    auto turingMachineInput = readInput();
    char startState;
    int maxSteps;
    std::vector<std::tuple<char, char, char, char, char>> transitions;
    std::tie(startState, maxSteps, transitions) = turingMachineInput;
    TuringMachine turingMachine(startState, maxSteps, transitions);
    std::cout << turingMachine.run() << std::endl;
    return 0;
}
