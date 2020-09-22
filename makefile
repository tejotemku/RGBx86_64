CC=gcc
main.o: main.c
	$(CC) -m64 -g -std=c99 -c main.c
func.o: func.asm
	nasm -f elf64 -g -F dwarf func.asm
all: main.o func.o
	$(CC) -m64 -g -o main main.o func.o
