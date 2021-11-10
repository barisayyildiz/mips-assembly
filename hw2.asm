.data
promptPrefix: .asciiz "candidate sequence : ["
promptPostfix: .asciiz "]\n"
comma: .asciiz ","

arr: .word 3, 4
arrSize: .word 2

temp: .space 40
tempSize: .word 0

longest: .space 40
longestSize: .word 0

newLine: .asciiz "\n"

.text
	main:
		# # adjusting parameters before calling printArr function
		# la $a1, arr
		# lw $a2, arrSize
		# jal printArr

		# adjusting parameters before calling recursive algo function
		la $a0, arr								# arr adress
		lw $a1, arrSize						# arrSize
		la $a2 temp								# temp adress
		lw $a3, tempSize					# tempSize
		addi $s7, $zero, 0				# index
		jal algo

		j end											# terminate the program

	end:
		li $v0, 10
		syscall
	
	algo:
		#	$a0		arr
		#	$a1		arrSize
		#	$a2		temp
		#	$a3		tempSize
		# $s7		index
		addi $sp, $sp, -24						# adjust stack
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		sw $s7, 20($sp)								#	index

		# save parameters to local variables
		move $s0, $a0					# arr adress
		move $s1, $a1					# arrSize
		move $s2, $a2					# temp adress
		move $s3, $a3					# tempSize
		move $s4, $s7					# index

		jal algoSizeCondition
		lw $ra, 0($sp)										# load prev
		bne $v0, $zero, goBack						# if false, go back

		jal algoIncreasingCondition				# jump to algoIncreasing condition
		bne $v0, $zero, biggerNumber			# if condition true, do the recursion

		# adjusting parameters before calling recursive algo function
		move $t0, $s0
		add $t0, $t0, 4							# increment arr adress pointer by 4 byte
		move $a0, $t0								# arr adress

		move $a1, $s1								# arrSize

		move $t0, $s2
		add $t0, $t0, 4							# increment temp adress pointer by 4 byte
		move $a2, $t0								# temp adress

		move $a3, $s3								# tempSize
		
		add $s7, $zero, $s4					# index
		jal algo
		

		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		lw $s7, 20($sp)
		addi $sp, $sp, 24						# adjust stack

		j goBack

	biggerNumber:
		addi $sp, $sp, -4						# adjust stack
		sw $ra, 0($sp)

		lw $t0, 0($s0)							# *arr
		sw $t0, ($s2)								# tempin sonuna *arr ekle

		# adjusting parameters before calling recursive algo function
		move $t0, $s0
		add $t0, $t0, 4							# increment arr adress pointer by 4 byte

		move $a0, $t0								# arr adress
		move $a1, $s1								# arrSize

		move $t0, $s2
		add $t0, $t0, 4							# increment temp adress pointer by 4 byte
		move $a2, $t0								# temp adress

		move $t0, $s3
		add $t0, $t0, 1							# increment tempSize by 1

		move $a3, $t0								# tempSize
		add $s7, $s4, 1							# index
		jal algo

		lw $ra, 0($sp)
		addi $sp, $sp, 4						# adjust pointer

		j goBack


	algoIncreasingCondition:
		addi $sp, $sp, -4						# adjust pointer
		sw $ra, 0($sp)

		jal algoIncreasingFirstCondition			# jump to first condition
		move $t6, $v0
		jal algoIncreasingSecondCondition			# jump to second condition
		move $t7, $v0

		or $t6, $t6, $t7						# or 2 conditions

		lw $ra, 0($sp)
		addi $sp, $sp, 4						# adjust stack

		# true veya false dondur
		bne $t6, $zero, true				# firstCondition || secondCondition => true
		j false											# return false

		j goBack										# go back

	algoIncreasingFirstCondition:
		beq $s3, $zero, true				# tempSize == 0 => true
		j false											# return false

	algoIncreasingSecondCondition:
		lw $t0, 0($s0)						# *arr uzerindeki deger
		lw $t1, -4($s2)						# tempArr[tempSize-1]
		bgt $t0, $t1, true				# *arr > tempArr[tempSize-1]
		j false										# return false

	false:
		li $v0, 0x00000000
		j goBack

	true:
		li $v0, 0x11111111
		j goBack

	indexGreaterThanArrSize:
		bge $s4, $s1, true					# if (index >= arrSize)
		j false

	algoSizeCondition:
		addi $sp, $sp, -4					# adjust stack
		sw $ra, 0($sp)

		# blt $s4, $s1, false						# !(index >= arrSize) => false BURADA BIR SORUN OLABILIR!!!!
		# jal longestSizeCondition			# jumpt to longest size condition
		
		jal indexGreaterThanArrSize
		beq $v0, $zero, algoSizeConditionFalse
		jal longestSizeCondition

		la $a1, temp									# temp
		move $a2, $s3									# tempSize
		jal printArr									# printArray

		lw $ra, 0($sp)
		addi $sp, $sp, 4							# adjust stack
		j true												# return true

	algoSizeConditionFalse:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		j false

	longestSizeCondition:
		lw $a0, longestSize						# longestSize
		ble $s3, $a0, goBack					# tempSize <= longestSize
		j changeLongest								# jump to change longest

		j goBack

	changeLongest:
		j goBack

	goBack:
		jr $ra

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
		
