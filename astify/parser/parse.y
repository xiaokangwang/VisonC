%{
package parser

import tycommon "github.com/xiaokangwang/VisonC/structure/common"
import tyast "github.com/xiaokangwang/VisonC/structure/ast"
%}

%union{
BlueprintSpec      tycommon.BlueprintSpec
ImplSpec           tycommon.ImplSpec
ImplBlock          tyast.ImpBlock
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
}

%type <BlueprintSpec> BLueprintSPec BLueprintSPecONgoing BLueprintSPecONgoingS BLueprintSPecONgoingN BLueprintSPecONgoingSN BLueprintSPecONgoingSNIoONgoing
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

%type <TraitSelector> TRaitSElector

%type <TraitSpec> TRaitSPec

%type <TraitDelcare> TRaitDElcare TRaitDElcareHEad TRaitDElcareBOdy SIgnalDEclare SIgnalDEclareHEad

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
  }
  |SOurceCLaimS SOurceCLaim
  {
  $$=append($1,$2)
  }
  |SOurceCLaimS newLIne{
  $$=$1
  }

KEyedValue:
  TId ':' VAlue
  {
  $$=tycommon.KeyedValue{Key:$1,Value:$2}
  }

KEyedValueLIstONgoing:
  KEyedValueLIstONgoing KEyedValue
  {
  $$.KeyedIDList = append($1.KeyedIDList,$2)
  }
  |'(' KEyedValue
  {
  $$=&KeyedValueList{}
  $$.KeyedIDList = make([]tycommon.KeyedValue)
  }

KEyedValueLIst:
  KEyedIDLIstONgoing ')'
  {
  $$=$1
  }

VAlue:
  TId
  {
  $$=tycommon.Value_IdValue{IdValue:$1}
  }
  |numberConst
  {
  $$=tycommon.Value_IntValue{IntValue:$1}
  }
  |stringConst
  {
  $$=tycommon.Value_StringValue{StringValue:$1}
  }

KEyedID:
  TId ':' TId
  {
  $$=tycommon.KeyedID{Key:$1.Name,Id:$3}
  }

KEyedIDLIstONgoing:
  KEyedIDLIstONgoing KEyedID
  {
  $$=append($1.KeyedIDList,$2)
  }
  |'{' KEyedID
  {
  $$=KeyedIDList{KeyedIDList:make([]tycommon.KEyedID)}
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
  $$=&tycommon.BlueprintSpec{}
  }


BLueprintSPecONgoingS:
  BLueprintSPecONgoing SIgnalID
  {
  $$=$1
  $$.BlueprintID = $2
  }

BLueprintSPecONgoingN:
  BLueprintSPecONgoing NOdeID
  {
  $$=$1
  $$.BlueprintID = $2
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
    $$.DataInputDocker =  make([]*tycommon.DataInputDocker)
  }
  $$.DataInputDocker = append($$.DataInputDocker,$2)
  }
  |BLueprintSPecONgoingSNIoONgoing DAtaOUtputDOcker
  {
  $$=$1
  if $$.DataOutputDocker == nil {
    $$.DataOutputDocker =  make([]*tycommon.DataOutputDocker)
  }
  $$.DataOutputDocker = append($$.DataOutputDocker,$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalINputDOcker
  {
  $$=$1
  if $$.SignalInputDocker == nil {
    $$.SignalInputDocker =  make([]*tycommon.SignalInputDocker)
  }
  $$.SignalInputDocker = append($$.SignalInputDocker,$2)
  }
  |BLueprintSPecONgoingSNIoONgoing SIgnalOUtputDOcker
  {
  $$=$1
  if $$.SignalOutputDocker == nil {
    $$.SignalOutputDocker =  make([]*tycommon.SignalOutputDocker)
  }
  $$.SignalOutputDocker = append($$.SignalOutputDocker,$2)
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
  $$.Blueprint=$2
  }
  |implKeyword NOdeID
  {
  $$=tycommon.ImplSpec{}
  $$.Blueprint=$2
  }
  |implKeyword
  {
  $$=tycommon.ImplSpec{}
  }


DAtaINputDOcker:
  inputKeyword TId TRaitSElector
  {
  $$=tycommon.DataInputDocker{DockerID:$2,TraitSelector:$3}
  }

DAtaOUtputDOcker:
  outputKeyword TId TRaitSElector
  {
  $$=tycommon.DataOutputDocker{DockerID:$2,TraitSelector:$3}
  }

SIgnalINputDOcker:
  inputKeyword signalKeyword TId TRaitSElector
  {
  $$=tycommon.SignalInputDocker{DockerID:$2,TraitSelector:$3}
  }

SIgnalOUtputDOcker:
  outputKeyword signalKeyword TId TRaitSElector
  {
  $$=tycommon.SignalOutputDocker{DockerID:$2,TraitSelector:$3}
  }

IMplBLockONgoing:
  IMplSPec newLIne
  {
  $$=$1
  }
  |IMplSPec
  {
  $$=$1
  }

IMplBLock:
  IMplBLockONgoing ImpInstructionList '}'
  {
  $$=tyast.ImpBlock{}
  $$.Spec=$1
  $$.Ctx=$2
  }

ImpInstructionList:
  ImpInstructionList newLIne
  {
  $$=$1
  }
  |ImpInstructionList IMpINstruction
  {
    $$=append($1,$2)
  }

IMpINstruction:
  IMplDAtaImplSTmt|
  IMplSIgnalImplSTmt

IMplDAtaImplSTmt:
  KEyedIDLIst DataAssign NOdeID KEyedValueLIst

IMplSIgnalImplSTmt
  KEyedIDLIst SignalAssignL SIgnalID KEyedValueLIst |
  KEyedIDLIst SignalAssignL SIgnalID KEyedValueLIst WaitUntilL KEyedIDLIst|
  KEyedIDLIst WaitUntilR SIgnalID KEyedValueLIst SignalAssignR KEyedIDLIst|
  SIgnalID KEyedValueLIst SignalAssignR KEyedIDLIst

TRaitSElector:
  TRaitSElectorONgoing TRaitSElector newLIne

TRaitSElectorONgoing:
  '<'|
  TRaitSElectorONgoing TRaitSPec

TRaitSPec:
  TId KEyedValueLIst|
  TId

TRaitDElcareHEad:
  traitKeyword TId|
  traitKeyword TId implKeyword TId

TRaitDElcareBOdy:
  TRaitDElcareBOdy newLIne|
  TRaitDElcareBOdy propKeyword TId TRaitSElector|
  TRaitDElcareBOdy BLueprintSPec|
  TRaitDElcareBOdy BLueprintSPec IMplBLock

TRaitDElcare:
  TRaitDElcareHEad '{' TRaitDElcareBOdy '}'

SIgnalDEclareHEad:
  signalKeyword TId|
  signalKeyword TId implKeyword TId

SIgnalDEclare:
  SIgnalDEclareHEad '{' TRaitDElcareBOdy '}'



SOurceCLaim:
  TRaitDElcare|
  SIgnalDEclare|
  BLueprintSPec|
  IMplBLock
