package imprint

import "crypto/rand"

func GenerateRandImprint()[]byte{
	rnt:=make([]byte,8)
	rand.Read(rnt)
	return rnt
}