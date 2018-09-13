package main

import (
	"bufio"
	"go/token"
	"os"

	lexer "github.com/xiaokangwang/VisonC/astify/lexer"
	"github.com/xiaokangwang/VisonC/astify/parser"
)
import "github.com/davecgh/go-spew/spew"

func main() {
	input := os.Stdin
	bufinput := bufio.NewReader(input)
	fileset := token.NewFileSet()
	filetracker := fileset.AddFile("/dev/stdin", fileset.Base(), 65536)
	result := lexer.GetLexerResult(filetracker, bufinput)
	claims := parser.ConstructClaim(result)
	spew.Dump(claims)
}
