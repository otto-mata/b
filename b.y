%{
#include <stdio.h>
extern int yylex(void);
void yyerror(const char *s);
%}
%debug
%token IDENTIFIER CONSTANT KW_RETURN KW_GOTO KW_SWITCH KW_WHILE KW_IF KW_ELSE KW_CASE KW_EXTRN KW_AUTO BINARY_OP UNARY_OP LPAREN EQUAL RPAREN LBRACK RBRACK LCURLY RCURLY Q_MARK SEMICOLON COLON COMMA INC DEC AMPERSAND STAR SLASH

%left   PLUS MINUS
%left   STAR SLASH
%right  EQUAL
%left   BINARY_OP
%right  Q_MARK COLON
%right UNARY_OP
%left INC DEC
%right AMPERSAND
%nonassoc RPAREN
%nonassoc KW_ELSE
%%

program
	: /* none */
	| definitions
	;

block
    : LCURLY statements RCURLY
	| LCURLY RCURLY
    ;

definitions
	: definition
	| definitions definition
	;

definition
	: IDENTIFIER LPAREN RPAREN block
	| IDENTIFIER LPAREN identifiers RPAREN block
	| IDENTIFIER SEMICOLON
	| IDENTIFIER values SEMICOLON
	| vector
	;

vector
	: IDENTIFIER RBRACK LBRACK SEMICOLON
	| IDENTIFIER RBRACK LBRACK values SEMICOLON
	| IDENTIFIER RBRACK CONSTANT LBRACK SEMICOLON
	| IDENTIFIER RBRACK CONSTANT LBRACK values SEMICOLON
	;

identifiers
	: IDENTIFIER
	| identifiers COMMA IDENTIFIER
	;

values
	: value
	| values COMMA value
	;

value
	: CONSTANT
	| IDENTIFIER
	;

statements
	: statement
	| statements statement
	;

case
	: KW_CASE CONSTANT COLON statement
	| KW_CASE CONSTANT COLON block
	;

cases
	: case
	| cases case
	;

switch
	: KW_SWITCH LPAREN expr RPAREN LCURLY cases RCURLY
	| KW_SWITCH LPAREN expr RPAREN block
	| KW_SWITCH LPAREN expr RPAREN statement
	;

if
	: KW_IF LPAREN expr RPAREN block
	| KW_IF LPAREN expr RPAREN statement
	| KW_IF LPAREN expr RPAREN statement KW_ELSE statement %prec KW_ELSE
	| KW_IF LPAREN expr RPAREN statement KW_ELSE block %prec KW_ELSE
	| KW_IF LPAREN expr RPAREN block KW_ELSE statement %prec KW_ELSE
	| KW_IF LPAREN expr RPAREN block KW_ELSE block %prec KW_ELSE
	;

while
	: KW_WHILE LPAREN expr RPAREN block
	| KW_WHILE LPAREN expr RPAREN statement
	;

statement
	: SEMICOLON
	| KW_AUTO vars SEMICOLON
	| KW_EXTRN ext_sym SEMICOLON
	| IDENTIFIER COLON statement
	| if
	| while
	| switch
	| KW_GOTO IDENTIFIER SEMICOLON
	| KW_RETURN SEMICOLON
	| KW_RETURN LPAREN expr RPAREN SEMICOLON
	| expr SEMICOLON
	;

ext_sym
	: IDENTIFIER
	| ext_sym COMMA IDENTIFIER
	;

var
	: IDENTIFIER
	| IDENTIFIER CONSTANT
	;

vars
	: var
	| var COMMA var
	;

exprs
	: expr
	| exprs COMMA expr
	;

primary
    : IDENTIFIER
    | CONSTANT
    | LPAREN expr RPAREN
    ;

postfix
    : primary
    | postfix LPAREN RPAREN
    | postfix LPAREN exprs RPAREN
    | postfix LBRACK expr RBRACK
	| postfix INC
	| postfix DEC
    ;

unary
    : postfix
    | INC unary
    | DEC unary
    | UNARY_OP unary
    | STAR unary
    | AMPERSAND unary
    ;

multiplicative
    : unary
    | multiplicative STAR unary
    | multiplicative SLASH unary
    ;

additive
    : multiplicative
    | additive PLUS multiplicative
    | additive MINUS multiplicative
    ;

assignment
    : additive
    | assignment assign additive
    ;

expr
    : assignment
    | expr Q_MARK expr COLON expr
    ;

assign
	: EQUAL
	| EQUAL BINARY_OP
	;

%%
extern int yydebug;
int main(void) {
    yydebug = 1;
    return yyparse();
}
void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

