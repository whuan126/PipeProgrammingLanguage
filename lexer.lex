%option yylineno

%{

#include <stdio.h>
#include "y.tab.h"
extern char * var_ident;

static int next_column = 1;
int column = 1;

#define HANDLE_COLUMN column = next_column; next_column += strlen(yytext)

char *lineptr = NULL;
size_t n = 0;
size_t consumed = 0;
size_t available = 0;

size_t min(size_t a, size_t b);
#define YY_INPUT(buf,result,max_size) {\
    if(available <= 0) {\
        consumed = 0;\
        available = getline(&lineptr, &n, yyin);\
        if (available < 0) {\
            if (ferror(yyin)) { perror("read error:"); }\
                available = 0;\
            }\
    }\
    result = min(available, max_size);\
    strncpy(buf, lineptr + consumed, result);\
    consumed += result;\
    available -= result;\
}

%}

%option noyywrap noinput nounput yylineno




DIGIT [0-9]
ALPHA [a-zA-Z]
INVALIDVARIABLE [0-9][a-zA-Z0-9_]*
VARIABLE [a-zA-Z][a-zA-Z0-9_]*
INT int
STRING string
EQUAL \|eq
MULTIPLY \|mult
ADD \|add
NOTEQUAL \|neq
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
READ \|read
TRUE True
FALSE False
WRITE \|write
COMMENT \/\/.*$
STRINGLITERAL  \"(\\.|[^"\\])*\"

%{
int num = 0;
int op = 0;
int paren = 0;
int equal = 0;
int line = 0;
%}

%%
{DIGIT}+		{ HANDLE_COLUMN; var_ident = yytext; return DIGIT; }
{INT}		{ HANDLE_COLUMN; return INT; }
{INDEX}			{ HANDLE_COLUMN; return INDEX; }
{STRING}		{ HANDLE_COLUMN; return STRING; }
{EQUAL}			{ HANDLE_COLUMN; return EQUAL; }
{MULTIPLY}		{ HANDLE_COLUMN; return MULTIPLY; }
{ADD}			{ HANDLE_COLUMN; return ADD; }
{SUBTRACT}		{ HANDLE_COLUMN; return SUBTRACT; }
{DIVISION}		{ HANDLE_COLUMN; return DIVISION; }
{LESSEROREQUAL}		{ HANDLE_COLUMN; return LESSEROREQUAL; }
{GREATEROREQUAL}	{ HANDLE_COLUMN; return GREATEROREQUAL; }
{LESSTHAN}		{ HANDLE_COLUMN; return LESSTHAN; }
{GREATERTHAN} 		{ HANDLE_COLUMN; return GREATERTHAN; }
{EQUIVALENT} 		{ HANDLE_COLUMN; return EQUIVALENT; }
{WHILE} 		{ HANDLE_COLUMN; return WHILE; }
{DO} 			{ HANDLE_COLUMN; return DO; }
{IF} 			{ HANDLE_COLUMN; return IF; }
{ELSE} 			{ HANDLE_COLUMN; return ELSE; }
{FUNCTION} 		{ HANDLE_COLUMN; return FUNCTION; }
{LEFT_PREN} 		{ HANDLE_COLUMN; return LEFT_PREN; }
{RIGHT_PREN} 		{ HANDLE_COLUMN; return RIGHT_PREN; }
{LEFT_BRACKET} 		{ HANDLE_COLUMN; return LEFT_BRACKET; }
{RIGHT_BRACKET} 	{ HANDLE_COLUMN; return RIGHT_BRACKET; }
{LEFT_CURR_BRACKET}	{ HANDLE_COLUMN; return LEFT_CURR_BRACKET; }
{RIGHT_CURR_BRACKET}    { HANDLE_COLUMN; return RIGHT_CURR_BRACKET; }
{RETURN}		{ HANDLE_COLUMN; return RETURN; }
{END}			{ HANDLE_COLUMN; return END; }
{COMMA}			{ HANDLE_COLUMN; return COMMA; }
{READ}			{ HANDLE_COLUMN; return READ; }
{WRITE}			{ HANDLE_COLUMN; return WRITE; }
{COMMENT}		{}
{STRINGLITERAL}		{ HANDLE_COLUMN; var_ident = yytext; return STRINGLITERAL; }	
{INVALIDVARIABLE}	{ HANDLE_COLUMN; return INVALIDVAR; }
{VARIABLE}		{ HANDLE_COLUMN; var_ident = yytext; return VARIABLE; }
[[:space:]]+
			
.		{printf("ERROR: NO SYMBOLS OR LETTERS: %s - LINE: %d\n", yytext,yylineno); exit(1); }
%%

// main (void) {
// 	printf("Ctrl+D to quit. \n");
// 	yylex();
// 	printf("Total Integers: %d\n", num);
// 	printf("Total Operators: %d\n", op);
// 	printf("Total Parenthesis: %d\n", paren);
// 	printf("Total equal signs: %d\n", equal);
// 	printf("Quiting...\n");
// }

