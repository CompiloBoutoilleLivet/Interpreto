%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "lex.yy.h"

extern int line;
int yyerror (char *s);

%}

%union
{
}

%token tADD tMUL tSOU tDIV
%token tCOP tAFC
%token tJMP tJMF
%token tINF tSUP tEQU
%token tPRI
%token tBEGIN_ADDRESS tEND_ADDRESS tBEGIN_LABEL tLABEL_END tNUMBER tEND_LINE tDELIMITEUR

%start Operations

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
            | Operations CallLabel tEND_LINE
            ;

Address : tBEGIN_ADDRESS tNUMBER tEND_ADDRESS

Label : tBEGIN_LABEL tNUMBER 

CallLabel : Label tLABEL_END
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

void print_usage(char *s)
{
    printf("usage : %s \n", s);
    printf("\t -h \t\t print this help\n");
    printf("\t -d \t\t enable parser debug\n");
    printf("\t -s \t\t enable symtab debug\n");
    printf("\t -f <filename>\t filename to parse\n");
    printf("\t\t\t if -f is not specified, stdin is parsed\n");
}

int main(int argc, char **argv) {
    int dflag = 0;
    int sflag = 0;
    char *filename_in = NULL;
    FILE *fin = NULL;
    int c = 0;

    while((c = getopt(argc, argv, "hd::s::f:S:")) != -1)
    {
        switch(c)
        {
            case 'h':
                print_usage(argv[0]);
                return EXIT_SUCCESS;
                break;

            case 'd': // debug
                dflag = 1;
                break;

            case 's': // symbol debug
                sflag = 1;
                break;

            case 'f': // stdin
                filename_in = optarg;
                break;

            case '?':
                return EXIT_FAILURE;
                break;

        }
    }

    if(dflag)
    {
        yydebug = 1;
    }

    if(filename_in != NULL)
    {
        fin = fopen(filename_in, "r");
        if(fin == NULL)
        {
            printf("[-] %s not found ...\n", filename_in);
            return EXIT_FAILURE;
        }
        printf("[+] Reading from file %s\n", filename_in);
        yyin = fin;
    }

	yyparse();

    if(sflag)
    {
        printf("[+] Number of line(s) = %d\n", line);
    }

	return EXIT_SUCCESS;
}
