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
	int i;
	struct instr *current;
	while(cpu->pc != NULL)
	{
		current = cpu->pc;
		cpu_exec_instr(cpu, current);

		if(current->type != JMP_INSTR || current->type != JMF_INSTR)
		{
			cpu->pc = cpu->pc->next;
		}
	}

	for(i=0; i<MEM_SIZE; i+=4)
	{
		printf("%08x : %08x", i, cpu->memory[i]);
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

	}
}
