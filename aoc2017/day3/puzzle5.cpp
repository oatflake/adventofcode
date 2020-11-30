#include <cmath>
#include <array>
#include <iostream>

int bottomRightCorner(int x) {
    int root = ceil(sqrt(x));
    if (root % 2 == 0)
        root += 1;
    return root * root;
}

std::array<int, 4> computeCorners(int bottomRight) {
    int sideLength = sqrt(bottomRight);
    std::array<int, 4> corners;
    corners[3] = bottomRight;
    for (int i = 2; i >= 0; i--)
        corners[i] = corners[i + 1] - (sideLength - 1);
    return corners;
}

int closestCorner(std::array<int, 4> corners, int x) {
    for (int i = 2; i >= 0; i--) {
        if (x > corners[i])
            return corners[i + 1];
    }
    return corners[0];
}

int manhattenDistance(int x, int bottomRight, int closest) {
    int halfSide = sqrt(bottomRight) / 2;
    int mid = closest - halfSide;
    int y = abs(x - mid);
    return halfSide + y;
}

int main() {
    int input = 347991;
    int bottomRight = bottomRightCorner(input);
    std::array<int, 4> corners = computeCorners(bottomRight);
    int closest = closestCorner(corners, input);
    int dist = manhattenDistance(input, bottomRight, closest);
    std::cout << dist << std::endl;
    return 0;
}
