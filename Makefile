CC = gcc-11
CFLAGS = -m32 -Wall

.PHONY: build
all: main.o
	$(CC) $(CFLAGS) main.o -o main
	./main

main.o: main.s
	nasm -f elf main.s

.PHONY: clean
clean:
	rm -fr *.o
