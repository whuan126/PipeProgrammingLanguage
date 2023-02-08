%{
#include <stdio.h>
extern FILE* yyin;
char* var_ident;
%}

%start start
%token DIGIT INT INDEX STRING EQUAL MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE STRINGLITERAL INVALIDVAR VARIABLE

%%
start: /*epsilon*/ {printf("prog start\n");}
        | exp EQUAL {printf("start -> exp EQUAL\n");}

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
int yyerror(){}
