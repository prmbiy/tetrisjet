%debug
%expect 27
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
          | MOVEMENT '(' ')' ';'
          | id '.' id '=' int_const ';'
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

  // declaring file pointers
  FILE *fp1, *fp2;

  // opening files
  fp1 = fopen("Template.cpp", "a+");
  fp2 = fopen("user_code.cpp", "w");

  char buf[2];

  // writing the contents of
  // template file to destination file.
  while (!feof(fp1)) {
      fgets(buf, sizeof(buf), fp1);
      fprintf(fp2, "%s", buf);
  }

  fp1 = fopen("code.cpp", "r");

  // code file to destination file.
  while (!feof(fp1)) {
      fgets(buf, sizeof(buf), fp1);
      fprintf(fp2, "%s", buf);
  }

	return 0;
}
