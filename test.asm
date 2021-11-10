.data
	fileName: .asciiz "input.txt"
	fileWords: .space 1024
.text
	main:
		# open file
		li $v0, 13
		la $a0, fileName
		li $a1, 0
		syscall
		move $s0, $v0

		# read file
		li $v0, 14
		move $a0, $s0
		la $a1, fileWords
		la $a2, 1024
		syscall

		addi $t0, $zero, 0
		move $t1, $a1					# save the adress of the array
		jal whileLoop

		# print whats in the file
		li $v0, 4
		la $a0, fileWords
		syscall

		# exit
		li $v0, 10
		syscall

	whileLoop:
		lb $t2, ($t1)					# get the char in the current index

		beq $t2, ']', endWhileLoop

		# print character
		li $v0, 11
		move $a0, $t2
		syscall
		sub $t2, $t2, 48

		addi $t1, $t1, 1

		j whileLoop

	endWhileLoop:
		jr $ra


