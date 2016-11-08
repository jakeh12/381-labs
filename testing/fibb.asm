j skip_initially
loop_forever:
j loop_forever
skip_initially:
addi $sp, $zero, 255
addi $a0, $zero, 3
addi $s0, $zero, 4
sw $s0, 0($sp)
