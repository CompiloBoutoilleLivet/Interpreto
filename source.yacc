%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "lex.yy.h"
#include "instructionmanager/instructions.h"

extern int line;
int yyerror (char *s);

%}

%union
{
    int number;
}

%token tADD tMUL tSOU tDIV
%token tCOP tAFC
%token tJMP tJMF
%token tINF tSUP tEQU
%token tPRI
%token tBEGIN_ADDRESS tEND_ADDRESS tBEGIN_LABEL tLABEL_END tEND_LINE tDELIMITEUR
%token <number> tNUMBER

%start Operations
%type <number> Address
%type <number> Label

%%

Operations : /* empty */
            | Operations Addition tEND_LINE 
            | Operations Multiplication tEND_LINE 
            | Operations Soustraction tEND_LINE 
            | Operations Division tEND_LINE 
            | Operations Copie tEND_LINE 
            | Operations Affectation tEND_LINE 
            | Operations Saut tEND_LINE 
            | Operations SautConditionel tEND_LINE 
            | Operations ComparaisonInf tEND_LINE 
            | Operations ComparaisonSup tEND_LINE 
            | Operations ComparaisonEq tEND_LINE 
            | Operations Imprimer tEND_LINE 
            | Operations DeclareLabel tEND_LINE
            ;

Address : tBEGIN_ADDRESS tNUMBER tEND_ADDRESS
        {
            $$ = $2;
        }
        ;

Label : tBEGIN_LABEL tNUMBER
        {
            $$ = $2;
        }
        ;

DeclareLabel : Label tLABEL_END
        {

        }

Addition : tADD Address tDELIMITEUR Address tDELIMITEUR Address
        {
        }

Multiplication : tMUL Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

Soustraction : tSOU Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

Division : tDIV Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

Copie : tCOP Address tDELIMITEUR Address 
        {

        }

Affectation : tAFC Address tDELIMITEUR tNUMBER 
        {

        }

Saut : tJMP Label
        {

        }

SautConditionel : tJMF Address tDELIMITEUR Label
        {

        }

ComparaisonSup : tSUP Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

ComparaisonInf : tINF Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

ComparaisonEq : tEQU Address tDELIMITEUR Address tDELIMITEUR Address
        {

        }

Imprimer : tPRI Address 
        {

        }

%%

int yyerror (char *s) {
        fprintf (stderr, "line %d: %s\n", line, s);
        exit(-1);
}
