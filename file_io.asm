.data
	fileName: .asciiz "input.txt"
	fileWords: .space 1024

	arr: .space 400									# arr
	arrLength: .word 0							# arrLength

	# file reading
	EOF: .byte '\0'									# EOF
	blank: .byte ' '								# blank space
	str: .space 10									# string representation of the number will be readen from the file
	strCounter: .word 0							# string length
	strPtr: .byte										# strPtr that points any point on str array
	num: .word 0
	
	#	strToInt function
	digit: .word 0
	times: .word 1
	total: .word 0
	
	strLength: .word 0							# length of the string
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


		# la $a0, fileWords			# adress of fileWords
		# jal printLineByByte		# call printByLine

		# fileWords and fileWordsPtr initially show the same cell
		la $t0, fileWords

		# str and strPtr initially show the same cell
		la $t0, str
		# sw $t0, (strPtr)


		jal readStringForLoop

		li $v0, 10						# terminate the program
		syscall

	readStringForLoop:
		# t0 -> fileWords
		# t1 -> str
		# t2 -> strPtr
		# t3 -> strCounter
		# t4 -> current char(byte)
		# t5 -> EOF
		# t6 -> ' '
		addi $sp, $sp, -8
		sw $ra, 0($sp)

		# load variables
		la $t0, fileWords
		la $t1, str
		la $t2, strPtr
		lw $t3, strCounter
		la $t5, EOF
		la $t6, blank
		
		lb $t4, ($t0)													# read byte
		addi $t0, $t0, 4											# increment address by 4
		
		beq $t4, $t5, readStringForLoopEnd
		beq $t4, $t6, readStringForLoopIfCase

		# else
		lw $t3, strCounter										# load string counter
		addi $t3, $t3, 1											# increment strCounter by 1
		sw $t3, strCounter										# save strCounter
		la $t2, strPtr												# get strPtr adress
		sw $t4, ($t2)													# save current byte to strPtr
		addi $t2, $t2, 1											# increment strPtr by 1
		sw $t2, strPtr												# save strPtr

	readStringForLoopIfCase:
		addi $sp, $sp, -8
		sw $ra, 0($sp)

		la $a0, str
		lw $a1, strCounter
		jal strToInt

		# print number
		li $v0, 1
		lw $a0, num
		syscall

		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jal readStringForLoop

	readStringForLoopEnd:
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra

	strToInt:
		# a0, str
		# a1, strCounter
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $s0, 4($sp)

		addi $t7, $zero, 0					# temp = 0
		addi $t1, $zero, 0					# digit = 0
		addi $t2, $zero, 1					# times = 1
		
		addi $t3, $zero, 0					# i
		strToIntFor:
			bge $t3, $a1, strToIntForEnd			# if i >= counter
			addi $t4, $zero, 0				# j
			move $t5, $a1
			sub $t5, $t5, 1						# < strCounter - 1
			sub $t5, $t5, $t3					# < strCounter - 1 - i
			calculateTimes:
				bge $t4, $t5, calculateTimesEnd 	# if j >= strCounter-i-1
				mul $t2, $t2, 10									# times *= 10
			calculateTimesEnd:
				la $t6, ($a0)
				la, $t1, ($t6)
				addi $t1, $t1, -48			# digit
				addi $t6, $t6, 1				# increment byte by 1
				move $a0, $t6						# save pointer

				mul $t1, $t1, $t2			# digit = digit*times
				add $t7, $t7, $t1			# temp += digit
				addi $t2, $zero, 1			# times = 1

				addi $t3, $t3, 1				# i++
				j strToIntFor
		strToIntForEnd:

		lw $t7, num									# num = temp


		lw $ra, 0($sp)
		sw $s0, 4($sp)
		addi $sp, $sp, 12
		jr $ra


	printLineByByte:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)

		move $t0, $a0					# save current address to $t0
		lb $t1, ($t0)					# load byte to $t1
		lb $t2, EOF						# load EOF

		# if current value is EOF
		beq $t1, $t2, printLineByByteEnd

		# print byte
		li $v0, 11
		move $a0, $t1
		syscall

		addi $t0, $t0, 1			# increment pointer
		move $a0, $t0					# adjust parameter

		jal printLineByByte		# call recursive function

	printLineByByteEnd:
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra

	goBack:
		jr $ra

