package outpackage

import (
	"archive/zip"
	"bufio"
	"github.com/xiaokangwang/VisonC/astify/parser"
	"go/token"
	"os"
	tylexer "github.com/xiaokangwang/VisonC/astify/lexer"
)

func parseFile(f os.File, set token.FileSet, compressor zip.Compressor)error{
	stat,err:=f.Stat()
	if err !=nil {
		return err
	}
	filetracker:=set.AddFile(f.Name(),set.Base(), int(stat.Size()))

	bufinput := bufio.NewReader(f)
	result := tylexer.GetLexerResult(filetracker, bufinput)
	claims := parser.ConstructClaim(result)


}