
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "instructionmanager/instructions.h"
#include "cpu.h"

struct cpu * cpu_init(struct instr_manager *man)
{
	int i;
	struct cpu *cpu = malloc(sizeof(struct cpu));

	cpu->rom = man;
	cpu->pc = man->first;
	cpu->stop = 0;

	for(i=0; i<MEM_SIZE; i++)
	{
		cpu->memory[i] = 0;
	}

	for(i=0; i<NUM_REG; i++)
	{
		cpu->regs[i] = 0;
	}

	return cpu;
}

void cpu_reset(struct cpu *cpu)
{
	int i;
	cpu->pc = cpu->rom->first;
	cpu->stop = 0;

	for(i=0; i<MEM_SIZE; i++)
	{
		cpu->memory[i] = 0;
	}
}

void cpu_run(struct cpu *cpu)
{
	struct instr *current;
	while(cpu->pc != NULL && cpu->stop == 0)
	{
		current = cpu->pc;
		cpu_exec_instr(cpu, current);
		cpu->pc = cpu->pc->next;
		assert(cpu->regs[SP_REG] <= MEM_SIZE);
		assert(cpu->regs[BP_REG] <= MEM_SIZE);
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

void cpu_register_dump(struct cpu *cpu)
{
	int i;
	for(i=0; i<NUM_REG; i++)
	{
		printf("%02d : %s : %08X\n", i, instr_int_to_reg(i), cpu->regs[i]);
	}
}

void cpu_push_stack(struct cpu *cpu, int v)
{
	cpu->memory[cpu->regs[SP_REG]] = v;
	cpu->regs[SP_REG]++;
}

int cpu_pop_stack(struct cpu *cpu)
{
	int ret = cpu->memory[cpu->regs[SP_REG]];
	cpu->regs[SP_REG]--;
	return ret;
}

void cpu_exec_instr(struct cpu *cpu, struct instr *i)
{
	int reg, val1, val2;

	switch(i->type)
	{

		case COP_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]];
			break;

		case COP_REG_INSTR:
			cpu->regs[i->params[0]] = cpu->regs[i->params[1]];
			break;

		case COP_REL_REG_INSTR:
			cpu->memory[cpu->regs[i->params[0]] + i->params[1]] = cpu->memory[cpu->regs[i->params[2]] + i->params[3]];
			break;

		case AFC_INSTR:
			cpu->memory[i->params[0]] = i->params[1];
			break;

		case AFC_REG_INSTR:
			cpu->regs[i->params[0]] = i->params[1];
			break;

		case AFC_REL_REG_INSTR:
			cpu->memory[cpu->regs[i->params[0]] + i->params[1]] = i->params[2];
			break;

		case AFC_REG_MEM_INSTR:
			cpu->regs[i->params[0]] = cpu->memory[cpu->regs[i->params[1]] + i->params[2]];
			break;

		case AFC_MEM_REG_INSTR:
			cpu->memory[cpu->regs[i->params[0]] + i->params[1]] = cpu->regs[i->params[2]];
			break;

		case ADD_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] + cpu->memory[i->params[2]];
			break;

		case ADD_REG_VAL_INSTR:
			cpu->regs[i->params[0]] = cpu->regs[i->params[1]] + i->params[2];
			break;

		case ADD_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			cpu->memory[reg + i->params[1]] = val1 + val2;
			break;

		case MUL_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] * cpu->memory[i->params[2]];
			break;

		case MUL_REG_VAL_INSTR:
			cpu->regs[i->params[0]] = cpu->regs[i->params[1]] * i->params[2];
			break;

		case MUL_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			cpu->memory[reg + i->params[1]] = val1 * val2;
			break;

		case SOU_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] - cpu->memory[i->params[2]];
			break;

		case SOU_REG_VAL_INSTR:
			cpu->regs[i->params[0]] = cpu->regs[i->params[1]] - i->params[2];
			break;

		case SOU_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			cpu->memory[reg + i->params[1]] = cpu->memory[reg + i->params[2]] - cpu->memory[reg + i->params[3]];
			break;

		case DIV_INSTR:
			cpu->memory[i->params[0]] = cpu->memory[i->params[1]] / cpu->memory[i->params[2]];
			break;

		case DIV_REG_VAL_INSTR:
			cpu->regs[i->params[0]] = cpu->regs[i->params[1]] / i->params[2];
			break;

		case DIV_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			cpu->memory[reg + i->params[1]] = val1 / val2;
			break;

		case PRI_INSTR:
			printf("%d\n", cpu->memory[i->params[0]]);
			break;

		case PRI_REL_REG_INSTR:
			printf("%d\n", cpu->memory[cpu->regs[i->params[0]] + i->params[1]]);
			break;

		case INF_INSTR:
			if(cpu->memory[i->params[1]] < cpu->memory[i->params[2]])
			{
				cpu->memory[i->params[0]] = 1;
			} else {
				cpu->memory[i->params[0]] = 0;
			}
			break;

		case INF_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			if(val1 < val2)
			{
				cpu->memory[reg + i->params[1]] = 1;
			} else {
				cpu->memory[reg + i->params[1]] = 0;
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

		case SUP_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			if(val1 < val2)
			{
				cpu->memory[reg + i->params[1]] = 1;
			} else {
				cpu->memory[reg + i->params[1]] = 0;
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

		case EQU_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			val1 = cpu->memory[reg + i->params[2]];
			val2 = cpu->memory[reg + i->params[3]];
			if(val1 == val2)
			{
				cpu->memory[reg + i->params[1]] = 1;
			} else {
				cpu->memory[reg + i->params[1]] = 0;
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

		case JMF_REL_REG_INSTR:
			reg = cpu->regs[i->params[0]];
			if(cpu->memory[reg + i->params[1]] == 0)
			{
				cpu->pc = label_table_get_label(i->params[2])->instr;
			}
			break;

		case PUSH_INSTR:
			cpu_push_stack(cpu, i->params[0]);
			break;

		case PUSH_REL_REG_INSTR:
			cpu_push_stack(cpu, cpu->memory[cpu->regs[i->params[0]] + i->params[1]]);
			break;

		case PUSH_REG_INSTR:
			cpu_push_stack(cpu, cpu->regs[i->params[0]]);
			break;

		case POP_INSTR:
			printf("flemme :)\n");
			break;

		case CALL_INSTR:
			cpu_push_stack(cpu, cpu->pc->instr_number+1);
			cpu->pc = label_table_get_label(i->params[0])->instr;
			break;

		case LEAVE_INSTR:

			cpu->regs[SP_REG] = cpu->regs[BP_REG];
			cpu_pop_stack(cpu);
			cpu->regs[BP_REG] = cpu_pop_stack(cpu);
			break;

		case RET_INSTR:
			val1 = cpu_pop_stack(cpu);
			cpu->pc = instr_get_instr_by_num(val1-1);
			break;

		case STOP_INSTR:
			cpu->stop = 1;
			break;

		// default:
		// 	printf("Unknown instruction\n");
		// 	exit(EXIT_FAILURE);
		// 	break;

	}
}
