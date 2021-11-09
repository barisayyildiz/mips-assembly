.data
	myArray: .space 12
.text
	main:
		addi $s0, $zero, 4
		addi $s1, $zero, 10
		addi $s2, $zero, 12

		# $t0 = 0
		# save array to RAM
		addi $t0, $zero, 0
		sw $s0, myArray($t0)
		addi $t0, $t0, 4
		sw $s1, myArray($t0)
		addi $t0, $t0, 4
		sw $s2, myArray($t0)

		# Load first element from RAM to register $t6
		lw $t6, myArray($zero)

		# print first element
		li $v0, 1
		addi $a0, $t6, 0
		syscall


