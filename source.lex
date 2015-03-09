%{
#include <stdio.h>
int line = 1;
%}

%option nounput

WHITESPACE [ \t]
ENDLINE [\n]+

%x COMMENT
%%

"/*" 			{BEGIN COMMENT;}
<COMMENT>\n 		{line++;}
<COMMENT>[^\*\/] 	{}
<COMMENT>"*/" 	        {BEGIN INITIAL;}


{WHITESPACE}    {};
{ENDLINE} 	{line++;};


%%
