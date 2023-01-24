%{

#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [a-zA-Z]
GREATERTHAN [/\|gt]
EQUIVALENT [/\|equiv]
WHILE [while]
DO [do]
IF [if]
ELSE [else]
FUNCTION [function]
LEFT_PREN [(]
RIGHT_PREN [)]
LEFT_BRACKET [[]
RIGHT_BRACKET []]

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
"="		{ equal++; printf("EQUAL\n"); }
{GREATERTHAN}+ 	{printf("GREATERTHAN: %s\n", yytext); }
{EQUIVALENT}+ 	{printf("EQUIVALENT: %s\n", yytext); }
{WHILE}+ 	{printf("WHILE: %s\n", yytext); }
{DO}+ 	{printf("DO: %s\n", yytext); }
{IF}+ 	{printf("IF: %s\n", yytext); }
{ELSE}+ {printf("ELSE: %s\n", yytext); }
{FUNCTION}+ {printf("FUNCTION: %s\n", yytext); }
{LEFT_PREN}+ {printf("LEFT_PREN: %s\n", yytext); }
{RIGHT_PREN}+ {printf("RIGHT_PREN: %s\n", yytext); }
{LEFT_BRACKET}+ {printf("LEFT_BRACKET: %s\n", yytext); }
{RIGHT_BRACKET}+ {printf("RIGHT_BRACKET: %s\n", yytext); }

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

