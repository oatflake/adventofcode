#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include "../helper.h"

class DanceMove {
public:
    virtual std::string dance(const std::string& programs) const = 0;
};

class Spin : public DanceMove {
    int amount;
public:
    Spin(const std::string& input) {
        amount = std::stoi(input.substr(1));
    }
    std::string dance(const std::string& programs) const override {
        std::string result = programs;
        for (int i = 0; i < programs.size(); i++) {
            result[(i + amount) % programs.size()] = programs[i];
        }
        return result;
    }
};

class Exchange : public DanceMove {
    int aPos;
    int bPos;
public:
    Exchange(const std::string& input) {
        auto parts = split(input.substr(1), "/");
        aPos = std::stoi(parts[0]);
        bPos = std::stoi(parts[1]);
    }
    std::string dance(const std::string& programs) const override {
        std::string result = programs;
        char c = result[aPos];
        result[aPos] = result[bPos];
        result[bPos] = c;
        return result;
    }
};

class Partner : public DanceMove {
    char a;
    char b;
public:
    Partner(const std::string& input) {
        auto parts = split(input.substr(1), "/");
        a = parts[0][0];
        b = parts[1][0];
    }
    std::string dance(const std::string& programs) const override {
        std::string result = programs;
        int aPos = -1;
        int bPos = -1;
        for (int i = 0; i < programs.size(); i++) {
            if (programs[i] == a)
                aPos = i;
            if (programs[i] == b)
                bPos = i;
        }
        char c = result[aPos];
        result[aPos] = result[bPos];
        result[bPos] = c;
        return result;
    }
};

std::vector<std::unique_ptr<DanceMove>> readPosInput() {
    std::vector<std::unique_ptr<DanceMove>> danceMoves;
    auto lambda = [&](const std::string& line) {
        auto moves = split(line, ",");
        for (const auto& move : moves) {
            if (move[0] == 's')
                danceMoves.push_back(std::make_unique<Spin>(move));
            if (move[0] == 'x')
                danceMoves.push_back(std::make_unique<Exchange>(move));
        }
    };
    readInputFile(lambda);
    return danceMoves;
}

std::vector<std::unique_ptr<DanceMove>> readNameInput() {
    std::vector<std::unique_ptr<DanceMove>> danceMoves;
    auto lambda = [&](const std::string& line) {
        auto moves = split(line, ",");
        for (const auto& move : moves) {
            if (move[0] == 'p')
                danceMoves.push_back(std::make_unique<Partner>(move));
        }
    };
    readInputFile(lambda);
    return danceMoves;
}

std::string permutate(const std::string& permutation, const std::string& input) {
    std::string output = input;
    for (int i = 0; i < permutation.size(); i++) {
        int c = permutation[i] - 'a';
        output[i] = input[c];
    }
    return output;
}

int main() {
    auto dancePosMoves = readPosInput();
    auto danceNameMoves = readNameInput();
    std::string programs = "abcdefghijklmnop";
    std::string permutationPos = programs;
    std::string permutationName = programs;
    for (int i = 0; i < danceNameMoves.size(); i++) {    
        permutationName = danceNameMoves[i]->dance(permutationName);
    }
    for (int i = 0; i < dancePosMoves.size(); i++) {    
        permutationPos = dancePosMoves[i]->dance(permutationPos);
    }
    int rounds = 1000000000;
    std::string permutationNameFinal = programs;
    std::string permutationPosFinal = programs;
    for (int j = rounds; j > 0; j >>= 1) {
        if (j % 2 == 1) {
            permutationNameFinal = permutate(permutationName, permutationNameFinal);
            permutationPosFinal = permutate(permutationPos, permutationPosFinal);
        }
        permutationName = permutate(permutationName, permutationName);
        permutationPos = permutate(permutationPos, permutationPos);
    }
    std::cout << permutate(permutationPosFinal, permutationNameFinal) << std::endl;
    return 0;
}
