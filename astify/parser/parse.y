%{
package parser

import tycommon "github.com/xiaokangwang/VisonC/structure/common"
import "github.com/mohae/deepcopy"
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


%type <SignalID> SIgnalIDWIthTRait
%type <NodeID> NOdeIDWIthTRait

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
  tracker:=yyDollar[1].Tracker
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=SourceClaimSFromSourceClaim($1)
  (*tracker)=&$$
  }
  |SOurceCLaimS SOurceCLaim
  {
  tracker:=yyDollar[1].Tracker
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=append($1,$2)
  (*tracker)=&$$
  }
  |SOurceCLaimS newLIne{
  tracker:=yyDollar[1].Tracker
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  (*tracker)=&$$
  }

KEyedValue:
  TId ':' VAlue
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedValue{Key:&$1,Value:&$3}
  }
  |VAlue
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedValue{Value:&$1}
  }

KEyedValueLIstONgoing:
  KEyedValueLIstONgoing ',' KEyedValue
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.KeyedIDList = append($1.KeyedIDList,&$3)
  }
  |'('
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedValueList{}
  $$.KeyedIDList = make([]*tycommon.KeyedValue,0)
  }
  |KEyedValueLIstONgoing  KEyedValue
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.KeyedIDList = append($1.KeyedIDList,&$2)
  }

KEyedValueLIst:
  KEyedValueLIstONgoing ')'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

VAlue:
  TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Type=&tycommon.Value_IdValue{IdValue:&$1}
  }
  |numberConst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Type=&tycommon.Value_IntValue{IntValue:int64($1)}
  }
  |stringConst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Type=&tycommon.Value_StringValue{StringValue:$1}
  }

KEyedID:
  TId ':' TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedID{Key:$1.Name,Id:&$3}
  }
  |TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedID{Id:&$1}
  }

KEyedIDLIstONgoing:
  KEyedIDLIstONgoing ',' KEyedID
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.KeyedIDList=append($1.KeyedIDList,&$3)
  }
  |'{'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.KeyedIDList{KeyedIDList:make([]*tycommon.KeyedID,0)}
  }|
  KEyedIDLIstONgoing KEyedID
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.KeyedIDList=append($1.KeyedIDList,&$2)
  }

KEyedIDLIst:
  KEyedIDLIstONgoing '}'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

stringConstONgoing:
  QuoteStart
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=""
  }
  |stringConstONgoing QuoteCtx
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1+$2
  }
  |stringConstONgoing EscapeStart EscapeCtx
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1+$3
  }

stringConst:
  stringConstONgoing QuoteEND
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

BLueprintSPecONgoing:
  blueprintKeyword
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.BlueprintSpec{}
  }


BLueprintSPecONgoingS:
  BLueprintSPecONgoing SIgnalID
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  $$.BlueprintID=&tycommon.NodeOrSignalID{}
  $$.BlueprintID.IDType = &tycommon.NodeOrSignalID_Signal{&$2}
  }

BLueprintSPecONgoingN:
  BLueprintSPecONgoing NOdeID
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  $$.BlueprintID=&tycommon.NodeOrSignalID{}
  $$.BlueprintID.IDType = &tycommon.NodeOrSignalID_Node{&$2}
  }

BLueprintSPecONgoingSN:
  BLueprintSPecONgoingS
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingN
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingSN traitKeyword TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  //TODO
  }

BLueprintSPecONgoingSNIoONgoing:
  BLueprintSPecONgoingSN newLIne '('
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingSN  '('
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingSNIoONgoing newLIne
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingSNIoONgoing DAtaINputDOcker
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  if $$.DataInputDocker == nil {
    $$.DataInputDocker =  make([]*tycommon.DataInputDocker,0)
  }
  $$.DataInputDocker = append($$.DataInputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing DAtaOUtputDOcker
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  if $$.DataOutputDocker == nil {
    $$.DataOutputDocker =  make([]*tycommon.DataOutputDocker,0)
  }
  $$.DataOutputDocker = append($$.DataOutputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalINputDOcker
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  if $$.SignalInputDocker == nil {
    $$.SignalInputDocker =  make([]*tycommon.SignalInputDocker,0)
  }
  $$.SignalInputDocker = append($$.SignalInputDocker,&$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalOUtputDOcker
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  if $$.SignalOutputDocker == nil {
    $$.SignalOutputDocker =  make([]*tycommon.SignalOutputDocker,0)
  }
  $$.SignalOutputDocker = append($$.SignalOutputDocker,&$2)
  }

BLueprintSPecONgoingSNIo:
  BLueprintSPecONgoingSNIoONgoing ')'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

BLueprintSPec:
  BLueprintSPecONgoingSNIo newLIne
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |BLueprintSPecONgoingSNIo
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }



IMplSPec:
  IMplSPecONgoing '{'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }


IMplSPecONgoing:
  implKeyword TId BLueprintSPec
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.ImplSpec{}
  $$.Blueprint=&tycommon.BlueprintSpec{}
  $$.Blueprint=&$3
  $$.ImplID=&tycommon.ID{}
  $$.ImplID=&$2
  }
  |implKeyword
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.ImplSpec{}
  }


DAtaINputDOcker:
  inputKeyword TId TRaitSElector
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.DataInputDocker{DockerID:&$2,TraitSelector:&$3}
  }

DAtaOUtputDOcker:
  outputKeyword TId TRaitSElector
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.DataOutputDocker{DockerID:&$2,TraitSelector:&$3}
  }

SIgnalINputDOcker:
  inputKeyword signalKeyword TId TRaitSElector
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalInputDocker{DockerID:&$3,TraitSelector:&$4}
  }

SIgnalOUtputDOcker:
  outputKeyword signalKeyword TId TRaitSElector
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalOutputDocker{DockerID:&$3,TraitSelector:&$4}
  }

IMplBLockONgoing:
  IMplBLockONgoing newLIne
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |IMplSPec
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Spec=&$1
  }

IMplBLock:
  IMplBLockONgoing IMpINstructionLIst '}'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.ImpBlock{}
  $$.Spec=$1.Spec
  $$.Ctx=$2
  }

IMpINstructionLIst:
  IMpINstruction
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=make([]*tycommon.ImpInstruction,1)
  $$[0]=&$1
  }
  |IMpINstructionLIst newLIne
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |IMpINstructionLIst IMpINstruction
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=append($1,&$2)
  }

IMpINstruction:
  IMplDAtaImplSTmt
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.InstrType=&tycommon.ImpInstruction_Data{&$1}
  }
  |IMplSIgnalImplSTmt
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.InstrType=&tycommon.ImpInstruction_Signall{&$1}
  }

IMplDAtaImplSTmt:
  KEyedIDLIst DataAssign NOdeIDWIthTRait KEyedValueLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.DataImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  }

IMplSIgnalImplSTmt:
  KEyedIDLIst SignalAssignL SIgnalIDWIthTRait KEyedValueLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  }
  |KEyedIDLIst SignalAssignL SIgnalIDWIthTRait KEyedValueLIst WaitUntilL KEyedIDLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$1
  $$.Invoke = &$3
  $$.Input = &$4
  $$.Wait = &$6
  }
  |KEyedIDLIst WaitUntilR SIgnalIDWIthTRait KEyedValueLIst SignalAssignR KEyedIDLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$6
  $$.Invoke = &$3
  $$.Input = &$4
  $$.Wait = &$1
  }
  |SIgnalIDWIthTRait KEyedValueLIst SignalAssignR KEyedIDLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.SignalImplStmt{}
  $$.Assignee = &$4
  $$.Invoke = &$1
  $$.Input = &$2
  }

TRaitSElector:
  TRaitSElectorONgoing '>'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

TRaitSElectorONgoing:
  '<'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.TraitSelectorList{}
  $$.TraitSelectorList = make([]*tycommon.TraitSelector,0)
  }
  |TRaitSElectorONgoing TRaitSPec
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.TraitSelectorList = append($$.TraitSelectorList,&$2)
  }

TRaitSPec:
  TId KEyedValueLIst
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.TraitSelector{}
  $$.TraitID=&$1
  $$.KeyedidList=&$2
  }
  |TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.TraitSelector{}
  $$.TraitID=&$1
  }

TRaitDElcareHEad:
  traitKeyword TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.Trait{}
  $$.TraitID=&$2
  $$.ConformsTraitID=make([]*tycommon.ID,0)
  }
  |TRaitDElcareHEad implKeyword TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.ConformsTraitID=append($$.ConformsTraitID,&$3)
  }

TRaitDElcareBOdy:
  '{'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.Trait{}
  $$.Prop=&tycommon.Props{}
  $$.Prop.Prop = make([]*tycommon.Prop,0)
  $$.Cap = make([]*tycommon.BlueprintSpec,0)
  $$.CapImpl = make([]*tycommon.ImpBlock,0)
  }
  |TRaitDElcareBOdy newLIne
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }
  |TRaitDElcareBOdy propKeyword TId TRaitSElector
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  $$.Prop.Prop=append($$.Prop.Prop,&tycommon.Prop{Id:&$3,Trait:&$4})
  }
  |TRaitDElcareBOdy BLueprintSPec
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Cap = append($$.Cap,&$2)
  $$.CapImpl = append($$.CapImpl,nil)
  }
  |TRaitDElcareBOdy BLueprintSPec IMplBLock
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Cap = append($$.Cap,&$2)
  $$.CapImpl = append($$.CapImpl,&$3)
  }

TRaitDElcare:
  TRaitDElcareHEad TRaitDElcareBOdy '}'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=$2
    $$.TraitID=$1.TraitID
    $$.TraitImplID=$1.TraitImplID
    $$.ConformsTraitID=$1.ConformsTraitID
  }

SIgnalDEclareHEad:
  signalKeyword TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=tycommon.Signal{}
  $$.Name=&$2
  }
  |SIgnalDEclareHEad implKeyword TId
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  }

SIgnalDEclare:
  SIgnalDEclareHEad  TRaitDElcareBOdy '}'
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$=$1
  $$.Cap=$2.Cap
  $$.CapImpl=$2.CapImpl
  }

  NOdeIDWIthTRait:
    TRaitSElector NOdeID
    {
    yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=$2
    $$.Trait=$1.TraitSelectorList[0].TraitID.Name
    }
    |NOdeID
    {
    yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=$1
    }

  SIgnalIDWIthTRait:
    TRaitSElector SIgnalID
    {
    yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=$2
    $$.Trait=$1.TraitSelectorList[0].TraitID.Name
    }
    |SIgnalID
    {
    yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
    $$=$1
    }



SOurceCLaim:
  TRaitDElcare
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Contain=1
  $$.Trait=$1
  }
  |SIgnalDEclare
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Contain=2
  $$.Signal=$1
  }
  |BLueprintSPec
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Contain=3
  $$.BlueprintSpec=$1
  }
  |IMplBLock
  {
  yyDollar = (deepcopy.Copy(yyDollar)).([]yySymType)
  $$.Contain=4
  $$.ImplBlock=$1
  }
