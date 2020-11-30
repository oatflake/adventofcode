#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include "../helper.h"

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
    int id;
    std::string decryptedName;
    
    Room(const std::string& line) {
        std::vector<std::string> splitLine = split(line, "-");
        auto splitLine2 = split(splitLine[splitLine.size() - 1], "[");
        id = std::stoi(splitLine2[0]);
        for (int i = 0; i < splitLine.size() - 1; i++) {
            decryptedName += decrypt(splitLine[i], id) + " ";
        }
    }

    std::string decrypt(const std::string& word, int id) {
        std::string decrypted(word);
        for (int i = 0; i < word.size(); i++) {
            decrypted[i] = (char)(((word[i] - 'a' + id) % ('z' - 'a' + 1)) + 'a');
        }
        return decrypted;
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
    for (const Room& room : rooms) {
        if (room.decryptedName.find("north") != std::string::npos) {
            std::cout << room.decryptedName << room.id << std::endl;
        }
    }
    return 0;
}
