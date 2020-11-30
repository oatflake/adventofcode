#include <iostream>
#include <string>
#include <vector>
#include "../helper.h"

std::string hash(std::string input) {
    std::vector<int> lengths;
    for (char c : input)
        lengths.push_back((int)c);
    std::vector<int> suffix = { 17, 31, 73, 47, 23 };
    for (int length : suffix)
        lengths.push_back(length);
    std::vector<int> ring;
    for (int i = 0; i < 256; i++) {
        ring.push_back(i);
    }
    int skipSize = 0;
    int currentPos = 0;
    for (int r = 0; r < 64; r++) {
        for (int length : lengths) {
            for (int i = 0; i < length / 2; i++) {
                int a = (currentPos + i) % 256;
                int b = (currentPos + length - 1 - i) % 256;
                int tmp = ring[b];
                ring[b] = ring[a];
                ring[a] = tmp;
            }
            currentPos += length + skipSize;
            skipSize++;
        }
    }
    std::vector<int> dense;
    int x = 0;
    for (int i = 0; i < ring.size(); ) {
        x ^= ring[i];
        i++;
        if (i % 16 == 0) {
            dense.push_back(x);
            x = 0;
        }
    }
    std::string output;
    for (int i = 0; i < dense.size(); i++) {
        int a = dense[i] / 16;
        int b = dense[i] % 16;
        output.push_back(a < 10 ? '0' + a : 'a' + (a - 10));
        output.push_back(b < 10 ? '0' + b : 'a' + (b - 10));
    }
    return output;
}

std::vector<bool> toBits(std::string hex) {
    std::vector<bool> bits;
    for (auto c : hex) {
        int n;
        if ('0' <= c && c <= '9')
            n = c - '0';
        else
            n = c - 'a' + 10;
        int s = 0;
        std::array<int, 4> stack;
        for (int i = 0; i < 4; i++) {
            stack[s++] = n % 2;
            n >>= 1;
        }
        for (int i = 3; i >= 0; i--) {
            bits.push_back(stack[i] == 1);
        }
    }
    return bits;
}

int main() {
    std::vector<bool> map;
    for (int i = 0; i < 128; i++) {
        auto bits = toBits(hash("xlqgujun-" + std::to_string(i)));
        for (bool b : bits)
            map.push_back(b);
    }
    int regions = 0;
    for (int i = 0; i < map.size(); i++) {
        if (!map[i])
            continue;
        regions++;
        std::vector<int> stack;
        stack.push_back(i);
        while (!stack.empty()) {
            int current = stack.back();
            stack.pop_back();
            if (!map[current])
                continue;
            map[current] = false;
            int x = current % 128;
            int y = current / 128;
            if (x > 0 && map[(x - 1) + 128 * y])
                stack.push_back((x - 1) + 128 * y);
            if (x < 127 && map[(x + 1) + 128 * y])
                stack.push_back((x + 1) + 128 * y);
            if (y > 0 && map[x + 128 * (y - 1)])
                stack.push_back(x + 128 * (y - 1));
            if (y < 127 && map[x + 128 * (y + 1)])
                stack.push_back(x + 128 * (y + 1));
        }
    }
    std::cout << regions << std::endl;
}
