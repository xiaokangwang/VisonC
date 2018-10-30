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
	flag.StringVar(&input, "input file", ".", "The input file(s)")
	flag.BoolVar(&inputIsDir, "directory input", false, "Input is a directory")
	flag.StringVar(&output, "output file", "out.visonpkg", "The output file")

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
	ozip.Flush()
	outfile.Close()

}
