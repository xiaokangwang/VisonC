package parser

import (
	"go/token"
	"io"

	"github.com/cznic/golex/lex"
)

// Allocate Character classes anywhere in [0x80, 0xFF].
const (
	classUnicode = iota + 0x80
)

type Lexer struct {
	*lex.Lexer
	stat int
}

func rune2Class(r rune) int {
	if r >= 0 && r < 0x80 { // Keep ASCII as it is.
		return int(r)
	}

	return classUnicode
}

func GetLexerResult(file *token.File, src io.RuneReader) []*ParsedToken {
	var ret []*ParsedToken
	lx, err := lex.New(file, src, lex.RuneClass(rune2Class))
	if err != nil {
		panic(err)
	}
	l := &Lexer{lx, 0}
	for {
		o := l.scan()
		if o == "EOF" {
			break
		}
		parsedToken := new(ParsedToken)
		parsedToken.Trace = int(l.First.Pos())
		parsedToken.Type = o
		parsedToken.Content = string(l.TokenBytes(nil))
		if len(parsedToken.Content) == 1 && parsedToken.Type == "UNKNOWN" {
			parsedToken.Type = "SINGLE"
		}
		ret = append(ret, parsedToken)
	}
	return ret
}

type ParsedToken struct {
	Type    string
	Content string
	Trace   int
}
