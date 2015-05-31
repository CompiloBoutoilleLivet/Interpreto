	afc bp, 0
	afc sp, 0
	call main
	stop
fibo:
	push bp
	cop bp, sp
	add sp, sp, 5
	cop [bp+1], [bp+-3]
	afc [bp+2], 1
	inf [bp+3], [bp+1], [bp+2]
	jmf [bp+3], label_0002
	jmp label_0001
label_0002:
	equ [bp+3], [bp+1], [bp+2]
	jmf [bp+3], label_0000
label_0001:
	cop [bp+2], [bp+-3]
	afc rt, [bp+2]
	jmp fibo_end
	jmp label_0003
label_0000:
	cop [bp+2], [bp+-3]
	afc [bp+3], 1
	sou [bp+2], [bp+2], [bp+3]
	push [bp+2]
	call fibo
	afc [bp+2], rt
	cop [bp+3], [bp+-3]
	afc [bp+4], 2
	sou [bp+3], [bp+3], [bp+4]
	push [bp+3]
	call fibo
	afc [bp+3], rt
	add [bp+2], [bp+2], [bp+3]
	afc rt, [bp+2]
	jmp fibo_end
label_0003:
fibo_end:
	leave
	ret
main:
	push bp
	cop bp, sp
	add sp, sp, 5
	afc [bp+1], 0
	cop [bp+1], [bp+1]
label_0004:
	cop [bp+2], [bp+1]
	afc [bp+3], 30
	inf [bp+2], [bp+2], [bp+3]
	jmf [bp+2], label_0005
	cop [bp+3], [bp+1]
	push [bp+3]
	call fibo
	afc [bp+3], rt
	pri [bp+3]
	cop [bp+3], [bp+1]
	afc [bp+4], 1
	add [bp+3], [bp+3], [bp+4]
	cop [bp+1], [bp+3]
	jmp label_0004
label_0005:
main_end:
	leave
	ret
