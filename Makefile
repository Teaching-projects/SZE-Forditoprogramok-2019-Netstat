all: netstat

netstat.tab.c netstat.tab.h:	netstat.y
	bison -d netstat.y

lex.yy.c: netstat.l netstat.tab.h
	flex netstat.l

netstat: lex.yy.c netstat.tab.c netstat.tab.h
	gcc -v -o netstat netstat.tab.c lex.yy.c

clean:
	rm netstat netstat.tab.c lex.yy.c netstat.tab.h
