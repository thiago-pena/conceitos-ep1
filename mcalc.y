/* Calculadora infixa */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char *oper(char op, char *l, char *r) {
	char *res = malloc(strlen(l)+strlen(r)+6);
	sprintf(res, "(%c %s %s)", op, l, r);
	return res;
}
char *dup(char *orig) {
	char *res = malloc(strlen(orig)+1);
	strcpy(res,orig);
	return res;
}
char *testePena(char *l, char *r) {
	char *res = malloc(strlen(l) + strlen(r) + 1);
	printf("-------------\n");
	sprintf(res, "'(%s %s)", l, r);
	return res;
}
int yylex();
void yyerror(char *);
%}

%union {
	char *val;
}

%token	<val> NUM
/* %token  ADD SUB MUL PRINT OPEN CLOSE */
%token ADD SUB MUL DIV PRINT OPEN CLOSE
%type <val> exp
%token <val> FUNC

%left ADD SUB
%left MUL DIV
%left NEG
// checar precedências daqui pra baixo


/* Gramatica */
%%

input:
		| 		exp     { puts($1);}
		| 		error  	{ fprintf(stderr, "Entrada inválida\n"); }
;

exp: 			NUM 			{ $$ = dup($1); }
		| 		exp ADD exp		{ $$ = oper('+', $1, $3);}
		| 		exp SUB exp		{ $$ = oper('-', $1, $3);}
		| 		exp MUL exp		{ $$ = oper('*', $1, $3);}
		| 		exp DIV exp		{ $$ = oper('/', $1, $3);}
		| 		SUB exp %prec NEG  { $$ = oper('~', $2, "");}
		| 		OPEN exp CLOSE	{ $$ = dup($2);}
;

%%

void yyerror(char *s) {
  fprintf(stderr,"%s\n",s);
}
