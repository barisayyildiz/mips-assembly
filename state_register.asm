.data
.text
	main:
		addi $s0, $zero, 10
		
		jal increaseMyRegister
		

		li $v0, 1
		move $a0, $s0
		syscall

		li $v0, 10
		syscall

	increaseMyRegister:
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		addi $s0, $s0, 30
	
		li $v0, 1
		move $a0, $s0
		syscall
		
		lw $s0, 0($sp)
		addi $sp, $sp, 4 
		
		jr $ra



