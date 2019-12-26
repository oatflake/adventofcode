#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include "helper.h"

struct LetterOccurence {
    char letter;
    int occurence;
    LetterOccurence(char letter, int occurence) : letter(letter), occurence(occurence) { }
};

bool compareLetters (LetterOccurence a, LetterOccurence b) {
    if (a.occurence != b.occurence)
        return a.occurence > b.occurence;
    return a.letter < b.letter;
}

struct Room {
    std::string name;
    int id;
    std::string checksum;
    bool real;
    
    Room(std::string line) {
        std::vector<std::string> splitLine = split(line, "-");
        for (int i = 0; i < splitLine.size() - 1; i++) {
            name += splitLine[i];
        }
        splitLine = split(splitLine[splitLine.size() - 1], "[");
        id = std::stoi(splitLine[0]);
        checksum = splitLine[1].substr(0, splitLine[1].size() - 1);
        real = isReal();
    }

    bool isReal() {
        std::vector<LetterOccurence> letterOccurences;
        for (char letter = 'a'; letter <= 'z'; letter++) {
            letterOccurences.push_back(LetterOccurence(letter, 0));
        }
        for (char c : name) {
            int index = c - 'a';
            letterOccurences[index].occurence += 1;
        }
        std::sort(letterOccurences.begin(), letterOccurences.end(), compareLetters);
        for (int i = 0; i < checksum.size(); i++) {
            if (letterOccurences[i].letter != checksum[i])
                return false;
        }
        return true;
    }
};

std::vector<Room> readInput() {
    std::vector<Room> result;
    auto lambda = [&](void* handler, std::string line) {
        Room room(line);
        result.push_back(room);
    };
    readInputFile(nullptr, lambda);
    return result;
}

int main () { 
    std::vector<Room> rooms = readInput();
    int idSum = 0;
    for (const Room& room : rooms) {
        if (room.real) {
            idSum += room.id;
        }
    }
    std::cout << idSum << std::endl;
    return 0;
}
