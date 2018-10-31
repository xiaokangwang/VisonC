package outpackage

import (
	"archive/zip"
	"bufio"
	"encoding/hex"
	"fmt"
	"github.com/golang/protobuf/proto"
	tylexer "github.com/xiaokangwang/VisonC/astify/lexer"
	"github.com/xiaokangwang/VisonC/astify/parser"
	"github.com/xiaokangwang/VisonC/generate/imprint"
	"github.com/xiaokangwang/VisonC/structure/common"
	"github.com/xiaokangwang/VisonC/transform/fill"
	"github.com/xiaokangwang/VisonC/transform/impl"
	"go/token"
	"os"
)

func parseFile(f *os.File, set *token.FileSet, writer *zip.Writer) error {
	stat, err := f.Stat()
	if err != nil {
		return err
	}
	filetracker := set.AddFile(f.Name(), set.Base(), int(stat.Size()))

	bufinput := bufio.NewReader(f)
	result := tylexer.GetLexerResult(filetracker, bufinput)
	claims := parser.ConstructClaim(result)
	claims = fill.FillImprint(claims)

	currentProgressing := 0

	for {
		if len(claims) == currentProgressing {
			break
		}

		if claims[currentProgressing].Contain == 3 &&
			len(claims) > currentProgressing+1 &&
			claims[currentProgressing+1].Contain == 4 &&
			claims[currentProgressing+1].ImplBlock.Spec.Blueprint == nil {
			//:Construct a blueprint with default impl
			blueprintspec := claims[currentProgressing].BlueprintSpec
			exec := claims[currentProgressing+1].ImplBlock
			if exec.Spec.Blueprint == nil {
				exec.Spec.Blueprint = &blueprintspec
				exec.Spec.Blueprint = fill.FillBlueprintspec(exec.Spec.Blueprint)
			}

			out := impl.Transfrom(*exec.Spec, exec)
			generating := common.Blueprint{}
			generating.Spec = &blueprintspec

			generating.Imprint = imprint.GenerateRandImprint()
			out.Imprint = imprint.GenerateRandImprint()

			generating.DefaultImplImprint = out.Imprint
			out.TargetBlueprintImprint = generating.Imprint

			//Done; write out and generate to stream

			blueprint, err := proto.Marshal(&generating)
			if err != nil {
				return err
			}

			impl, err := proto.Marshal(&out)
			if err != nil {
				return err
			}

			err = outputNamedFileToZip(fmt.Sprintf("blueprints/%v",
				hex.EncodeToString(generating.Imprint)),
				blueprint,writer)
			if err != nil {
				return err
			}
			err = outputNamedFileToZip(fmt.Sprintf("impls/%v",
				hex.EncodeToString(out.Imprint)),
				impl,writer)
			if err != nil {
				return err
			}
		} else {
			switch claims[currentProgressing].Contain {
			case 1:
				//Trait
				trait:=claims[currentProgressing].Trait
				if trait.CapImpl != nil {
					for implid,impld:=range trait.CapImpl{
						if impld == nil {
							continue
						}
						blueprint:=trait.Cap[implid]
						if impld.Spec.Blueprint==nil {
							impld.Spec.Blueprint = blueprint
							impld.Spec.Blueprint = fill.FillBlueprintspec(impld.Spec.Blueprint)
						}

						implout:=impl.Transfrom(*impld.Spec,*impld)

						implout.Imprint = imprint.GenerateRandImprint()

						implout.TargetTraitImprint=trait.Imprint

						implob, err := proto.Marshal(&implout)
						if err != nil {
							return err
						}

						err = outputNamedFileToZip(fmt.Sprintf("impls/%v",
							hex.EncodeToString(implout.Imprint)),
							implob,writer)
						if err != nil {
							return err
						}

					}
				}

				traitb, err := proto.Marshal(&trait)


				err = outputNamedFileToZip(fmt.Sprintf("traits/%v",
					hex.EncodeToString(trait.Imprint)),
					traitb,writer)
				if err != nil {
					return err
				}

			case 2:
				//Signal

				signalstructure :=claims[currentProgressing].Signal
				if signalstructure.CapImpl != nil {
					for sigid, signald :=range signalstructure.CapImpl{
						blueprint:= signalstructure.Cap[sigid]
						if signald.Spec.Blueprint==nil {
							signald.Spec.Blueprint = blueprint
							signald.Spec.Blueprint = fill.FillBlueprintspec(signald.Spec.Blueprint)
						}

						signalout :=impl.Transfrom(*signald.Spec,*signald)

						signalout.Imprint = imprint.GenerateRandImprint()

						signalout.TargetSignalImprint= signalstructure.Imprint

						signalimpl, err := proto.Marshal(&signalout)
						if err != nil {
							return err
						}

						err = outputNamedFileToZip(fmt.Sprintf("impls/%v",
							hex.EncodeToString(signalout.Imprint)),
							signalimpl,writer)
						if err != nil {
							return err
						}

					}
				}

				traitb, err := proto.Marshal(&signalstructure)


				err = outputNamedFileToZip(fmt.Sprintf("traits/%v",
					hex.EncodeToString(signalstructure.Imprint)),
					traitb,writer)
				if err != nil {
					return err
				}


			case 3:
				//Blueprint

				blueprintspec := claims[currentProgressing].BlueprintSpec
				generating := common.Blueprint{}
				generating.Spec=&blueprintspec
				generating.Imprint=imprint.GenerateRandImprint()


				generatingb, err := proto.Marshal(&generating)


				err = outputNamedFileToZip(fmt.Sprintf("blueprints/%v",
					hex.EncodeToString(generating.Imprint)),
					generatingb,writer)
				if err != nil {
					return err
				}

			case 4:
				//impl
				exec := claims[currentProgressing+1].ImplBlock
				out := impl.Transfrom(*exec.Spec, exec)

				impl, err := proto.Marshal(&out)
				if err != nil {
					return err
				}

				err = outputNamedFileToZip(fmt.Sprintf("impls/%v",
					hex.EncodeToString(out.Imprint)),
					impl,writer)
				if err != nil {
					return err
				}
			}
		}

		currentProgressing++
	}

	return nil

}

func outputNamedFileToZip(filename string, content []byte, writer* zip.Writer) error {

	o, err := writer.Create(filename)
	if err != nil {
		return err
	}
	n, err := o.Write(content)
	if err != nil {
		return err
	}
	for n != len(content) {
		content = content[n:]
		n, err = o.Write(content)
		if err != nil {
			return err
		}
	}
	return nil

}

func ParseFile(f *os.File, set *token.FileSet, writer *zip.Writer) error {
	return parseFile(f,set,writer)
}
