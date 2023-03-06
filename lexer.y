//c code. 
%define api.pure
%{
#include <stdio.h>
#include<string>
#include<vector>
#include<string.h>

using namespace std;

extern FILE* yyin;
extern int currLine;
extern int currPos;
extern char* lineptr;
extern int yylex(void);
void yyerror(const char *msg);
char *identToken;
int numberToken;
int count_names = 0;

/////////////////////////////////////////////////////////


%}


%define parse.error verbose

//Start definition
%start start
//Tokens: 
%token DIGIT ALPHA INVALIDVARIABLE VARIABLE INT STRING EQUAL NOTEQUAL MULTIPLY ADD NOTEQUIV SUBTRACT DIVISION LESSEROREQUAL GREATEROREQUAL LESSTHAN GREATERTHAN EQUIVALENT WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN RIGHT_BRACKET LEFT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN INDEX END COMMA READ TRUE FALSE WRITE COMMENT STRINGLITERAL


// production rules. 
%%
//start -> functions
start: functions

//functions -> functions function | function
functions	: functions function
		  	| function {printf("functions -> function");}

function	: FUNCTION VARIABLE LEFT_PREN functionargs RIGHT_PREN statements END

functionargs: %empty {printf("functionargs -> empty");}
			| INT VARIABLE 


statements	: %empty {printf("statements -> empty");}
			| INT VARIABLE


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
	return 0;
}
void yyerror(const char *msg) {
    //fprintf(stderr, "%s\n", msg);
    printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
	exit(1);
}
