%{
#include "gram.tab.h"
%}

%%
a {return a;}
b {return b;}
"\n" {return NL;}
. ;
[ \t]+ ;
%%

int yywrap() {
    return 1;
}