ASM=as
LNK=gcc

lab1: source.s
	$(ASM) -o lab2.o source.s
	$(LNK) -o lab2 lab2.o
