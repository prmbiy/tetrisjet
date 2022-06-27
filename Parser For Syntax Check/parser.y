%debug
%{
//including necessary libraries 
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <error.h>
#include <errno.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int yylineno;

//Function to handle errors
void yyerror(char *s)
{
fprintf(stderr,"%s Line Number:%d\n",s, yylineno);
return;
}

int yywrap()
{
    return 1;
}

%}

//Declaring the tokens used in the grammar
%token IF ELSE WHILE CONTINUE BREAK RETURN HEADER
%token KEYWORDFUNC MOVEMENT BLOCKTYPE GRIDTYPE INTTYPE FLOATTYPE BOOLTYPE CHARTYPE
%token float_const int_const char_const id op_single rel_const or_const and_const eq_const
%token string comment space ERROR

%%
//Files
FILE      : FUNC FILE
          | comment FILE
          |
          ;

//Functions
FUNC      : KEYWORDFUNC '(' ')' '{' STM_LIST '}' 
          ;

//Statement List
STM_LIST  : STM STM_LIST
          |
          ;

//Statement
STM       : IF '(' EXPR ')' STM ELSE STM 
          | IF '(' EXPR ')' STM
          | WHILE '(' EXPR ')'
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

//Declaration
DEC       : INTTYPE id '=' EXPR ';'
          | FLOATTYPE id '=' EXPR ';'
          | BOOLTYPE id '=' EXPR ';'
          | CHARTYPE id '=' char_const ';'
          | INTTYPE id';'
          | FLOATTYPE id';'
          | BOOLTYPE id';'
          | CHARTYPE id';'
          ;

//Assignment
ASN       : id '=' EXPR ';'
          | id '=' char_const ';'
          ;

//Expression
EXPR      : EXPR or_const EXPR 
          | EXPR and_const EXPR
          | EXPR eq_const EXPR
          | EXPR rel_const EXPR
          | EXPR op_single EXPR
          | TERM
          ;

//Term
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
