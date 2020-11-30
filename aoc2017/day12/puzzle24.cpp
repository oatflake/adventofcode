#include <iostream>
#include <vector>
#include <string>
#include <unordered_set>
#include "../helper.h"

std::vector<std::vector<int>> readInput() {
    std::vector<std::vector<int>> pipes;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, " <-> ");
        parts = split(parts[1], ", ");
        std::vector<int> connected;
        for (const auto& id : parts)
            connected.push_back(std::stoi(id));
        pipes.push_back(connected);
    };
    readInputFile(lambda);
    return pipes;
}

int main() {
    auto pipes = readInput();
    std::unordered_set<int> visited;
    int groups = 0;
    for (int i = 0; i < pipes.size(); i++) {
        if (visited.find(i) != visited.end())
            continue;
        std::vector<int> stack;
        stack.push_back(i);
        while (!stack.empty()) {
            int current = stack.back();
            stack.pop_back();
            if (visited.find(current) != visited.end())
                continue;
            visited.insert(current);
            for (int neighbor : pipes[current]) {
                if (visited.find(neighbor) == visited.end())
                    stack.push_back(neighbor);
            }
        }
        groups++;
    }
    
    std::cout << groups << std::endl;
    return 0;
}
