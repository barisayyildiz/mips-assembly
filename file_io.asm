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

		# print whats in the file
		li $v0, 4
		la $a0, fileWords
		syscall

