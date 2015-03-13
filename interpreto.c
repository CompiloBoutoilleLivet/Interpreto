#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "lex.yy.h"
#include "instructionmanager/instructions.h"
#include "cpu.h"

extern int line;
extern int yydebug;
void yyparse();

void print_usage(char *s)
{
    printf("usage : %s \n", s);
    printf("\t -h \t\t print this help\n");
    printf("\t -d \t\t enable parser debug\n");
    printf("\t -s \t\t enable symtab debug\n");
    printf("\t -f <filename>\t filename to parse\n");
    printf("\t\t\t if -f is not specified, stdin is parsed\n");
}

void interprete()
{
    struct cpu *cpu = cpu_init(instr_manager_get());
    cpu_run(cpu);
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

    instr_manager_init();
	yyparse();

    if(sflag)
    {
        printf("[+] Number of line(s) = %d\n", line);
    }
    interprete();

	return EXIT_SUCCESS;
}
