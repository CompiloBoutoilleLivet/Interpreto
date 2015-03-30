%{
#include <stdio.h>
#include "y.tab.h"
int line = 1;
%}

%option nounput

WHITESPACE [ \t]
ENDLINE [\n]+
NUMBER [0-9]+
ID [a-zA-Z][a-zA-Z0-9_]*

%%

{WHITESPACE}    {};
{ENDLINE} 		{
					line++; 
					return tEND_LINE;
				};
"[$"			{return tBEGIN_ADDRESS;};
"]"				{return tEND_ADDRESS;};
{NUMBER}		{
					yylval.number = atoi(yytext);
					return tNUMBER;
				};
":"				{return tLABEL_END;};
","				{return tDELIMITEUR;};
add 			{return tADD;};
mul				{return tMUL;};
sou				{return tSOU;};
div				{return tDIV;};
cop				{return tCOP;};
afc				{return tAFC;};
jmp				{return tJMP;};
jmf				{return tJMF;};
inf				{return tINF;};
sup				{return tSUP;};
equ				{return tEQU;};
pri				{return tPRI;};
stop			{return tSTOP;};
{ID}			{
					yylval.id = strdup(yytext);
					return tID;
				};


%%
