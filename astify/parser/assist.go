package parser

import tycommon "github.com/xiaokangwang/VisonC/structure/common"
import tyast "github.com/xiaokangwang/VisonC/structure/ast"

type SymHolder struct {
	BlueprintSpec      tycommon.BlueprintSpec
	ImplSpec           tycommon.ImplSpec
	ImplBlock          []tyast.ImpInstruction
	ImpInstruction     tyast.ImpInstruction
	ImpInstructionList []tyast.ImpInstruction
	ImplDataImplStmt   tyast.DataImplStmt
	ImplSignalImplStmt tyast.SignalImplStmt
	DataInputDocker    tycommon.DataInputDocker
	DataOutputDocker   tycommon.DataOutputDocker
	SignalInputDocker  tycommon.SignalInputDocker
	SignalOutputDocker tycommon.SignalOutputDocker
	KeyedIDList        tycommon.KeyedIDList
	KeyedID            tycommon.KeyedID
	KeyedValueList     tycommon.KeyedValueList
	KeyedValue         tycommon.KeyedValue
	Value              tycommon.Value
	String             string
	TraitSelector      tycommon.TraitSelectorList
	TraitSpec          tycommon.Trait
	TraitDelcare       tycommon.Trait
	SourceClaim        int
	SourceClaimS       int
	Number             int
	ID                 tycommon.ID
	SignalID           tycommon.SignaledNodeID
	NodeID             tycommon.NodeID
	Keyword            string
	Operator           string
	Quote              string
	Escape             string
}

type SourceClaimC struct {
	Contain       int
	BlueprintSpec tycommon.BlueprintSpec
}
