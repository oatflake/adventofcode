#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include "../helper.h"

std::vector<int> readInput() {
    std::vector<int> result;
    auto lambda = [&](void* handler, std::string line) {
        std::vector<std::string> splitLine = split(line, " ");
        std::vector<int> numbers;
        for (int i = 0; i < splitLine.size(); i++) {
            if (splitLine[i] != ""){
                int num = std::stoi(splitLine[i]);
                result.push_back(num);
            }
        }
    };
    readInputFile(nullptr, lambda);
    return result;
}

int main () { 
    std::vector<int> triangleSides = readInput();
    int possibleTriangles = 0;
    for (int i = 0; i < triangleSides.size(); i += 3) {
        int a = triangleSides[i];
        int b = triangleSides[i + 1];
        int c = triangleSides[i + 2];
        int m = std::max(a, std::max(b, c));
        if (m < a + b + c - m)
            possibleTriangles += 1;
    }
    std::cout << possibleTriangles << std::endl;
    return 0;
}
