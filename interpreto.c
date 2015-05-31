#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "lex.yy.h"
#include "instructionmanager/instructions.h"
#include "cpu.h"

extern int line;
extern int yydebug;
void yyparse();

#define LINE_SIZE 32

void print_usage(char *s)
{
    printf("usage : %s \n", s);
    printf("\t -h \t\t print this help\n");
    printf("\t -d \t\t enable parser debug\n");
    printf("\t -f <filename>\t filename to parse\n");
    printf("\t\t\t if -f is not specified, stdin is parsed\n");
    printf("\t -m \t\t enable dumping memory\n");
    printf("\t -i \t\t enable interactive mode\n");
}

void interprete(struct cpu *cpu)
{
    cpu_run(cpu);
}

void interprete_interactive(struct cpu *cpu)
{
    char line[LINE_SIZE] = {0};

    do
    {
        if(strlen(line) != 0 && line[0] != '\n')
        {
            line[strlen(line)-1] = '\0';
            
            if(strcmp(line, "help") == 0)
            {
                printf("commands :\n");
                printf("r \t run de program\n");
                printf("reset \t reset the cpu state\n");
                printf("disas \t print instructions of program\n");
                printf("dump \t dump the memory\n");
                printf("q \t quit\n");
            }
            else if(strcmp(line, "r") == 0)
            {
                if(cpu->pc == NULL)
                {
                    printf("pc is at the end - do 'reset' to reset the state of the cpu\n");
                } else {
                    cpu_run(cpu);
                }
            }
            else if(strcmp(line, "reset") == 0)
            {
                cpu_reset(cpu);
                printf("cpu reset !\n");
            }
            else if(strcmp(line, "disas") == 0)
            {
                instr_manager_print_textual(1);
            }
            else if(strcmp(line, "s") == 0)
            {
                if(cpu->pc == NULL)
                {
                    printf("pc is at the end - do 'reset' to reset the state of the cpu\n");
                } else {
                    instr_manager_print_instr(cpu->pc, 1);
                    cpu_exec_instr(cpu, cpu->pc);
                    cpu->pc = cpu->pc->next;
                }
            }
            else if (strcmp(line, "dump") == 0)
            {
                cpu_memdump(cpu);
            }
            else if (strcmp(line, "regs") == 0)
            {
                cpu_register_dump(cpu);
            }
            else if(strcmp(line, "q") == 0)
            {
                printf("bye !\n");
                break;
            } else {
                printf("'%s' command not found\n", line);
            }
        }

        printf("(interpreto $) ");
    } while((fgets(line, LINE_SIZE, stdin)) != NULL);
}

int main(int argc, char **argv)
{
    int dflag = 0;
    int mflag = 0;
    int iflag = 0;
    char *filename_in = NULL;
    FILE *fin = NULL;
    int c = 0;
    struct cpu *cpu = NULL;

    while((c = getopt(argc, argv, "hd::m::i::f:")) != -1)
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

            case 'm': // memory
                mflag = 1;
                break;

            case 'i': // interactive
                iflag = 1;
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

    cpu = cpu_init(instr_manager_get());
    if(iflag)
    {
        interprete_interactive(cpu);
    } else {
        printf("[+] Execute program ... \n");
        interprete(cpu);
    }
    

    if(mflag)
    {
        printf("[+] Memory dump at the end : \n");
        cpu_memdump(cpu);
    }

	return EXIT_SUCCESS;
}
