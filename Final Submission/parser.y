%debug
%expect 27
%{
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <error.h>
#include <errno.h>


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

%union{
  char *str;
}

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
          | id '.' id '=' int_const ';'
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
