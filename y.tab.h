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
    LEFT_PREN = 258,
    R_PREN = 259,
    LESSTHAN = 260,
    GREATERTHAN = 261,
    LESSEROREQUAL = 262,
    GREATEROREQUAL = 263,
    EQUIVALENT = 264,
    NOTEQUIVALENT = 265,
    ADD = 266,
    SUBTRACT = 267,
    MULTIPLY = 268,
    DIVISON = 269,
    INDEX = 270,
    INT = 271,
    STRING = 272,
    THEN = 273,
    EQUAL = 274,
    TRUE = 275,
    FALSE = 276,
    DIVISION = 277,
    WHILE = 278,
    DO = 279,
    IF = 280,
    ELSE = 281,
    FUNCTION = 282,
    RIGHT_PREN = 283,
    LEFT_BRACKET = 284,
    RIGHT_BRACKET = 285,
    LEFT_CURR_BRACKET = 286,
    RIGHT_CURR_BRACKET = 287,
    RETURN = 288,
    END = 289,
    COMMA = 290,
    READ = 291,
    WRITE = 292,
    INVALIDVAR = 293,
    VARIABLE = 294,
    DIGIT = 295,
    NUMBER = 296,
    STRINGLITERAL = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 102 "lexer.y" /* yacc.c:1909  */

 char *op_val;
 struct Node *node;

#line 102 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
