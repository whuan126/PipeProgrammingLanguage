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
    VARIABLE = 258,
    DIGIT = 259,
    INT = 260,
    INDEX = 261,
    THEN = 262,
    STRING = 263,
    EQUAL = 264,
    NOTEQUIVALENT = 265,
    TRUE = 266,
    FALSE = 267,
    MULTIPLY = 268,
    ADD = 269,
    SUBTRACT = 270,
    DIVISION = 271,
    LESSEROREQUAL = 272,
    EQUIVALENT = 273,
    GREATEROREQUAL = 274,
    LESSTHAN = 275,
    GREATERTHAN = 276,
    WHILE = 277,
    DO = 278,
    IF = 279,
    ELSE = 280,
    FUNCTION = 281,
    LEFT_PREN = 282,
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
    STRINGLITERAL = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 37 "lexer.y" /* yacc.c:1909  */

 char *op_val;
 struct Node *node;

#line 99 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
