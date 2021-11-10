.data
promptPrefix: .asciiz "candidate sequence : ["
promptPostfix: .asciiz "]\n"
comma: .asciiz ","

arr: .word 3, 10, 7, 9, 4, 11
arrSize: .word 6

temp: .space 40
tempSize: .word 0

longest: .space 40
longestSize: .word 0

newLine: .asciiz "\n"

.text
	main:
		# fill arr
		# jal fillArr

		# # print size
		# li $v0, 1
		# lw $a0, arrSize
		# syscall

		la $a1, arr
		lw $a2, arrSize
		jal printArr

		# end program
		li $v0, 10
		syscall

	printArr:
		# $a1, array adress
		# $a2, arraySize
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)

		la $s0, ($a1)								# load array adress
		move $s1, $a2								# load array size

		li $v0, 4
		la $a0, promptPrefix
		syscall

		addi $t0, $zero, 0
		jal printArrLoop

		li $v0, 4
		la $a0, promptPostfix
		syscall

		lw $ra, 0($sp)						# load return adress back
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		addi $sp, $sp, 12

		jr $ra										# jump back

	printArrLoop:
		bge $t0, $s1, printArrLoopEnd	# if(index >= size), go to return adress

		li $v0, 1
		lw $a0, ($s0)									# load 4 byte integer
		syscall												# print integer

		li $v0, 4
		la $a0, comma
		syscall												# print comma

		addi $s0, $s0, 4							# increment array pointer by 4
		addi $t0, $t0, 1							# increment counter by 1

		j printArrLoop

	printArrLoopEnd:
		jr $ra
		

	# fillArr:
	# 	addi $t0, $zero, 0
	# 	lw $t1, arrSize

	# 	addi $s0, $zero, 3
	# 	sw $s0, arr($t0)
	# 	addi $t0, $t0, 4
	# 	addi $t1, $t1, 1

	# 	addi $s0, $zero, 10
	# 	sw $s0, arr($t0)
	# 	addi $t0, $t0, 4
	# 	addi $t1, $t1, 1

	# 	addi $s0, $zero, 7
	# 	sw $s0, arr($t0)
	# 	addi $t0, $t0, 4
	# 	addi $t1, $t1, 1

	# 	addi $s0, $zero, 9
	# 	sw $s0, arr($t0)
	# 	addi $t0, $t0, 4
	# 	addi $t1, $t1, 1

	# 	addi $s0, $zero, 4
	# 	sw $s0, arr($t0)
	# 	addi $t0, $t0, 4
	# 	addi $t1, $t1, 1
		
	# 	addi $s0, $zero, 11
	# 	sw $s0, arr($t0)
	# 	addi $t1, $t1, 1

	# 	# save array size
	# 	sw $t1, arrSize

	# 	# print size
	# 	li $v0, 1
	# 	move $a0, $t1
	# 	syscall

	# 	# print new line
	# 	li $v0, 4
	# 	la $a0, newLine
	# 	syscall

	# 	jr $ra

