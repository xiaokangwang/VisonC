package fill

import (
	"github.com/xiaokangwang/VisonC/astify/parser"
	"github.com/xiaokangwang/VisonC/generate/imprint"
	"github.com/xiaokangwang/VisonC/structure/common"
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
					Trait.CapImpl[capimpl].Spec.Blueprint=fillBlueprintspec(Trait.CapImpl[capimpl].Spec.Blueprint)
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
				Signal.CapImpl[capimpl].Spec.Blueprint=fillBlueprintspec(Signal.CapImpl[capimpl].Spec.Blueprint)
			}
		}

		claim.Signal=Signal

	case 3:

	case 4:
		//ImplBlock
		Impl := claim.ImplBlock
		Impl.Spec.Imprint = imprint.GenerateRandImprint()
		Impl.Spec.Blueprint=fillBlueprintspec(Impl.Spec.Blueprint)

		claim.ImplBlock=Impl
	}
	return claim
}
func fillBlueprintspec(blueprint* common.BlueprintSpec)*common.BlueprintSpec{
	if blueprint==nil{
		return blueprint
	}
	if blueprint.DataOutputDocker!=nil{
		for index := range blueprint.DataOutputDocker {
			if blueprint.DataOutputDocker[index] !=nil {
				blueprint.DataOutputDocker[index].Imprint=imprint.GenerateRandImprint()
			}
		}
	}

	if blueprint.DataInputDocker!=nil{
		for index := range blueprint.DataInputDocker {
			if blueprint.DataInputDocker[index] !=nil {
				blueprint.DataInputDocker[index].Imprint=imprint.GenerateRandImprint()
			}
		}
	}

	if blueprint.SignalOutputDocker!=nil{
		for index := range blueprint.SignalOutputDocker {
			if blueprint.SignalOutputDocker[index] !=nil {
				blueprint.SignalOutputDocker[index].Imprint=imprint.GenerateRandImprint()
			}
		}
	}

	if blueprint.SignalInputDocker!=nil{
		for index := range blueprint.SignalInputDocker {
			if blueprint.SignalInputDocker[index] !=nil {
				blueprint.SignalInputDocker[index].Imprint=imprint.GenerateRandImprint()
			}
		}
	}

	return blueprint
}
func FillBlueprintspec(blueprint* common.BlueprintSpec)*common.BlueprintSpec{
	return fillBlueprintspec(blueprint)
}