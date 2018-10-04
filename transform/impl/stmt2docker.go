package impl

import (
	"fmt"
	"github.com/xiaokangwang/VisonC/generate/imprint"
	tycommon "github.com/xiaokangwang/VisonC/structure/common"
	"github.com/xiaokangwang/VisonC/structure/represent"
)

func transfrom(implspec tycommon.ImplSpec, block tycommon.ImpBlock) {

	ret:=represent.ImplElab{
		Spec: implspec.Blueprint,
		Exec:       make([]*represent.ImplExecBlock,0),
		Connection: make([]*represent.ImplConnection,0),
	}


	referenceMap:=make(map[string]([]byte))
	for _, docking := range implspec.Blueprint.DataInputDocker {
		_,errsig:=referenceMap[docking.DockerID.Name]
		if errsig {
			panic("dup name for docker")
		}
		referenceMap[docking.DockerID.Name] =  docking.Imprint

	}

	for _, docking := range implspec.Blueprint.DataOutputDocker {
		//TODO Verify no override
		_,errsig:=referenceMap[docking.DockerID.Name]
		if errsig {
			panic("dup name for docker")
		}
		referenceMap[docking.DockerID.Name] =  docking.Imprint
	}

	for _, docking := range implspec.Blueprint.SignalInputDocker {
		_,errsig:=referenceMap[docking.DockerID.Name]
		if errsig {
			panic("dup name for docker")
		}
		referenceMap[docking.DockerID.Name] =  docking.Imprint
	}

	for _, docking := range implspec.Blueprint.SignalOutputDocker {
		_,errsig:=referenceMap[docking.DockerID.Name]
		if errsig {
			panic("dup name for docker")
		}
		referenceMap[docking.DockerID.Name] =  docking.Imprint
	}
	
	for _,statement := range block.Ctx {
		if x:=statement.GetData();x!=nil {
			execblock:=&represent.ImplExecBlock{
				Spec: &tycommon.BlueprintSpec{
					BlueprintID: &tycommon.NodeOrSignalID{&tycommon.NodeOrSignalID_Node{x.Invoke}},
					TraitConstrant: &tycommon.ID{x.Invoke.Trait},
				},
			}
			inputid:=x.Input.KeyedIDList
			outputid:=x.Assignee.KeyedIDList
			createlink(inputid, referenceMap, execblock, ret, outputid)
		}

		if x:=statement.GetSignall();x!=nil {
			execblock:=&represent.ImplExecBlock{
				Spec: &tycommon.BlueprintSpec{
					BlueprintID: &tycommon.NodeOrSignalID{&tycommon.NodeOrSignalID_Signal{x.Invoke}},
					TraitConstrant: &tycommon.ID{x.Invoke.Trait},
				},
			}
			inputid:=x.Input.KeyedIDList
			outputid:=x.Assignee.KeyedIDList
			createlink(inputid, referenceMap, execblock, ret, outputid)
		}
	}
}

func createlink(inputid []*tycommon.KeyedValue, referenceMap map[string][]byte, execblock *represent.ImplExecBlock, ret represent.ImplElab, outputid []*tycommon.KeyedID) {
	for inputseq, linking := range inputid {
		var usingimprint []byte
		switch v := linking.Value.GetType().(type) {
		case *tycommon.Value_IdValue:
			usingimprint = referenceMap[v.IdValue.Name]
		case *tycommon.Value_IntValue:
			usingimprint = []byte(fmt.Sprintf("const.int.%v", v.IntValue))
		case *tycommon.Value_StringValue:
			usingimprint = []byte(fmt.Sprintf("const.string.%v", v.StringValue))
		}

		var outgoingimprint []byte

		if linking.Key != nil && linking.Key.Name != "" {
			outgoingimprint = append([]byte(fmt.Sprintf("func.kinput.%v.", linking.Key.Name)), execblock.Imprint...)
		} else {
			outgoingimprint = append([]byte(fmt.Sprintf("func.qinput.%v.", inputseq)), execblock.Imprint...)
		}

		connection := represent.ImplConnection{
			From:    usingimprint,
			To:      outgoingimprint,
			Imprint: imprint.GenerateRandImprint(),

		}

		ret.Connection = append(ret.Connection, &connection)

	}
	for outputseq, data := range outputid {
		var outputimprint []byte
		linking := data
		if linking.Key != nil && linking.Key.Name != "" {
			outputimprint = append([]byte(fmt.Sprintf("func.koutput.%v.", linking.Key.Name)), execblock.Imprint...)
		} else {
			outputimprint = append([]byte(fmt.Sprintf("func.qoutput.%v.", outputseq)), execblock.Imprint...)
		}
		//we should register this variable to symbol table

		referenceMap[data.Id.Name] = outputimprint

	}
}