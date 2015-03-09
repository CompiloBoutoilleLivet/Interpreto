	afc [$1], 1337
	cop [$1], [$1]
label-1:
	cop [$2], [$0]
	afc [$3], 10
	inf [$2], [$2], [$3]
	jmf [$2], label-2
	cop [$2], [$0]
	afc [$3], 5
	equ [$2], [$2], [$3]
	jmf [$2], label-3
	cop [$2], [$1]
	pri [$2]
	jmp label-4
label-3:
	cop [$2], [$0]
	pri [$2]
label-4:
	cop [$2], [$0]
	afc [$3], 1
	add [$2], [$2], [$3]
	cop [$0], [$2]
	jmp label-1
label-2:
