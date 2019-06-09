%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

void handle_port_occurence(int port);

struct PortStorage {
  int port, occurence;
  struct PortStorage *next;
};

struct PortStorage *head = NULL;

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
    | T_PROTO T_WHITESPACE T_NUMBER T_WHITESPACE T_NUMBER T_WHITESPACE T_IP T_COLON T_NUMBER T_WHITESPACE T_IP T_COLON T_NUMBER T_WHITESPACE T_STATE T_WHITESPACE pid_per_program T_NEWLINE {handle_port_occurence($13); ++valid_lines; }
    | error T_NEWLINE { yyerrok; }

pid_per_program:
    T_NUMBER T_PER words

words:
    T_WORD
    | T_WORD T_WHITESPACE T_WORD

%%

int main(int argc, char** argv) {

  if (argc != 1) {
    if(!(yyin = fopen(argv[1], "r"))) {
      fprintf(stderr, "Failed to open source file!\n");
      exit(1);
    }
  } else {
	  yyin = stdin;
    fprintf(stdout, "Welcome to the netstat -apn output parser. Please type your first analyzed line!\n");
  }
	do {
		yyparse();
	} while(!feof(yyin));
  fprintf(stdout, "Valid lines %i\n", valid_lines);

  if (head != NULL) {
    fprintf(stdout, "Result:");
    struct PortStorage *current = head;
    while (current != NULL) {
      fprintf(stderr, "Port: %i, Occurence: %i\n", current->port, current->occurence);
      current = current->next;
    }
  }
	return 0;
}

void yyerror(const char* s) {
}

void handle_port_occurence(int port) {
  fprintf(stderr, "Port arrived: %i\n", port);
  if (head == NULL) {
    fprintf(stderr, "Hat a head nagyon null!\n");
    head = (struct PortStorage*) malloc(sizeof(struct PortStorage));
    head->port = port;
    head->occurence = 1;
  } else {
    struct PortStorage *current = head;
    while (current != NULL) {
      if (current->port == port) {
        current->occurence++;
        return;
      }
      if (current->next == NULL) {
        break;
      }
      current = current->next;
    }
    struct PortStorage *next = (struct PortStorage*) malloc(sizeof(struct PortStorage));
    next->port = port;
    next->occurence = 1;
    current->next = next;
  }
}
