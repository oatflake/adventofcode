#include <iostream>
#include <list>

int main() {
    int input = 3001330;
    
    std::list<int> elves;
    for (int i = 1; i <= input; i++) {
        elves.push_back(i);
    }

    int i = 0;
    while (elves.size() > 1) {
        for (auto it = elves.begin(); it != elves.end(); i++) {
            if (i % 2 == 1) {
                it = elves.erase(it);
            } else {
                ++it;
            }
        }
    }
    std::cout << elves.front() << std::endl;

    return 0;
}
