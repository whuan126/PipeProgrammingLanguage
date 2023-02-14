parser: 
	flex lexer.lex
	bison -v -d --file-prefix=y lexer.y
	gcc -o lexer y.tab.c lex.yy.c -lfl
	
clean: 
	rm -f lex.yy.c y.tab.c y.output
