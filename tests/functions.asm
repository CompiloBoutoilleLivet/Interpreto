	afc bp, 255
	afc sp, 255
	call main
	stop
get:
	push bp
	cop bp, sp
	sou sp, sp, 2
	cop [bp+1], [bp+-2]
	afc [bp+2], 1
	equ [bp+1], [bp+1], [bp+2]
	jmf [bp+1], label_0000
	afc [bp+2], 1
	afc rt, [bp+2]
	jmp get_end
	jmp label_0001
label_0000:
label_0001:
	afc [bp+1], 0
	afc rt, [bp+1]
	jmp get_end
get_end:
	leave
	ret
main:
	push bp
	cop bp, sp
	sou sp, sp, 2
	afc [bp+1], 1
	push [bp+1]
	call get
	add sp, sp, 1
	afc [bp+1], rt
	afc [bp+2], 0
	push [bp+2]
	call get
	add sp, sp, 1
	afc [bp+2], rt
	add [bp+1], [bp+1], [bp+2]
	cop [bp+1], [bp+1]
main_end:
	leave
	ret
