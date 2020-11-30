#include <iostream>
#include <array>

int main() {
    std::array<int, 2018> numbers;
    numbers[0] = 0;
    int current = 0;
    for (int i = 1; i < 2018; i++) {
        for (int j = 0; j < 335; j++) {
            current = numbers[current];
        }
        numbers[i] = numbers[current];
        numbers[current] = i;
        current = i;
    }
    std::cout << numbers[2017] << std::endl;
    return 0;
}
