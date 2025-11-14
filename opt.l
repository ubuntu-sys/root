%{
#include "opt.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
[0-9]+ { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"="|";"|"("|")"|"+"|"-"|"*"|"/" { return yytext[0]; }
. ;
[ \t\r\n]+ ;
%%

int yywrap() { return 1; }
