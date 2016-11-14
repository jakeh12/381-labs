addi $t0, $zero, -1 #reg8 = -1
addi $t1, $zero, -2 #reg9 = -2
addi $t2, $zero, -3 #reg10 = -3
addi $t3, $zero, -4 #reg11 = -4

sw $t0, 0($zero) #mem[0] = -1
sh $t1, 0($zero) #mem[0] = -2
sb $t2, 0($zero) #mem[0] = -3

nop
nop
nop

sw $zero, 0($zero) #set mem[0] to all 0

sb $t0, 0($zero) #set mem[0] to F byte by byte
sb $t0, 1($zero)
sb $t0, 2($zero)
sb $t0, 3($zero)

nop
nop
nop

sw $t0, 0($zero) #set mem[0] to all F

sh $zero, 0($zero) #set mem[0] to FFFF0000
sh $zero, 2($zero)

nop
nop
nop

sw $t0, 0($zero) #set mem[0] to all F

addi $t1, $zero, 0 #reg9 = 0
addi $t2, $zero, 0 #reg10 = 0
addi $t3, $zero, 0 #reg11 = 0

lw $t1, 0($zero) #reg9 = FFFFFFFF
lh $t2, 0($zero) #reg10 = FFFFFFFF
lb $t3, 0($zero) #reg11 = FFFFFFFF

nop
nop
nop

sw $t0, 0($zero) #set mem[0] to all F

addi $t1, $zero, 0 #reg9 = 0
addi $t2, $zero, 0 #reg10 = 0
addi $t3, $zero, 0 #reg11 = 0

lhu $t2, 0($zero) #reg10 = 0000FFFF
lhu $t2, 2($zero) #reg10 = FFFF0000

lbu $t3, 0($zero) #reg11 = 000000FF
lbu $t3, 1($zero) #reg11 = 0000FF00
lbu $t3, 2($zero) #reg11 = 00FF0000
lbu $t3, 3($zero) #reg11 = FF000000

nop
nop
nop




