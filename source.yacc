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

%token tADD tMUL tSOU tDIV
%token tCOP tAFC
%token tJMP tJMF
%token tINF tSUP tEQU
%token tPRI
%token tBEGIN_ADDRESS tEND_ADDRESS tLABEL_END tEND_LINE tDELIMITEUR
%token <id> tID
%token <number> tNUMBER

%start Operations
%type <number> Address

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

DeclareLabel : tID tLABEL_END
        {
                int l = label_add($1);
                instr_emit_label(l);
        }
        ;

Addition : tADD Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_add($2, $4, $6);
        }
        ;

Multiplication : tMUL Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_mul($2, $4, $6);
        }
        ;

Soustraction : tSOU Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_sou($2, $4, $6);
        }
        ;

Division : tDIV Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_div($2, $4, $6);
        }
        ;

Copie : tCOP Address tDELIMITEUR Address 
        {
                instr_emit_cop($2, $4);
        }
        ;

Affectation : tAFC Address tDELIMITEUR tNUMBER 
        {
                instr_emit_afc($2, $4);
        }
        ;

Saut : tJMP tID
        {
                instr_emit_jmp(label_table_hash_string($2));
        }
        ;

SautConditionel : tJMF Address tDELIMITEUR tID
        {
                instr_emit_jmf($2, label_table_hash_string($4));
        }
        ;

ComparaisonSup : tSUP Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_sup($2, $4, $6);
        }
        ;

ComparaisonInf : tINF Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_inf($2, $4, $6);
        }
        ;

ComparaisonEq : tEQU Address tDELIMITEUR Address tDELIMITEUR Address
        {
                instr_emit_equ($2, $4, $6);
        }
        ;

Imprimer : tPRI Address 
        {
                instr_emit_pri($2);
        }
        ;

%%

int yyerror (char *s) {
        fprintf (stderr, "line %d: %s\n", line, s);
        exit(-1);
}
