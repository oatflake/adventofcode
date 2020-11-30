#include <iostream>
#include <string>

void applyDragonCurve(std::string& word) {
    std::string copy = word;
    int length = copy.size();
    for (int i = 0; i < length / 2; i++) {
        int tmp = copy[length - i - 1];
        copy[length - i - 1] = copy[i];
        copy[i] = tmp;
    }
    for (int i = 0; i < length; i++) {
        int c = copy[i] - '0';
        copy[i] = 1 - c + '0';
    }
    word += '0' + copy;
}

int main() {
    std::string input = "01000100010010111";
    int length = 35651584;
    while (input.size() < length) {
        applyDragonCurve(input);
    }
    while (length % 2 != 1) {
        for (int i = 0; i < length; i += 2) {
            input[i / 2] = input[i] == input[i + 1] ? '1' : '0';
        }
        length /= 2;
    }
    std::cout << input.substr(0, length) << std::endl;
}
