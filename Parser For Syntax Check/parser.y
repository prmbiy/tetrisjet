%debug
%{
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <error.h>
#include <errno.h>

#include "y.tab.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(char *s)
{
fprintf(stderr,"%s\n",s);
return;
}

int yywrap()
{
    return 1;
}

%}

%token IF ELSE WHILE CONTINUE BREAK RETURN HEADER
%token KEYWORDFUNC MOVEMENT BLOCKTYPE GRIDTYPE INTTYPE FLOATTYPE BOOLTYPE CHARTYPE
%token float_const int_const char_const id op_single rel_const or_const and_const eq_const
%token string comment space ERROR

%%

FILE      : FUNC FILE
          | comment FILE
          |
          ;
FUNC      : KEYWORDFUNC '(' ')' '{' STM_LIST '}'
          ;

STM_LIST  : STM STM_LIST
          |
          ;

STM       : IF '(' EXPR ')' STM ELSE STM
          | IF '(' EXPR ')' STM
          | WHILE '(' EXPR ')' STM
          | DEC
          | ASN
          | CONTINUE ';'
          | BREAK ';'
          | RETURN ';'
          | MOVEMENT '(' id ')' ';'
          | id '.' id '(' string ')' ';'
          | comment
          | '{' STM_LIST '}'
          | ';'
          ;

DEC       : INTTYPE id '=' EXPR ';'
          | FLOATTYPE id '=' EXPR ';'
          | BOOLTYPE id '=' EXPR ';'
          | CHARTYPE id '=' char_const ';'
          | INTTYPE id';'
          | FLOATTYPE id';'
          | BOOLTYPE id';'
          | CHARTYPE id';'
          ;

ASN       : id '=' EXPR ';'
          | id '=' char_const ';'
          ;

EXPR      : EXPR or_const EXPR
          | EXPR and_const EXPR
          | EXPR eq_const EXPR
          | EXPR rel_const EXPR
          | EXPR op_single EXPR
          | TERM
          ;

TERM      : float_const
          | int_const
          | char_const
          | id
          | id '.' id '(' ')' ';'
          | '(' EXPR ')'
          ;


%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}
