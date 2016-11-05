nop
nop
nop
nop
addi $t0, $zero, -1
addi $t1, $zero, 1
addi $t2, $zero, 1
nop
beq $t1, $t2, beq_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
beq_label:
beq $t0, $t1, beq_label # should never branch
bne $t0, $t1, bne_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bne_label:
bne $t0, $t0, bne_label # should never branch
bltz $t0, bltz_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bltz_label:
bltz $zero, bltz_label # should never branch
bltz $t1, bltz_label # should never branch
bgez $zero, bgez_label1
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bgez_label1:
bgez $t1, bgez_label2
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bgez_label2:
bgez $t0, bgez_label2 # should never branch
blez $zero, blez_label1
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
blez_label1:
blez $t0, blez_label2
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
blez_label2:
blez $t1, blez_label2 # should never branch
bgtz $t1, bgtz_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bgtz_label:
bgtz $zero, bgtz_label # should never branch
bgtz $t0, bgtz_label # should never branch
j j_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
j_label:
jal jal_label1
j post_jr_label
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
jal_label1:
jr $ra
post_jr_label:
jal jal_label2
j post_jalr1
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
jal_label2:
jalr $t3, $ra
j post_jalr2
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
post_jalr1:
jr $t3
post_jalr2:
bltzal $zero, bltzal_label # should never branch
bltzal $t1, bltzal_label # should never branch
bltzal $t0, bltzal_label
j post_bltzal
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bltzal_label:
jr $ra
post_bltzal:
bgezal $t0, bgezal_label1 # should never branch
bgezal $zero, bgezal_label1
j post_bgezal1
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bgezal_label1:
jr $ra
post_bgezal1:
bgezal $t1, bgezal_label2 
j post_bgezal2
nop #should never hit
nop #should never hit
nop #should never hit
nop #should never hit
bgezal_label2:
jr $ra
post_bgezal2:
nop