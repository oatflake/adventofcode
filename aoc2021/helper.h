#pragma once

#include <iostream>
#include <fstream>
#include <vector>
#include <string.h> 
#include <functional>

std::vector<std::string> split(const std::string& word, const std::string& delimiter) {
    std::vector<std::string> substrings;
    std::size_t startIndex = 0;
    std::size_t endIndex = word.find(delimiter);
    while (endIndex < std::string::npos) {
        substrings.push_back(word.substr(startIndex, endIndex - startIndex));
        startIndex = endIndex + delimiter.size();
        endIndex = word.find(delimiter, startIndex);
    }
    substrings.push_back(word.substr(startIndex));
    return substrings;
}

bool readInputFile(std::function<void(const std::string&)> callback) {
    std::string line;
    std::ifstream inputFile ("input");
    if (inputFile.is_open()) {
        while (getline(inputFile,line)) {
            callback(line);
        }
        inputFile.close();
        return true;
    }
    else {
        std::cout << "Unable to open file";
        return false;
    }
}

template <class T, int n> struct Vector {
private:
	T coords[n];

public:
	Vector() {
		for (int i = 0; i < n; i++)
			coords[i] = 0;
	}

	Vector(const T coords[n]) {
		memcpy(this->coords, coords, n * sizeof(T));
	}
	
    T operator[](int i) const {
        return coords[i];
    }

    static Vector<T, n> abs(const Vector<T, n>& lhs);
};

template<typename T, int n> Vector<T, n> 
operator+(const Vector<T, n>& lhs, const Vector<T, n>& rhs) {
    T coords[n];
    for (int i = 0; i < n; i++) {
        coords[i] = lhs[i] + rhs[i];
    }
    return Vector<T, n>(coords);
}

template<typename T, int n> Vector<T, n> 
operator-(const Vector<T, n>& lhs, const Vector<T, n>& rhs) {
    T coords[n];
    for (int i = 0; i < n; i++) {
        coords[i] = lhs[i] - rhs[i];
    }
    return Vector<T, n>(coords);
}

template<typename T, int n> Vector<T, n> 
Vector<T, n>::abs(const Vector<T, n>& lhs) {
    T coords[n];
    for (int i = 0; i < n; i++) {
        coords[i] = std::abs(lhs[i]);
    }
    return Vector<T, n>(coords);
}

template<typename T, int n> 
Vector<T, n> operator*(int lhs, const Vector<T, n>& rhs) {
    T coords[n];
    for (int i = 0; i < n; i++) {
        coords[i] = lhs * rhs[i];
    }
    return Vector<T, n>(coords);
}

template<typename T, int n> 
Vector<T, n> operator*(const Vector<T, n>& lhs, int rhs) {
    return rhs * lhs;
}

template<typename T, int n> 
bool operator==(const Vector<T, n>& lhs, const Vector<T, n>& rhs) {
    bool same = true;
    for (int i = 0; i < n; i++) {
        same = same && lhs[i] == rhs[i];
    }
    return same;
}

// --- based on: https://stackoverflow.com/questions/19195183/how-to-properly-hash-the-custom-struct ---
namespace std {
template <class T>
inline void hash_combine(std::size_t& s, const T& v) {
  std::hash<T> h;
  s^= h(v) + 0x9e3779b9 + (s<< 6) + (s>> 2);
}

template<typename T, int n>
struct hash<Vector<T, n>> {
    std::size_t operator()(Vector<T, n> const& s) const {
        std::size_t res = 0;
        for (int i = 0; i < n; i++) {
            hash_combine(res, s[i]);
        }
        return res;
    }
};
}
// -----------------------------------------------------------------------------------------------------

typedef Vector<int, 2> Vec2i;
Vector<int, 2> vec2i(int x, int y) {
    int a[2];
    a[0] = x;
    a[1] = y;
    return Vector<int, 2>(a);
}
