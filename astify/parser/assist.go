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
	TraitSelector      int
	TraitSpec          int
	TraitDelcare       int
	SourceClaim        int
	SourceClaimS       int
	Number             int
	ID                 int
	SignalID           int
	NodeID             int
	Keyword            int
	Operator           int
	Quote              int
	Escape             int
}
