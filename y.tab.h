/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ARRAY = 258,
    EQUAL = 259,
    LEFT_BRACKET = 260,
    RIGHT_BRACKET = 261,
    LEFT_PREN = 262,
    R_PREN = 263,
    LESSTHAN = 264,
    GREATERTHAN = 265,
    LESSEROREQUAL = 266,
    GREATEROREQUAL = 267,
    EQUIVALENT = 268,
    NOTEQUIVALENT = 269,
    ADD = 270,
    SUBTRACT = 271,
    MULTIPLY = 272,
    DIVISON = 273,
    BREAK = 274,
    INDEX = 275,
    INT = 276,
    STRING = 277,
    THEN = 278,
    TRUE = 279,
    FALSE = 280,
    DIVISION = 281,
    WHILE = 282,
    DO = 283,
    IF = 284,
    ELSE = 285,
    FUNCTION = 286,
    RIGHT_PREN = 287,
    LEFT_CURR_BRACKET = 288,
    RIGHT_CURR_BRACKET = 289,
    RETURN = 290,
    END = 291,
    COMMA = 292,
    READ = 293,
    WRITE = 294,
    INVALIDVAR = 295,
    VARIABLE = 296,
    DIGIT = 297,
    NUMBER = 298,
    STRINGLITERAL = 299
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 143 "lexer.y" /* yacc.c:1909  */

 char *op_val;
 struct Node *node;

#line 104 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
