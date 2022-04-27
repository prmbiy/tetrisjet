
%{
	#include <stdio.h>
	#include "parser.tab.h"
	#include <math.h>
	/* Token type.  */
%}
%option yylineno


%%
"import" {return HEADER;}
"onCollisionEnter"|"onLevelOrder"|"onCollisionExit" {return KEYWORDFUNC;}
"goUp"|"goDown"|"goLeft"|"goRight" {return MOVEMENT;}
"char" {return CHARTYPE;}
"int" {return INTTYPE;}
"float" {return FLOATTYPE;}
"bool" {return BOOLTYPE;}
"Block" {return BLOCKTYPE;}
"Grid" {return GRIDTYPE;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"continue" {return CONTINUE;}
"break" {return BREAK;}
"return" {return RETURN;}
"||" {return or_const;}
"&&" {return and_const;}
"=="|"!=" {return eq_const;}
"<="|">=" {return rel_const;}
"//"([\\]|[.]|[^\n])*[\n] {return comment;}
"," {return ERROR;}
"*"|"+"|"-"|"/"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" {return op_single;}
";"|"="|"{"|"}"|"("|")"|"["|"]"|"." {return yytext[0];}
[-]?[0-9]+	{return int_const;}
[-]?[0-9]+"."[0-9]+ {return float_const;}
"'"."'" {return char_const;}
[a-zA-Z_][a-zA-Z_0-9]* {return id;}
\"(\\.|[^\"])*\" {return string;}
[/][*]([^*]|[*]*[^*/])*[*]+[/] {return comment;}
[\n] {}
[ \t\n\r]+
%%

#ifdef STANDALONE_LEXER
int main(int argc, char** argv)
{
	if (argc > 1)
	{
		FILE *file;
		file = fopen(argv[1], "r");
		if (!file)
		{ printf("\n");
			fprintf(stderr, "Could not open %s\n", argv[1]);
			exit(1);
		}
		yyin = file;
	}


	while(yylex()){};
}
#endif
