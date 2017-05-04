#include <iostream>
#include <string.h>
#include <cstdio>
#include<iomanip>
using namespace std;

int main(int argc, char* argv[]) {
    char c;
    int i = 0;
    cout << ".word 0x";
    while ((c=getchar())!=EOF) {
        if (i != 0 && i % 4 == 0) {
            cout << "\n.word 0x";
        }
        cout << setfill('0') << setw(2) << hex << (int)c;
        i++;
    }
    cout << "\n";
}
