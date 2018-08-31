%{
package parser

import "fmt"

func (lx *Lexer) scan() string {
  c := lx.Enter()

%}

%yyn c = lx.Next()
%yyc c

%yym lx.Mark()

%yyt lx.stat

%x QUOTE
%x ESCAPE


%%

    c = lx.Rule0()

\\
    lx.stat=2
    return "ESCAPESTART"

\"
    lx.stat=1
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

[a-z]([a-z0-9_])*
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

([0-9])+
    return "NUMBER"

<QUOTE>[^\"]
    return "QUOTECTX"

<QUOTE>\"
    lx.stat = 0
    return "QUOTEEND"

<ESCAPE>.
    return "ESCAPE"

%%
    if c, ok := lx.Abort(); ok {
      if c == -1 {
        return "EOF"
      }
      return "UNKNOWN"
    }

    return "UNKNOWN ERR"
}
