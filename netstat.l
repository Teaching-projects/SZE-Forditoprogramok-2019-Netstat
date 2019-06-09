%option noyywrap
%{
#include <stdio.h>

#include "netstat.tab.h"
%}

DIGIT [0-9]
WORD [a-zA-Z_]

%%
"tcp"|"tcp6"|"udp"|"udp6"                               {return T_PROTO;}
"ESTABLISHED"|"LISTEN"|"TIME_WAIT"|"CLOSE_WAIT"         {return T_STATE;}
":"                                                     {return T_COLON;}
{DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}  {
                                                          yylval.ip = malloc(strlen(yytext));
                                                          strncpy(yylval.ip, yytext, strlen(yytext));
                                                          return T_IP;
                                                        }
{DIGIT}+                                                {
                                                          yylval.num = atoi(yytext);
                                                          return T_NUMBER;
                                                        }
"/"                                                     {return T_PER;}
[ \t]+                                                  {return T_WHITESPACE;}
\n                                                      {return T_NEWLINE;}
{WORD}+                                                 {return T_WORD;}
.                                                       {return T_ELSE;}
%%

