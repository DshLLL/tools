//
// Created by Hao Sun on 2017-05-04.
//

#include <iostream>
#include <sstream>
#include <string.h>
#include <bitset>

using namespace std;

int main(int argc, char* argv[]) {
    string str;
    while (getline(cin, str)) {
        stringstream ss;
        str = str.substr(6, str.length());
        ss << hex << str;
        unsigned num;
        ss >> num;
        bitset<32> b(num);
        string bstr = b.to_string();
        for (unsigned i = 0; i < bstr.length(); i = i + 4) {
            cout << bstr.substr(i, 4) << ' ';
        }
        cout << endl;
        ss.str(string());
    }
}
