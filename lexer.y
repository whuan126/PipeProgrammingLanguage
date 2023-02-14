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
        | function void {printf("start -> function\n");}

void: /*epsilon*/
	| function void

function: FUNCTION functiondec statements END

functiondec: VARIABLE LEFT_PREN declarationargs RIGHT_PREN

functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN

elses: /*epsilon*/
	| ELSE statements END

statements: /*epsilon*/
	| rule s2

s2: /*epsilon*/
	| rule s2

rule: IF conditional statements elses END
        | WHILE conditional DO statements END
	| statement

statement: INT VARIABLE
        | VARIABLE EQUAL exp
        | VARIABLE EQUAL STRINGLITERAL
   
	| INT VARIABLE EQUAL exp {printf("A");}
        
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

condition: LESSEROREQUAL 
        | GREATEROREQUAL
        | LESSTHAN 
        | GREATERTHAN 
        | EQUIVALENT 
        | NOTEQUIVALENT 

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

exp: exp addop term {printf("prog_start -> exp addop term\n");}
        | term {printf("prog_start -> term\n");}

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
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            printf("syntax: %s filename", argv[0]);
        }
    }
    yyparse(); // more magical stuff
    return 0;
}

void yyerror(const char *msg) {
    //fprintf(stderr, "%s\n", msg);
    fprintf(stderr,"error: %s in line %d, column %d\n", msg, currLine, currPos);
    fprintf(stderr, "%s\n", lineptr);
    int i;   
    for(i = 0; i < currPos - 1; i++)
        fprintf(stderr,"_");
    fprintf(stderr,"^\n");


}	
