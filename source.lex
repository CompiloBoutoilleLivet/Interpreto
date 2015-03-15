%{
#include <stdio.h>
#include "y.tab.h"
int line = 1;
%}

%option nounput

WHITESPACE [ \t]
ENDLINE [\n]+
NUMBER [0-9]+
LABEL "label_"

%%

{WHITESPACE}    {};
{ENDLINE} 		{
					line++; 
					return tEND_LINE;
				};
"[$"			{return tBEGIN_ADDRESS;};
"]"				{return tEND_ADDRESS;};
{LABEL}			{return tBEGIN_LABEL;};
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

%%
