nop
nop
nop
nop
addi $t0, $zero, -1
lui $t1, 4100
nop
sw $t0, 0($t1) # Mem[] = -1
nop
lw $t2, 0($t1) # $t2 = -1
nop
sh $t0, 4($t1) # Mem[] = 0x0000FFFF
nop
lh $t3, 4($t1) # t2 = 0xFFFFFFFF
nop
lhu $t3, 4($t1) # t3 = 0x0000FFFF
nop
sb $t0, 8($t1) # Mem[] = 0x000000FF
nop
lb $t4, 8($t1) # t4 = 0xFFFFFFFF
nop
lbu $t4, 8($t1) # t4 = 0x000000FF
