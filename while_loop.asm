.data
	newLine: .asciiz "\n"
.text
	main:
		# i = 0
		addi $t0, $zero, 0
	
		while:
			bgt $t0, 9, exit	
			add $t0, $t0, 1 # i++
			add $a1, $t0, 0
			jal print
			j while
			
		exit:
			li $v0, 10
			syscall	
			
		print:
			li $v0, 1
			add $a0, $a1, 0
			syscall
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			jr $ra
			
			
			
			
			
			
			
			
			
			