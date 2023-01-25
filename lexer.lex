%{

#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [a-zA-Z]
INTEGER int
STRING string
EQUAL \|eq
MULTIPLY \|mult
ADD \|add
SUBTRACT \|sub
DIVISION \|div
LESSEROREQUAL \|leq
GREATEROREQUAL \|geq
LESSTHAN \|lt
GREATERTHAN \|gt
EQUIVALENT \|equiv
WHILE while
DO do
IF if
ELSE else
FUNCTION function
LEFT_PREN \(
RIGHT_PREN \)
LEFT_BRACKET \[
RIGHT_BRACKET \]
LEFT_CURR_BRACKET \{
RIGHT_CURR_BRACKET \}
RETURN \|return
INDEX \|
END end
COMMA \,

%{
int num = 0;
int op = 0;
int paren = 0;
int equal = 0;
%}

%%
{DIGIT}+		{ num++; printf("NUMBER: %s\n", yytext); }
{INTEGER}		{ printf("INTEGER\n"); }
{INDEX}			{ printf("INDEX\n"); }
{STRING}		{ printf("STRING\n"); }
{EQUAL}			{ equal++; printf("EQUAL\n"); }
{MULTIPLY}		{ op++; printf("MULTIPLY\n"); }
{ADD}			{ op++; printf("ADD\n"); }
{SUBTRACT}		{ op++; printf("SUBTRACT\n"); }
{DIVISION}		{ op++; printf("DIVISION\n"); }
{LESSEROREQUAL}		{ printf("LESSEROREQUAL\n"); }
{GREATEROREQUAL}	{ printf("GREATEROREQUAL\n"); }
{LESSTHAN}		{ printf("LESSTHAN\n"); }
{GREATERTHAN} 		{ printf("GREATERTHAN\n"); }
{EQUIVALENT} 		{ printf("EQUIVALENT\n"); }
{WHILE} 		{ printf("WHILE\n"); }
{DO} 			{ printf("DO\n"); }
{IF} 			{ printf("IF\n"); }
{ELSE} 			{ printf("ELSE\n"); }
{FUNCTION} 		{ printf("FUNCTION\n"); }
{LEFT_PREN} 		{ paren++; printf("LEFT_PREN\n"); }
{RIGHT_PREN} 		{ paren++; printf("RIGHT_PREN\n"); }
{LEFT_BRACKET} 		{ printf("LEFT_BRACKET\n"); }
{RIGHT_BRACKET} 	{ printf("RIGHT_BRACKET\n"); }
{LEFT_CURR_BRACKET}	{ printf("LEFT_CURR_BRACKET"); }
{RIGHT_CURR_BRACKET}    { printf("RIGHT_CURR_BRACKET"); }
{RETURN}		{ printf("RETURN\n"); }
{END}			{ printf("END\n"); }
{COMMA}			{ printf("COMMA\n"); }

{ALPHA}+		{ printf("VARIABLE: %s\n", yytext); }
[[:space:]]+
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

