.data
	myArray: .word 100:3
	space: .byte ' '
.text
	main:
		# clear $t0
		addi $t0, $zero, 0
	
	while:
		# condition
		beq $t0, 12, exit
		
		# print the current value
		lw $t6, myArray($t0) # value in the current index
		li $v0, 1
		move $a0, $t6
		syscall

		li $v0, 4
		la $a0, space
		syscall

		# increment index
		addi $t0, $t0, 4
		
		# jump back to while
		j while

	exit:
		# exit the program
		li $v0, 10
		syscall




