bison -d parser.y
flex lexic.l
gcc parser.tab.c lex.yy.c -o syntax_check -lm
