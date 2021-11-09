.data
	myArray: .space 12
	space: .byte ' '
.text
	main:
		addi $s0, $zero, 3
		addi $s1, $zero, 4
		addi $s2, $zero, 5

		addi $t0, $zero, 0

		# fill the array in the RAM
		sw $s0, myArray($t0)
		addi $t0, $t0, 4
		sw $s1, myArray($t0)
		addi $t0, $t0, 4
		sw $s2, myArray($t0)

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




