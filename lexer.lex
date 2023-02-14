
%{
#include "y.tab.h"
int currLine = 1, currPos = 1;


char* lineptr = NULL;
size_t n = 0;
size_t consumed = 0;
size_t available = 0;

size_t min(size_t a, size_t b) {
    return b < a ? b : a;
}

/// DEFINING MACRO TO KEEP TRACK OF LINES! 
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

DIGIT [0-9]
ALPHA [a-zA-Z]
INVALIDVARIABLE [0-9][a-zA-Z0-9_]*
VARIABLE [a-zA-Z][a-zA-Z0-9_]*
INT int
STRING string
EQUAL \|eq
NOTEQUAL \|neq
MULTIPLY \|mult
ADD \|add
NOTEQUIV \|noteq
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
THEN then
ELSE else
FUNCTION function
LEFT_PREN \(
RIGHT_PREN \)
LEFT_BRACKET \[
RIGHT_BRACKET \]
LEFT_CURR_BRACKET \{
RIGHT_CURR_BRACKET \}
RETURN return
INDEX \|
END end
COMMA \,
READ \|read
TRUE true
FALSE false
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
{DIGIT}+		{ currPos += yyleng; return DIGIT; }
\n              {currPos =1;}
{INT}		{ currPos += yyleng; return INT; }
{INDEX}			{ currPos += yyleng; return INDEX; }
{STRING}		{ currPos += yyleng; return STRING; }
{EQUAL}			{ currPos += yyleng; return EQUAL; }
{MULTIPLY}		{ currPos += yyleng; return MULTIPLY; }
{ADD}			{ currPos += yyleng; return ADD; }
{SUBTRACT}		{ currPos += yyleng; return SUBTRACT; }
{DIVISION}		{ currPos += yyleng; return DIVISION; }
{LESSEROREQUAL}		{ currPos += yyleng; return LESSEROREQUAL; }
{GREATEROREQUAL}	{ currPos += yyleng; return GREATEROREQUAL; }
{LESSTHAN}		{ currPos += yyleng; return LESSTHAN; }
{GREATERTHAN} 		{ currPos += yyleng; return GREATERTHAN; }
{EQUIVALENT} 		{ currPos += yyleng; return EQUIVALENT; }
{WHILE} 		{ currPos += yyleng; return WHILE; }
{DO} 			{ currPos += yyleng; return DO; }
{IF} 			{ currPos += yyleng; return IF; }
{THEN}			{ currPos += yyleng; return THEN; }
{ELSE} 			{ currPos += yyleng; return ELSE; }
{FUNCTION} 		{ currPos += yyleng; return FUNCTION; }
{LEFT_PREN} 		{ currPos += yyleng; return LEFT_PREN; }
{RIGHT_PREN} 		{ currPos += yyleng; return RIGHT_PREN; }
{LEFT_BRACKET} 		{ currPos += yyleng; return LEFT_BRACKET; }
{RIGHT_BRACKET} 	{ currPos += yyleng; return RIGHT_BRACKET; }
{LEFT_CURR_BRACKET}	{ currPos += yyleng; return LEFT_CURR_BRACKET; }
{RIGHT_CURR_BRACKET}    { currPos += yyleng; return RIGHT_CURR_BRACKET; }
{RETURN}		{ currPos += yyleng; return RETURN; }
{END}			{ currPos += yyleng; return END; }
{COMMA}			{ currPos += yyleng; return COMMA; }
{READ}			{ currPos += yyleng; return READ; }
{WRITE}			{ currPos += yyleng; return WRITE; }
{COMMENT}		{}
{STRINGLITERAL}		{ currPos += yyleng; return STRINGLITERAL; }	
{INVALIDVARIABLE}	{ currPos += yyleng; return INVALIDVAR; }
{VARIABLE}		{ currPos += yyleng; return VARIABLE; }
{NOTEQUIV}		{ currPos += yyleng; return NOTEQUIVALENT; }
[[:space:]]+
.        {printf("");}

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

