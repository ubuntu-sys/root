%{
#include "calc.tab.h"
%}

%%
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"\n" {return NL;}
[\t ]+ ;
. ;
%%

int yywrap() {
    return 1;
}
