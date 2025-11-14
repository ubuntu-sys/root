%skeleton "yacc.c"
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyin;

/* -------- Helpers -------- */

char* sdup(char *s) {
    char *r = strdup(s);
    free(s);
    return r;
}

int isnum(const char *s) {
    for (int i = 0; s[i]; i++)
        if (!isdigit((unsigned char)s[i])) return 0;
    return 1;
}

int is_pow2(int n) {
    return n > 0 && (n & (n - 1)) == 0;
}

int lg2(int n) {
    int k = 0;
    while (n > 1) n >>= 1, k++;
    return k;
}

int yylex();
int yyerror(char *msg) { return 0; }

%}

%union { char *str; }

%token <str> NUMBER ID
%type  <str> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program:
      program stmt
    | /* empty */
    ;

stmt:
      ID '=' expr ';' {
            printf("%s = %s\n", $1, $3);
            free($1); free($3);
      }
    | expr ';' {
            printf("%s\n", $1);
            free($1);
      }
    ;

expr:
      expr '+' expr {
            if (isnum($1) && isnum($3)) {
                char buf[32];
                sprintf(buf, "%d", atoi($1) + atoi($3));
                $$ = strdup(buf);
            } else if (!strcmp($1,"0")) $$ = sdup($3);
            else if (!strcmp($3,"0"))  $$ = sdup($1);
            else {
                $$ = malloc(strlen($1)+strlen($3)+2);
                sprintf($$, "%s+%s", $1, $3);
            }
            free($1); free($3);
      }

    | expr '-' expr {
            if (isnum($1) && isnum($3)) {
                char buf[32];
                sprintf(buf, "%d", atoi($1) - atoi($3));
                $$ = strdup(buf);
            } else if (!strcmp($3,"0")) $$ = sdup($1);
            else {
                $$ = malloc(strlen($1)+strlen($3)+2);
                sprintf($$, "%s-%s", $1, $3);
            }
            free($1); free($3);
      }

    | expr '*' expr {
            if (isnum($1) && isnum($3)) {
                char buf[32];
                sprintf(buf, "%d", atoi($1) * atoi($3));
                $$ = strdup(buf);
            }
            else if (!strcmp($1,"1")) $$ = sdup($3);
            else if (!strcmp($3,"1")) $$ = sdup($1);
            else if (!strcmp($1,"0") || !strcmp($3,"0")) $$ = strdup("0");

            /* ⭐ POWER OF 2: multiply */
            else if (isnum($1) && is_pow2(atoi($1))) {
                int k = lg2(atoi($1));
                $$ = malloc(strlen($3) + 10);
                sprintf($$, "%s<<%d", $3, k);
            }
            else if (isnum($3) && is_pow2(atoi($3))) {
                int k = lg2(atoi($3));
                $$ = malloc(strlen($1) + 10);
                sprintf($$, "%s<<%d", $1, k);
            }

            else {
                $$ = malloc(strlen($1)+strlen($3)+2);
                sprintf($$, "%s*%s", $1, $3);
            }

            free($1); free($3);
      }

    | expr '/' expr {
            if (isnum($1) && isnum($3) && atoi($3)!=0) {
                char buf[32];
                sprintf(buf, "%d", atoi($1) / atoi($3));
                $$ = strdup(buf);
            }
            else if (!strcmp($3,"1")) $$ = sdup($1);

            /* ⭐ POWER OF 2: divide */
            else if (isnum($3) && is_pow2(atoi($3))) {
                int k = lg2(atoi($3));
                $$ = malloc(strlen($1) + 10);
                sprintf($$, "%s>>%d", $1, k);
            }

            else {
                $$ = malloc(strlen($1)+strlen($3)+2);
                sprintf($$, "%s/%s", $1, $3);
            }

            free($1); free($3);
      }

    | NUMBER { $$ = sdup($1); }
    | ID     { $$ = sdup($1); }

    | '-' expr %prec UMINUS {
            $$ = malloc(strlen($2)+2);
            sprintf($$, "-%s", $2);
            free($2);
      }

    | '(' expr ')' { $$ = $2; }
    ;

%%

int main() {
    yyin = fopen("tac.txt", "r");
    if (!yyin) { perror("three_addr.txt"); return 1; }
    printf("Optimized Code Output:\n");
    yyparse();
    return 0;
}
