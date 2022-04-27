
%{
	#include <stdio.h>
	#include "parser.tab.h"
	#include <math.h>
	/* Token type.  */
%}


%%
"import" { printf("HEADER\n"); return HEADER;}
"onCollisionEnter"|"onLevelOrder"|"onCollisionExit" { printf("KEYWORDFUNC\n"); return KEYWORDFUNC;}
"goUp"|"goDown"|"goLeft"|"goRight" { printf("MOVEMENT\n"); return MOVEMENT;}
"char" { printf("CHARTYPE\n"); return CHARTYPE;}
"int" { printf("INTTYPE\n"); return INTTYPE;}
"float" { printf("FLOATTYPE\n"); return FLOATTYPE;}
"bool" { printf("BOOLTYPE\n"); return BOOLTYPE;}
"Block" { printf("BLOCKTYPE\n"); return BLOCKTYPE;}
"Grid" { printf("GRIDTYPE\n"); return GRIDTYPE;}
"if" { printf("IF\n"); return IF;}
"else" { printf("ELSE\n"); return ELSE;}
"while" { printf("WHILE\n"); return WHILE;}
"continue" { printf("CONTINUE\n"); return CONTINUE;}
"break" { printf("BREAK\n"); return BREAK;}
"return" { printf("RETURN\n"); return RETURN;}
"||" { printf("or_const\n"); return or_const;}
"&&" { printf("and_const\n"); return and_const;}
"=="|"!=" { printf("eq_const\n"); return eq_const;}
"<="|">=" { printf("rel_const\n"); return rel_const;}
"//"([\\]|[.]|[^\n])*[\n] { printf("comment\n"); return comment;}
"," {return ERROR;}
"*"|"+"|"-"|"/"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" { printf("%c\n",yytext[0] ); return op_single;}
";"|"="|"{"|"}"|"("|")"|"["|"]" { printf("%c\n",yytext[0] ); return yytext[0];}
[-]?[0-9]+	{printf("int_const\n"); return int_const;}
[-]?[0-9]+"."[0-9]+ { printf("float_const\n"); return float_const;}
"'"."'" { printf("char_const\n"); return char_const;}
[a-zA-Z_][a-zA-Z_0-9]* { printf("id\n"); return id;}
\"(\\.|[^\"])*\" { printf("string\n"); return string;}
[/][*]([^*]|[*]*[^*/])*[*]+[/] { printf("comment\n"); return comment;}
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
