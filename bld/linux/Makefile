# Makefile for Linux platform
#
# - Expects variable CPU to be defined

BIN	= forth

SRC	= ../../src

all:
	gcc -g -c $(SRC)/linux/forth_linux.c
	gcc -g -static -Wa,-ahlms -Wa,-I$(SRC)/$(CPU)-linux -Wa,-I$(SRC)/$(CPU) -Wa,-I$(SRC)/shared -o $(BIN) $(SRC)/$(CPU)-linux/forth.s forth_linux.o

clean:
	rm -f $(BIN) *.o *~
