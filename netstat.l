%option noyywrap
%{
#include <stdio.h>

#include "netstat.tab.h"
%}

%%
tcp|tcp6|udp|udp6                       {return T_PROTO;}
ESTABLISHED|LISTEN|TIME_WAIT|CLOSE_WAIT {return T_STATE;}
:                                       {return T_COLON;}
\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}           {return T_IP;}
\d{1,5}                                   {return T_NUMBER;}
\d/[a-z]+                                 {return T_PID_PROCESS;}
[ \t]                                     {return T_WHITESPACE;}
\n                                        {return T_NEWLINE;}
%%

