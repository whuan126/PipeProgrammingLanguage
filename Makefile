run:
	lex lexer.lex
	gcc -o lexer lex.yy.c -lfl
	./lexer test_input.txt

parser: 
	flex lexer.lex
	bison -v -d --file-prefix=y lexer.y
	g++ -o lexer y.tab.c lex.yy.c -lfl

bison.tab.c bison.tab.h:	lexer.y
	bison -t -v -d lexer.y

lex.yy.c: lexer.lex bison.tab.h
	flex lexer.lex 

practice: lex.yy.c lexer.tab.c lexer.tab.h
	g++ -o practice lexer.tab.c lex.yy.c -lfl
	./practice add.min
	
clean: 
	rm -f lex.yy.c y.tab.c y.tab.h y.output lexer.tab.c lexer.output lexer
