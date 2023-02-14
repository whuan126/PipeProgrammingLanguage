%{
#include <stdio.h>
extern FILE* yyin;
char* var_ident;
extern int yylineno;
extern int column;
extern char *lineptr;



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
        | DIGIT {printf("factor -> number: %s\n",var_ident);}	
	| VARIABLE

%%

int yyerror(const char *str){
        fprintf(stderr, "error: %s in line %d, column %d\n", str, yylineno, column);
        fprintf(stderr, "%s", lineptr);
        int i = 0;
        for(i=0; i < column - 1; i++){
                fprintf(stderr, "-");
        }
        fprintf(stderr, "^\n");
}


void main (int argc, char** argv){
        if (argc >= 2){
                yyin = fopen(argv[1],"n");
                if (yyin == NULL)
                        yyin = stdin;
        }else{
                yyin = stdin;
        }
        yyparse();
}

