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

std::string returnArgument(){
    std::string argName("$");
    char strCount[2];
    sprintf(strCount,"%d",argCount);
    argName += std::string(strCount);
    argCount++;
    return argName;
}

std::string returnTempVarName(){
    static int count = 0;
    std::string varName("_temp");
    char strCount[2];
    sprintf(strCount,"%d",count);
    varName += std::string(strCount);
    count++;
    return varName;
}


enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

struct Node {
	std::string code;
	std::string name;
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
 struct Node *node;
}

%define parse.error verbose
%start start

%left LEFT_PREN R_PREN
%left LESSTHAN GREATERTHAN LESSEROREQUAL GREATEROREQUAL EQUIVALENT NOTEQUIVALENT
%left ADD SUBTRACT
%left MULTIPLY DIVISON

%token INDEX INT STRING THEN EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE INVALIDVAR VARIABLE DIGIT NUMBER STRINGLITERAL
%type <op_val> FUNCTION addop mulop VARIABLE INT
%type <node> declarationarg exp declaration assignment inputoutput functions function term factor declarationargs statements statement
%%
start: %empty/*epsilon*/ 
        | functions {
			Node * node = $1;
			printf("%s\n", node->code.c_str());
		}

functions: functions function{
	Node *node1 = $2;
	Node *node2 = $1;
	Node *node = new Node;
	node->code = std::string("");
	node->code = node1->code + node2->code;
	$$ = node;
}
	| function {
		Node * node = $1;
		Node * node1 = new Node;
		node1 = node;
		$$ = node1;
	}


function: FUNCTION VARIABLE LEFT_PREN declarationargs RIGHT_PREN statements END {
	Node * node = new Node;
	Node * statements = $6;
	std::string name = $2;

	node->code = std::string("");
	node->code += std::string("func ") + name + std::string("\n");
	node->code += $4->code;
	node->code += statements->code;
	node->code += std::string("endfunc\n\n");
	}

statements: statements statement
	{
		Node * statements = $1;
		Node * statement = $2;
		Node * node = new Node;
		node->code = std::string("");
		node->code += statements->code + statement->code;
		$$ = node;
	}
	| statement {
		Node * statement = $1;
		Node *node = new Node;
		node->code = std::string("");
		node->code += statement->code;
		$$ = node;
	}

statement: declaration{
	Node * node = $1;
	$$ = node;
}
	| assignment{
		Node * node = $1;
		$$ = node;
	}
	| exp {
		Node * node = $1;
		$$ = node;
	}
	| inputoutput{
		Node * node = $1;
		$$ = node;
	}

declaration: INT VARIABLE{
	Node *node = new Node;
	node->code = std::string(". ") + $2;
	node->name = $2;
	$$ = node;

}

assignment: VARIABLE EQUAL exp{
	Node *node = new Node;
	std::string variable = $1; 
	Node * expression = $3;
	node->code = $3 -> code;
	node->code += std::string("= ") + variable + std::string(", ") + expression->name;
}
	| declaration EQUAL exp {
		Node * node = new Node;
		Node * decl = $1; 
		Node * expression = $3;
		node->code = decl->code + std::string("\n") + $3->code;
		node->code += std::string("= ") + decl-> name + std::string(", ") + expression -> name;
	}

inputoutput: WRITE VARIABLE {
	Node * node = new Node;
	node->code = std::string(".> ") + std::string($2);
	$$ = node;
}

declarationargs: %empty /*epsi*/{
	Node * node = new Node;
	node->code = std::string("");
	$$ = node;
} 
	| declarationarg {
	argCount = 0;
	$$ = $1;
}
	| declarationarg COMMA declarationarg {
		argCount = 0;
		Node *node = new Node;
		Node * arg = $1;
		Node * args = $3;
		node->code += arg->code + args->code;
		node->name = arg->name+std::string(",") + args->name;
		$$ = node;
	}

declarationarg: INT VARIABLE {
	Node * node = new Node;
	node->name = $2;
	node->code = std::string(". ") + $2 + std::string("\n");
	node->code += std::string("= ") + $2 + std::string(", ") + returnArgument() + std::string("\n");
	$$ = node;
}


exp: exp addop term 
	| term

addop: ADD
        | SUBTRACT 

term: term mulop factor 
        | factor 

mulop: MULTIPLY 
        | DIVISION 

factor: LEFT_PREN exp RIGHT_PREN 
	|DIGIT  	
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
