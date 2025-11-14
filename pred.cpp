#include <bits/stdc++.h>
using namespace std;

unordered_set<char> NT, T;
unordered_map<char, set<string>> G;
unordered_map<char, set<char>> Fi, Fo;
map<pair<char, char>, string> Table;
char init;

bool isT(char c) { return islower(c) || !isalpha(c); }

void display() {
    cout << "FIRST: " << endl;
    for (auto &[A, s] : Fi) {
        cout << A << " : ";
        for (char c : s) {
            cout << c << ",";
        }
        cout << endl;
    }
    cout << endl;
    cout << "FOLLOW: " << endl;
    for (auto &[A, s] : Fo) {
        cout << A << " : ";
        for (char c : s) {
            cout << c << ",";
        }
        cout << endl;
    }
    cout << endl;
    cout << "Parse Table: " << endl;
    T.insert('$');
    for (char nt : NT) {
        for (char t : T) {
            cout << "     ";
            if (Table.count({nt, t})) cout << nt << "->" << Table[{nt, t}];
            else cout << "ERROR";
            cout << "     ";
        }
        cout << endl;
    }
    cout << endl;
    T.erase('$');
}

unordered_set<char> firstOf(string s) {
    unordered_set<char> res;
    if (s == "#") {res.insert('#'); return res;}
    for (char c : s) {
        if (c == '#') continue;
        if (isT(c)) {res.insert(c); return res;}
        auto fset = Fi[c];
        for (char t : fset) if (t != '#') res.insert(t);
        if (!fset.count('#')) return res;
    }
    res.insert('#');
    return res;
}

void FIRST() {
    int changed = 1;
    while (changed) {
        changed = 0;
        for (auto &[A, prods] : G) {
            for (auto &p : prods) {
                auto fset = firstOf(p);
                int sz = Fi[A].size();
                Fi[A].insert(fset.begin(), fset.end());
                if (sz != Fi[A].size()) changed = 1;
            }
        }
    }
}

void FOLLOW() {
    Fo[init].insert('$');
    int changed = 1;
    while (changed) {
        changed = 0;
        for (auto &[A, prods] : G) {
            for (auto &p : prods) {
                for (int i = 0; i < p.length(); i++) {
                    if (p[i]!='#' && !isT(p[i])) {
                        string beta = p.substr(i+1);
                        auto fset = firstOf(beta);
                        int sz = Fo[p[i]].size();
                        for (char t : fset) if (t != '#') Fo[p[i]].insert(t);
                        if (beta.empty() || fset.count('#')) {
                            Fo[p[i]].insert(Fo[A].begin(), Fo[A].end());
                        }
                        if (sz != Fo[p[i]].size()) changed = 1;
                    }
                }
            }
        }
    }
}

void makeTable() {
    for (auto &[A, prods] : G) {
        for (auto &p : prods) {
            auto fset = firstOf(p);
            for (char t : fset) {
                if (t != '#') Table[{A, t}] = p;
            }
            if (fset.count('#')) {
                for (char t : Fo[A]) Table[{A, t}] = p;
            }
        }
        if (Fi[A].count('#') &&  Fo[A].count('$')) Table[{A, '$'}] = '#';
    }
}

void format(stack<char> S, string ip, int i, string mes) {
    while (!S.empty()) {cout << S.top(); S.pop();}
    cout << "          ";
    cout << ip.substr(i);
    cout << "          ";
    cout << mes << endl;
}

void parser(string ip) {
    stack<char> S;
    ip += '$';
    S.push('$');
    S.push(init);
    int i = 0;
    format(S, ip, i, "INITIAL");
    string mes = "ERROR";
    while (!S.empty()) {
        char tops = S.top(), cur = ip[i];
        if (tops == '$') break;
        if (isT(tops)) {
            if (cur == tops) {S.pop(); i++; mes="MATCHED";}
            else break;
        }
        else {
            if (Table.count({tops, ip[i]})) {
                S.pop();
                string p = Table[{tops, ip[i]}];
                for (int i = p.length()-1; i >= 0 ; i--) {
                    if (p[i] != '#') S.push(p[i]);
                }
                mes = string(1, tops) + "->" + p;
            }
            else break;
        }
        format(S, ip, i, mes);
    }
    if (S.size()==1 && S.top() == '$' && ip[i]=='$') cout << "Accepted." << endl;
    else cout << "Rejected." << endl;
}

int main() {
    int n; cin >> n;
    for (int i = 0; i < n; i++) {
        string nt, x;
        string line; cin >> line;
        stringstream ss(line);
        getline(ss, nt, '=');
        getline(ss, x);
        G[nt[0]].insert(x);
        NT.insert(nt[0]);
        for (char c : x) if (c != '#') {if (isT(c)) T.insert(c); else NT.insert(c);}
        if (i == 0) init = nt[0];
    }
    FIRST();
    FOLLOW();
    makeTable();
    display();
    string p; cin >> p;
    parser(p);
    return 0;
}