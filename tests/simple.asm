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
	inf [$5], [$5], [$6]
	jmf [$5], label_0001
	cop [$5], [$3]
	afc [$6], 15
	sup [$5], [$5], [$6]
	jmf [$5], label_0002
	cop [$5], [$0]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
	jmp label_0003
label_0002:
	cop [$5], [$3]
	afc [$6], 10
	sup [$5], [$5], [$6]
	jmf [$5], label_0004
	cop [$5], [$1]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
	jmp label_0005
label_0004:
	cop [$5], [$2]
	pri [$5]
	cop [$5], [$3]
	pri [$5]
label_0005:
label_0003:
	cop [$5], [$3]
	afc [$6], 1
	add [$5], [$5], [$6]
	cop [$3], [$5]
	jmp label_0000
label_0001:
