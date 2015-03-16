# Interpreto
L'interpreteur de l'assembleur généré par notre compilateur

## Compile

Clone the repository
```
[tlk:~]$ git clone https://github.com/ProjectoInformatico/Interpreto.git
Clonage dans 'Interpreto'...
remote: Counting objects: 97, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 97 (delta 0), reused 0 (delta 0), pack-reused 93
Dépaquetage des objets: 100% (97/97), fait.
Vérification de la connectivité... fait.
```

Init and update submodule
```
[tlk:~/Interpreto]$ git submodule init                                                                                
Sous-module 'instructionmanager' (https://github.com/ProjectoInformatico/InstructionManager.git) enregistré pour le chemin 'instructionmanager'
[tlk:~/Interpreto]$ git submodule update                                                                              
Clonage dans 'instructionmanager'...
remote: Counting objects: 58, done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 58 (delta 33), reused 28 (delta 8), pack-reused 0
Dépaquetage des objets: 100% (58/58), fait.
Vérification de la connectivité... fait.
Chemin de sous-module 'instructionmanager' : '3457dfebd4e8ff3834eab5c58925b493ed6390f2' extrait
```

Launch make
```
[tlk:~/Interpreto]$ make                                                                                              
gcc -Wall -o cpu.o -c cpu.c
yacc -d --debug --verbose source.yacc
lex --header-file=lex.yy.h source.lex
gcc -Wall -o interpreto.o -c interpreto.c
gcc -Wall -o instructionmanager/label.o -c instructionmanager/label.c
gcc -Wall -o instructionmanager/instructions.o -c instructionmanager/instructions.c
gcc -Wall -o lex.yy.o -c lex.yy.c
lex.yy.c:1200:16: attention : ‘input’ defined but not used [-Wunused-function]
     static int input  (void)
                ^
gcc -Wall -o y.tab.o -c y.tab.c
gcc -o bin/interpreto cpu.o interpreto.o instructionmanager/label.o instructionmanager/instructions.o lex.yy.o y.tab.o -lfl -ly
```

## Demo

```
[tlk:~/Interpreto]$ ./bin/interpreto -f tests/simple.asm -i
[+] Reading from file tests/simple.asm
(interpreto $) disas
	afc [$0], 0
	cop [$0], [$0]
	afc [$1], 1337
	cop [$1], [$1]
label_0:
	cop [$2], [$0]
	afc [$3], 10
	inf [$2], [$2], [$3]
	jmf [$2] label_1
	cop [$2], [$0]
	afc [$3], 5
	inf [$2], [$2], [$3]
	jmf [$2] label_2
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
(interpreto $) r
0
1
2
3
4
1337
1337
1337
1337
1337
(interpreto $) reset
cpu reset !
(interpreto $) s
	afc [$0], 0
(interpreto $) s
	cop [$0], [$0]
(interpreto $) s
	afc [$1], 1337
(interpreto $) s
	cop [$1], [$1]
(interpreto $) s
label_0:
(interpreto $) s
	cop [$2], [$0]
(interpreto $) s
	afc [$3], 10
(interpreto $) s
	inf [$2], [$2], [$3]
(interpreto $) s
	jmf [$2] label_1
(interpreto $) s
	cop [$2], [$0]
(interpreto $) s
	afc [$3], 5
(interpreto $) s
	inf [$2], [$2], [$3]
(interpreto $) s
	jmf [$2] label_2
(interpreto $) s
	cop [$2], [$0]
(interpreto $) s
	pri [$2]
0
(interpreto $) r
1
2
3
4
1337
1337
1337
1337
1337
(interpreto $) q
bye !
```

