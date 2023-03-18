%{
#include<stdio.h>
#include<string>
#include<vector>
#include<string.h>

#include<map>
#include<iostream>
#include<algorithm>

extern FILE* yyin;
extern int currLine;
extern int currPos;
extern char* lineptr;

extern int yylex(void);
void yyerror(const char *msg);

bool isKeyword(std::string keyString);
bool isVariable(std::string varString);
bool isFunction(std::string funcString);

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

///////////Semantic Stuff//////////

std::vector<std::string> keywordVec = {"INDEX", "INT", "STRING", "THEN", "EQUAL", "NOTEQUIVALENT", 
										"TRUE", "FALSE", "MULTIPLY", "ADD", "SUBTRACT", "DIVISION", "LESSEROREQUAL", "EQUIVALENT", 
										"GREATEROREQUAL", "LESSTHAN", "GREATERTHAN", "WHILE", "DO", "IF", "ELSE", "FUNCTION", 
										"LEFT_PREN", "RIGHT_PREN", "LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_CURR_BRACKET", 
										"RIGHT_CURR_BRACKET", "RETURN", "END", "COMMA", "READ", "WRITE", "INVALIDVAR", "VARIABLE", 
										"DIGIT", "NUMBER", "STRINGLITERAL"};
std::vector<std::string> variableVec;
std::vector<std::string> functionVec;
bool errorOccured = false;

%}

%union {
 char *op_val;
 struct Node *node;
}

%define parse.error verbose
%start start
%locations

%left ARRAY EQUAL
%left LEFT_BRACKET RIGHT_BRACKET
%left LEFT_PREN R_PREN
%left LESSTHAN GREATERTHAN LESSEROREQUAL GREATEROREQUAL EQUIVALENT NOTEQUIVALENT
%left ADD SUBTRACT
%left MULTIPLY DIVISON

%token ARRAY BREAK INDEX INT STRING THEN EQUAL NOTEQUIVALENT TRUE FALSE MULTIPLY ADD SUBTRACT DIVISION LESSEROREQUAL EQUIVALENT GREATEROREQUAL LESSTHAN GREATERTHAN WHILE DO IF ELSE FUNCTION LEFT_PREN RIGHT_PREN LEFT_BRACKET RIGHT_BRACKET LEFT_CURR_BRACKET RIGHT_CURR_BRACKET RETURN END COMMA READ WRITE INVALIDVAR VARIABLE DIGIT NUMBER STRINGLITERAL
%type <op_val> ARRAY FUNCTION addop mulop VARIABLE INT DIGIT 
%type <node> break conditional elses GREATERTHAN comparison LESSEROREQUAL comparitor LESSTHAN NOTEQUIVALENT EQUIVALENT GREATEROREQUAL return if inputargs while functioncall factor assignment declarationarg exp declaration inputoutput functions function term declarationargs statements statement  
%%
start: %empty/*epsilon*/
	{
		
	} 
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
		//printf("IN FUNCTION\n");
		Node * node = $1;
		Node * node1 = new Node;
		node1 = node;
		$$ = node1;
	}

function: FUNCTION VARIABLE LEFT_PREN declarationargs RIGHT_PREN statements END {
	std::string funcName = $2;
	functionVec.push_back(funcName);
	if (std::find(keywordVec.begin(), keywordVec.end(), funcName) != keywordVec.end()) {
		yyerror("Invalid declaration using a reserved keyword");
		errorOccured = true;
	}
	if (std::find(functionVec.begin(), functionVec.end(), "main") == functionVec.end()) {
		yyerror("Function main not declared");
		errorOccured = true;
	}
	if (!errorOccured) {
		Node * node = new Node;
		Node * statements = $6;
		std::string name = $2;
		node->code = std::string("");
		node->code += std::string("func ") + name + std::string("\n");
		node->code += $4->code;
		node->code += statements->code;
		node->code += std::string("\nendfunc\n\n");\
		$$ = node;
	}
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

functioncall: VARIABLE LEFT_PREN inputargs RIGHT_PREN {
	std::string funcName = $1;
	if (std::find(functionVec.begin(), functionVec.end(), funcName) != functionVec.end()) {
		std::cerr << "Function" << $1 << "not declared";
		errorOccured = true;
	}
	Node * node = new Node;
	Node * inputargs = $3;
	node->name = $1;
	node->code = inputargs->code;
	$$=node;
}

inputargs: %empty {
	Node * node = new Node;
	node->code = std::string("");
	$$=node;
}
	| exp COMMA exp {
		Node * exp1 = $1;
		Node *exp2 = $3; 
		Node *node = new Node;
		node->code += exp1->code + std::string("\n");
		node->code += exp2->code + std::string("\n");
		node->code += std::string("param ") + exp1->name + std::string("\n");
		node->code += std::string("param ") +exp2->name + std::string("\n");
		$$=node;
	}
	| exp
	{
		Node * node = new Node;
		node->code = std::string("param ") + $1->code;
		$$=node;
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

	| return {
		Node * node = $1;
		$$ = node;
	}
	| break {
		Node * node = $1;
		$$ = node;
	}
/* ///////////    THE GRAMMAR ZONE    //////////// */
	| if {
		//printf("statement -> if\n");
		Node* node =$1;
		$$ = node;
	}
	| while {
		//printf("statement -> while\n");	
		Node * node = $1;
		$$ = node;
	}
	/* we do not have 'BREAK' in our language. use empty 'RETURN' instead? */

if: IF conditional statements elses END {
		//printf("if -> IF conditional statements elses END\n");
		// Code for conditional will go first
		// . _temp0
		// < _temp0, a, b
		Node * cond = $2;
		Node * node = new Node; 
		node->code = cond->code;
		
		// The If statement part will go next!
		// ?:= if_true0, _temp0(name of conditional)
		// := else0 

		node->code += std::string("?:= if_true0, ") + cond->name + std::string("\n");
		node->code += std::string(":= else0") + std::string("\n");

		node->code += std::string(": if_true0") + std::string("\n");

		Node * stmnts = $3;
		node->code += stmnts->code;
		node->code += std::string(":= endif0") + std::string("\n");

		node->code += std::string(": else0") + std::string("\n");
		node->code += $4 -> code;
		node->code += std::string(": endif0") + std::string("\n");

		$$ = node;

	}

elses: %empty {
		//printf("elses -> empty\n");
	}
	| ELSE statements {
		//printf("elses -> ELSE statements\n");
		Node * statements = $2;
		$$ = statements;
	}

conditional: VARIABLE comparitor comparison {
		//printf("conditional -> VARIABLE comparitor comparison\n");
		std::string temp = returnTempVarName();
		std::string var1 = $1;
		
		Node * comparison = $3;
		Node * comparitor = $2;

		Node * node = new Node;
		node->code = std::string(". ") + temp + std::string("\n");
		node->name = temp;
		node->code += comparitor->code + std::string(" ") + temp + std::string(", ") + var1 + std::string(", ") + comparison->name + std::string("\n");
		$$ = node;

	}

comparitor: EQUIVALENT {
		//printf("comparitor -> EQUIVALENT\n");
		Node * node = new Node;
		node->code = std::string("==");
		$$ = node;
	}
	| NOTEQUIVALENT {
		//printf("comparitor -> NOTEQUIVALENT\n");
		Node * node = new Node;
		node->code = std::string("!=");
		$$ = node;
		
	}
	| GREATEROREQUAL {
		//printf("comparitor -> GREATEROREQUAL\n");
		Node * node = new Node;
		node->code = std::string(">=");
		$$ = node;
	}
	| LESSEROREQUAL {
		//printf("comparitor -> LESSEROREQUAL\n");
		Node * node = new Node;
		node->code = std::string("<=");
		$$ = node;
	}
	| LESSTHAN {
		//printf("comparitor -> LESSTHAN\n");
		Node * node = new Node;
		node->code = std::string("<");
		$$ = node;
	}
	| GREATERTHAN{
		//printf("comparitor -> GREATERTHAN\n");
		Node * node = new Node;
		node->code = std::string(">");
		$$ = node;
	}

comparison: exp{
		//printf("comparison -> VARIABLE\n");
		Node * exp = $1;
		$$ = exp;
	}
	| TRUE{
		//printf("comparison -> TRUE\n");
	}
	| FALSE{
		//printf("comparison -> FALSE\n");
	}

while: WHILE conditional statements END {
		//printf("while -> WHILE conditional statements END\n");
		Node * conditional  = $2; 
		Node * statements = $3;

		Node * node = new Node;
		// missing :beginloop0
		//. _temp0
		node->code = std::string(": beginloop0") + std::string("\n");
		node-> code += conditional->code;
		node->code += std::string("?:= loopbody0, ") + conditional->name + std::string("\n");
		node-> code += std::string(":= endloop0") + std::string("\n");
		node->code += std::string(": loopbody0") + std::string("\n");
		node->code += statements->code;
		node->code += std::string(":= beginloop0") + std::string("\n");
		node->code += std::string(": endloop0") + std::string("\n");
		$$ = node;


	}
/* ///////////// END OF GRAMMAR ZONE //////////////// */
return: RETURN exp
{	
	//printf("IN RETURN\n");
	Node * expression = $2; 
	Node * node = new Node;
	node->code = std::string("ret ") + expression->name;
	$$=node;
}

break: BREAK
{
	Node * node = new Node;
	node->code = std::string(":= endloop0") + std::string("\n");
	$$ = node;
}
declaration: INT VARIABLE{
	//printf("READING INT VAR\n");
	std::string varName = $2;
	variableVec.push_back(varName);
	if (std::find(variableVec.begin(), variableVec.end(), varName) == variableVec.end()) {
		std::cerr << "Variable " << varName << "has not been declared";
		errorOccured = true;
	}
	Node *node = new Node;
	node->code = std::string(". ") + $2 + std::string("\n");
	node->name = $2;
	$$ = node;
} 
	| INT VARIABLE LEFT_BRACKET DIGIT RIGHT_BRACKET {
		//printf("INT ARRAY\n");
		if ($4 <= 0) {
			yyerror("Declaring an array of size less than or equal to zero");
			errorOccured = true;
		}
		if (!errorOccured) {
			std::string digit = $4;
			std::string name = $2;
			Node * node = new Node; 
			node->code = std::string(".[] ") + name + std::string(", ") + digit + std::string("\n");
			$$ = node;
		}
	}
	| INT VARIABLE EQUAL functioncall
		{
			std::string varName = $2;
			if (std::find(keywordVec.begin(), keywordVec.end(), varName) != keywordVec.end()) {
				yyerror("Invalid declaration using a reserved keyword");
				errorOccured = true;
			}
			variableVec.push_back(varName);

			Node * node = new Node;
			std::string variable = $2;
			Node *functioncall = $4;
			node->code = functioncall->code + std::string("call ") + functioncall->name + std::string(", ") + variable + std::string("\n");
			$$=node;
		}

assignment: VARIABLE EQUAL exp{
	//printf("READING VAR = EXP\n");
	std::string varName = $1;
	if (std::find(variableVec.begin(), variableVec.end(), varName) == variableVec.end()) {
		std::cerr << "Variable " << varName << " is not declared" << std::endl;
		errorOccured = true;
	}
	Node *node = new Node;
	std::string variable = $1;
	Node * expression = $3;
	if (expression->code[0] != '='){ // default. exp isnt array
		node->code = $3 -> code;
		node->code += std::string("= ") + variable + std::string(", ") + expression->name + std::string("\n");
	}else{  //exp is an array
		node->code = std::string("=[] ") + variable + std::string(", ") + expression->name;
        }
	$$ = node;
}
	| VARIABLE LEFT_BRACKET DIGIT RIGHT_BRACKET EQUAL exp {
		//printf("VARIABLE ARRAY\n");
		std::string varName = $1;
		if (std::find(variableVec.begin(), variableVec.end(), varName) != variableVec.end()) {
		std::cerr<< "Variable " << varName <<  " is not declared" << std::endl;
		errorOccured = true;
	}
		Node * expression = $6;
		std::string digit = $3;
		std::string name = $1;
		Node * node = new Node;
		node->code = std::string(". ") + expression->name + std::string("\n");
		node->code += std::string("[]= ") + name + std::string(", ") + digit + std::string(", ") + expression->name + std::string("\n");
		$$ = node;
	}


	| declaration EQUAL exp {
		Node * node = new Node;
		Node * decl = $1; 
		Node * expression = $3;
		node->code = decl->code + std::string("\n") + $3->code;
		node->code += std::string("= ") + decl-> name + std::string(", ") + expression -> name;
		$$ = node;
	}


inputoutput: WRITE VARIABLE {
	Node * node = new Node;
	node->code = std::string(".> ") + std::string($2) + std::string("\n");
	$$ = node;
}
	| WRITE VARIABLE LEFT_BRACKET DIGIT RIGHT_BRACKET
	{	
		Node * node = new Node; 
		node->code = std::string(".[]> ") + $2 + std::string(", ") + $4 + std::string("\n");
		$$=node; 
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
	//printf("INT VARIABLE\n");
	Node * node = new Node;
	node->name = $2;
	node->code = std::string(". ") + $2 + std::string("\n");
	node->code += std::string("= ") + $2 + std::string(", ") + returnArgument() + std::string("\n");
	$$ = node;
}


exp: exp addop term {
	// printf("EXP ADDOP TERM\n");
	Node * node = new Node;
	std::string tempVar = returnTempVarName();
	node->name = tempVar;
	node->code= $1->code + $3->code + std::string(". ") + tempVar + std::string("\n");
	node->code += std::string($2) + std::string(" ") + tempVar + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	$$ = node;
}
	| term {
		//printf("TERM\n");
		Node *node = $1;
		$$ = node;
	}

addop: ADD {
	char addition[] = "+";
	$$ = addition;
	//printf("ADD\n");
}
        | SUBTRACT {
			char subtraction[] = "-";
			$$ = subtraction;
			//printf("SUB\n");
		}

term: term mulop factor {
	//printf("TERM MULOP FACTOR\n");
	Node *node = new Node;
	std::string tempVar = returnTempVarName();
	node->name = tempVar;
	node->code = $1->code + $3->code + std::string(". ") + tempVar + std::string("\n");
	node->code += std::string($2) + std::string(" ") +tempVar + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
    $$ = node;

}
        | factor {
			//printf("FACTOR\n");
			Node *node = $1;
		}

mulop: MULTIPLY {
	//printf("MULTIPLY\n");
	char multiply[] = "*";
	$$ = multiply;
}
        | DIVISION {
			//printf("DIVISION\n");
			char division[] = "/";
			$$ = division;
		}

factor: LEFT_PREN exp RIGHT_PREN {
	//printf("(EXP)\n");
	Node *node = new Node;
	Node *exp = $2;
	node->code = exp->code;
	$$ = node;
	
}
	| DIGIT  	{
		//printf("DIGIT\n");
		Node *node = new Node;
		node -> name = $1;
		$$ = node;
	}
	| VARIABLE {
		//printf("VARIABLE\n");
		Node * node = new Node;
		node->name = $1;
		$$ = node;
	}
	| VARIABLE LEFT_BRACKET DIGIT RIGHT_BRACKET {
                //printf("EXP ARRAY\n");
                std::string digit = $3;
                std::string name = $1;
                Node * node = new Node;
                node->code = std::string("=[]") + name + std::string(", ") + digit + std::string("\n"); // idk do both i guess
                node->name = name + std::string(", ") + digit + std::string("\n");
		$$ = node;
	}
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
	//print_symbol_table();
	return 0;
}
void yyerror(const char *msg) {
    fprintf(stderr, "%s\n", msg);
    printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
	//exit(1);
}
/*
bool isFunction (std::string funcString) {
	if (std::find(functionVec.begin(), functionVec.end(), funcString) != functionVec.end()) {
		yyerror("Function" + funcString + "not declared");
		errorOccured = true;
	}
}

bool isKeyword (std::string keyString) {
	if (std::find(keywordVec.begin(), keywordVec.end(), keyString) != keywordVec.end()) {
		yyerror("Invalid declaration using a reserved keyword");
		errorOccured = true;
	}
}

bool isVariable (std::string varString) {
	if (std::find(variableVec.begin(), variableVec.end(), varString) != variableVec.end()) {
		yyerror("Variable" + varString + "is not declared");
		errorOccured = true;
	}
}
*/
