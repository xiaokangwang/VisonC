package fill

import (
	"github.com/xiaokangwang/VisonC/astify/parser"
	"github.com/xiaokangwang/VisonC/generate/imprint"
)

func FillImprint(claim []parser.SourceClaimC){
	for n := range claim {
		claim[n] = fillOneImprint(claim[n])
	}
}

func fillOneImprint(claim parser.SourceClaimC)parser.SourceClaimC{
	switch claim.Contain {
	case 1:
		//TraitDelcare
		Trait:=claim.Trait
		Trait.Imprint=imprint.GenerateRandImprint()

	case 2:
		//SignalDelcare
	case 3:
	case 4:
		//ImplBlock
	}
}


