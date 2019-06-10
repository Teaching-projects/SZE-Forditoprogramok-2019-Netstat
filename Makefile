all: netstat_parser

netstat.tab.c netstat.tab.h:	netstat.y
	bison -d netstat.y

lex.yy.c: netstat.l netstat.tab.h
	flex netstat.l

netstat_parser: lex.yy.c netstat.tab.c netstat.tab.h
	gcc -o netstat_parser netstat.tab.c lex.yy.c

clean:
	rm netstat_parser netstat.tab.c lex.yy.c netstat.tab.h
