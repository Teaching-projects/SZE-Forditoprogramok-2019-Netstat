%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

void handle_port_occurence(int port);

typedef struct PortStorage {
  int port, occurence;
  struct PortStorage *next;
} PortStorage_t;

PortStorage_t *head = NULL;

PortStorage_t* initialize_next_port_storage(int port);

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
  fprintf(stdout, "##############\nNumber of accepted lines:  %i\n##############\n", valid_lines);

  if (head != NULL) {
    fprintf(stdout, "The statistic of the outgoing ports is the following:\n");
    struct PortStorage *current = head;
    while (current != NULL) {
      fprintf(stdout, "Port: %i,\tOccurence: %i\n", current->port, current->occurence);
      current = current->next;
    }
  }
	return 0;
}

void yyerror(const char* s) {
}

void handle_port_occurence(int port) {
  if (head == NULL) {
    head = initialize_next_port_storage(port);
  } else {
    PortStorage_t *current = head;
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
    current->next = initialize_next_port_storage(port);
  }
}

PortStorage_t* initialize_next_port_storage(int port) {
    PortStorage_t* next = (PortStorage_t*) malloc(sizeof(struct PortStorage));
    next->port = port;
    next->occurence = 1;
    return next;
}
