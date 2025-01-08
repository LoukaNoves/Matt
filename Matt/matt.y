%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int intval;
    char *strval;
}

%token <intval> NUMBER
%token <strval> IDENTIFIER
%token IF ELSE PRINT PLUS MINUS STAR SLASH ASSIGN LPAREN RPAREN LBRACKET RBRACKET COMMA
%token LIBRARY IMPORT

%type <intval> assignment_statement print_statement expression matrix_expression row_list row

%%

program:
    library_definitions statements
;

library_definitions:
    /* empty */
    | library_definitions library_definition
;

library_definition:
    LIBRARY IDENTIFIER '{' statements '}'
    {
        printf("Defining library %s\n", $2);
        // Ajouter le code pour stocker la bibliothèque
    }
;

statements:
    statement
    | statements statement
;

statement:
    expression_statement
    | assignment_statement
    | if_statement
    | print_statement
    | import_statement
;

expression_statement:
    expression
    ;

assignment_statement:
    IDENTIFIER '=' expression { printf("Assigning %s = %d\n", $1, $3); }
;

if_statement:
    IF expression block ELSE block
    {
        printf("IF statement with conditional\n");
    }
;

print_statement:
    PRINT expression { printf("Print %d\n", $2); }
;

import_statement:
    IMPORT IDENTIFIER
    {
        printf("Importing library %s\n", $2);
        // Ajouter le code pour importer la bibliothèque
    }
;

block:
    '{' statements '}'
;

expression:
    expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression STAR expression { $$ = $1 * $3; }
    | expression SLASH expression { if ($3 == 0) yyerror("Division by zero"); else $$ = $1 / $3; }
    | NUMBER { $$ = $1; }
    | IDENTIFIER { $$ = 0; /* lookup variable value */ }
    | LPAREN expression RPAREN { $$ = $2; }
    | matrix_expression
    ;

matrix_expression:
    LBRACKET row_list RBRACKET
    {
        printf("Matrix expression\n");
    }
;

row_list:
    row
    | row_list COMMA row
    ;

row:
    expression
    | row expression
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    return yyparse();
}