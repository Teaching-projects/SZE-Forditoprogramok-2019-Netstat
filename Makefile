SRCS = main.c netstat.c
CC = gcc

lexer:
	flex netstat.l

compile: lexer
	$(CC) lex.yy.c -o netstat_result_parser -ll

clean:
	rm lex.yy.c netstat_result_parser
