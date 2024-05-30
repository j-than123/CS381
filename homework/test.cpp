#include <iostream>

int y = 7;
int z;
 
int f(int x) {
    x = x+1;
    y = x;
    x = x+1;
    y = x;
    return y;
}
int g(int x) {
    y = f(x)+1;
    x = f(y)+3;

    y = x;
    return x;
}

int main() {
    z = g(y);
    std::cout << "z: " << z << std::endl;
    std::cout << "y: " << y << std::endl;
}