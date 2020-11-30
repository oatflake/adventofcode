#include <iostream>
#include <string>
#include <memory>
#include "../helper.h"

const int SCREEN_WIDTH = 50;
const int SCREEN_HEIGHT = 6;

class Operation {
public:
    virtual void process(const std::vector<bool>& readBuffer, std::vector<bool>& writeBuffer) = 0;
};

class Rect : public Operation {
    int width;
    int height;
public:
    Rect(int width, int height) : width(width), height(height) { }
    void process(const std::vector<bool>& readBuffer, std::vector<bool>& writeBuffer) override {
        writeBuffer = readBuffer;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                writeBuffer[x + y * SCREEN_WIDTH] = true;
            }
        }
    }
};

class RotateRow : public Operation {
    int row;
    int offset;
public:
    RotateRow(int row, int offset) : row(row), offset(offset) { }
    void process(const std::vector<bool>& readBuffer, std::vector<bool>& writeBuffer) override {
        writeBuffer = readBuffer;
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            int dstX = (x + offset) % SCREEN_WIDTH;
            writeBuffer[dstX + row * SCREEN_WIDTH] = readBuffer[x + row * SCREEN_WIDTH];
        }
    }
};

class RotateColumn : public Operation {
    int column;
    int offset;
public:
    RotateColumn(int column, int offset) : column(column), offset(offset) { }
    void process(const std::vector<bool>& readBuffer, std::vector<bool>& writeBuffer) override {
        writeBuffer = readBuffer;
        for (int y = 0; y < SCREEN_HEIGHT; y++) {
            int dstY = (y + offset) % SCREEN_HEIGHT;
            writeBuffer[column + dstY * SCREEN_WIDTH] = readBuffer[column + y * SCREEN_WIDTH];
        }
    }
};

std::vector<std::unique_ptr<Operation>> readInput() {
    std::vector<std::unique_ptr<Operation>> operations;
    auto lambda = [&](void* handler, std::string line) {
        auto parts = split(line, " ");
        if (parts[0] == "rect") {
            auto coords = split(parts[1], "x");
            int x = std::stoi(coords[0]);
            int y = std::stoi(coords[1]);
            operations.push_back(std::make_unique<Rect>(x, y));
        } else if (parts[1] == "row") {
            auto y = std::stoi(split(parts[2], "=")[1]);
            auto offset = std::stoi(parts[4]);
            operations.push_back(std::make_unique<RotateRow>(y, offset));
        } else if (parts[1] == "column") {
            auto x = std::stoi(split(parts[2], "=")[1]);
            auto offset = std::stoi(parts[4]);
            operations.push_back(std::make_unique<RotateColumn>(x, offset));
        }
    };
    readInputFile(nullptr, lambda);
    return operations;
}

int main() {
    auto operations = readInput();
    std::vector<bool> read(SCREEN_WIDTH * SCREEN_HEIGHT, false);
    std::vector<bool> write(SCREEN_WIDTH * SCREEN_HEIGHT, false);
    for (const auto& operation : operations) {
        operation->process(read, write);
        read.swap(write);
    }
    int litPixels = 0;
    for (bool lit : read) {
        if (lit)
            litPixels++;
    }
    std::cout << litPixels << std::endl;
    return 0;
}
