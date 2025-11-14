%{
#include <stdio.h>
#include <string.h>

int yylex();
int yywrap();
int yyerror(char*);
%}

%token NUMBER ADD SUB MUL DIV NL
%left ADD SUB 
%left MUL DIV

%%
input: input line
|
;

line: expr NL {printf("Result = %d\n", $1);}
;

expr: expr ADD expr {$$ = $1 + $3;}
| expr SUB expr {$$ = $1 - $3;}
| expr MUL expr {$$ = $1 * $3;}
| expr DIV expr {$$ = $1 / $3;}
| NUMBER {$$ = $1;}
;
%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *msg) {
    return 1;
}