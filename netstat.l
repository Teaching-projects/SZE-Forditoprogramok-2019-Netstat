%{
  #include <stdio.h>

  int num_char = 0;
%}
%option noyywrap
%%
.          { ++num_char; }
\n          { ++num_char; }
%%
int main(int argc, char **argv) {
  if(argc < 2){
    fprintf(stderr,"Usage: cat files....\n");
    exit(1);
  }
  yyin = fopen(argv[1],"r");
  if(yyin == NULL){
    fprintf(stderr,"cat: unable to open %s\n",
              argv[1]);
    yyterminate();
  }
  
  yylex();
  fprintf(stdout, "Number of characters in the file %d\n", num_char);
}
