%{
#include "ast.tab.h"
#include <string.h>
%}

%%
[0-9]+ { yylval.sval = strdup(yytext); return NUMBER; }

"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }

"\n" { return NL; }

.  ;
[ \t]+ ;
%%

int yywrap() {
    return 1;
}
