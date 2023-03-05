%{
#include <stdio.h>
#include<string>
#include<vector>
#include<string.h>

extern FILE* yyin;
extern int currLine;
extern int currPos;
extern char* lineptr;

extern int yylex(void);
void yyerror(const char *msg);

char *identToken;
int numberToken;
int count_names = 0;

std::string returnName() {
	static int count = 0;
	std::string varName("_temp");
	char stringCounter[2];
	sprintf(stringCounter,"%d",count);
	varName += std::string(stringCounter);
	count++;
	return varName;
}

struct Node {
  std::string code;
  std:: string name;
};
%}

////////////////////////////////////////////////////////

%union {
 char *op_val;
 struct Node *node;
}

%define parse.error verbose
%start start
%token VARIABLE DIGIT INT INDEX THEN STRING EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE INVALIDVAR

%token <op_val> STRINGLITERAL
%type <op_val> VARIABLE
%type <node> exp
%type <node> statement
%type <node> statements
%type <node> function
%type <node> functions
%type <op_val> addop
%type <node> factor
%type <node> term
%type <node> elses
%type <node> s2
%type <node> rule
%type <node> declarationargs
%type <node> conditional


%%
start: /*epsilon*/ 
        | functions  
		{
			Node *node = $1;
			printf("%s\n", node->code.c_str());
		}

functions: function {
	Node * node = $1;
	Node *tnode = new Node;
	tnode = node;
	$$ = tnode;
	}
	| function functions {
		Node * node = $1;
		Node * node2 = $2;
		Node * _node = new Node;
		_node -> code = "";
		_node -> code = node->code + node2->code;
		$$ = _node;
	};

function: FUNCTION VARIABLE LEFT_PREN declarationargs RIGHT_PREN statements END {
	Node *node = new Node;
	Node *statements = $6;
	std::string func_name = $2;
	node-> code = "";
	node -> code += std::string("func ") + func_name + std::string("\n");

	node -> code += $4 -> code;
	node -> code += statements -> code;
	node -> code += std::string("endfunc\n");
};

/*
functiondec: VARIABLE LEFT_PREN declarationargs RIGHT_PREN 
{
// midrule!!!!!
// add function to symbol table
std::string func_name = $1;
add_function_to_symbol_table(func_name);
printf("func %s\n", $1);
}
*/

functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN 

elses: /*epsilon*/ 
	| ELSE statements 

statements: /*epsilon*/ 
	| rule s2 

s2: /*epsilon*/ 
	| rule s2 

rule: IF conditional statements elses END 
        | WHILE conditional statements END 
	| statement 

statement:   INT VARIABLE
	{// add vars to symbol table (declaration)
		//std::string value = "0";//$1; placeholder value since empty declaration
		//Type t = Integer;
		//add_variable_to_symbol_table(value,t);
		char * var  = $2;
		printf(".%s", var);
		
	}  
	| VARIABLE EQUAL exp 
		{
		}

	| VARIABLE EQUAL STRINGLITERAL

	| INT VARIABLE EQUAL exp  
		{
		}
	| WRITE DIGIT 
	{
		
	}
	
	| WRITE VARIABLE 
	
	| WRITE STRINGLITERAL 
	
	| STRING VARIABLE EQUAL STRINGLITERAL 
	
	| RETURN retval 
	
	| functioncall 
	
	| functioncall addop functioncall 
	
	| functioncall mulop functioncall 
	
	| VARIABLE EQUAL functioncall 
	
	| INT VARIABLE EQUAL functioncall 

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

declarationargs: arg
	| arg COMMA declarationargs
	| /*epsilon*/

arg: INT VARIABLE| {
	Node *node = new Node;
	node -> name = $2;
	node -> code = std::string(". ") + $2 + std::string("\n");
	node -> code += std::string("= ") $2 + std::string(", ") + returnArgument() + std::string(":\n");
	$$ = node;
}
	exp {
		$$ = $1;
	}

exp: exp addop term 
	{
		Node *node = new Node;
		std::string temp = returnName();
		node->name = temp;
		node->code = $1->code + $3->code + std::string(". ") + temp + std::string("\n");
		node->code += std::string($2) + std::string(" ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
		$$ = node;
	}
    | term  {
		Node *node = $1;
		$$ = node;
	}

	addop: ADD {
		$$ = "+";
		}

    | SUBTRACT {
		$$ = "-";
	}

term: term mulop factor 
        | factor 

mulop: MULTIPLY 
        | DIVISION 

factor: LEFT_PREN exp RIGHT_PREN 
        | DIGIT  	
	| VARIABLE 
	| function_call 
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
	exit(1);
}
