package main

import (
	"archive/zip"
	"flag"
	"github.com/xiaokangwang/VisonC/generate/outpackage"
	"go/token"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	var input, output string
	var inputIsDir bool
	flag.StringVar(&input, "i", ".", "The input file(s)")
	flag.BoolVar(&inputIsDir, "d", false, "Input is a directory")
	flag.StringVar(&output, "o", "out.visonpkg", "The output file")

	flag.Parse()

	outfile, err := os.Create(output)
	if err != nil {
		panic(err)
	}
	ozip := zip.NewWriter(outfile)
	fileset := token.NewFileSet()

	if inputIsDir {

		err := filepath.Walk(input,
			func(path string, info os.FileInfo, err error) error {
				if err != nil {
					return err
				}
				if strings.HasSuffix(path, ".vison") {
					inputfile, err := os.Open(path)
					if err != nil {
						return err
					}
					outpackage.ParseFile(inputfile, fileset, ozip)
				}
				return nil
			})
		if err != nil {
			log.Println(err)
		}
	} else {
		inputfile, err := os.Open(input)
		if err != nil {
			panic(err)
		}
		outpackage.ParseFile(inputfile, fileset, ozip)
	}
	err=ozip.Close()
	if err != nil {
		panic(err)
	}
	err=outfile.Close()
	if err != nil {
		panic(err)
	}

}
