%{
#include <stdio.h>
#include <string>
#include <vector>

extern FILE* yyin;
extern int currLine;
extern int currPos;
extern char* lineptr;
void yyerror(const char *msg);
extern int yylex(void);

%}

%start start
%token DIGIT INT INDEX THEN STRING EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE STRINGLITERAL INVALIDVAR VARIABLE

%%
start: /*epsilon*/ {printf("prog start\n");}
        | function void {printf("start -> function\n");}

void: /*epsilon*/
	| function void

function: FUNCTION functiondec statements END { printf("function -> FUNCTION functiondec statements END\n"); }

functiondec: VARIABLE LEFT_PREN declarationargs RIGHT_PREN { printf("functiondec -> VARIABLE LEFT_PREN declarationargs RIGHT_PREN\n"); }

functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN { printf("functiondec -> VARIABLE LEFT_PREN inputargs RIGHT_PREN\n"); }

elses: /*epsilon*/
	| ELSE statements

statements: /*epsilon*/
	| rule s2

s2: /*epsilon*/
	| rule s2

rule: IF conditional statements elses END
        | WHILE conditional statements END { printf("rule -> WHILE conditional DO statements END\n"); }
	| statement

statement: INT VARIABLE
		| VARIABLE EQUAL exp
        | VARIABLE EQUAL STRINGLITERAL
   
	| INT VARIABLE EQUAL exp {printf("A");}
		| WRITE DIGIT
        | WRITE VARIABLE
		| WRITE STRINGLITERAL
        | STRING VARIABLE EQUAL STRINGLITERAL
        | RETURN retval
	| functioncall
        | functioncall addop functioncall
        | functioncall mulop functioncall
	| VARIABLE EQUAL functioncall
	| INT VARIABLE EQUAL functioncall {printf("D");}

conditional: exp condition exp
	| exp condition boolean
        | STRINGLITERAL condition STRINGLITERAL
	
boolean: TRUE
	| FALSE

condition: LESSEROREQUAL{ printf("condition -> LESSEROREQUAL\n"); }
        | GREATEROREQUAL{ printf("condition -> GREATEROREQUAL\n"); }
        | LESSTHAN      { printf("condition -> LESSTHAN\n"); }
        | GREATERTHAN   { printf("condition -> GREATERTHAN\n"); }
        | EQUIVALENT    { printf("condition -> EQUIVALENT\n"); }
        | NOTEQUIVALENT { printf("condition -> NOTEQUIVALENT\n"); }

retval: statement
	| exp 
	| conditional
	| boolean

type: /*epsilon*/
	| INT
	| STRING

input: exp

inputargs: /*epsilon*/
	| input inputargs2

inputargs2: /*epsilon*/
	| COMMA input inputargs2

declarationargs:  /*epsilon*/
	| type VARIABLE declarationargs2 {printf("args -> args var\n");}

declarationargs2: /*epsilon*/
	| COMMA type VARIABLE declarationargs2

exp: exp addop term {printf("exp -> exp addop term\n");}
        | term {printf("exp -> term\n");}

addop: ADD {printf("addop -> +\n");}
        | SUBTRACT {printf("addop -> -\n");}

term: term mulop factor {printf("term -> term mulop factor\n");}
        | factor {printf("term -> factor\n");}

mulop: MULTIPLY {printf("mulop -> *\n");}
        | DIVISION {printf("mulop -> /\n");}

factor: LEFT_PREN exp RIGHT_PREN {printf("factor -> (exp)\n");}
        | DIGIT 	
		| VARIABLE
%%

int main(int argc, char ** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}
	yyparse();
	return 1;
}
void yyerror(const char *msg) {
    //fprintf(stderr, "%s\n", msg);
    printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
}
