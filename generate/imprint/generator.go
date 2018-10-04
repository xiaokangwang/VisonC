package imprint

import "crypto/rand"

func GenerateRandImprint()[]btye{
	rnt:=make([]byte,256)
	rand.Read(rnt)
	return rnt
}