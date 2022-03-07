killandcreate:
	rm -f ./lex.yy.c
	rm -f ./a.out
	flex ./lexic.l
	gcc ./lex.yy.c -o output
	# ./output < input.txt

everything:
	flex ./lexic.l
	gcc ./lex.yy.c -o output
	./output

transpile:
	flex ./lexic.l
	
compile:
	gcc ./lex.yy.c -o output
	
run:
	./output

clear:
	rm -f ./lex.yy.c
	rm -f ./a.out