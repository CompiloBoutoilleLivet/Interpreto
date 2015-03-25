	afc [$0], 0
	cop [$0], [$0]
	afc [$1], 1
	cop [$1], [$1]
	afc [$2], 2
	cop [$2], [$2]
	afc [$3], 0
	cop [$3], [$3]
	afc [$4], 1337
	cop [$4], [$4]
label_0000:
	cop [$5], [$3]
	afc [$6], 20
	inf [$7], [$5], [$6]
	jmf [$7], label_0003
	jmp label_0002
label_0003:
	equ [$7], [$5], [$6]
	jmf [$7], label_0001
label_0002:
	cop [$5], [$3]
	afc [$6], 20
	sup [$7], [$5], [$6]
	jmf [$7], label_0006
	jmp label_0005
label_0006:
	equ [$7], [$5], [$6]
	jmf [$7], label_0004
label_0005:
	cop [$5], [$2]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
	jmp label_0007
label_0004:
	cop [$5], [$3]
	afc [$6], 10
	sup [$7], [$5], [$6]
	jmf [$7], label_000A
	jmp label_0009
label_000A:
	equ [$7], [$5], [$6]
	jmf [$7], label_0008
label_0009:
	cop [$5], [$1]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
	jmp label_000B
label_0008:
	cop [$5], [$0]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
label_000B:
label_0007:
	cop [$5], [$3]
	afc [$6], 1
	add [$5], [$5], [$6]
	cop [$3], [$5]
	jmp label_0000
label_0001:
