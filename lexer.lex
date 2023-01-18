%{

#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [a-zA-Z]

%{
int num = 0;
int op = 0;
int paren = 0;
int equal = 0;
%}

%%
{DIGIT}+	{ num++; printf("NUMBER: %s\n", yytext); }
"+"		{ op++; printf("PLUS\n"); }
"-"		{ op++; printf("MINUS\n"); }
"*"		{ op++; printf("MULT\n"); }
"/"		{ op++; printf("DIV\n"); }
"("		{ paren++; printf("L_PAREN\n"); }
")"		{ paren++; printf("R_PAREN\n"); }
"="		{ equal++; printf("EQUAL\n"); }
"int"		{ printf("INTEGER"); }
"string"	{ printf("STRING"); }
"|eq"		{ printf("EQUAL"); }
"|mult"		{ printf("MULTIPLY"); }
"|add"		{ printf("ADD"); }
.		{printf("ERROR: NO SYMBOLS OR LETTERS: %s\n", yytext); exit(1); }
%%

main (void) {
	printf("Ctrl+D to quit. \n");
	yylex();
	printf("Total Integers: %d\n", num);
	printf("Total Operators: %d\n", op);
	printf("Total Parenthesis: %d\n", paren);
	printf("Total equal signs: %d\n", equal);
	printf("Quiting...\n");
}

