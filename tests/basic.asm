	afc [$1], 0
	cop [$1], [$1]
	afc [$2], 1
	cop [$2], [$2]
	afc [$3], 2
	cop [$3], [$3]
	afc [$4], 0
	cop [$4], [$4]
	afc [$5], 1337
	cop [$5], [$5]
label_0000:
	cop [$6], [$4]
	afc [$7], 20
	inf [$8], [$6], [$7]
	jmf [$8], label_0003
	jmp label_0002
label_0003:
	equ [$8], [$6], [$7]
	jmf [$8], label_0001
label_0002:
	cop [$7], [$4]
	afc [$8], 1
	add [$7], [$7], [$8]
	cop [$7], [$7]
	cop [$8], [$7]
	pri [$8]
	cop [$8], [$4]
	afc [$9], 20
	sup [$10], [$8], [$9]
	jmf [$10], label_0006
	jmp label_0005
label_0006:
	equ [$10], [$8], [$9]
	jmf [$10], label_0004
label_0005:
	afc [$9], 0
	cop [$9], [$9]
	cop [$10], [$9]
	pri [$10]
	cop [$10], [$3]
	pri [$10]
	cop [$10], [$4]
	pri [$10]
	jmp label_0007
label_0004:
	cop [$8], [$4]
	afc [$9], 10
	sup [$10], [$8], [$9]
	jmf [$10], label_000A
	jmp label_0009
label_000A:
	equ [$10], [$8], [$9]
	jmf [$10], label_0008
label_0009:
	cop [$9], [$2]
	pri [$9]
	cop [$9], [$4]
	pri [$9]
	jmp label_000B
label_0008:
	cop [$9], [$1]
	pri [$9]
	cop [$9], [$4]
	pri [$9]
label_000B:
label_0007:
	cop [$8], [$4]
	afc [$9], 1
	add [$8], [$8], [$9]
	cop [$4], [$8]
	jmp label_0000
label_0001:
	stop
