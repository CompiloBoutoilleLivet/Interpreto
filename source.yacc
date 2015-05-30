%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "lex.yy.h"
#include "instructionmanager/label.h"
#include "instructionmanager/instructions.h"

extern int line;
int yyerror (char *s);

%}

%union
{
    int number;
    char *id;
}

%token tAFC tCALL tCOMA tSTOP
%token tPUSH tCOP tBRACKET_OPEN tBRACKET_CLOSE
%token tPLUS tEQU tLEAVE tRET
%token tADD tEND_LINE tLABEL_END tJMP
%token tJMF tSOU tINF tPRI
%token tDOLLAR
%token <id> tID
%token <number> tNUMBER

%token tMUL tDIV tSUP 

%start Operations

%%

Operations : /* empty */
            | Operations Afc tEND_LINE
            | Operations Call tEND_LINE
            | Operations Stop tEND_LINE
            | Operations DeclareLabel tEND_LINE
            | Operations Push tEND_LINE
            | Operations Cop tEND_LINE
            | Operations Sou tEND_LINE
            | Operations Add tEND_LINE
            | Operations Mul tEND_LINE
            | Operations Div tEND_LINE
            | Operations Equ tEND_LINE
            | Operations Inf tEND_LINE
            | Operations Sup tEND_LINE
            | Operations Jmf tEND_LINE
            | Operations Jmp tEND_LINE
            | Operations Leave tEND_LINE
            | Operations Ret tEND_LINE
            | Operations Pri tEND_LINE
            ;

RegOffset : tBRACKET_OPEN tID tPLUS tNUMBER tBRACKET_CLOSE
Reg : tID
Label : tID 
DeclareLabel : tID tLABEL_END
Address : tBRACKET_OPEN tDOLLAR tNUMBER tBRACKET_CLOSE

Afc  : tAFC Address tCOMA tNUMBER
     | tAFC Reg tCOMA tNUMBER
     | tAFC Reg tCOMA RegOffset
     | tAFC RegOffset tCOMA tNUMBER
     | tAFC RegOffset tCOMA Reg

Cop :   tCOP Address tCOMA Address
    | tCOP Reg tCOMA Reg
    | tCOP RegOffset tCOMA RegOffset

Push : tPUSH Reg
     | tPUSH RegOffset

Call : tCALL Label
Leave : tLEAVE
Ret : tRET

Stop : tSTOP

Equ : tEQU RegOffset tCOMA RegOffset tCOMA RegOffset
    | tEQU Address tCOMA Address tCOMA Address

Inf : tINF RegOffset tCOMA RegOffset tCOMA RegOffset
    | tINF Address tCOMA Address tCOMA Address

Sup : tSUP RegOffset tCOMA RegOffset tCOMA RegOffset
    | tSUP Address tCOMA Address tCOMA Address


Jmp : tJMP Label
Jmf : tJMF RegOffset tCOMA Label
    | tJMF Address tCOMA Label

Sou : tSOU Address tCOMA Address tCOMA Address
    | tSOU Reg tCOMA Reg tCOMA tNUMBER
    | tSOU RegOffset tCOMA RegOffset tCOMA RegOffset

Add : tADD Address tCOMA Address tCOMA Address
    | tADD Reg tCOMA Reg tCOMA tNUMBER
    | tADD RegOffset tCOMA RegOffset tCOMA RegOffset

Div : tDIV Address tCOMA Address tCOMA Address
    | tDIV Reg tCOMA Reg tCOMA tNUMBER
    | tDIV RegOffset tCOMA RegOffset tCOMA RegOffset

Mul : tMUL Address tCOMA Address tCOMA Address
    | tMUL Reg tCOMA Reg tCOMA tNUMBER
    | tMUL RegOffset tCOMA RegOffset tCOMA RegOffset

Pri : tPRI Address
    | tPRI RegOffset

%%

int yyerror (char *s) {
        fprintf (stderr, "line %d: %s\n", line, s);
        exit(-1);
}
