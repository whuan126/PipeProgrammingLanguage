# WHVB-CS152FinalProject

- Language Name: Pipe
- Language Extension: ''example.pipe''
- Compiler Name: PipePack

## Language Features
| Language Feature                  | Code Example                                                                      |
|-----------------------------------|-----------------------------------------------------------------------------------|
| Integer Scalar Variables          | - int a, b, c<br>- int sum<br>- int median                                        |
| One Dimensional Array of Integers | - int array[4] \|eq {0,1,2,3} <br>- array[2] \|equiv 1                            |
| Assignment Statements             | - a \|eq 1                                                                        |
| Arithmetic Operators              | - total \|eq 4 \|add 8 <br>- minimum \|eq 3 \|mult 5                              |
| Relational Operators              | - a \|equiv 4<br>- a \|noteq 3                                                    |
| While or Do-While loops           | - while a \|equiv true do<br>end<br>- do a \|eq a \|add 1<br>while b \|equiv true |
| If else                           | if a\|equiv true <br>b \|eq true<br>else<br>c \|eq true<br>end                |
| Read write:                       | - \|read<br>- \|write<br>                                                         |
| comments                          | - //This is a comment                                                             |
| Functions                         | - function foo(int b)<br>  a \|eq b<br>  end<br>- int c \|eq 1<br>foo(c)          |


#### Valid Identifiers

- Symbols in our language can not be used as an identifier.
  - For example, int int would not be a valid integer declaration
- The first letter of every identifier will be a character.
- A valid identifier can consist of uppercase or lowercase letters, numbers, and underscores.
- The max length of any identifier is 32 characters.

#### Case Sensitive
- The language will be case sensitive.
  - For example, int num and int Num are two different integer identifiers

#### White Spaces
- White spaces will be ignored
- This is because white spaces, indentations, and formatting should be subjective and not significant in production and compilation.

## Symbols In Language

| Symbol in Language | Token Name     |
|--------------------|----------------|
| int                | INTEGER        |
| string             | STRING         |
| \|eq               | EQUAL          |
| \|mult             | MULTIPLY       |
| \|add              | ADD            |
| \|sub              | SUBTRACT       |
| \|div              | DIVISION       |
| \|leq              | LESSEROREQUAL  |
| \|geq              | GREATEROREQUAL |
| \|lt               | LESSTHAN       |
| \|gt               | GREATERTHAN    |
| \|equiv            | EQUIVALENT     |
| \|noteq            | NOT EQUAL      |
| while              | WHILE          |
| do                 | DO             |
| if                 | IF             |
| else               | ELSE           |                      
| function           | FUNCTION       |
| (                  | LEFT_PREN      |
| )                  | RIGHT_PREN     |
| [                  | LEFT_BRACKET   |
| ]                  | RIGHT_BRACKET  |


