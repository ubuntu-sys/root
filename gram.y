%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char *s);
%}

%token a b NL

%%
input:
| input line
;
line: S NL {printf("Accepted\n");}
| error NL {printf("Rejected\n"); yyerrok;}

S: a b X
;
X: b b a a X b a
| b b a
;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    return 1;
}
