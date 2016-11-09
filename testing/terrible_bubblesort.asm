#######################################
#     bubble sort with set values     #
#######################################

#put values int reg9 - reg12
addi $t1,$zero, 5
addi $t2,$zero, 4
addi $t3,$zero, 3
addi $t4,$zero, 1

#first check
slt $s4,$t1,$t2 #s4 = 1 if t1 less than t2
bne $s4,$zero, firstcheck #branch if t1<t2
jal swap12
firstcheck:
addi $s4,$zero,0 #reset check

#second check
slt $s4,$t2,$t3 
bne $s4,$zero, secondcheck 
jal swap23
secondcheck:
addi $s4,$zero,0 #reset check

#third check
slt $s4,$t3,$t4 
bne $s4,$zero, secondcheck 
jal swap34
thirdcheck:
addi $s4,$zero,0 #reset check

#first check
slt $s4,$t1,$t2 #s4 = 1 if t1 less than t2
bne $s4,$zero, firstcheck2 #branch if t1<t2
jal swap12
firstcheck2:
addi $s4,$zero,0 #reset check

#second check
slt $s4,$t2,$t3 
bne $s4,$zero, secondcheck2 
jal swap23
secondcheck2:
addi $s4,$zero,0 #reset check

#first check
slt $s4,$t1,$t2 #s4 = 1 if t1 less than t2
bne $s4,$zero, firstcheck2 #branch if t1<t2
jal swap12
firstcheck3:
addi $s4,$zero,0 #reset check

j done


#swap register values
swap12:
add $s3,$t2,$zero
add $t2,$t1,$zero
add $t1,$s3,$zero
jr $ra
swap23:
add $s3,$t3,$zero
add $t3,$t2,$zero
add $t2,$s3,$zero
jr $ra
swap34:
add $s3,$t4,$zero
add $t4,$t3,$zero
add $t3,$s3,$zero
jr $ra


done:
nop
nop
nop
nop

