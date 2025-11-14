%{
#include <stdio.h>
#include <string.h>

int yywrap();
int yylex();
int yyerror(char*);
%}


%union {
    char *sval;
}

%token ADD SUB MUL DIV NL
%token <sval> NUMBER
%left ADD SUB
%left MUL DIV
%type <sval> expr


%%
input: input line
|
;

line: expr NL {printf("Postfix = %s\n", $1); free($1);}
;

expr: NUMBER {$$ = strdup($1);}
| expr ADD expr {
    int len = strlen($1) + 4 + strlen($3);
    char *s = malloc(len);
    sprintf(s, "%s %s +", $1, $3);
    $$ = s;
}
| expr SUB expr {
    int len = strlen($1) + 4 + strlen($3);
    char *s = malloc(len);
    sprintf(s, "%s %s -", $1, $3);
    $$ = s;
}
| expr MUL expr {
    int len = strlen($1) + 4 + strlen($3);
    char *s = malloc(len);
    sprintf(s, "%s %s *", $1, $3);
    $$ = s;
}
| expr DIV expr {
    int len = strlen($1) + 4 + strlen($3);
    char *s = malloc(len);
    sprintf(s, "%s %s /", $1, $3);
    $$ = s;
}
%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char * msg) {
    return 1;
}