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

/////////////////////////////////////////////////////////

enum Type { Integer, Array };
struct Node {
  std::string code;
  std::string name;
};
struct Symbol {
	std::string name;
	Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

Function *get_function() {
  int last = symbol_table.size()-1;
  return &symbol_table[last];
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

%}

%union {
 char *op_val;
 Node *node;
}

%define parse.error verbose
%start start
%token INT STRING
%token INDEX DIGIT THEN EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE INVALIDVAR VARIABLE NUMBER STRINGLITERAL
%type <op_val> FUNCTION VARIABLE var NUMBER
%type <node> exp functions function term factor
%%
start: /*epsilon*/ {}
        | functions {
			Node * node = $1;
			printf("%s\n", node->code.c_str());
		}

functions: function {
	Node * codenode = $1;
	Node *node = new Node;
	node = codenode;
	$$ = node;
}
	| function functions {
		Node * codeNode1 = $1;
		Node * codeNode2 = $2;
		Node * node = new Node;
		node->code = "";
		node->code = codeNode1->code + codeNode2->code;
		$$ = node;
	}

function: FUNCTION VARIABLE LEFT_PREN declarationargs RIGHT_PREN statements END {

	
	}

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

statement: INT var /* declarations + assignments */ 
	{	// add vars to symbol table (declaration)
		//std::string value = "0";//$1; placeholder value since empty declaration
		//Type t = Integer;
		//add_variable_to_symbol_table(value,t);
		char * var  = $2;
		printf(".%s", var);
		
	}  
	| INT var EQUAL exp  
	{
		std::string variable = $2;
		Node * exp = $4;
		
	}
	| STRING var EQUAL STRINGLITERAL
	| INT var EQUAL functioncall
	| INT var EQUAL array
	| STRING var EQUAL array

	| WRITE DIGIT {} /* io */
	| WRITE VARIABLE 
	| WRITE STRINGLITERAL 
	
	| RETURN retval  /* function calls */
	| functioncall 
	| functioncall addop functioncall 
	| functioncall mulop functioncall 

	| var EQUAL functioncall /* assignments */
	| var EQUAL exp
	| var EQUAL STRINGLITERAL     

array: LEFT_CURR_BRACKET arrayargs1 RIGHT_CURR_BRACKET

arrayargs1: arrayarg arrayargs

arrayargs: /*epsilon*/ 
	| COMMA arrayarg arrayargs
	
arrayarg: var
	| STRINGLITERAL
	| DIGIT

var: VARIABLE
	| VARIABLE arrayindex

arrayindex: INDEX DIGIT

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
	| type VARIABLE declarationargs2 

declarationargs2: /*epsilon*/ 
	| COMMA type VARIABLE declarationargs2 

exp: exp addop term 
	| term

addop: ADD
        | SUBTRACT 

term: term mulop factor 
        | factor 

mulop: MULTIPLY 
        | DIVISION 

factor: LEFT_PREN exp RIGHT_PREN 
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
	print_symbol_table();
	return 0;
}
void yyerror(const char *msg) {
    //fprintf(stderr, "%s\n", msg);
    printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
	exit(1);
}
