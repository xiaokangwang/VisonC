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

%type <KeyedIDList> KEyedIDLIst KEyedIDLIstONgoing
%type <KeyedID> KEyedID

%type <String> stringConst stringConstONgoing

%type <Trait> TRait

%token <Number> numberConst

%token <ID> TId
%token <SignalID> SIgnalID
%token <NodeID> NOdeID
%token <Keyword> blueprintKeyword inputKeyword outputKeyword signalKeyword traitKeyword propKeyword implKeyword joinKeyword
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
  BLueprintSPecONgoingSN  '(' |
  BLueprintSPecONgoingSNIoONgoing
