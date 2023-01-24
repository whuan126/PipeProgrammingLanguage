%{

#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [a-zA-Z]
SUBTRACT [/\|sub]
DIVISION [/\|div]
LESSEROREQUAL [/\|leq]
GREATEROREQUAL [/\|geq]
LESSTHAN [/\|lt]
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
"int"		{ printf("INTEGER"); }
"string"	{ printf("STRING"); }
"|eq"		{ printf("EQUAL"); }
"|mult"		{ printf("MULTIPLY"); }
"|add"		{ printf("ADD"); }
{SUBTRACT}+	{printf("SUBTRACT: %s\n", yytext); }
{DIVISION}+	{printf("DIVISION: %s\n", yytext); }
{LESSEROREQUAL}+	{printf("LESSEROREQUAL: %s\n", yytext); }
{GREATEROREQUAL}+	{printf("GREATEROREQUAL: %s\n", yytext); }
{LESSTHAN}+	{printf("LESSTHAN: %s\n", yytext); }
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

