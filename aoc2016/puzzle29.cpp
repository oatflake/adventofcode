#include <iostream>
#include <vector>
#include <tuple>
#include "helper.h"

// --- taken from: https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm ---
#include <stdio.h>
#include <stdlib.h> // strtol() function

void xgcd(long *result, long a, long b){
    long aa[2]={1,0}, bb[2]={0,1}, q;
    while(1) {
        q = a / b; a = a % b;
        aa[0] = aa[0] - q*aa[1];  bb[0] = bb[0] - q*bb[1];
        if (a == 0) {
            result[0] = b; result[1] = aa[1]; result[2] = bb[1];
            return;
        };
        q = b / a; b = b % a;
        aa[1] = aa[1] - q*aa[0];  bb[1] = bb[1] - q*bb[0];
        if (b == 0) {
            result[0] = a; result[1] = aa[0]; result[2] = bb[0];
            return;
        };
    };
}
// -------------------------------------------------------------------------------------------------------------------

long chineseRemainderTheorem(std::vector<int> a, std::vector<int> n) {
    long N = 1;
    for (int ni : n) {
        N *= ni;
    }
    std::vector<int> Ni;
    for (int ni : n) {
        Ni.push_back(N / ni);
    }
    std::vector<int> Mi;
    long* result = new long[3];
    for (int i = 0; i < n.size(); i++) {
        xgcd(result, Ni[i], n[i]);
        Mi.push_back(result[1]);
    }
    long x = 0;
    for (int i = 0; i < n.size(); i++) {
        x += a[i] * Mi[i] * Ni[i] % N;
    }
    delete[] result;
    return ((x % N) + N) % N;
}

std::tuple<std::vector<int>, std::vector<int>> readInput() {
    std::vector<int> a;
    std::vector<int> n;
    int i = 1;
    auto lambda = [&](void* handler, const std::string& line){
        std::vector<std::string> parts = split(line, " ");
        int positions = std::stoi(parts[3]);
        int startPos = std::stoi(parts[11].substr(0, parts[11].size() - 1));
        a.push_back((positions - startPos - i) % positions);
        n.push_back(positions);
        i++;
    };
    readInputFile(nullptr, lambda);
    return std::make_tuple(a, n);
}

int main() {
    std::vector<int> a;
    std::vector<int> n;
    std::tie(a, n) = readInput();
    int time = chineseRemainderTheorem(a, n);
    std::cout << time << std::endl;
    return 0;
};
