%{
#include <stdio.h>
extern FILE* yyin;
extern int currLine;
extern int currPos;
extern char* lineptr;
void yyerror(const char *msg);

%}

%start start
%token DIGIT INT INDEX THEN STRING EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE STRINGLITERAL INVALIDVAR VARIABLE

%%
start: /*epsilon*/ {printf("prog start\n");}
        | function void {printf("start -> function void\n");}

void: /*epsilon*/ {printf("void -> epsilon\n");}
	| function void {printf("void -> function void");}

function: FUNCTION functiondec statements END { printf("function -> FUNCTION functiondec statements END\n"); }

functiondec: VARIABLE LEFT_PREN declarationargs RIGHT_PREN { printf("functiondec -> VARIABLE LEFT_PREN declarationargs RIGHT_PREN\n"); }

functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN { printf("functiondec -> VARIABLE LEFT_PREN inputargs RIGHT_PREN\n"); }

elses: /*epsilon*/ {printf("elses -> epsilon\n");}
	| ELSE statements {printf("elses -> ELSE statements\n");}

statements: /*epsilon*/ {printf("statements -> epsilon\n");}
	| rule s2 {printf("statements -> rule s2\n");}

s2: /*epsilon*/ {printf("s2 -> epsilon\n");}
	| rule s2 {printf("s2 -> rule s2\n");}

rule: IF conditional statements elses END {printf("rule -> IF conditional statements elses END\n");}
        | WHILE conditional statements END { printf("rule -> WHILE conditional statements END\n"); }
	| statement {printf("rule -> statement\n");}

statement: INT VARIABLE  {printf("statement -> INT VARIABLE\n");}
	| VARIABLE EQUAL exp {printf("statement -> VARIABLE EQUAL exp\n");}
        | VARIABLE EQUAL STRINGLITERAL {printf("statement -> VARIABLE EQUAL STRINGLITERAL\n");}
	| INT VARIABLE EQUAL exp  {printf("statement -> INT VARIABLE EQUAL exp\n");}
	| WRITE DIGIT {printf("statement -> WRITE DIGIT\n");}
        | WRITE VARIABLE {printf("statement -> WRITE VARIABLE\n");}
	| WRITE STRINGLITERAL {printf("statement-> WRITE STRINGLITERAL\n");}
        | STRING VARIABLE EQUAL STRINGLITERAL {printf("statement -> STRING VARIABLE EQUAL STRINGLITERAL\n");}
        | RETURN retval {printf("statement -> RETURN retval\n");}
	| functioncall {printf("statement -> functioncall\n");}
        | functioncall addop functioncall {printf("statement -> functioncall addop functioncall\n");}
        | functioncall mulop functioncall {printf("statement -> functioncall mulop functioncall\n");}
	| VARIABLE EQUAL functioncall {printf("statement -> VARIABLE EQUAL functioncall\n");}
	| INT VARIABLE EQUAL functioncall {printf("statement -> INT VARIABLE EQUAL functioncall\n");}

conditional: exp condition exp  {printf("conditional -> exp condition exp\n");}
	| exp condition boolean {printf("conditional -> exp condition boolean\n");}
        | STRINGLITERAL condition STRINGLITERAL  {printf("conditional -> STRINGLITERAL condition STRINGLITERAL\n");}
	
boolean: TRUE {printf("boolean -> TRUE\n");}
	| FALSE {printf("boolean -> FALSE\n");}

condition: LESSEROREQUAL{ printf("condition -> LESSEROREQUAL\n"); }
        | GREATEROREQUAL{ printf("condition -> GREATEROREQUAL\n"); }
        | LESSTHAN      { printf("condition -> LESSTHAN\n"); }
        | GREATERTHAN   { printf("condition -> GREATERTHAN\n"); }
        | EQUIVALENT    { printf("condition -> EQUIVALENT\n"); }
        | NOTEQUIVALENT { printf("condition -> NOTEQUIVALENT\n"); }

retval: statement {printf("retval -> statement\n");}
	| exp  {printf("retval -> exp\n");}
	| conditional {printf("retval -> conditional\n");}
	| boolean {printf("retval -> boolean\n");}

type: /*epsilon*/ {printf("type -> epsilon\n");}
	| INT {printf("type -> INT\n");}
	| STRING {printf("type -> STRING\n");}

input: exp {printf("input -> exp\n");}

inputargs: /*epsilon*/ {printf("inputargs -> epsilon\n");}
	| input inputargs2 {printf("inputargs -> input inputargs2\n");}

inputargs2: /*epsilon*/ {printf("inputargs2 -> epsilon\n");}
	| COMMA input inputargs2 {printf("inputargs2 -> COMMA input inputargs2\n");}

declarationargs:  /*epsilon*/ {printf("declarationargs -> epsilon\n");}
	| type VARIABLE declarationargs2 {printf("declarationargs -> type VARIABLE declarationargs2\n");}

declarationargs2: /*epsilon*/ {printf("declarationargs2 -> epsilon\n");}
	| COMMA type VARIABLE declarationargs2 {printf("declarationargs2 -> COMMA type VARIABLE declarationargs2\n");}

exp: exp addop term {printf("exp -> exp addop term\n");}
        | term {printf("exp -> term\n");}

addop: ADD {printf("addop -> +\n");}
        | SUBTRACT {printf("addop -> -\n");}

term: term mulop factor {printf("term -> term mulop factor\n");}
        | factor {printf("term -> factor\n");}

mulop: MULTIPLY {printf("mulop -> *\n");}
        | DIVISION {printf("mulop -> /\n");}

factor: LEFT_PREN exp RIGHT_PREN {printf("factor -> (exp)\n");}
        | DIGIT  {printf("factor -> DIGIT\n");}	
	| VARIABLE {printf("factor -> VARIABLE\n");}
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
