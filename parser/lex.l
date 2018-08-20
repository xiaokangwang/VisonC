%{
package parser

func (lx *lexer)lex()string{

%}

%yyn lx.next()
%yyc lx.c

%x QUOTE

%%

"
    yyt=QUOTE
    return "QUOTESTART"

blueprint
    return "blueprint"

input
    return "input"

output
    return "output"

signal
    return "signal"

trait
    return "trait"

prop
    return "prop"

impl
    return "impl"

join
    return "join"

S[a-z]([a-z0-9_])+
    return "Signal"

P[a-z]([a-z0-9_])+
    return "Process"

[a-z]([a-z0-9_])+
    return "ID"

:=
    return ":="

\<=
    return "<="

=>
    return "=>"

\<\<
    return "<<"

\>\>
    return ">>"

<QUOTE>[^\"]
    return "QUOTECTX"

<QUOTE>\"
    yyt = INITIAL
    return "QUOTEEND"

%%
    return "UNKNOW"
}
