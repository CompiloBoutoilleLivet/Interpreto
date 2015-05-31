%{
#include <stdio.h>
#include "interpreto.h"
#include "y.tab.h"
int line = 1;
%}

%option nounput

WHITESPACE [ \t]
ENDLINE [\n]+
NUMBER [-]*[0-9]+
ID [a-zA-Z][a-zA-Z0-9_]*

%%

{WHITESPACE}    {};
{ENDLINE} 		{
					line++; 
					return tEND_LINE;
				};
{NUMBER}		{
					yylval.number = atoi(yytext);
					return tNUMBER;
				};
"+"				{return tPLUS;};
"["				{return tBRACKET_OPEN;};
"]"				{return tBRACKET_CLOSE;};
":"				{return tLABEL_END;};
","				{return tCOMA;};
"$"				{return tDOLLAR;};
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
call			{return tCALL;};
leave			{return tLEAVE;};
ret 			{return tRET;};
stop			{return tSTOP;};
push			{return tPUSH;};
{ID}			{
					yylval.id = strdup(yytext);
					return tID;
				};


%%
