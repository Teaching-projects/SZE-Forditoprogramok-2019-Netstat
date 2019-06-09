%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

int valid_lines = 0;

%}

%union {
	char* ip;
	int num;
}

%token <num> T_NUMBER
%token <ip> T_IP
%token T_PROTO T_STATE T_PER T_WORD
%token T_COLON T_WHITESPACE T_NEWLINE T_ELSE

%start analyze
%%

analyze:
       | analyze line

line:
    T_NEWLINE
    | T_PROTO T_WHITESPACE T_NUMBER T_WHITESPACE T_NUMBER T_WHITESPACE T_IP T_COLON T_NUMBER T_WHITESPACE T_IP T_COLON T_NUMBER T_WHITESPACE T_STATE T_WHITESPACE T_NUMBER T_PER T_WORD T_NEWLINE { fprintf(stderr, "Ip and port that get caught: %s %i\n", $7, $9); ++valid_lines; }
    | error T_NEWLINE { yyerrok; }

%%

int main(int argc, char** argv) {
  if (argc != 1) {
    yyin = fopen(argv[1], "r");
  } else {
	  yyin = stdin;
    fprintf(stdout, "Welcome to the netstat -apn output parser. Please type your first analyzed line!\n");
  }
	do {
		yyparse();
	} while(!feof(yyin));
  fprintf(stdout, "Valid lines %i\n", valid_lines);
	return 0;
}
void yyerror(const char* s) {
}
