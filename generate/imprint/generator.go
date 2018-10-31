package imprint

import "crypto/rand"

func GenerateRandImprint()[]byte{
	rnt:=make([]byte,256)
	rand.Read(rnt)
	return rnt
}