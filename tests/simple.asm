	afc [$0], 0
	cop [$0], [$0]
	afc [$1], 1337
	cop [$1], [$1]
label_0:
	cop [$2], [$0]
	afc [$3], 10
	inf [$2], [$2], [$3]
	jmf [$2], label_1
	cop [$2], [$0]
	afc [$3], 5
	inf [$2], [$2], [$3]
	jmf [$2], label_2
	cop [$2], [$0]
	pri [$2]
	jmp label_3
label_2:
	cop [$2], [$1]
	pri [$2]
label_3:
	cop [$2], [$0]
	afc [$3], 1
	add [$2], [$2], [$3]
	cop [$0], [$2]
	jmp label_0
label_1:
