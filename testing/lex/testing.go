package main

import (
	"bufio"
	"fmt"
	"go/token"
	"os"

	lexer "github.com/xiaokangwang/VisonC/astify/lexer"
)

func main() {
	input := os.Stdin
	bufinput := bufio.NewReader(input)
	fileset := token.NewFileSet()
	filetracker := fileset.AddFile("/dev/stdin", fileset.Base(), 65536)
	result := lexer.GetLexerResult(filetracker, bufinput)
	for _, resultc := range result {
		fmt.Printf("%v: <%v> %v\n", fileset.Position(token.Pos(resultc.Trace)).String(), resultc.Type, resultc.Content)
	}
}
