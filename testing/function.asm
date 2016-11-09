		addi $sp, $zero, 255
		jal foo
loop_forever:	j loop_forever

foo:		addi $sp, $sp, -4 # push $ra on stack
		sw $ra, 0($sp)
		add $ra, $zero, $zero # clear $ra
		lw $ra, 0($sp)
		addi $sp, $sp, 4 # pop $ra
		jr $ra # return
