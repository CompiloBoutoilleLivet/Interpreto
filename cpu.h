#ifndef CPU_H
#define CPU_H

#define MEM_SIZE 65535
#define NUM_REG 3

struct cpu {
	struct instr_manager *rom;
	struct instr *pc;
	int memory[MEM_SIZE];
	int regs[NUM_REG];
	int stop;
};

struct cpu *cpu_init(struct instr_manager *man);
void cpu_reset(struct cpu *cpu);
void cpu_run(struct cpu *cpu);
void cpu_memdump(struct cpu *cpu);
void cpu_exec_instr(struct cpu *cpu, struct instr *i);
void cpu_register_dump(struct cpu *cpu);
void cpu_register_dump(struct cpu *cpu);

#endif