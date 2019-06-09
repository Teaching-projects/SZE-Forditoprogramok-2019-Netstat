%{

#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
%}

%token T_PROTO T_STATE T_IP T_NUMBER T_PID_PROCESS
%token T_COLON T_WHITESPACE T_NEWLINE

%%

start:
       | start line

line:
    T_NEWLINE
    | T_PROTO T_WHITESPACE T_NUMBER T_WHITESPACE T_NUMBER ip_port T_WHITESPACE ip_port T_WHITESPACE T_STATE T_WHITESPACE T_PID_PROCESS T_NEWLINE

ip_port:
       T_IP T_COLON T_NUMBER
%%
