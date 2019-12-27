#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

std::string readInput() {
    std::string result;
    auto lambda = [&](void* handler, const std::string& line) {
        result = line;
    };
    readInputFile(nullptr, lambda);
    return result;
}

int64_t decompress(const std::string& input) {
    int64_t decompressedLength = 0;
    for (int i = 0; i < input.size(); i++) {
        if (input[i] == '(') {
            int j = i;
            for (; j < input.size(); j++) {
                if (input[j] == ')')
                    break;
            }
            auto parameters = split(input.substr(i + 1, j - i - 1), "x");
            int length = std::stoi(parameters[0]);
            int repeat = std::stoi(parameters[1]);
            std::string repeatedString = input.substr(j + 1, length);
            decompressedLength += decompress(repeatedString) * repeat;
            i = j + length;
        } else {
            decompressedLength++;
        }
    }
    return decompressedLength;
}

int main() {
    std::string input = readInput();
    std::cout << decompress(input) << std::endl;
    return 0;
}
