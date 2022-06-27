all:
	bison -d parser.y
	flex lexic.l
	gcc parser.tab.c lex.yy.c -o parser -lm
	./parser < "code.cpp"
	g++ Engine.cpp -o game -lncurses
	rm user_code.cpp
	rm lex.yy.c
	rm parser.tab.c
	rm parser.tab.h
	rm parser
