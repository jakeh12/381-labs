beq $zero, $zero, label
add $t2, $t1, $t1
nop 
nop 
nop
nop
label:
addi $t4, $zero, 1
sw $t4, 0($t4)
lw $t2, 0($t4)
add $t3, $t2, $t2
