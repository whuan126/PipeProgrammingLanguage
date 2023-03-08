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
    INDEX = 274,
    INT = 275,
    STRING = 276,
    THEN = 277,
    TRUE = 278,
    FALSE = 279,
    DIVISION = 280,
    WHILE = 281,
    DO = 282,
    IF = 283,
    ELSE = 284,
    FUNCTION = 285,
    RIGHT_PREN = 286,
    LEFT_CURR_BRACKET = 287,
    RIGHT_CURR_BRACKET = 288,
    RETURN = 289,
    END = 290,
    COMMA = 291,
    READ = 292,
    WRITE = 293,
    INVALIDVAR = 294,
    VARIABLE = 295,
    DIGIT = 296,
    NUMBER = 297,
    STRINGLITERAL = 298
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 124 "lexer.y" /* yacc.c:1909  */

 char *op_val;
 struct Node *node;

#line 103 "y.tab.h" /* yacc.c:1909  */
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
