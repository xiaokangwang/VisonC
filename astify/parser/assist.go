package parser

import (
	"fmt"
	"strconv"

	lexer "github.com/xiaokangwang/VisonC/astify/lexer"
	tycommon "github.com/xiaokangwang/VisonC/structure/common"
)

type SourceClaimC struct {
	Contain       int
	BlueprintSpec tycommon.BlueprintSpec
	ImplBlock     tycommon.ImpBlock
	Trait         tycommon.Trait
	Signal        tycommon.Signal
}

func ConstructClaim(token []*lexer.ParsedToken) []SourceClaimC {
	yyDebug = 8
	yyErrorVerbose = true
	lexer := &LexHolder{Payload: token}
	yyParse(lexer)
	return *lexer.Tracker
}

func SourceClaimSFromSourceClaim(claim SourceClaimC) []SourceClaimC {
	l := make([]SourceClaimC, 1)
	l[0] = claim
	return l
}

type LexHolder struct {
	Payload []*lexer.ParsedToken
	Current int
	Tracker *([]SourceClaimC)
}

func (lh *LexHolder) Error(s string) {
	fmt.Println(s)
}
func (lh *LexHolder) Lex(lval *yySymType) int {
	if lh.Current == len(lh.Payload) {
		return 0
	}
	lval.Tracker = &lh.Tracker
	sub := lh.Payload[lh.Current]
	lh.Current++
	switch sub.Type {
	case "Signal":
		lval.SignalID.Name = sub.Content
		return SIgnalID
	case "Process":
		lval.NodeID.Name = sub.Content
		return NOdeID
	case "ID":
		lval.ID.Name = sub.Content
		return TId
	case "NUMBER":
		lval.Number, _ = strconv.Atoi(sub.Content)
		return numberConst
	case "QUOTESTART":
		return QuoteStart
	case "ESCAPESTART":
		return EscapeStart
	case "QUOTECTX":
		lval.Quote = sub.Content
		return QuoteCtx
	case "QUOTEEND":
		return QuoteEND
	case "ESCAPE":
		lval.Escape = sub.Content
		return EscapeCtx
	case ":=":
		return DataAssign
	case "<=":
		return SignalAssignL
	case "=>":
		return SignalAssignR
	case "<<":
		return WaitUntilL
	case ">>":
		return WaitUntilR
	case "input":
		return inputKeyword
	case "output":
		return outputKeyword
	case "signal":
		return signalKeyword
	case "trait":
		return traitKeyword
	case "prop":
		return propKeyword
	case "impl":
		return implKeyword
	case "join":
		return joinKeyword
	case "blueprint":
		return blueprintKeyword
	case "newline":
		return newLIne
	case "SINGLE":
		return int(sub.Content[0])
	default:
		panic(sub)
	}
}
