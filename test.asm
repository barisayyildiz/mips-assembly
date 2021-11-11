.data
promptPrefix: .asciiz "candidate sequence : ["
promptPostfix: .asciiz "]\n"
comma: .asciiz ","

arr: .word 3, 10, 7, 9, 4, 11
arraySize: .word 6
temp: .space 40
tempSize: .word 0

.text:

	la $a0, arr
	addi $a1, $zero, 0
	la $a2, temp
	lw $a3, tempSize
	jal algo


	li $v0, 10
	syscall


	algo:
		# $a0 arr
		# $a1 arrIndex
		# $a2 temp
		# $a3 tempSize
		addi $sp, $sp, -24
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)

		move $s0, $a0						# arr
		move $s1, $a1						# arrIndex
		move $s2, $a2						# temp
		move $s3, $a3						# tempSize

		jal branchOne
		bne $v0, $zero, algoReturn

		jal branchTwo

		# call algo
		lw $a0, 4($sp) 							# get array adress
		addi $a0, $a0, 4						# increment array pointer
		lw $a1, 8($sp)							# get array index
		addi $a1, $a1, 1						# increment array index
		lw $a2, 12($sp)							# get temp array adress
		# addi $a2, $a2, 4						# increment temp array pointer
		lw $a3, 16($sp)							# get tempSize
		jal algo

		# return
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addi $sp, $sp, 24
		jr $ra

	algoReturn:
		lw $ra, 0($sp)
		addi $sp, $sp, 24
		jr $ra

	branchTwo:
		addi $sp, $sp, -24
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)

		jal tempSizeZero
		move $v1, $v0
		jal currentIndexItemGreaterThanTheLastItem
		or $v0, $v0, $v1

		beq $v0, $zero, branchTwoFalse
		# if true append and call algo
		jal appendTemp

		# call algo
		lw $a0, 4($sp) 							# get array adress
		addi $a0, $a0, 4						# increment array pointer
		lw $a1, 8($sp)							# get array index
		addi $a1, $a1, 1						# increment array index
		lw $a2, 12($sp)							# get temp array adress
		addi $a2, $a2, 4						# increment temp array pointer
		lw $a3, 16($sp)							# get tempSize
		addi $a3, $a3, 1						# increment tempSize
		jal algo


		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		addi $sp, $sp, 24
		jr $ra

	branchTwoFalse:
		# go back to algo function
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		addi $sp, $sp, 24
		jr $ra		


	branchOne:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $s3, 4($sp)

		jal indexGreaterThanArrSize
		beq $v0, $zero, branchOneElseFirst

		# print temp
		la $a1, temp
		lw $a2, 4($sp)
		jal printArr

		jal tempSizeGreaterThanLargest
		beq $v0, $zero, branchOneElseSecond

		jal changeLongest

		lw $ra, 0($sp)
		lw $s3, 4($sp)
		addi $sp, $sp, 12
		j true

	branchOneElseFirst:
		lw $ra, 0($sp)
		lw $s3, 4($sp)
		addi $sp, $sp, 12
		j false
	branchOneElseSecond:
		lw $ra, 0($sp)
		lw $s3, 4($sp)
		addi $sp, $sp, 12
		j true


	
	appendTemp:
		lw $t0, ($s0)						# get *arr
		sw $t0, ($s2)						# append it to temp
		jr $ra
	currentIndexItemGreaterThanTheLastItem:
		lw $t0, 0($s0)					# *arr
		lw $t1, -4($s2)					# temp[tempSize-1]
		bgt $t0, $t1, true			# *arr > temp[tempSize-1]
		j false
	tempSizeZero:
		beq $s3, $zero, true		# tempSize == 0
		j false
	tempSizeGreaterThanLargest:
		# placeholder
		j false
	indexGreaterThanArrSize:
		lw $t0, arraySize				# arraySize
		bge $s1, $t0, true			# index >= arraySize
		j false
	true:
		li $v0, 0x11111111
		jr $ra
	false:
		li $v0, 0x00000000
		jr $ra
	changeLongest:
		jr $ra
	goBack:
		jr $ra
	printArr:
		# $a1, array adress
		# $a2, arraySize
		addi $sp, $sp, -16
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
		addi $sp, $sp, 16

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
		
