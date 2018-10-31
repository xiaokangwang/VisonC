package main

import (
	"archive/zip"
	"flag"
	"github.com/xiaokangwang/VisonC/package/debugger"
	"os"
)

func main(){
	var input string
	flag.StringVar(&input, "i", ".", "The input file(s)")
	flag.Parse()

	f,err:=os.Open(input)
	if err != nil {
		panic(err)
	}
	fs,err:=f.Stat()
	if err != nil {
		panic(err)
	}
	reader,err:=zip.NewReader(f,fs.Size())
	if err != nil {
		panic(err)
	}
	err=debugger.Dump(reader)
	if err != nil {
		panic(err)
	}

}
