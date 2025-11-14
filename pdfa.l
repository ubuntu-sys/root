%{
#include <stdio.h>

/* Flex keeps this variable internally, but we can access it */
extern int yy_current_state;
%}

%option noyywrap
%option yylineno    /* Enables line number tracking */

%%

[A-Za-z]+   {
                printf("[Line %d] Identifier: %s   DFA State: %d\n",
                       yylineno, yytext, yy_current_state);
            }

[0-9]+      {
                printf("[Line %d] Number: %s      DFA State: %d\n",
                       yylineno, yytext, yy_current_state);
            }

\n          {
                /* Still print state to see newlines */
                printf("[Line %d] Newline            DFA State: %d\n",
                       yylineno, yy_current_state);
            }

.           {
                printf("[Line %d] Other char: %c      DFA State: %d\n",
                       yylineno, yytext[0], yy_current_state);
            }

%%

int main() {
    yylex();
    return 0;
}
