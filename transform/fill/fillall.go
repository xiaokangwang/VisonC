package fill

import (
	"github.com/xiaokangwang/VisonC/astify/parser"
	"github.com/xiaokangwang/VisonC/generate/imprint"
)

func FillImprint(claim []parser.SourceClaimC)[]parser.SourceClaimC {
	for n := range claim {
		claim[n] = fillOneImprint(claim[n])
	}
	return claim
}

func fillOneImprint(claim parser.SourceClaimC) parser.SourceClaimC {
	switch claim.Contain {
	case 1:
		//TraitDelcare
		Trait := claim.Trait
		Trait.Imprint = imprint.GenerateRandImprint()

		//Also generate imprint for trait impl
		if Trait.CapImpl != nil {
			for capimpl := range Trait.CapImpl {
				if Trait.CapImpl[capimpl]!=nil&&Trait.CapImpl[capimpl].Spec !=nil {
					Trait.CapImpl[capimpl].Spec.Imprint = imprint.GenerateRandImprint()
				}
			}
		}

		claim.Trait=Trait


	case 2:
		//SignalDelcare
		Signal := claim.Signal
		Signal.Imprint = imprint.GenerateRandImprint()

		if Signal.CapImpl != nil {
			for capimpl := range Signal.CapImpl {
				Signal.CapImpl[capimpl].Spec.Imprint = imprint.GenerateRandImprint()
			}
		}

		claim.Signal=Signal

	case 3:

	case 4:
		//ImplBlock
		Impl := claim.ImplBlock
		Impl.Spec.Imprint = imprint.GenerateRandImprint()
		claim.ImplBlock=Impl
	}
	return claim
}
