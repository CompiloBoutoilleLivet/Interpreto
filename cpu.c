
#include <stdio.h>
#include <stdlib.h>
#include "instructionmanager/instructions.h"
#include "cpu.h"

struct cpu * cpu_init(struct instr_manager *man)
{
	int i;
	struct cpu *cpu = malloc(sizeof(struct cpu));

	cpu->rom = man;
	cpu->pc = man->first;

	for(i=0; i<MEM_SIZE; i++)
	{
		cpu->memory[i] = 0;
	}

	return cpu;
}

void cpu_run(struct cpu *cpu)
{
	struct instr *current;
	while(cpu->pc != NULL)
	{
		current = cpu->pc;
		cpu_exec_instr(cpu, current);
		cpu->pc = cpu->pc->next;
	}

}

void cpu_memdump(struct cpu *cpu)
{
	int i;
	for(i=0; i<MEM_SIZE; i+=4)
	{
		printf("%08x : %08X", i, cpu->memory[i]);
		printf(" %08X", cpu->memory[i+1]);
		printf(" %08X", cpu->memory[i+2]);
		printf(" %08X\n", cpu->memory[i+3]);
	}
}

void cpu_exec_instr(struct cpu *cpu, struct instr *i)
{

	switch(i->type)
	{

		case COP_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]];
			break;

		case AFC_INSTR:
			cpu->memory[i->params[0]] = i->params[1];
			break;

		case ADD_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] + cpu->memory[i->params[2]];
			break;

		case MUL_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] * cpu->memory[i->params[2]];
			break;

		case SOU_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] - cpu->memory[i->params[2]];
			break;

		case DIV_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] / cpu->memory[i->params[2]];
			break;

		case PRI_INSTR:
			printf("%d\n", cpu->memory[i->params[0]]);
			break;

		case INF_INSTR:
			if(cpu->memory[i->params[1]] < cpu->memory[i->params[2]])
			{
				cpu->memory[i->params[0]] = 1;
			} else {
				cpu->memory[i->params[0]] = 0;
			}
			break;

		case SUP_INSTR:
			if(cpu->memory[i->params[1]] > cpu->memory[i->params[2]])
			{
				cpu->memory[i->params[0]] = 1;
			} else {
				cpu->memory[i->params[0]] = 0;
			}
			break;

		case EQU_INSTR:
			if(cpu->memory[i->params[1]] == cpu->memory[i->params[2]])
			{
				cpu->memory[i->params[0]] = 1;
			} else {
				cpu->memory[i->params[0]] = 0;
			}
			break;

		case LABEL_INSTR:
			// do nothing :) it's a virtual instruction
			break;

		case JMP_INSTR:
		cpu->pc = label_table_get_label(i->params[0])->instr;
			break;

		case JMF_INSTR:
			if(cpu->memory[i->params[0]] == 0)
			{
				cpu->pc = label_table_get_label(i->params[1])->instr;
			}
			break;

	}
}
