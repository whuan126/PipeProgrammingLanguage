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
    DIGIT = 258,
    ALPHA = 259,
    INVALIDVARIABLE = 260,
    VARIABLE = 261,
    INT = 262,
    STRING = 263,
    EQUAL = 264,
    NOTEQUAL = 265,
    MULTIPLY = 266,
    ADD = 267,
    NOTEQUIV = 268,
    SUBTRACT = 269,
    DIVISION = 270,
    LESSEROREQUAL = 271,
    GREATEROREQUAL = 272,
    LESSTHAN = 273,
    GREATERTHAN = 274,
    EQUIVALENT = 275,
    WHILE = 276,
    DO = 277,
    IF = 278,
    ELSE = 279,
    FUNCTION = 280,
    LEFT_PREN = 281,
    RIGHT_PREN = 282,
    RIGHT_BRACKET = 283,
    LEFT_BRACKET = 284,
    LEFT_CURR_BRACKET = 285,
    RIGHT_CURR_BRACKET = 286,
    RETURN = 287,
    INDEX = 288,
    END = 289,
    COMMA = 290,
    READ = 291,
    TRUE = 292,
    FALSE = 293,
    WRITE = 294,
    COMMENT = 295,
    STRINGLITERAL = 296
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif



int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
