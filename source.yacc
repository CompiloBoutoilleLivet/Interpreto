%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "interpreto.h"
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
    struct reg_offset reg_offset;
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

%type <reg_offset> RegOffset
%type <number> Reg
%type <number> Label
%type <number> DeclareLabel
%type <number> Address

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

RegOffset : tBRACKET_OPEN Reg tPLUS tNUMBER tBRACKET_CLOSE { 
        struct reg_offset ret = {$2, $4};
        $$ = ret;
    };
Reg : tID { $$ = instr_reg_to_int($1); }
Label : tID { $$ = label_table_hash_string($1); }
DeclareLabel : tID tLABEL_END { $$ = label_add($1); instr_emit_label($$); }
Address : tBRACKET_OPEN tDOLLAR tNUMBER tBRACKET_CLOSE { $$ = $3; }

Afc  : tAFC Address tCOMA tNUMBER { instr_emit_afc($2, $4); }
     | tAFC Reg tCOMA tNUMBER { instr_emit_afc_reg($2, $4); }
     | tAFC Reg tCOMA RegOffset { instr_emit_afc_reg_mem($2, $4.reg, $4.off); }
     | tAFC RegOffset tCOMA tNUMBER { instr_emit_afc_rel_reg($2.reg, $2.off, $4); }
     | tAFC RegOffset tCOMA Reg { instr_emit_afc_mem_reg($2.reg, $2.off, $4); }

Cop : tCOP Address tCOMA Address { instr_emit_cop($2, $4); }
    | tCOP Reg tCOMA Reg { instr_emit_cop_reg($2, $4); }
    | tCOP RegOffset tCOMA RegOffset { instr_emit_cop_rel_reg($2.reg, $2.off, $4.reg, $4.off); }

Push : tPUSH Reg { instr_emit_push_reg($2); }
     | tPUSH RegOffset { instr_emit_push_rel_reg($2.reg, $2.off); }

Call : tCALL Label { instr_emit_call($2); }
Leave : tLEAVE { instr_emit_leave(); }
Ret : tRET { instr_emit_ret(); }

Stop : tSTOP { instr_emit_stop(); }

Equ : tEQU RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_equ_rel_reg($2.reg, $2.off, $4.off, $6.off); }
    | tEQU Address tCOMA Address tCOMA Address { instr_emit_equ($2, $4, $6); }

Inf : tINF RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_inf_rel_reg($2.reg, $2.off, $4.off, $6.off); }
    | tINF Address tCOMA Address tCOMA Address { instr_emit_inf($2, $4, $6); }

Sup : tSUP RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_sup_rel_reg($2.reg, $2.off, $4.off, $6.off); }
    | tSUP Address tCOMA Address tCOMA Address { instr_emit_sup($2, $4, $6); }


Jmp : tJMP Label { instr_emit_jmp($2); }
Jmf : tJMF RegOffset tCOMA Label { instr_emit_jmf_rel_reg($2.reg, $2.off, $4); }
    | tJMF Address tCOMA Label { instr_emit_jmf($2, $4); }

Sou : tSOU Address tCOMA Address tCOMA Address { instr_emit_sou($2, $4, $6); }
    | tSOU Reg tCOMA Reg tCOMA tNUMBER { instr_emit_sou_reg_val($2, $4, $6); }
    | tSOU RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_sou_rel_reg($2.reg, $2.off, $4.off, $6.off); }

Add : tADD Address tCOMA Address tCOMA Address { instr_emit_add($2, $4, $6); }
    | tADD Reg tCOMA Reg tCOMA tNUMBER { instr_emit_add_reg_val($2, $4, $6); }
    | tADD RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_add_rel_reg($2.reg, $2.off, $4.off, $6.off); }

Div : tDIV Address tCOMA Address tCOMA Address { instr_emit_div($2, $4, $6); }
    | tDIV Reg tCOMA Reg tCOMA tNUMBER { instr_emit_div_reg_val($2, $4, $6); }
    | tDIV RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_div_rel_reg($2.reg, $2.off, $4.off, $6.off); }

Mul : tMUL Address tCOMA Address tCOMA Address { instr_emit_mul($2, $4, $6); }
    | tMUL Reg tCOMA Reg tCOMA tNUMBER { instr_emit_mul_reg_val($2, $4, $6); }
    | tMUL RegOffset tCOMA RegOffset tCOMA RegOffset { instr_emit_mul_rel_reg($2.reg, $2.off, $4.off, $6.off); }

Pri : tPRI Address { instr_emit_pri($2); }
    | tPRI RegOffset { instr_emit_pri_rel_reg($2.reg, $2.off); }

%%

int yyerror (char *s) {
        fprintf (stderr, "line %d: %s\n", line, s);
        exit(-1);
}
