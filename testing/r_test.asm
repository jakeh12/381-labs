nop 
nop
nop
nop # load values
addi $t0, $zero, 2
addi $t1, $zero, -1
addi $s0, $zero, 1
nop #test add
add $t2, $t0, $t1 # $t2 = 1
nop
addu $t2, $t0, $t1 # $t2 = 1
nop
sub $t2, $t0, $t1 # $t2 = 3
nop
subu $t2, $t0, $t1 # $t2 = 3
nop
and $t2, $t2, $t0 # $t2 = 2
nop
or $t2, $t2, $t1 # $t2 = -1
nop
xor $t2, $t2, $t2 # $t2 = 0
nop
nor $t2, $t2, $t0 # $t2 = -3
nop
sra $t2, $t2, 1 # $t2 = -2
nop
srav $t2, $t2, $s0 # $t2 = -1
nop
sll $t2, $t0, 1 # $t2 = 4
nop
srl $t2, $t0, 1 # $t2 = 1
nop
sllv $t2, $t0, $s0 # $t2 = 4
nop
srlv $t2, $t0, $s0 # $t2 = 1
nop
slt $t2, $t1, $t0 # $t2 = 1
nop
slt $t2, $t0, $t1 # $t2 = 0
nop
sltu $t2, $t0, $t1 # $t2 = 1
nop
sltu $t2, $t1, $t0 # $t2 = 0
nop
nop
nop
nop
mul $t2, $t0, $t1 # $t2 = -2
