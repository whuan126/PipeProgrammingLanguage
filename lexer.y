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
int argCount = 0;
/////////////////////////////////////////////////////////

enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};

struct Node{
	std::string name;
	std::string code;
};

struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

std::string returnTempName(){
	static int count = 0;
	std::string varName("_temp");
	char strCount[2];
	sprintf(strCount, "%d", count);
	varName += std::string(strCount);
	count++;
	return varName;
}

std::string returnArg(){
	std::string argName("$");
	char strCount[2];
	sprintf(strCount, "%d", argCount);
	argName += std::string(strCount);
	argCount++;
	return argName;
}

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
%start start
%union {
 char *op_val;
 struct Node *node;
}

%define parse.error verbose

%token INDEX NUMBER INT DIGIT STRING THEN EQUAL STRINGLITERAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE INVALIDVAR VARIABLE 
%type <op_val> VARIABLE
%type <op_val>  FUNCTION
%type <op_val> STRING
%type <op_val> INT
%type <node> exp functions statement statements term factor var function declarationargs conditional declarationargs2 type
%type <op_val> ELSE IF COMMA mulop addop

%%

start: functions 
			{
				Node *node = $1;
				printf("%s\n", node->code.c_str());
			}

functions: function
	{
		Node *node = $1;
		Node *tempNode = new Node;
		tempNode = node;
		$$ = tempNode;

	}
	| functions function 
	{
		Node* node1 = $1;
		Node * node2 = $2;
		Node * node = new Node;
		node -> code = "";
		node -> code = node1 -> code + node2 -> code;
		
		$$ = node;
	}

function: FUNCTION VARIABLE LEFT_PREN declarationargs RIGHT_PREN statements END 
	{
		Node *node = new Node;
		std::string functionName = $2;
		Node *statements = $6;
		node->code = "";
		node->code += std::string("func ") + functionName + std::string("\n");
		node->code += $4->code;
		node->code += statements->code;
		node->code+= std::string("endfunc\n\n");
		
	}



functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN 
{
	
}

statements: %empty /*epsilon*/
	{
	Node *node = new Node;
	node->code = std::string("");
	$$ = node;
	}
	| statement statements
	{
		Node *statement = $1;
		Node *statements = $2;

		Node *node = new Node;
		node->code = statement->code + std::string("\n") + statements ->code;
		$$ = node;
	}

statement: INT var /* declarations + assignments */ 
	{
		Node *node = new Node;
		node-> name = $2->code;
		node-> code = std::string(". ") + $2->code + std::string("\n");
		node -> code += std::string("= ") + $2->code + std::string(", ") + returnArg() + std::string("\n");
		$$ = node;
	}  
	| INT var EQUAL exp  
	{
		Node *node = new Node;
		std::string ident = $1;
		Node *expression = $4;
		node-> code = $4->code;
		node-> code += std::string("= ") + ident + std::string(", ") + expression -> name;
		$$ = node;
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
	{
		Node *node = new Node;
		std::string variable = $1;
		node->code = variable;
		$$ = node;
	}
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

type: INT 
	| STRING 

input: exp 

inputargs: %empty /*epsilon*/ 
	| input inputargs2 

inputargs2: /*epsilon*/ 
	| COMMA input inputargs2 


exp: exp addop term {
	Node *node = new Node;
	std::string tempVar = returnTempName();
	node->name = tempVar;
	node->code = $1->code + $3->code + std::string(". ") + tempVar + std::string("\n");
	node->code+= std::string($2) + std::string(" ") + tempVar + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
}
	| term

addop: ADD {
		char op[] = "+";
		$$ = op;
	}
    | SUBTRACT  {
		char op[] = "-";
		$$ = op;
	}

term: term mulop factor 
    | factor 

mulop: MULTIPLY {
	char op[] = "*";
	$$ = op;
}
    | DIVISION
	{
		char op[] = "/";
		$$ = op;
	} 

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
