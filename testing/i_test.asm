nop 
nop
nop
nop # load values
addi $t0, $zero, 2
addi $t1, $zero, -1
addi $s0, $zero, 1
nop #test add
addi $t2, $t0, 2 # $t2 = 4
nop
addiu $t2, $t0, 2 # $t2 = 4
nop
ori $t2, $t0, 3 # $t2 = 3
nop
andi $t2, $t0, 3 # $t2 = 2
nop
xori $t2, $t0, 3 # $t2 = 1
nop
slti $t2, $t0, 4 # $t2 = 1
nop
slti $t2, $t0, -4 # t2 = 0
nop
sltiu $t2, $t0, -4 # t2 = 1
nop
sltiu $t2, $t0, 1 # t2 = 0
nop
lui $t2, 255
