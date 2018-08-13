%{
package parser

func (lx *lexer)lex(){

%}

%yyn lx.next
%yyc lx.c

%%

blueprint
    return "blueprint"

input

output

signal

trait

prop

impl

join

S[a-z]([a-z0-9_])*

P[a-z]([a-z0-9_])*

[a-z]([a-z0-9_])*

:=

<=

=>

<<

>>
