%{
#include <stdio.h>
#include "b_parser.tab.h"
%}

alpha			[a-zA-Z_\b]
digit			[0-9]
lbrack			\[
rbrack			\]
lparen			\(
rparen			\)
lcurly			\{
rcurly			\}
ampers			&
qsmark			\?
colon			:
semi			;
neg				!
eq				=
blcomp			{eq}{eq}
blncmp			{neg}{eq}
bitwiseor		\|
lt				<
lte				{lt}{eq}
gt				>
gte				{gt}{eq}
bitshiftl		{lt}{lt}
bitshiftr		{rt}{rt}
minus			-
plus			\+
mod				%
star			\*
div				/
inc				{plus}{plus}
dec				{minus}{minus}
escape_seq		\*[0e()t*'"n]
char			{alpha}|{digit}|[!"#$%&'()+,\-./:;<=>?@\[\\\]^_*`{|}~\a\t\n\v\f\r -]|{escape_seq}
alpha_digit		{alpha}|{digit}
name			{alpha}{alpha_digit}{0,7}
constant		{digit}+|'{char}{1,2}'|\"{char}*\"
binary			[|&<>+\-%*/]|[=!<>]=|<<|>>
unary			{minus}|{neg}
%%

"/*" { int c;
    for (;;) {
        while ((c = input()) != '*' && c != EOF)
            ; /* eat up text of comment */
        if (c == '*') {
            while ((c = input()) == '*')
                ;
            if (c == '/')
                break; /* found the end */
        }
        if (c == EOF) {
            break;
        }
    }
}

"&"				{ return AMPERSAND; }
return			{ return KW_RETURN; }
goto			{ return KW_GOTO; }
switch			{ return KW_SWITCH; }
while			{ return KW_WHILE; }
if				{ return KW_IF; }
else			{ return KW_ELSE; }
case			{ return KW_CASE; }
extrn			{ return KW_EXTRN; }
auto			{ return KW_AUTO; }
{constant}		{ return CONSTANT;}
{name}			{ return IDENTIFIER; }
{inc}			{ return INC; }
{dec}			{ return DEC; }
"*"				{ return STAR; }
"/"				{ return SLASH; }
{binary}		{ return BINARY_OP; }
{unary}			{ return UNARY_OP; }
{lparen}		{ return LPAREN; }
{eq}			{ return EQUAL; }
{rparen}		{ return RPAREN; }
{lbrack}		{ return LBRACK; }
{rbrack}		{ return RBRACK; }
{lcurly}		{ return LCURLY; }
{rcurly}		{ return RCURLY; }
{qsmark}		{ return Q_MARK; }
{semi}			{ return SEMICOLON; }
{colon}			{ return COLON; }
,				{ return COMMA; }
[ \t\r\n]+		{ /* skip whitespace */ }
.				{ if (yytext[0] != '\n') printf("UNRECOGNIZED: %s\n", yytext); }


%%
int yywrap(void) { return 1; }
