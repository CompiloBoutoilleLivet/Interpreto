%{
#include <stdio.h>
#include "y.tab.h"
int line = 1;
%}

%option nounput

WHITESPACE [ \t]
ENDLINE [\n]+
NUMBER [0-9]+
LABEL "label-"

%x COMMENT
%%

"/*" 			{BEGIN COMMENT;}
<COMMENT>\n 		{line++;}
<COMMENT>[^\*\/] 	{}
<COMMENT>"*/" 	        {BEGIN INITIAL;}


{WHITESPACE}    {};
{ENDLINE} 		{line++;};
"[$"			{return tBEGIN_ADDRESS;};
"]"				{return tEND_ADDRESS;};
{LABEL}			{return tBEGIN_LABEL;};
{NUMBER}		{return tNUMBER;};
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
