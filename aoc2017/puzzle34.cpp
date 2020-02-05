#include <iostream>
#include <array>
#include <vector>

int main() {
    std::vector<int> numbers(50000001);
    numbers[0] = 0;
    int current = 0;
    for (int i = 1; i < 50000001; i++) {
        for (int j = 0; j < 335; j++) {
            current = numbers[current];
        }
        numbers[i] = numbers[current];
        numbers[current] = i;
        current = i;
    }
    std::cout << numbers[0] << std::endl;
    return 0;
}
