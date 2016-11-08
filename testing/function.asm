	addiu $a0, $zero, 10 # initialize function argument to n
	addi $sp, $zero, 255 # set $sp to address 0xFF
	addi $t0, $zero, 24
	sw $t0, 0($sp) # main returns to 0
	jal foo
	addu $v0, $a0, $zero
loop_forever:
	j loop_forever
foo:
	addiu $sp, $sp, -4 # make room in stack
	sw $ra, 0($sp) # push $ra on stack
	jal bar
	addiu $a0, $a0, 100
	lw $ra, 0($sp)
	addiu $sp, $sp, 4 # pop $ra from stack
	jr $ra
bar:
	addiu $sp, $sp, -4 # make room in stack
	sw $ra, 0($sp) # push $ra on stack
	jal baz
	addiu $a0, $a0, 10
        lw $ra, 0($sp)
	addiu $sp, $sp, 4 # pop $ra from stack
	jr $ra
	
baz:
	addiu $a0, $a0, 1 # increment a0
	jr $ra