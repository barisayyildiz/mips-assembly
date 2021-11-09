.data

.text:
	main:
		addi $a1, $zero, 50
		addi $a2, $zero, 40
		
		jal addIntegers
		
		li $v0, 1
		addi $a0, $v1, 0
		syscall
		
		li $v0, 10 # end the program
		syscall
		
	addIntegers:
		add $v1, $a1, $a2
		jr $ra		
		
