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
    INT = 258,
    STRING = 259,
    INDEX = 260,
    THEN = 261,
    EQUAL = 262,
    NOTEQUIVALENT = 263,
    TRUE = 264,
    FALSE = 265,
    MULTIPLY = 266,
    ADD = 267,
    SUBTRACT = 268,
    DIVISION = 269,
    LESSEROREQUAL = 270,
    EQUIVALENT = 271,
    GREATEROREQUAL = 272,
    LESSTHAN = 273,
    GREATERTHAN = 274,
    WHILE = 275,
    DO = 276,
    IF = 277,
    ELSE = 278,
    FUNCTION = 279,
    LEFT_PREN = 280,
    RIGHT_PREN = 281,
    LEFT_BRACKET = 282,
    RIGHT_BRACKET = 283,
    LEFT_CURR_BRACKET = 284,
    RIGHT_CURR_BRACKET = 285,
    RETURN = 286,
    END = 287,
    COMMA = 288,
    READ = 289,
    WRITE = 290,
    INVALIDVAR = 291,
    VARIABLE = 292,
    DIGIT = 293,
    NUMBER = 294,
    STRINGLITERAL = 295
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 100 "lexer.y" /* yacc.c:1909  */

 char *op_val;
 struct Node *node;

#line 100 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
