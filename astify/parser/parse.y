%{
package parser

import tycommon "github.com/xiaokangwang/VisonC/structure/common"
%}

%union{
BlueprintSpec      tycommon.BlueprintSpec
ImplSpec           tycommon.ImplSpec
ImplBlock          tycommon.ImpBlock
ImpInstruction     tycommon.ImpInstruction
ImpInstructionList []*tycommon.ImpInstruction
ImplDataImplStmt   tycommon.DataImplStmt
ImplSignalImplStmt tycommon.SignalImplStmt
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
TraitSpec          tycommon.TraitSelector
TraitDelcare       tycommon.Trait
SignalDelcare      tycommon.Signal
SourceClaim        SourceClaimC
SourceClaimS       []SourceClaimC
Number             int
ID                 tycommon.ID
SignalID           tycommon.SignaledNodeID
NodeID             tycommon.NodeID
Keyword            string
Operator           string
Quote              string
Escape             string
Tracker            **([]SourceClaimC)
}

%type <BlueprintSpec> BLueprintSPec BLueprintSPecONgoing BLueprintSPecONgoingS BLueprintSPecONgoingN BLueprintSPecONgoingSN BLueprintSPecONgoingSNIo BLueprintSPecONgoingSNIoONgoing
%type <ImplSpec> IMplSPec  IMplSPecONgoing
%type <ImplBlock> IMplBLock IMplBLockONgoing
%type <ImpInstruction> IMpINstruction
%type <ImpInstructionList> IMpINstructionLIst
%type <ImplDataImplStmt> IMplDAtaImplSTmt
%type <ImplSignalImplStmt> IMplSIgnalImplSTmt

%type <DataInputDocker> DAtaINputDOcker
%type <DataOutputDocker> DAtaOUtputDOcker
%type <SignalInputDocker> SIgnalINputDOcker
%type <SignalOutputDocker> SIgnalOUtputDOcker

%type <KeyedIDList> KEyedIDLIst KEyedIDLIstONgoing
%type <KeyedID> KEyedID

%type <KeyedValueList> KEyedValueLIst KEyedValueLIstONgoing
%type <KeyedValue> KEyedValue

%type <Value> VAlue

%type <String> stringConst stringConstONgoing

%type <TraitSelector> TRaitSElector TRaitSElectorONgoing

%type <TraitSpec> TRaitSPec

%type <TraitDelcare> TRaitDElcare TRaitDElcareHEad TRaitDElcareBOdy

%type <SignalDelcare>  SIgnalDEclare SIgnalDEclareHEad

%type <SourceClaim> SOurceCLaim

%type <SourceClaimS> SOurceCLaimS

%token <Number> numberConst

%token <ID> TId
%token <SignalID> SIgnalID
%token <NodeID> NOdeID
%token <Keyword> blueprintKeyword inputKeyword outputKeyword signalKeyword traitKeyword propKeyword implKeyword joinKeyword newLIne
%token <Operator> DataAssign SignalAssignL WaitUntilL SignalAssignR WaitUntilR
%token <Quote> QuoteStart QuoteCtx QuoteEND
%token <Escape> EscapeStart EscapeCtx

%token <Keyword> '(' ')' '[' ']' '{' '}' ':'

%%

SOurceCLaimS: SOurceCLaim
  {
  $$=SourceClaimSFromSourceClaim($1)
  (*yyDollar[1].Tracker)=&$$
  }
  |SOurceCLaimS SOurceCLaim
  {
  $$=append($1,$2)
  (*yyDollar[1].Tracker)=&$$
  }
  |SOurceCLaimS newLIne{
  $$=$1
  (*yyDollar[1].Tracker)=&$$
  }

KEyedValue:
  TId ':' VAlue
  {
  $$=tycommon.KeyedValue{Key:&$1,Value:&$3}
  }

KEyedValueLIstONgoing:
  KEyedValueLIstONgoing KEyedValue
  {
  $$.KeyedIDList = append($1.KeyedIDList,&$2)
  }
  |'(' KEyedValue
  {
  $$=tycommon.KeyedValueList{}
  $$.KeyedIDList = make([]*tycommon.KeyedValue,0)
  }

KEyedValueLIst:
  KEyedValueLIstONgoing ')'
  {
  $$=$1
  }

VAlue:
  TId
  {
  $$.Type=&tycommon.Value_IdValue{IdValue:&$1}
  }
  |numberConst
  {
  $$.Type=&tycommon.Value_IntValue{IntValue:int64($1)}
  }
  |stringConst
  {
  $$.Type=&tycommon.Value_StringValue{StringValue:$1}
  }

KEyedID:
  TId ':' TId
  {
  $$=tycommon.KeyedID{Key:$1.Name,Id:&$3}
  }
  |TId
  {
  $$=tycommon.KeyedID{Id:&$1}
  }

KEyedIDLIstONgoing:
  KEyedIDLIstONgoing KEyedID
  {
  $$.KeyedIDList=append($1.KeyedIDList,&$2)
  }
  |'{'
  {
  $$=tycommon.KeyedIDList{KeyedIDList:make([]*tycommon.KeyedID,0)}
  }

KEyedIDLIst:
  KEyedIDLIstONgoing '}'
  {
  $$=$1
  }

stringConstONgoing:
  QuoteStart
  {
  $$=""
  }
  |stringConstONgoing QuoteCtx
  {
  $$=$1+$2
  }
  |stringConstONgoing EscapeStart EscapeCtx
  {
  $$=$1+$3
  }

stringConst:
  stringConstONgoing QuoteEND
  {
  $$=$1
  }

BLueprintSPecONgoing:
  blueprintKeyword
  {
  $$=tycommon.BlueprintSpec{}
  }


BLueprintSPecONgoingS:
  BLueprintSPecONgoing SIgnalID
  {
  $$=$1
  $$.BlueprintID=&tycommon.NodeOrSignalID{}
  $$.BlueprintID.IDType = &tycommon.NodeOrSignalID_Signal{&$2}
  }

BLueprintSPecONgoingN:
  BLueprintSPecONgoing NOdeID
  {
  $$=$1
  $$.BlueprintID=&tycommon.NodeOrSignalID{}
  $$.BlueprintID.IDType = &tycommon.NodeOrSignalID_Node{&$2}
  }

BLueprintSPecONgoingSN:
  BLueprintSPecONgoingS
  {
  $$=$1
  }
  |BLueprintSPecONgoingN
  {
  $$=$1
  }
  |BLueprintSPecONgoingSN traitKeyword TId
  {
  $$=$1
  //TODO
  }

BLueprintSPecONgoingSNIoONgoing:
  BLueprintSPecONgoingSN newLIne '('
  {
  $$=$1
  }
  |BLueprintSPecONgoingSN  '('
  {
  $$=$1
  }
  |BLueprintSPecONgoingSNIoONgoing newLIne
  {
  $$=$1
  }
  |BLueprintSPecONgoingSNIoONgoing DAtaINputDOcker
  {
  $$=$1
  if $$.DataInputDocker == nil {
    $$.DataInputDocker =  make([]*tycommon.DataInputDocker,0)
  }
  $$.DataInputDocker = append($$.DataInputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing DAtaOUtputDOcker
  {
  $$=$1
  if $$.DataOutputDocker == nil {
    $$.DataOutputDocker =  make([]*tycommon.DataOutputDocker,0)
  }
  $$.DataOutputDocker = append($$.DataOutputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalINputDOcker
  {
  $$=$1
  if $$.SignalInputDocker == nil {
    $$.SignalInputDocker =  make([]*tycommon.SignalInputDocker,0)
  }
  $$.SignalInputDocker = append($$.SignalInputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalOUtputDOcker
  {
  $$=$1
  if $$.SignalOutputDocker == nil {
    $$.SignalOutputDocker =  make([]*tycommon.SignalOutputDocker,0)
  }
  $$.SignalOutputDocker = append($$.SignalOutputDocker,&$2)
  }

BLueprintSPecONgoingSNIo:
  BLueprintSPecONgoingSNIoONgoing ')'
  {
  $$=$1
  }

BLueprintSPec:
  BLueprintSPecONgoingSNIo newLIne
  {
  $$=$1
  }
  |BLueprintSPecONgoingSNIo
  {
  $$=$1
  }



IMplSPec:
  IMplSPecONgoing '{'
  {
  $$=$1
  }


IMplSPecONgoing:
  implKeyword SIgnalID
  {
  $$=tycommon.ImplSpec{}
  $$.Blueprint=&tycommon.NodeOrSignalID{}
  $$.Blueprint.IDType = &tycommon.NodeOrSignalID_Signal{&$2}
  }
  |implKeyword NOdeID
  {
  $$=tycommon.ImplSpec{}
  $$.Blueprint=&tycommon.NodeOrSignalID{}
  $$.Blueprint.IDType = &tycommon.NodeOrSignalID_Node{&$2}
  }
  |implKeyword
  {
  $$=tycommon.ImplSpec{}
  }


DAtaINputDOcker:
  inputKeyword TId TRaitSElector
  {
  $$=tycommon.DataInputDocker{DockerID:&$2,TraitSelector:&$3}
  }

DAtaOUtputDOcker:
  outputKeyword TId TRaitSElector
  {
  $$=tycommon.DataOutputDocker{DockerID:&$2,TraitSelector:&$3}
  }

SIgnalINputDOcker:
  inputKeyword signalKeyword TId TRaitSElector
  {
  $$=tycommon.SignalInputDocker{DockerID:&$3,TraitSelector:&$4}
  }

SIgnalOUtputDOcker:
  outputKeyword signalKeyword TId TRaitSElector
  {
  $$=tycommon.SignalOutputDocker{DockerID:&$3,TraitSelector:&$4}
  }

IMplBLockONgoing:
  IMplBLockONgoing newLIne
  {
  $$=$1
  }
  |IMplSPec
  {
  $$.Spec=&$1
  }

IMplBLock:
  IMplBLockONgoing IMpINstructionLIst '}'
  {
  $$=tycommon.ImpBlock{}
  $$.Spec=$1.Spec
  $$.Ctx=$2
  }

IMpINstructionLIst:
  IMpINstruction
  {
  $$=make([]*tycommon.ImpInstruction,1)
  $$[0]=&$1
  }
  |IMpINstructionLIst newLIne
  {
  $$=$1
  }
  |IMpINstructionLIst IMpINstruction
  {
    $$=append($1,&$2)
  }

IMpINstruction:
  IMplDAtaImplSTmt
  {
  $$.InstrType=&tycommon.ImpInstruction_Data{&$1}
  }
  |IMplSIgnalImplSTmt
  {
  $$.InstrType=&tycommon.ImpInstruction_Signall{&$1}
  }

IMplDAtaImplSTmt:
  KEyedIDLIst DataAssign NOdeID KEyedValueLIst
  {
  $$=tycommon.DataImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  }

IMplSIgnalImplSTmt:
  KEyedIDLIst SignalAssignL SIgnalID KEyedValueLIst
  {
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  }
  |KEyedIDLIst SignalAssignL SIgnalID KEyedValueLIst WaitUntilL KEyedIDLIst
  {
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  $$.Wait = &$6
  }
  |KEyedIDLIst WaitUntilR SIgnalID KEyedValueLIst SignalAssignR KEyedIDLIst
  {
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$6
  $$.Invoke = &$3
  $$.Input = &$4
  $$.Wait = &$1
  }
  |SIgnalID KEyedValueLIst SignalAssignR KEyedIDLIst
  {
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$4
  $$.Invoke = &$1
  $$.Input = &$2
  }

TRaitSElector:
  TRaitSElectorONgoing '>'
  {
  $$=$1
  }

TRaitSElectorONgoing:
  '<'
  {
  $$=tycommon.TraitSelectorList{}
  $$.TraitSelectorList = make([]*tycommon.TraitSelector,0)
  }
  |TRaitSElectorONgoing TRaitSPec
  {
  $$.TraitSelectorList = append($$.TraitSelectorList,&$2)
  }

TRaitSPec:
  TId KEyedValueLIst
  {
  $$=tycommon.TraitSelector{}
  $$.TraitID=&$1
  $$.KeyedidList=&$2
  }
  |TId
  {
  $$=tycommon.TraitSelector{}
  $$.TraitID=&$1
  }

TRaitDElcareHEad:
  traitKeyword TId
  {
  $$=tycommon.Trait{}
  $$.TraitID=&$2
  $$.ConformsTraitID=make([]*tycommon.ID,0)
  }
  |TRaitDElcareHEad implKeyword TId
  {
  $$.ConformsTraitID=append($$.ConformsTraitID,&$3)
  }

TRaitDElcareBOdy:
  '{'
  {
  $$=tycommon.Trait{}
  $$.Prop=&tycommon.Props{}
  $$.Prop.Prop = make([]*tycommon.Prop,0)
  $$.Cap = make([]*tycommon.BlueprintSpec,0)
  $$.CapImpl = make([]*tycommon.ImpBlock,0)
  }
  |TRaitDElcareBOdy newLIne
  {
  $$=$1
  }
  |TRaitDElcareBOdy propKeyword TId TRaitSElector
  {
  $$=$1
  $$.Prop.Prop=append($$.Prop.Prop,&tycommon.Prop{Id:&$3,Trait:&$4})
  }
  |TRaitDElcareBOdy BLueprintSPec
  {
  $$.Cap = append($$.Cap,&$2)
  $$.CapImpl = append($$.CapImpl,nil)
  }
  |TRaitDElcareBOdy BLueprintSPec IMplBLock
  {
  $$.Cap = append($$.Cap,&$2)
  $$.CapImpl = append($$.CapImpl,&$3)
  }

TRaitDElcare:
  TRaitDElcareHEad TRaitDElcareBOdy '}'
  {
    $$=$2
    $$.TraitID=$1.TraitID
    $$.TraitImplID=$1.TraitImplID
    $$.ConformsTraitID=$1.ConformsTraitID
  }

SIgnalDEclareHEad:
  signalKeyword TId
  {
  $$=tycommon.Signal{}
  $$.Name=&$2
  }
  |SIgnalDEclareHEad implKeyword TId
  {
  $$=$1
  }

SIgnalDEclare:
  SIgnalDEclareHEad  TRaitDElcareBOdy '}'
  {
  $$=$1
  $$.Cap=$2.Cap
  }



SOurceCLaim:
  TRaitDElcare
  {
  $$.Contain=1
  $$.Trait=$1
  }
  |SIgnalDEclare
  {
  $$.Contain=2
  $$.Signal=$1
  }
  |BLueprintSPec
  {
  $$.Contain=3
  $$.BlueprintSpec=$1
  }
  |IMplBLock
  {
  $$.Contain=4
  $$.ImplBlock=$1
  }
