		addi $a0, $zero, 8
		
		# load values into memory
		addi $t0, $zero, 4
		sw   $t0, 0($a0)
		addi $t0, $zero, 1
		sw   $t0, 4($a0)
		addi $t0, $zero, 3
		sw   $t0, 8($a0)
		addi $t0, $zero, 2
		sw   $t0, 12($a0)
		
		addi $a0, $a0, 0 # pointer to original array
		addi $a1, $a0, 20 # pointer to the final sorted array
		# begin merge sort
		
		# 4 1 3 2
		# _ _ 
		lw $t0, 0($a0)
		nop
		lw $t1, 4($a0)
		nop
		slt $t2, $t0, $t1 # 4 < 1 ?
		beq $t2, $zero, swap_1
		j continue_1

swap_1:		sw $t0 4($a0)
		sw $t1 0($a0)

continue_1:	
		
		# 1 4 3 2
		#     _ _ 
		lw $t0, 8($a0)
		nop
		lw $t1, 12($a0)
		nop
		slt $t2, $t0, $t1 # 3 < 2 ?
		beq $t2, $zero, swap_2
		j continue_2

swap_2:		sw $t0 12($a0)
		sw $t1 8($a0)

continue_2:	

                # Final merge
                # $t0 = left pointer, $t1 = right pointer, $t2 = sorted array pointer
                
                # l      r
                # |      |
		# 1 4    2 3
		# _ _    _ _
		
		addi $t2, $a1, 0 # new array pointer
		addi $s0, $zero, 3 # size
		
		addi $t0, $a0, 0 # left pointer
		addi $t1, $a0, 8 # right pointer
	
loop:		beq $s0, $zero, store_very_last	
		lw $t3, 0($t0) # dereference left
		nop
		lw $t4, 0($t1)	# dereference right
		nop
		slt $t5, $t3, $t4 # 1 < 2 ?
		beq $t5, $zero, store_right
		sw $t3, 0($t2) # store left first
		addi $t0, $t0, 4 # l++
	        j continue_3
	     
store_right:	sw $t4, 0($t2) # store right first
		addi $t1, $t1, 4 # r++
continue_3:	

		addi $t2, $t2, 4 # increment new array pointer
		addi $s0, $s0, -1 # decrement size
		j loop

store_last_right:	sw $t4, 0($t2)
			j done

store_last_left:	sw $t3, 0($t2)
			j done	
			
store_very_last:
		slt $t5, $t3, $t4 # 1 < 2 ?
		beq $t5, $zero, store_very_last_left
		sw $t4, 0($t2) # store right first
	        j done
	        
store_very_last_left:
		sw $t3, 0($t2) # store left first
		
done:		
		lw $s0, 0($a1)
		nop
		lw $s1, 4($a1)
		nop
		lw $s2, 8($a1)
		nop
		lw $s3, 12($a1)
		nop
infinite:		
		j infinite
		

















		 








		
		
