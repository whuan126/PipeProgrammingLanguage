%{
#include <stdio.h>
extern FILE* yyin;
char* var_ident;
extern int yylineno;
extern int column;
extern char *lineptr;
char* var_ident;
%}

%start start
%token DIGIT INT INDEX NOTEQUAL STRING EQUAL TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE STRINGLITERAL INVALIDVAR VARIABLE

%%
start: /*epsilon*/ {printf("prog start\n");}
        | function {printf("start -> exp EQUAL\n");}

function: FUNCTION VARIABLE LEFT_PREN args RIGHT_PREN statements RETURN END {printf("function (with return)");}
	| FUNCTION VARIABLE LEFT_PREN args RIGHT_PREN statements END {printf("function (no return)\n");}

statements: IF conditional statements END
        | IF conditional statements ELSE statements END
        | WHILE conditional DO statements END
        | INT VARIABLE
        | VARIABLE EQUAL exp
        | VARIABLE EQUAL STRINGLITERAL
        | INT VARIABLE EQUAL exp 
        | INT VARIABLE EQUAL VARIABLE
        | STRING VARIABLE EQUAL STRINGLITERAL
        | RETURN VARIABLE
        | RETURN conditional
        | RETURN exp
        | RETURN TRUE // add this 
        | RETURN FALSE // add this

conditional: VARIABLE condition VARIABLE
        | STRINGLITERAL condition STRINGLITERAL
        | exp condition exp

condition: LESSEROREQUAL 
        | GREATEROREQUAL
        | LESSTHAN 
        | GREATERTHAN 
        | EQUIVALENT 
        | NOTEQUAL  //addthis later

//  IF args THEN statements ELSE statements END
// 	| IF args THEN statements END
//      | IF args statements END
// 	| WHILE args DO statements END
// 	| INT VARIABLE EQUAL exp
// 	| INT VARIABLE EQUAL VARIABLE
// 	| STRING VARIABLE EQUAL STRINGLITERAL

args: args COMMA VARIABLE {printf("args -> args var\n");}
	| VARIABLE {printf("args -> var\n");}

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

