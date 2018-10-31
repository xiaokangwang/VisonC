package debugger

import (
	"archive/zip"
	"fmt"
	"github.com/golang/protobuf/proto"
	"github.com/xiaokangwang/VisonC/structure/common"
	"github.com/xiaokangwang/VisonC/structure/represent"
	"io/ioutil"
	"strings"
)

func dump(reader *zip.Reader)error{
	//Enum zip
	for _,file := range reader.File {
		filename:=file.Name
		fctx,err:=file.Open()
		if err != nil {
			return err
		}
		fctxb,err:=ioutil.ReadAll(fctx)

		if err != nil {
			return err
		}

		fmt.Println(filename)

		if strings.HasPrefix(filename,"blueprints/"){
			var blueprint common.Blueprint
			err=proto.Unmarshal(fctxb,&blueprint)
			if err != nil {
				return err
			}
			outstring:=proto.MarshalTextString(&blueprint)
			fmt.Println(outstring)
		}

		if strings.HasPrefix(filename,"impls/"){
			var implElab represent.ImplElab
			err=proto.Unmarshal(fctxb,&implElab)
			if err != nil {
				return err
			}
			outstring:=proto.MarshalTextString(&implElab)
			fmt.Println(outstring)

		}

		if strings.HasPrefix(filename,"traits/"){
			var trait common.Trait
			err=proto.Unmarshal(fctxb,&trait)
			if err != nil {
				return err
			}
			outstring:=proto.MarshalTextString(&trait)
			fmt.Println(outstring)
		}

		if strings.HasPrefix(filename,"signals/"){
			var signal common.Signal
			err=proto.Unmarshal(fctxb,&signal)
			if err != nil {
				return err
			}
			outstring:=proto.MarshalTextString(&signal)
			fmt.Println(outstring)
		}
	}

	return nil
}


func Dump(reader *zip.Reader)error{
	return dump(reader)
}