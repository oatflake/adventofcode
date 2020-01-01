#include <iostream>
#include <list>

int main() {
    int input = 3001330;
    
    std::list<int> elves;
    for (int i = 1; i <= input; i++) {
        elves.push_back(i);
    }

    auto iter = elves.begin();
    auto iterAcross = elves.begin();
    for (int i = 0; i < elves.size() / 2; i++) {
        ++iterAcross;
    }

    int leftDist = elves.size() / 2;
    int rightDist = elves.size() / 2 + elves.size() % 2;
    while (elves.size() > 1) {
        if (iterAcross == elves.end())
            iterAcross = elves.begin();
        if (iter == elves.end())
            iter = elves.begin();
        if (leftDist < rightDist - 1) {
            ++iterAcross;
            if (iterAcross == elves.end())
                iterAcross = elves.begin();
            rightDist--;
            leftDist++;
        }
        iterAcross = elves.erase(iterAcross);
        ++iter;
        leftDist--;
    }
    std::cout << elves.front() << std::endl;

    return 0;
}
