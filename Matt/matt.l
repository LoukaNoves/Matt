%{
#include "matt.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"print"     { return PRINT; }
"library"   { return LIBRARY; }
"import"    { return IMPORT; }
[0-9]+      { yylval.intval = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.strval = strdup(yytext); return IDENTIFIER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return SLASH; }
"="         { return ASSIGN; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }
","         { return COMMA; }
[ \t\n]+    { /* ignore whitespace */ }
.           { yyerror("Unexpected character"); }
%%

int yywrap(void) {
    return 1;
}