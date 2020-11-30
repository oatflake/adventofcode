#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cmath>
#include "../helper.h"

void printSqr(const std::string& square, const std::string& debug) {
    std::cout << debug << std::endl;
    int len = sqrt(square.size());
    for (int i = 0; i < square.size() / len; i++)
        std::cout << square.substr(i * len, len) << std::endl;
}

template<int n>
struct Pattern {
public:
    std::string input;
    std::string output;
    virtual bool applicable(std::string square) {
        //printSqr(square, "apply to");
        for (int flipped = 0; flipped < 2; flipped++) {
            for (int rotated = 0; rotated < 4; rotated++) {
                bool same = true;
                for (int i = 0; i < n; i++) {
                    same = same && input[i] == square[i];
                }
                if (same)
                    return true;
                square = rotate(square);
            }
            square = flip(square);
        }
        return false;
    }
    std::string permutate(const std::string& word, std::array<int, n> permutation) {
        std::string result = word;
        for (int i = 0; i < n; i++) {
            result[i] = word[permutation[i]];
        }
        return result;
    }
    virtual std::string rotate(const std::string& input) = 0;
    virtual std::string flip(const std::string& input) = 0;
};

struct Pattern2 : public Pattern<4> {
    Pattern2(std::string input, std::string output) {
        this->input = input;
        this->output = output;
    }
    std::string rotate(const std::string& input) override {
        return permutate(input, { 1,3,0,2 });
    };
    std::string flip(const std::string& input) override {
        return permutate(input, { 1,0,3,2 });
    };
};

struct Pattern3 : public Pattern<9> {
    Pattern3(std::string input, std::string output) {
        this->input = input;
        this->output = output;
    }
    std::string rotate(const std::string& input) override {
        return permutate(input, { 2,5,8,1,4,7,0,3,6 });
    };
    std::string flip(const std::string& input) override {
        return permutate(input, { 2,1,0,5,4,3,8,7,6 });
    };
};

struct Rulebook {
    std::vector<Pattern2> twoToThree;
    std::vector<Pattern3> threeToFour;

    std::string extractSquare(const std::string& input, int x, int y, int length) {
        int wordLen = sqrt(input.size());
        std::string partialWord;
        for (int j = 0; j < length; j++) {
            for (int i = 0; i < length; i++)
                partialWord.push_back(input[(x + i) + (y + j) * wordLen]);
        }
        return partialWord;
    }

    void insertSquare(const std::string& partialWord, int x, int y, int oldLength, int newLength, std::string& output) {
        int wordLength = sqrt(output.size());
        for (int j = 0; j < newLength; j++) {
            for (int i = 0; i < newLength; i++) {
                int outIndex = (x / oldLength * newLength + i) + (y / oldLength * newLength + j) * wordLength;
                output[outIndex] = partialWord[i + j * newLength];
            }
        }
    }

    std::string apply2(const std::string& input, int x, int y) {
        std::string partialWord = extractSquare(input, x, y, 2);
        for (auto rule : twoToThree) {
            if (rule.applicable(partialWord))
                return rule.output;
        }
        return "";
    }

    std::string apply3(const std::string& input, int x, int y) {
        std::string partialWord = extractSquare(input, x, y, 3);
        for (auto rule : threeToFour) {
            if (rule.applicable(partialWord))
                return rule.output;
        }
        return "";
    }
};

Rulebook readInput() {
    Rulebook rulebook;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, " => ");
        for (int i = 0; i < parts.size(); i++)
            parts[i].erase(std::remove(parts[i].begin(), parts[i].end(), '/'), parts[i].end());
        if (parts[0].size() == 4)
            rulebook.twoToThree.push_back(Pattern2(parts[0], parts[1]));
        else
            rulebook.threeToFour.push_back(Pattern3(parts[0], parts[1]));
    };
    readInputFile(lambda);
    return rulebook;
}

int main() {
    std::string word = ".#...####";
    Rulebook rulebook = readInput();
    std::string newWord;
    for (int i = 0; i < 18; i++) {
        int len = sqrt(word.size());
        //printSqr(word, "word");
        if (len % 2 == 0) {
            newWord = std::string(word.size() / 4 * 9, ' ');
            for (int y = 0; y < len; y += 2) {
                for (int x = 0; x < len; x += 2) {
                    std::string output = rulebook.apply2(word, x, y);
                    rulebook.insertSquare(output, x, y, 2, 3, newWord);
                }
            }
        } else if (len % 3 == 0) {
            newWord = std::string(word.size() / 9 * 16, ' ');
            for (int y = 0; y < len; y += 3) {
                for (int x = 0; x < len; x += 3) {
                    std::string output = rulebook.apply3(word, x, y);
                    rulebook.insertSquare(output, x, y, 3, 4, newWord);
                }
            }
        }
        //printSqr(newWord, "new word");
        word = newWord;
    }
    int count = 0;
    for (int i = 0; i < word.size(); i++)
        count += word[i] == '#' ? 1 : 0;
    std::cout << count << std::endl;
    return 0;
}


