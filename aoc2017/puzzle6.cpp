#include <cmath>
#include <array>
#include <tuple>
#include <vector>
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

int closestCornerID(const std::array<int, 4>& corners, int x) {
    for (int i = 2; i >= 0; i--) {
        if (x > corners[i])
            return i + 1;
    }
    return 0;
}

std::tuple<int, int> computeCoords(int v, int bottomRight, const std::array<int, 4>& corners, int cornerID) {
    int halfSide = sqrt(bottomRight) / 2;
    int mid = corners[cornerID] - halfSide;
    int y = v - mid;
    if (cornerID == 0) { // right side
        return std::make_tuple(halfSide, y);
    } else if (cornerID == 1) { // top side
        return std::make_tuple(-y, halfSide);
    } else if (cornerID == 2) { // left side
        return std::make_tuple(-halfSide, -y);
    } else {// if (closestID == 3) { // bottom side
        return std::make_tuple(y, -halfSide);
    }
}

int manhattenDistance(int x, int y) {
   return std::abs(x) + std::abs(y);
}

int coordToID(int x, int y) {
    int maxAbsCoord = std::max(std::abs(x), std::abs(y));
    int sideLength = maxAbsCoord * 2 + 1;
    int bottomRight = sideLength * sideLength;
    if (x == maxAbsCoord && y == -maxAbsCoord)
        return bottomRight;
    std::array<int, 4> corners = computeCorners(bottomRight);
    if (x > maxAbsCoord - 1)    // right side
        return corners[0] - (-y + maxAbsCoord);
    else if (y > maxAbsCoord - 1)    // top side
        return corners[1] - (x + maxAbsCoord);
    else if (x < -(maxAbsCoord - 1))    // left side
        return corners[2] - (y + maxAbsCoord);
    else //if (y < -(maxAbsCoord - 1))    // bottom side
        return corners[3] - (-x + maxAbsCoord);
}

int main() {
    std::vector<int> numbers;
    numbers.push_back(1);
    int input = 347991;
    int sum = 1;
    int i = 1;
    while (sum < input) {
        sum = 0;
        i++;
        int bottomRight = bottomRightCorner(i);
        std::array<int, 4> corners = computeCorners(bottomRight);
        int cornerID = closestCornerID(corners, i);
        int x;
        int y;
        std::tie(x, y) = computeCoords(i, bottomRight, corners, cornerID);
        for (int nx = -1; nx < 2; nx++) {
            for (int ny = -1; ny < 2; ny++) {
                if (nx == 0 && ny == 0)
                    continue;
                int nID = coordToID(x + nx, y + ny);
                if (nID > i)
                    continue;
                sum += numbers[nID - 1];
            }
        }
        numbers.push_back(sum);
        int dist = manhattenDistance(x, y);
    }
    std::cout << sum << std::endl;
    return 0;
}
