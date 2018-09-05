%{
package parser
%}

%union{

}

%type <BlueprintSpec> BLueprintSPec BLueprintSPecONgoing BLueprintSPecONgoingS BLueprintSPecONgoingN BLueprintSPecONgoingSN BLueprintSPecONgoingSNIoONgoing
%type <ImplSpec> IMplSPec  IMplSPecONgoing
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

%type <String> stringConst stringConstONgoing

%type <TraitSelector> TRaitSElector

%token <Number> numberConst

%token <ID> TId
%token <SignalID> SIgnalID
%token <NodeID> NOdeID
%token <Keyword> blueprintKeyword inputKeyword outputKeyword signalKeyword traitKeyword propKeyword implKeyword joinKeyword newLIne
%token <Operator> DataAssign SignalAssignL WaitUntilL SignalAssignR WaitUntilR
%token <Quote> QuoteStart QuoteCtx QuoteEND
%token <Escape> EscapeStart EscapeCtx

%token '(' ')' '[' ']' '{' '}' ':'

%%


KEyedID:
  TId ':' TId

KEyedIDLIstONgoing:
  KEyedIDLIstONgoing KEyedID |
  '{' KEyedID

KEyedIDLIst:
  KEyedIDLIstONgoing '}'

stringConstONgoing:
  QuoteStart|
  stringConstONgoing QuoteCtx |
  stringConstONgoing EscapeStart EscapeCtx

stringConst:
  stringConstONgoing QuoteEND

BLueprintSPecONgoing:
  blueprintKeyword


BLueprintSPecONgoingS:
  BLueprintSPecONgoing SIgnalID

BLueprintSPecONgoingN:
  BLueprintSPecONgoing NOdeID

BLueprintSPecONgoingSN:
  BLueprintSPecONgoingS |
  BLueprintSPecONgoingN |
  BLueprintSPecONgoingSN traitKeyword TId

BLueprintSPecONgoingSNIoONgoing:
  BLueprintSPecONgoingSN newLIne '(' |
  BLueprintSPecONgoingSN  '(' |
  BLueprintSPecONgoingSNIoONgoing newLIne |
  BLueprintSPecONgoingSNIoONgoing DAtaINputDOcker|
  BLueprintSPecONgoingSNIoONgoing DAtaOUtputDOcker|
  BLueprintSPecONgoingSNIoONgoing SIgnalINputDOcker|
  BLueprintSPecONgoingSNIoONgoing SIgnalINputDOcker

BLueprintSPecONgoingSNIo:
  BLueprintSPecONgoingSNIoONgoing ')'

BLueprintSPec:
  BLueprintSPecONgoingSNIo newline|
  BLueprintSPecONgoingSNIo



IMplSPec:
  IMplSPecONgoing '{'


IMplSPecONgoing:
  implKeyword SIgnalID|
  implKeyword NOdeID|
  implKeyword


DAtaINputDOcker:
  inputKeyword TId TRaitSElector

DAtaOUtputDOcker:
  outputKeyword TId TRaitSElector

SIgnalINputDOcker:
  inputKeyword signalKeyword TId TRaitSElector

SIgnalOUtputDOcker:
  outputKeyword signalKeyword TId TRaitSElector
