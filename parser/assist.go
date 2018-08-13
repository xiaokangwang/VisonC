package parser

import "bufio"

type lexer struct {
	buf bufio.Reader
	c   byte
}

func (lx *lexer) next() {
	lx.c, _ = lx.buf.ReadByte()
}
